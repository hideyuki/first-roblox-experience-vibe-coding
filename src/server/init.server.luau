-- 迷路ゲームサーバー（重複記録防止版）
print("迷路ゲームサーバーを起動中...")

-- 必要なサービスの初期化
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- 初期構造サービス（最優先）
local InitialStructureService = require(script.Services.InitialStructureService)

-- 共有定数の読み込み（safe wait）
local function getConstants()
    local success, constants = pcall(function()
        return require(game.ReplicatedStorage:WaitForChild("Shared", 10):WaitForChild("Constants", 5))
    end)
    
    if success then
        return constants
    else
        warn("❌ Constants.luau読み込み失敗、デフォルト値使用: " .. tostring(constants))
        return {
            RANKING_DATASTORE_NAME = "KanataMazeRankings",
            RANKING_DATASTORE_KEY = "GlobalRankings20250604"
        }
    end
end

local Constants = getConstants()

-- 照明サービスの読み込み
local LightingService = require(script.Services.LightingService)
local WarpService = require(script.Services.WarpService)
local WallService = require(script.Services.WallService)
local ComplexMazeService = require(script.Services.ComplexMazeService)
local GoalAreaService = require(script.Services.GoalAreaService)
local SignService = require(script.Services.SignService)
local GoalPathService = require(script.Services.GoalPathService)
local GoalLayoutService = require(script.Services.GoalLayoutService)
local CleanupService = require(script.Services.CleanupService)

-- ローカルテスト環境の検出
local function isStudioLocalTest()
    return game:GetService("RunService"):IsStudio()
end

local isLocalTest = isStudioLocalTest()

-- DataStore設定（本番環境のみ）
local rankingDataStore = nil
local RANKING_KEY = Constants.RANKING_DATASTORE_KEY

if not isLocalTest then
    local DataStoreService = game:GetService("DataStoreService")
    local success, result = pcall(function()
        return DataStoreService:GetDataStore(Constants.RANKING_DATASTORE_NAME)
    end)
    
    if success then
        rankingDataStore = result
        print("✅ DataStore接続成功（本番環境）")
        print("📊 DataStore名: " .. Constants.RANKING_DATASTORE_NAME)
        print("🔑 ランキングキー: " .. Constants.RANKING_DATASTORE_KEY)
    else
        warn("❌ DataStore接続失敗: " .. tostring(result))
    end
else
    print("🏠 ローカルテスト環境 - DataStore無効、メモリ内ランキング使用")
    print("📊 本番用DataStore名: " .. Constants.RANKING_DATASTORE_NAME)
    print("🔑 本番用ランキングキー: " .. Constants.RANKING_DATASTORE_KEY)
end

-- ゲーム状態管理（重複防止強化）
local playerStates = {} -- プレイヤーの状態管理
local globalRankings = {} -- グローバルランキングデータ

-- プレイヤー状態の定義
local STATE = {
    WAITING = "WAITING",      -- 待機中
    STARTED = "STARTED",      -- スタート済み（タイマー実行中）
    COMPLETED = "COMPLETED"   -- ゴール済み（記録済み）
}

-- RemoteEventsの安全な取得
local function getRemoteEvents()
    local success, result = pcall(function()
        local remoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents", 10)
        local startTimerEvent = remoteEvents:WaitForChild("StartTimer", 5)
        local stopTimerEvent = remoteEvents:WaitForChild("StopTimer", 5)
        local updateRankingEvent = remoteEvents:WaitForChild("UpdateRanking", 5)
        
        return {
            start = startTimerEvent,
            stop = stopTimerEvent,
            update = updateRankingEvent
        }
    end)
    
    if success then
        print("✅ RemoteEventsを正常に取得しました")
        return result
    else
        warn("❌ RemoteEventsの取得に失敗: " .. tostring(result))
        return nil
    end
end

local remoteEvents = getRemoteEvents()
if not remoteEvents then
    warn("❌ RemoteEventsが取得できないため、サーバーを停止します")
    return
end

-- DataStoreからランキングデータを読み込み（本番環境のみ）
local function loadRankings()
    if isLocalTest then
        -- ローカルテスト用のダミーデータ
        globalRankings = {
            {name = "TestPlayer1", time = 45.23, timestamp = os.time()},
            {name = "TestPlayer2", time = 52.18, timestamp = os.time()},
            {name = "TestPlayer3", time = 63.45, timestamp = os.time()}
        }
        print("🏠 ローカルテスト用ダミーランキングを初期化しました")
        return
    end
    
    if not rankingDataStore then
        print("⚠️ DataStore未接続 - 新しいランキングを初期化")
        globalRankings = {}
        return
    end
    
    local success, result = pcall(function()
        return rankingDataStore:GetAsync(RANKING_KEY)
    end)
    
    if success and result then
        globalRankings = result
        print("✅ ランキングデータを読み込みました: " .. #globalRankings .. " エントリ")
    else
        globalRankings = {}
        print("🆕 新しいランキングデータを初期化しました")
    end
end

-- DataStoreにランキングデータを保存（本番環境のみ）
local function saveRankings()
    if isLocalTest then
        print("🏠 ローカルテスト環境 - ランキング保存をスキップ")
        return
    end
    
    if not rankingDataStore then
        print("⚠️ DataStore未接続 - ランキング保存をスキップ")
        return
    end
    
    local success, error = pcall(function()
        rankingDataStore:SetAsync(RANKING_KEY, globalRankings)
    end)
    
    if success then
        print("✅ ランキングデータを保存しました")
    else
        warn("❌ ランキングデータの保存に失敗: " .. tostring(error))
    end
end

-- ランキングに新しい記録を追加
local function addToRankings(playerName, completionTime)
    -- 新しいエントリを追加
    table.insert(globalRankings, {
        name = playerName,
        time = completionTime,
        timestamp = os.time()
    })
    
    -- 時間順にソート（短い時間が上位）
    table.sort(globalRankings, function(a, b)
        return a.time < b.time
    end)
    
    -- 100位までに制限
    if #globalRankings > 100 then
        for i = #globalRankings, 101, -1 do
            table.remove(globalRankings, i)
        end
    end
    
    -- プレイヤーの順位を見つける
    local playerRank = nil
    for i, entry in ipairs(globalRankings) do
        if entry.name == playerName and entry.time == completionTime then
            playerRank = i
            break
        end
    end
    
    return playerRank
end

-- 時間を文字列形式に変換
local function formatTime(seconds)
    local minutes = math.floor(seconds / 60)
    local secs = seconds % 60
    return string.format("%02d:%05.2f", minutes, secs)
end

-- プレイヤー状態の初期化
local function initializePlayerState(player)
    playerStates[player.UserId] = {
        state = STATE.WAITING,
        startTime = nil,
        player = player,
        lastGoalTime = 0  -- 重複防止用
    }
end

-- スタートゲートの検出設定（重複防止強化）
local function setupStartGate()
    local success, startGate = pcall(function()
        return workspace.MazeGame:WaitForChild("StartGate", 10)
    end)
    
    if not success or not startGate then
        warn("❌ スタートゲートが見つかりません")
        return
    end
    
    local function onTouched(hit)
        local humanoid = hit.Parent:FindFirstChild("Humanoid")
        if humanoid then
            local player = Players:GetPlayerFromCharacter(hit.Parent)
            if not player then return end
            
            -- プレイヤー状態の初期化
            if not playerStates[player.UserId] then
                initializePlayerState(player)
            end
            
            local playerState = playerStates[player.UserId]
            
            -- WAITING 状態の時のみスタート可能
            if playerState.state == STATE.WAITING then
                -- タイマー開始
                playerState.state = STATE.STARTED
                playerState.startTime = tick()
                
                -- クライアントに通知
                local success, error = pcall(function()
                    remoteEvents.start:FireClient(player)
                end)
                
                if success then
                    print("🚀 " .. player.Name .. " がスタートしました - タイマー開始")
                else
                    warn("❌ スタートイベント送信失敗: " .. tostring(error))
                end
            elseif playerState.state == STATE.STARTED then
                print("⚠️ " .. player.Name .. " は既にタイマー実行中です")
            elseif playerState.state == STATE.COMPLETED then
                -- COMPLETED状態の場合は再挑戦として WAITING に戻す
                playerState.state = STATE.WAITING
                print("🔄 " .. player.Name .. " が再挑戦のため状態をリセットしました")
            end
        end
    end
    
    startGate.Touched:Connect(onTouched)
    print("✅ スタートゲートを設定しました（重複防止システム付き）")
end

-- ゴールゲートの検出設定（重複防止強化）
local function setupGoalGate()
    local success, goalGate = pcall(function()
        return workspace.MazeGame:WaitForChild("GoalGate", 10)
    end)
    
    if not success or not goalGate then
        warn("❌ ゴールゲートが見つかりません")
        return
    end
    
    local function onTouched(hit)
        local humanoid = hit.Parent:FindFirstChild("Humanoid")
        if humanoid then
            local player = Players:GetPlayerFromCharacter(hit.Parent)
            if not player then return end
            
            -- プレイヤー状態の確認
            if not playerStates[player.UserId] then
                print("⚠️ " .. player.Name .. " の状態が未初期化です")
                return
            end
            
            local playerState = playerStates[player.UserId]
            local currentTime = tick()
            
            -- STARTED 状態かつ重複防止チェック
            if playerState.state == STATE.STARTED and 
               (currentTime - playerState.lastGoalTime) > 2 then  -- 2秒間の重複防止
                
                -- タイマー停止・記録計算
                local completionTime = currentTime - playerState.startTime
                local playerRank = addToRankings(player.Name, completionTime)
                
                -- プレイヤー状態を更新
                playerState.state = STATE.COMPLETED
                playerState.lastGoalTime = currentTime
                
                -- クライアントに結果通知
                local success1, error1 = pcall(function()
                    remoteEvents.stop:FireClient(player, completionTime, playerRank)
                end)
                
                -- ランキング保存
                saveRankings()
                
                -- 全プレイヤーにランキング更新を通知
                local success2, error2 = pcall(function()
                    remoteEvents.update:FireAllClients(globalRankings)
                end)
                
                if success1 and success2 then
                    print("🏆 " .. player.Name .. " がゴール! 時間: " .. formatTime(completionTime) .. " 順位: #" .. (playerRank or "不明"))
                else
                    warn("❌ ゴールイベント送信失敗")
                    if not success1 then warn("  ストップイベント: " .. tostring(error1)) end
                    if not success2 then warn("  ランキング更新: " .. tostring(error2)) end
                end
            elseif playerState.state == STATE.WAITING then
                print("⚠️ " .. player.Name .. " はタイマーを開始していません（スタートゲートを通過してください）")
            elseif playerState.state == STATE.COMPLETED then
                print("ℹ️ " .. player.Name .. " は既にゴール済みです（再挑戦はスタートゲートから）")
            elseif (currentTime - playerState.lastGoalTime) <= 2 then
                print("🚫 " .. player.Name .. " の重複記録を防止しました")
            end
        end
    end
    
    goalGate.Touched:Connect(onTouched)
    print("✅ ゴールゲートを設定しました（重複防止システム付き）")
end

-- プレイヤー退出時のクリーンアップ
local function onPlayerRemoving(player)
    if playerStates[player.UserId] then
        playerStates[player.UserId] = nil
        print("🧹 " .. player.Name .. " の状態データをクリアしました")
    end
end

-- プレイヤー参加時の初期化
local function onPlayerAdded(player)
    initializePlayerState(player)
    print("👋 " .. player.Name .. " の状態を初期化しました")
end

-- 初期化
local function initialize()
    print("🚀 迷路ゲームサーバーを初期化中...")
    
    -- ランキングデータ読み込み
    loadRankings()
    
    -- ゲート設定
    setupStartGate()
    setupGoalGate()
    
    -- イベント接続
    Players.PlayerRemoving:Connect(onPlayerRemoving)
    Players.PlayerAdded:Connect(onPlayerAdded)
    
    -- 既存プレイヤーの初期化
    for _, player in pairs(Players:GetPlayers()) do
        initializePlayerState(player)
    end
    
    -- 定期的にランキングを更新（5秒間隔）
    spawn(function()
        while true do
            wait(5)
            if remoteEvents and remoteEvents.update then
                local success, error = pcall(function()
                    remoteEvents.update:FireAllClients(globalRankings)
                end)
                if not success then
                    warn("定期ランキング更新失敗: " .. tostring(error))
                end
            end
        end
    end)
    
    print("✅ 迷路ゲームサーバーの初期化完了!")
    print("📊 現在のランキング数: " .. #globalRankings .. " エントリ")
    print("🔒 重複記録防止システム: 有効")
    print("🔄 状態管理システム: 有効")
    
    if isLocalTest then
        print("🎮 ローカルテストモード - F5でテストプレイを開始してください")
    else
        print("🌐 本番モード - DataStore連携有効")
    end
end

-- ワープゾーンの検出設定
local function setupWarpZone()
    local success, warpZone = pcall(function()
        return workspace.MazeGame.WarpSystem:WaitForChild("WarpZone", 10)
    end)
    
    if not success or not warpZone then
        warn("❌ ワープゾーンが見つかりません（ranking_and_warp_fix.luauを先に実行してください）")
        return
    end
    
    local WARP_DESTINATION = Vector3.new(0, 5, -110) -- スタートエリアへの座標（地面より上）
    
    local function onWarpTouched(hit)
        local humanoid = hit.Parent:FindFirstChild("Humanoid")
        if humanoid then
            local player = Players:GetPlayerFromCharacter(hit.Parent)
            if not player then return end
            
            -- プレイヤー状態の確認
            if not playerStates[player.UserId] then
                initializePlayerState(player)
            end
            
            local playerState = playerStates[player.UserId]
            
            -- COMPLETED状態のみワープ可能（ゴール後のプレイヤーのみ）
            if playerState.state == STATE.COMPLETED then
                -- プレイヤーをワープ
                local character = player.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    -- ワープエフェクト（光る演出）
                    local rootPart = character.HumanoidRootPart
                    
                    -- ワープエフェクトのパーティクル
                    local attachment = Instance.new("Attachment")
                    attachment.Parent = rootPart
                    
                    local sparkles = Instance.new("Sparkles")
                    sparkles.Color = Color3.new(0, 1, 1)
                    sparkles.Parent = rootPart
                    
                    -- 実際のテレポート
                    rootPart.CFrame = CFrame.new(WARP_DESTINATION)
                    
                    -- プレイヤー状態をWAITINGにリセット
                    playerState.state = STATE.WAITING
                    playerState.startTime = nil
                    
                    -- エフェクトのクリーンアップ
                    spawn(function()
                        wait(2) -- 2秒間エフェクト表示
                        if sparkles then sparkles:Destroy() end
                        if attachment then attachment:Destroy() end
                    end)
                    
                    print("🌀 " .. player.Name .. " がワープゾーンを使用してスタートエリアに戻りました")
                end
            elseif playerState.state == STATE.WAITING then
                print("ℹ️ " .. player.Name .. " は既にスタートエリアにいます")
            elseif playerState.state == STATE.STARTED then
                print("⚠️ " .. player.Name .. " はタイマー実行中です（ゴール後にワープを使用してください）")
            end
        end
    end
    
    warpZone.Touched:Connect(onWarpTouched)
    print("✅ ワープゾーンを設定しました（ゴール後にスタートエリアへテレポート）")
end

-- 初期構造の即座構築（最優先、遅延なし）
InitialStructureService.Start()

-- サーバー起動時に初期化
initialize()

-- 複雑迷路システムの開始（初期構造の後、他より先に）
ComplexMazeService.Start()

-- ゴールエリアの拡張（最初に実行）
GoalAreaService.Start()

-- ゴールレイアウトの修正
GoalLayoutService.Start()

-- 照明システムの開始
LightingService.Start()

-- ワープシステムの開始
WarpService.Start()

-- 壁システムの開始（一時的に無効化 - 入口問題修正のため）
-- WallService.Start()

-- サインシステムの開始
SignService.Start()

-- ゴール一本道システムの開始
GoalPathService.Start()

-- クリーンアップシステムの開始
CleanupService.Start()

-- ワープゾーンの設定（少し遅延させてMazeGameが完全に構築されるのを待つ）
spawn(function()
    wait(6) -- 6秒待機（全システム構築を待つ）
    setupWarpZone()
end)

print("✅ 迷路ゲームサーバーが正常に起動しました!")
print("🏗️ 初期構造即座構築対応版")
print("🌟 複雑迷路自動生成対応版")
print("🌀 ワープシステム対応版")
print("🪟 自動ガラス天井システム対応版")
print("🧱 隙間修正壁システム対応版")
print("📊 地面設置ランキングボード対応版")
print("🏟️ 拡張ゴールエリア対応版")
print("🏷️ サイン位置修正対応版")
print("🛤️ ゴール一本道システム対応版")
print("🎨 ゴールレイアウト最適化対応版")
print("🧹 不要サインクリーンアップ対応版")
