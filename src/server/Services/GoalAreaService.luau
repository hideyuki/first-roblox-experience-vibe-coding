-- Kanata Maze ゴールエリアサービス（拡張版）
local GoalAreaService = {}

local workspace = game:GetService("Workspace")

-- ゴールエリア初期化フラグ
local goalAreaInitialized = false

-- 拡張ゴールエリア構築
local function buildExpandedGoalArea(mazeGame)
    -- 既存のゴールエリアを削除
    local existingGoalArea = mazeGame:FindFirstChild("GoalArea")
    if existingGoalArea then
        existingGoalArea:Destroy()
    end
    
    -- 新しい拡張ゴールエリアフォルダ
    local goalFolder = Instance.new("Folder")
    goalFolder.Name = "GoalArea"
    goalFolder.Parent = mazeGame
    
    -- 拡張されたゴールエリアの床
    local goalFloor = Instance.new("Part")
    goalFloor.Name = "GoalFloor"
    goalFloor.Size = Vector3.new(80, 1, 60)  -- 80x60スタッドに拡張
    goalFloor.Position = Vector3.new(0, 0, 115)  -- z=85から145までカバー
    goalFloor.Anchored = true
    goalFloor.Material = Enum.Material.Concrete
    goalFloor.BrickColor = BrickColor.new("Bright red")
    goalFloor.Parent = goalFolder
    
    -- ゴールエリアの壁（拡張版）
    local goalWalls = {
        -- 左壁
        {Vector3.new(1, 10, 60), Vector3.new(-40.5, 5, 115)},
        -- 右壁  
        {Vector3.new(1, 10, 60), Vector3.new(40.5, 5, 115)},
        -- 奥壁
        {Vector3.new(80, 10, 1), Vector3.new(0, 5, 145.5)},
        -- 手前壁（ゴールゲート周辺、左右に分割）
        {Vector3.new(35, 10, 1), Vector3.new(-22.5, 5, 84.5)},  -- 左側
        {Vector3.new(35, 10, 1), Vector3.new(22.5, 5, 84.5)}    -- 右側
    }
    
    for i, wall in ipairs(goalWalls) do
        local wallPart = Instance.new("Part")
        wallPart.Name = "GoalWall" .. i
        wallPart.Size = wall[1]
        wallPart.Position = wall[2]
        wallPart.Anchored = true
        wallPart.Material = Enum.Material.Brick
        wallPart.BrickColor = BrickColor.new("Dark stone grey")
        wallPart.Parent = goalFolder
    end
    
    -- ランキングボード台座の作成
    local rankingPedestal = Instance.new("Part")
    rankingPedestal.Name = "RankingPedestal"
    rankingPedestal.Size = Vector3.new(22, 2, 4)  -- ランキングボード用の台座
    rankingPedestal.Position = Vector3.new(0, 1, 130)  -- ゴールエリア中央奥
    rankingPedestal.Anchored = true
    rankingPedestal.Material = Enum.Material.Marble
    rankingPedestal.BrickColor = BrickColor.new("Institutional white")
    rankingPedestal.Parent = goalFolder
    
    -- ワープゾーン用のエリア
    local warpArea = Instance.new("Part")
    warpArea.Name = "WarpArea"
    warpArea.Size = Vector3.new(20, 0.1, 20)  -- ワープ用の床マーキング
    warpArea.Position = Vector3.new(0, 0.55, 140)  -- ランキングボードの後ろ
    warpArea.Anchored = true
    warpArea.Material = Enum.Material.Neon
    warpArea.BrickColor = BrickColor.new("Bright blue")
    warpArea.Transparency = 0.7
    warpArea.Parent = goalFolder
    
    -- ゴールエリアの装飾
    local celebrationArch = Instance.new("Part")
    celebrationArch.Name = "CelebrationArch"
    celebrationArch.Size = Vector3.new(25, 12, 3)
    celebrationArch.Position = Vector3.new(0, 6, 100)  -- エリア入口
    celebrationArch.Anchored = true
    celebrationArch.Material = Enum.Material.Marble
    celebrationArch.BrickColor = BrickColor.new("Bright yellow")
    celebrationArch.Parent = goalFolder
    
    -- アーチのテキスト
    local archGui = Instance.new("SurfaceGui")
    archGui.Name = "ArchGui"
    archGui.Face = Enum.NormalId.Front
    archGui.Parent = celebrationArch
    
    local archLabel = Instance.new("TextLabel")
    archLabel.Name = "ArchLabel"
    archLabel.Size = UDim2.new(1, 0, 1, 0)
    archLabel.BackgroundTransparency = 1
    archLabel.Text = "🎉 CONGRATULATIONS! 🎉"
    archLabel.TextColor3 = Color3.new(1, 1, 1)
    archLabel.TextScaled = true
    archLabel.Font = Enum.Font.SourceSansBold
    archLabel.Parent = archGui
    
    print("🏟️ 拡張ゴールエリアを構築しました（80x60スタッド）")
    return goalFolder
end

-- メイン初期化関数
function GoalAreaService.Initialize()
    if goalAreaInitialized then
        return
    end
    
    print("🏟️ ゴールエリアサービスを初期化中...")
    
    -- MazeGameの待機
    local mazeGame = workspace:WaitForChild("MazeGame", 30)
    if not mazeGame then
        warn("❌ MazeGameが見つかりません")
        return
    end
    
    -- 拡張ゴールエリア構築
    buildExpandedGoalArea(mazeGame)
    
    goalAreaInitialized = true
    print("✅ ゴールエリアサービスの初期化完了！")
end

-- サービス開始
function GoalAreaService.Start()
    spawn(function()
        wait(1) -- 早めに構築（他のサービスより前）
        GoalAreaService.Initialize()
    end)
end

return GoalAreaService