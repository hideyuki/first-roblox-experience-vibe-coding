-- Kanata Maze ゴールレイアウトサービス
local GoalLayoutService = {}

local workspace = game:GetService("Workspace")

-- ゴールレイアウト初期化フラグ
local goalLayoutInitialized = false

-- レイアウト修正システム構築
local function buildGoalLayoutSystem(mazeGame)
    -- 既存のアイテムを削除
    local itemsToRemove = {
        "CelebrationArch", "RankingPedestal", "WarpArea", 
        "GoalEntranceSign", "RankingSign", "WarpDirectionSign"
    }
    
    for _, itemName in ipairs(itemsToRemove) do
        local item = mazeGame:FindFirstChild(itemName)
        if item then
            item:Destroy()
        end
    end
    
    -- 1. Congratulationsアーチ削除（要求により）
    
    -- 2. ランキングボード台座（右側）
    local rankingPedestal = Instance.new("Part")
    rankingPedestal.Name = "RankingPedestal"
    rankingPedestal.Size = Vector3.new(22, 2, 4)
    rankingPedestal.Position = Vector3.new(20, 1, 135)  -- 右側
    rankingPedestal.Anchored = true
    rankingPedestal.Material = Enum.Material.Marble
    rankingPedestal.BrickColor = BrickColor.new("Institutional white")
    rankingPedestal.Parent = mazeGame
    
    -- 3. ワープエリアの床マーキング（左側）
    local warpArea = Instance.new("Part")
    warpArea.Name = "WarpArea"
    warpArea.Size = Vector3.new(18, 0.1, 18)
    warpArea.Position = Vector3.new(-20, 0.55, 135)  -- 左側
    warpArea.Anchored = true
    warpArea.Material = Enum.Material.Neon
    warpArea.BrickColor = BrickColor.new("Bright blue")
    warpArea.Transparency = 0.7
    warpArea.Parent = mazeGame
    
    -- 4. エリア案内標識削除（要求により）
    
    print("🎨 ゴールエリアレイアウトを修正しました")
end

-- メイン初期化関数
function GoalLayoutService.Initialize()
    if goalLayoutInitialized then
        return
    end
    
    print("🎨 ゴールレイアウトサービスを初期化中...")
    
    -- MazeGameの待機
    local mazeGame = workspace:WaitForChild("MazeGame", 30)
    if not mazeGame then
        warn("❌ MazeGameが見つかりません")
        return
    end
    
    -- レイアウト修正システム構築
    buildGoalLayoutSystem(mazeGame)
    
    goalLayoutInitialized = true
    print("✅ ゴールレイアウトサービスの初期化完了！")
end

-- サービス開始
function GoalLayoutService.Start()
    spawn(function()
        wait(2) -- ゴールエリア構築の後に実行
        GoalLayoutService.Initialize()
    end)
end

return GoalLayoutService