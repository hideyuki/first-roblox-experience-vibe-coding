-- Kanata Maze ゴール一本道サービス
local GoalPathService = {}

local workspace = game:GetService("Workspace")

-- ゴール一本道初期化フラグ
local goalPathInitialized = false

-- 壁作成関数
local function createWall(position, size, name, parent)
    local wall = Instance.new("Part")
    wall.Name = name
    wall.Size = size
    wall.Position = position
    wall.Anchored = true
    wall.Material = Enum.Material.Brick
    wall.BrickColor = BrickColor.new("Dark stone grey")
    wall.Parent = parent
    return wall
end

-- ガラス天井作成関数
local function createGlassCeiling(position, size, parent)
    local ceiling = Instance.new("Part")
    ceiling.Name = "GoalPathCeiling"
    ceiling.Size = size
    ceiling.Position = position
    ceiling.Anchored = true
    ceiling.CanCollide = true
    ceiling.Material = Enum.Material.Glass
    ceiling.BrickColor = BrickColor.new("Institutional white")
    ceiling.Transparency = 0.1
    ceiling.Reflectance = 0.1
    ceiling.Parent = parent
    return ceiling
end

-- 一本道システム構築
local function buildGoalPathSystem(mazeGame)
    -- 壁フォルダの取得
    local wallsFolder = mazeGame:FindFirstChild("Walls")
    if not wallsFolder then
        wallsFolder = Instance.new("Folder")
        wallsFolder.Name = "Walls"
        wallsFolder.Parent = mazeGame
    end
    
    -- 既存の問題のある壁を削除
    local problematicWalls = {
        "GoalGapWallLeft", "GoalGapWallRight",
        "GoalAreaExtendedWallLeft", "GoalAreaExtendedWallRight",
        "MazeBottomOuterWall", "GoalChannelWallLeft", "GoalChannelWallRight",
        "GoalPathWallLeft", "GoalPathWallRight"
    }
    
    for _, wallName in ipairs(problematicWalls) do
        local wall = wallsFolder:FindFirstChild(wallName)
        if wall then
            wall:Destroy()
        end
    end
    
    -- 1. 迷路終端からゴールゲートまでの導線壁
    createWall(Vector3.new(-25, 20, 74), Vector3.new(6, 40, 4), "GoalChannelWallLeft", wallsFolder)
    createWall(Vector3.new(25, 20, 74), Vector3.new(6, 40, 4), "GoalChannelWallRight", wallsFolder)
    
    -- 2. ゴールゲートからゴールエリアまでの一本道
    createWall(Vector3.new(-12, 20, 79), Vector3.new(6, 40, 12), "GoalPathWallLeft", wallsFolder)
    createWall(Vector3.new(12, 20, 79), Vector3.new(6, 40, 12), "GoalPathWallRight", wallsFolder)
    
    -- 3. ゴールエリア周辺の外側封鎖
    createWall(Vector3.new(-45, 20, 115), Vector3.new(6, 40, 60), "GoalAreaLeftOuterWall", wallsFolder)
    createWall(Vector3.new(45, 20, 115), Vector3.new(6, 40, 60), "GoalAreaRightOuterWall", wallsFolder)
    createWall(Vector3.new(0, 20, 150), Vector3.new(96, 40, 6), "GoalAreaBackOuterWall", wallsFolder)
    
    -- 4. 迷路外側からの迂回を防ぐ追加壁
    createWall(Vector3.new(-95, 20, 40), Vector3.new(6, 40, 80), "MazeLeftSideWall", wallsFolder)
    createWall(Vector3.new(95, 20, 40), Vector3.new(6, 40, 80), "MazeRightSideWall", wallsFolder)
    createWall(Vector3.new(-60, 20, 80), Vector3.new(60, 40, 6), "MazeBottomWallLeft", wallsFolder)
    createWall(Vector3.new(60, 20, 80), Vector3.new(60, 40, 6), "MazeBottomWallRight", wallsFolder)
    
    print("🛤️ ゴール一本道システムを構築しました")
    
    -- 5. 天井の追加
    local glassCeilingFolder = mazeGame:FindFirstChild("GlassCeiling")
    if glassCeilingFolder then
        for x = -20, 20, 10 do
            for z = 72, 84, 6 do
                createGlassCeiling(Vector3.new(x, 42, z), Vector3.new(10, 2, 6), glassCeilingFolder)
            end
        end
        print("🏠 一本道天井を追加しました")
    end
    
    -- 6. 案内標識削除（要求により）
    print("🏷️ シンプルなゴール一本道システムを構築しました")
end

-- メイン初期化関数
function GoalPathService.Initialize()
    if goalPathInitialized then
        return
    end
    
    print("🛤️ ゴール一本道サービスを初期化中...")
    
    -- MazeGameの待機
    local mazeGame = workspace:WaitForChild("MazeGame", 30)
    if not mazeGame then
        warn("❌ MazeGameが見つかりません")
        return
    end
    
    -- 一本道システム構築
    buildGoalPathSystem(mazeGame)
    
    goalPathInitialized = true
    print("✅ ゴール一本道サービスの初期化完了！")
end

-- サービス開始
function GoalPathService.Start()
    spawn(function()
        wait(5) -- 他のシステムの後に実行
        GoalPathService.Initialize()
    end)
end

return GoalPathService