-- Kanata Maze クリーンアップサービス
local CleanupService = {}

local workspace = game:GetService("Workspace")

-- クリーンアップ初期化フラグ
local cleanupInitialized = false

-- 不要なサインボード削除システム
local function cleanupUnwantedSigns(mazeGame)
    -- 削除対象のアイテム
    local itemsToDelete = {
        "CelebrationArch",        -- Congratulationsアーチ
        "GoalEntranceSign",       -- ゲート先のサイン
        "RankingSign",           -- ランキングボードのサイン
        "WarpDirectionSign"      -- ワープ方向サイン
    }
    
    local deletedCount = 0
    
    -- 指定されたアイテムを削除
    for _, itemName in ipairs(itemsToDelete) do
        local item = mazeGame:FindFirstChild(itemName)
        if item then
            item:Destroy()
            deletedCount = deletedCount + 1
            print("🗑️ " .. itemName .. " を削除しました")
        end
    end
    
    -- 追加で、名前にキーワードが含まれるアイテムを検索して削除
    local keywords = {"congratulations", "celebration", "entrance"}
    
    for _, child in pairs(mazeGame:GetChildren()) do
        if child:IsA("Part") then
            local name = string.lower(child.Name)
            for _, keyword in ipairs(keywords) do
                if string.find(name, keyword) then
                    child:Destroy()
                    deletedCount = deletedCount + 1
                    print("🗑️ " .. child.Name .. " を削除しました（キーワードマッチ）")
                    break
                end
            end
        end
    end
    
    -- GoalAreaフォルダ内もチェック
    local goalArea = mazeGame:FindFirstChild("GoalArea")
    if goalArea then
        for _, child in pairs(goalArea:GetChildren()) do
            if child:IsA("Part") then
                local name = string.lower(child.Name)
                for _, keyword in ipairs(keywords) do
                    if string.find(name, keyword) then
                        child:Destroy()
                        deletedCount = deletedCount + 1
                        print("🗑️ " .. child.Name .. " を削除しました（GoalArea内）")
                        break
                    end
                end
            end
        end
    end
    
    print("🧹 不要なサインボードクリーンアップ完了: " .. deletedCount .. " 個削除")
end

-- メイン初期化関数
function CleanupService.Initialize()
    if cleanupInitialized then
        return
    end
    
    print("🧹 クリーンアップサービスを初期化中...")
    
    -- MazeGameの待機
    local mazeGame = workspace:WaitForChild("MazeGame", 30)
    if not mazeGame then
        warn("❌ MazeGameが見つかりません")
        return
    end
    
    -- 不要なサインボード削除
    cleanupUnwantedSigns(mazeGame)
    
    cleanupInitialized = true
    print("✅ クリーンアップサービスの初期化完了！")
end

-- サービス開始
function CleanupService.Start()
    spawn(function()
        wait(7) -- 他の全システムの後に実行
        CleanupService.Initialize()
    end)
end

return CleanupService