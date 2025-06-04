-- Kanata Maze 壁サービス（隙間修正版）
local WallService = {}

local workspace = game:GetService("Workspace")

-- 壁システム初期化フラグ
local wallSystemInitialized = false

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

-- ガラス天井パネル作成
local function createGlassCeiling(position, size, parent)
    local ceiling = Instance.new("Part")
    ceiling.Name = "GapCeiling"
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

-- 隙間修正システムの構築
local function buildWallFixSystem(mazeGame)
    -- 壁フォルダの取得
    local wallsFolder = mazeGame:FindFirstChild("Walls")
    if not wallsFolder then
        wallsFolder = Instance.new("Folder")
        wallsFolder.Name = "Walls"
        wallsFolder.Parent = mazeGame
    end
    
    -- 問題のある既存の壁を削除
    local problematicWalls = {
        "StartGapWallLeft", "StartGapWallRight", 
        "StartAreaExtendedWallLeft", "StartAreaExtendedWallRight",
        "MazeTopOuterWall", "MazeTopOuterWallLeft", "MazeTopOuterWallRight"
    }
    
    for _, wallName in ipairs(problematicWalls) do
        local existingWall = wallsFolder:FindFirstChild(wallName)
        if existingWall then
            existingWall:Destroy()
        end
    end
    
    -- スタートエリアの隙間修正（入口を開けるため調整）
    createWall(Vector3.new(-50, 20, -81.5), Vector3.new(6, 40, 17), "StartGapWallLeft", wallsFolder)
    createWall(Vector3.new(50, 20, -81.5), Vector3.new(6, 40, 17), "StartGapWallRight", wallsFolder)
    
    -- スタートエリア外側の壁（入口を開けるため短縮）
    createWall(Vector3.new(-65, 20, -115), Vector3.new(6, 40, 30), "StartAreaExtendedWallLeft", wallsFolder)  -- 短縮（z=-130〜-100）
    createWall(Vector3.new(65, 20, -115), Vector3.new(6, 40, 30), "StartAreaExtendedWallRight", wallsFolder)  -- 短縮（z=-130〜-100）
    
    -- ゴールエリアの隙間修正
    createWall(Vector3.new(-50, 20, 79), Vector3.new(6, 40, 12), "GoalGapWallLeft", wallsFolder)
    createWall(Vector3.new(50, 20, 79), Vector3.new(6, 40, 12), "GoalGapWallRight", wallsFolder)
    createWall(Vector3.new(-65, 20, 110), Vector3.new(6, 40, 50), "GoalAreaExtendedWallLeft", wallsFolder)
    createWall(Vector3.new(65, 20, 110), Vector3.new(6, 40, 50), "GoalAreaExtendedWallRight", wallsFolder)
    
    -- 迷路外周の封鎖（スタートエリア入口を開ける）
    createWall(Vector3.new(-110, 20, 0), Vector3.new(6, 40, 160), "MazeLeftOuterWall", wallsFolder)
    createWall(Vector3.new(110, 20, 0), Vector3.new(6, 40, 160), "MazeRightOuterWall", wallsFolder)
    
    -- 迷路上側の壁（スタートエリア入口のために分割）
    createWall(Vector3.new(-75, 20, -85), Vector3.new(70, 40, 6), "MazeTopOuterWallLeft", wallsFolder)    -- 左側部分
    createWall(Vector3.new(75, 20, -85), Vector3.new(70, 40, 6), "MazeTopOuterWallRight", wallsFolder)    -- 右側部分
    -- 中央部分（x=-40からx=40）は開けておく（スタートエリアへの入口）
    
    createWall(Vector3.new(0, 20, 85), Vector3.new(220, 40, 6), "MazeBottomOuterWall", wallsFolder)
    
    print("🧱 エリア間隙間修正壁を構築しました")
    
    -- 隙間部分の天井追加
    local glassCeilingFolder = mazeGame:FindFirstChild("GlassCeiling")
    if glassCeilingFolder then
        -- スタートエリアとスタートゲート間の天井
        for x = -60, 60, 20 do
            for z = -90, -70, 20 do
                createGlassCeiling(Vector3.new(x, 42, z), Vector3.new(20, 2, 20), glassCeilingFolder)
            end
        end
        
        -- ゴールゲートとゴールエリア間の天井
        for x = -60, 60, 20 do
            for z = 70, 90, 20 do
                createGlassCeiling(Vector3.new(x, 42, z), Vector3.new(20, 2, 20), glassCeilingFolder)
            end
        end
        
        print("🏠 隙間部分のガラス天井を追加しました")
    end
end

-- メイン初期化関数
function WallService.Initialize()
    if wallSystemInitialized then
        return
    end
    
    print("🧱 壁サービスを初期化中...")
    
    -- MazeGameの待機
    local mazeGame = workspace:WaitForChild("MazeGame", 30)
    if not mazeGame then
        warn("❌ MazeGameが見つかりません")
        return
    end
    
    -- 隙間修正システム構築
    buildWallFixSystem(mazeGame)
    
    wallSystemInitialized = true
    print("✅ 壁サービスの初期化完了！")
end

-- サービス開始
function WallService.Start()
    spawn(function()
        wait(4) -- 他のシステムの後に実行
        WallService.Initialize()
    end)
end

return WallService