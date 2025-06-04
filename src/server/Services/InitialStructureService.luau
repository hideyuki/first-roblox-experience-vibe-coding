-- Kanata Maze 初期構造サービス（ロード時問題解決版）
local InitialStructureService = {}

local workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

-- 初期構造初期化フラグ
local initialStructureInitialized = false

-- 基本環境設定の即座適用
local function setupImmediateEnvironment()
    -- 環境光を即座に設定
    Lighting.Ambient = Color3.new(0.4, 0.4, 0.5)
    Lighting.Brightness = 2
    Lighting.OutdoorAmbient = Color3.new(0.6, 0.6, 0.7)
    Lighting.ColorShift_Bottom = Color3.new(0.3, 0.3, 0.4)
    Lighting.ColorShift_Top = Color3.new(0.8, 0.8, 0.9)
    Lighting.ShadowSoftness = 0.5
    Lighting.TimeOfDay = "14:00:00"
    Lighting.GeographicLatitude = 30
    
    print("☀️ 環境光を即座に設定しました")
end

-- 重要な初期構造の事前構築
local function buildCriticalStructures(mazeGame)
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
    
    -- 壁フォルダ（即座作成）
    local wallsFolder = Instance.new("Folder")
    wallsFolder.Name = "Walls"
    wallsFolder.Parent = mazeGame
    
    -- === スタートエリア周辺の完全封鎖 ===
    print("🚧 スタートエリア周辺を完全封鎖中...")
    
    -- スタートエリアの完全な囲い（40×80のスタートエリアを完全に囲む）
    -- 上側の壁（スタートエリアの奥側、z=-130）
    createWall(Vector3.new(0, 20, -130), Vector3.new(86, 40, 6), "StartAreaBackWall", wallsFolder)
    
    -- 左側の壁（スタートエリアの左側、x=-43）
    createWall(Vector3.new(-43, 20, -110), Vector3.new(6, 40, 46), "StartAreaLeftWall", wallsFolder)
    
    -- 右側の壁（スタートエリアの右側、x=43）
    createWall(Vector3.new(43, 20, -110), Vector3.new(6, 40, 46), "StartAreaRightWall", wallsFolder)
    
    -- スタートエリアからスタートゲートまでの通路の左側壁
    createWall(Vector3.new(-43, 20, -81.5), Vector3.new(6, 40, 17), "StartPassageLeftWall", wallsFolder)
    
    -- スタートエリアからスタートゲートまでの通路の右側壁
    createWall(Vector3.new(43, 20, -81.5), Vector3.new(6, 40, 17), "StartPassageRightWall", wallsFolder)
    
    -- 迷路外周の重要部分（スタート周辺）
    createWall(Vector3.new(-75, 20, -85), Vector3.new(50, 40, 6), "MazeTopWallLeft_Initial", wallsFolder)
    createWall(Vector3.new(75, 20, -85), Vector3.new(50, 40, 6), "MazeTopWallRight_Initial", wallsFolder)
    
    -- 迷路左右の外側壁（スタート周辺）
    createWall(Vector3.new(-95, 20, -50), Vector3.new(6, 40, 70), "MazeLeftWall_Initial", wallsFolder)
    createWall(Vector3.new(95, 20, -50), Vector3.new(6, 40, 70), "MazeRightWall_Initial", wallsFolder)
    
    print("✅ スタートエリア周辺の即座封鎖完了")
    
    -- === ゲートの即座配置 ===
    print("🚪 ゲートを即座に配置中...")
    
    -- スタートゲート
    local startGate = Instance.new("Part")
    startGate.Name = "StartGate"
    startGate.Size = Vector3.new(6, 12, 1)
    startGate.Position = Vector3.new(0, 6, -73)
    startGate.Anchored = true
    startGate.CanCollide = false
    startGate.Material = Enum.Material.ForceField
    startGate.BrickColor = BrickColor.new("Bright green")
    startGate.Transparency = 0.7
    startGate.Parent = mazeGame
    
    -- ゴールゲート
    local goalGate = Instance.new("Part")
    goalGate.Name = "GoalGate"
    goalGate.Size = Vector3.new(6, 12, 1)
    goalGate.Position = Vector3.new(0, 6, 73)
    goalGate.Anchored = true
    goalGate.CanCollide = false
    goalGate.Material = Enum.Material.ForceField
    goalGate.BrickColor = BrickColor.new("Bright red")
    goalGate.Transparency = 0.7
    goalGate.Parent = mazeGame
    
    print("✅ ゲートを即座に配置完了")
    
    -- === 基本ガラス天井の即座配置 ===
    print("🏠 基本ガラス天井を即座に配置中...")
    
    local glassCeilingFolder = Instance.new("Folder")
    glassCeilingFolder.Name = "GlassCeiling"
    glassCeilingFolder.Parent = mazeGame
    
    -- 重要エリアの天井を即座に配置
    local criticalAreas = {
        {x1 = -80, x2 = 80, z1 = -90, z2 = -70},  -- スタートエリア周辺
        {x1 = -30, x2 = 30, z1 = -75, z2 = 75},   -- ゲート周辺
        {x1 = -80, x2 = 80, z1 = 70, z2 = 90}     -- ゴールエリア周辺
    }
    
    for _, area in ipairs(criticalAreas) do
        for x = area.x1, area.x2, 20 do
            for z = area.z1, area.z2, 20 do
                local ceiling = Instance.new("Part")
                ceiling.Name = "GlassCeiling_Initial"
                ceiling.Size = Vector3.new(20, 2, 20)
                ceiling.Position = Vector3.new(x, 42, z)
                ceiling.Anchored = true
                ceiling.CanCollide = true
                ceiling.Material = Enum.Material.Glass
                ceiling.BrickColor = BrickColor.new("Institutional white")
                ceiling.Transparency = 0.1
                ceiling.Reflectance = 0.1
                ceiling.Parent = glassCeilingFolder
            end
        end
    end
    
    print("✅ 基本ガラス天井を即座に配置完了")
    
    -- === 基本照明の即座配置 ===
    print("💡 基本照明を即座に配置中...")
    
    -- 見えない環境光源を即座に配置
    for x = -60, 60, 30 do
        for z = -90, 90, 30 do
            local invisibleLight = Instance.new("Part")
            invisibleLight.Name = "InitialLight"
            invisibleLight.Size = Vector3.new(1, 1, 1)
            invisibleLight.Position = Vector3.new(x, 25, z)
            invisibleLight.Anchored = true
            invisibleLight.Transparency = 1
            invisibleLight.CanCollide = false
            invisibleLight.Parent = mazeGame
            
            local pointLight = Instance.new("PointLight")
            pointLight.Color = Color3.new(0.9, 0.9, 1)
            pointLight.Brightness = 2
            pointLight.Range = 35
            pointLight.Parent = invisibleLight
        end
    end
    
    print("✅ 基本照明を即座に配置完了")
end

-- メイン初期化関数
function InitialStructureService.Initialize()
    if initialStructureInitialized then
        return
    end
    
    print("🏗️ 初期構造サービスを初期化中...")
    
    -- 環境設定を即座に適用
    setupImmediateEnvironment()
    
    -- MazeGameフォルダの確保
    local mazeGame = workspace:FindFirstChild("MazeGame")
    if not mazeGame then
        mazeGame = Instance.new("Folder")
        mazeGame.Name = "MazeGame"
        mazeGame.Parent = workspace
    end
    
    -- 重要な構造を即座に構築
    buildCriticalStructures(mazeGame)
    
    initialStructureInitialized = true
    print("✅ 初期構造サービスの初期化完了！")
    print("🚧 スタートエリア隙間問題を事前に解決しました")
    print("💡 環境光とガラス天井を即座に適用しました")
end

-- サービス開始（最優先で実行）
function InitialStructureService.Start()
    -- 即座に実行（遅延なし）
    InitialStructureService.Initialize()
end

return InitialStructureService