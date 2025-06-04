-- 迷路ゲームのメインサーバーロジック
local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- DataStore設定
local rankingDataStore = DataStoreService:GetDataStore("MazeRankings")
local RANKING_KEY = "GlobalRankings"

-- ゲーム状態管理
local playerTimes = {} -- プレイヤーのタイマー情報
local globalRankings = {} -- グローバルランキングデータ

-- RemoteEventsの取得
local remoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local startTimerEvent = remoteEvents:WaitForChild("StartTimer")
local stopTimerEvent = remoteEvents:WaitForChild("StopTimer")
local updateRankingEvent = remoteEvents:WaitForChild("UpdateRanking")

-- DataStoreからランキングデータを読み込み
local function loadRankings()
    local success, result = pcall(function()
        return rankingDataStore:GetAsync(RANKING_KEY)
    end)
    
    if success and result then
        globalRankings = result
        print("ランキングデータを読み込みました: " .. #globalRankings .. " エントリ")
    else
        globalRankings = {}
        print("新しいランキングデータを初期化しました")
    end
end

-- DataStoreにランキングデータを保存
local function saveRankings()
    local success, error = pcall(function()
        rankingDataStore:SetAsync(RANKING_KEY, globalRankings)
    end)
    
    if success then
        print("ランキングデータを保存しました")
    else
        warn("ランキングデータの保存に失敗: " .. tostring(error))
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

-- スタートゲートの検出設定
local function setupStartGate()
    local startGate = workspace.MazeGame:WaitForChild("StartGate")
    
    local function onTouched(hit)
        local humanoid = hit.Parent:FindFirstChild("Humanoid")
        if humanoid then
            local player = Players:GetPlayerFromCharacter(hit.Parent)
            if player and not playerTimes[player.UserId] then
                -- タイマー開始
                playerTimes[player.UserId] = {
                    startTime = tick(),
                    player = player
                }
                
                -- クライアントに通知
                startTimerEvent:FireClient(player)
                print(player.Name .. " がスタートしました")
            end
        end
    end
    
    startGate.Touched:Connect(onTouched)
end

-- ゴールゲートの検出設定
local function setupGoalGate()
    local goalGate = workspace.MazeGame:WaitForChild("GoalGate")
    
    local function onTouched(hit)
        local humanoid = hit.Parent:FindFirstChild("Humanoid")
        if humanoid then
            local player = Players:GetPlayerFromCharacter(hit.Parent)
            if player and playerTimes[player.UserId] then
                -- タイマー停止
                local completionTime = tick() - playerTimes[player.UserId].startTime
                local playerRank = addToRankings(player.Name, completionTime)
                
                -- クライアントに結果通知
                stopTimerEvent:FireClient(player, completionTime, playerRank)
                
                -- ランキング保存
                saveRankings()
                
                -- 全プレイヤーにランキング更新を通知
                updateRankingEvent:FireAllClients(globalRankings)
                
                -- プレイヤーのタイマーデータをクリア（再挑戦可能にする）
                playerTimes[player.UserId] = nil
                
                print(player.Name .. " がゴール! 時間: " .. formatTime(completionTime) .. " 順位: " .. (playerRank or "不明"))
            end
        end
    end
    
    goalGate.Touched:Connect(onTouched)
end

-- プレイヤー退出時のクリーンアップ
local function onPlayerRemoving(player)
    if playerTimes[player.UserId] then
        playerTimes[player.UserId] = nil
        print(player.Name .. " のタイマーデータをクリアしました")
    end
end

-- 初期化
local function initialize()
    print("迷路ゲームサーバーを初期化中...")
    
    -- ランキングデータ読み込み
    loadRankings()
    
    -- ゲート設定
    setupStartGate()
    setupGoalGate()
    
    -- イベント接続
    Players.PlayerRemoving:Connect(onPlayerRemoving)
    
    -- 定期的にランキングを更新
    spawn(function()
        while true do
            wait(5)
            updateRankingEvent:FireAllClients(globalRankings)
        end
    end)
    
    print("迷路ゲームサーバーの初期化完了!")
end

-- サーバー起動時に初期化
initialize()
