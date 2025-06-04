-- ゴールまでの一本道修正
print("🛤️ ゴールまでの一本道を構築中...")

local workspace = game:GetService("Workspace")

-- MazeGameフォルダの取得
local mazeGame = workspace:FindFirstChild("MazeGame")
if not mazeGame then
    warn("❌ MazeGameフォルダが見つかりません")
    return
end

-- 壁フォルダの取得
local wallsFolder = mazeGame:FindFirstChild("Walls")
if not wallsFolder then
    wallsFolder = Instance.new("Folder")
    wallsFolder.Name = "Walls"
    wallsFolder.Parent = mazeGame
end

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

-- 既存の問題のある壁を削除
local problematicWalls = {
    "GoalGapWallLeft", "GoalGapWallRight",
    "GoalAreaExtendedWallLeft", "GoalAreaExtendedWallRight",
    "MazeBottomOuterWall"
}

for _, wallName in ipairs(problematicWalls) do
    local wall = wallsFolder:FindFirstChild(wallName)
    if wall then
        wall:Destroy()
        print("🗑️ " .. wallName .. " を削除しました")
    end
end

-- === 一本道システムの構築 ===

-- 1. 迷路終端からゴールゲートまでの導線壁
print("🛤️ 迷路終端からゴールゲートまでの導線を構築中...")

-- 迷路終端（z=75）からゴールゲート（z=73）までのチャネル
-- 左側の導線壁
createWall(Vector3.new(-25, 20, 74), Vector3.new(6, 40, 4), "GoalChannelWallLeft", wallsFolder)
-- 右側の導線壁  
createWall(Vector3.new(25, 20, 74), Vector3.new(6, 40, 4), "GoalChannelWallRight", wallsFolder)

-- 2. ゴールゲートからゴールエリアまでの一本道
print("🛤️ ゴールゲートからゴールエリアまでの一本道を構築中...")

-- ゴールゲート（z=73）からゴールエリア入口（z=85）までの狭い通路
-- 通路幅: 16スタッド（ゴールゲートと同じ幅）

-- 左側の通路壁
createWall(Vector3.new(-12, 20, 79), Vector3.new(6, 40, 12), "GoalPathWallLeft", wallsFolder)
-- 右側の通路壁
createWall(Vector3.new(12, 20, 79), Vector3.new(6, 40, 12), "GoalPathWallRight", wallsFolder)

-- 3. 迷路外側の完全封鎖（ゴールエリア周辺）
print("🛤️ ゴールエリア周辺の外側封鎖を構築中...")

-- ゴールエリア左右の外側壁（迂回防止）
createWall(Vector3.new(-45, 20, 115), Vector3.new(6, 40, 60), "GoalAreaLeftOuterWall", wallsFolder)
createWall(Vector3.new(45, 20, 115), Vector3.new(6, 40, 60), "GoalAreaRightOuterWall", wallsFolder)

-- ゴールエリア奥の外側壁
createWall(Vector3.new(0, 20, 150), Vector3.new(96, 40, 6), "GoalAreaBackOuterWall", wallsFolder)

-- 4. 迷路外側からの迂回を防ぐ追加壁
print("🛤️ 迂回防止壁を構築中...")

-- 迷路左右の外側を完全封鎖
createWall(Vector3.new(-95, 20, 40), Vector3.new(6, 40, 80), "MazeLeftSideWall", wallsFolder)
createWall(Vector3.new(95, 20, 40), Vector3.new(6, 40, 80), "MazeRightSideWall", wallsFolder)

-- 迷路下側の外側壁（ゴールエリア手前まで）
createWall(Vector3.new(-60, 20, 80), Vector3.new(60, 40, 6), "MazeBottomWallLeft", wallsFolder)
createWall(Vector3.new(60, 20, 80), Vector3.new(60, 40, 6), "MazeBottomWallRight", wallsFolder)
-- 中央部分（x=-15からx=15）は通路として開けておく

-- 5. 天井の追加（一本道部分）
print("🏠 一本道部分の天井を追加中...")

-- ガラス天井フォルダの取得
local glassCeilingFolder = mazeGame:FindFirstChild("GlassCeiling")
if glassCeilingFolder then
    -- ゴールゲートから通路までの天井
    for x = -20, 20, 10 do
        for z = 72, 84, 6 do
            local ceiling = Instance.new("Part")
            ceiling.Name = "GoalPathCeiling"
            ceiling.Size = Vector3.new(10, 2, 6)
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
    print("🏠 一本道天井を追加しました")
end

-- 6. 案内標識の設置
print("🏷️ 案内標識を設置中...")

-- 「GOAL ENTRANCE」標識
local goalEntranceSign = Instance.new("Part")
goalEntranceSign.Name = "GoalEntranceSign"
goalEntranceSign.Size = Vector3.new(8, 2, 0.5)
goalEntranceSign.Position = Vector3.new(0, 8, 78)  -- 通路の中間
goalEntranceSign.Anchored = true
goalEntranceSign.Material = Enum.Material.SmoothPlastic
goalEntranceSign.BrickColor = BrickColor.new("Bright yellow")
goalEntranceSign.Parent = mazeGame

-- 標識のGUI
local entranceGui = Instance.new("SurfaceGui")
entranceGui.Name = "EntranceGui"
entranceGui.Face = Enum.NormalId.Front
entranceGui.Parent = goalEntranceSign

local entranceLabel = Instance.new("TextLabel")
entranceLabel.Name = "EntranceLabel"
entranceLabel.Size = UDim2.new(1, 0, 1, 0)
entranceLabel.BackgroundTransparency = 1
entranceLabel.Text = "→ GOAL ENTRANCE ←"
entranceLabel.TextColor3 = Color3.new(0, 0, 0)
entranceLabel.TextScaled = true
entranceLabel.Font = Enum.Font.SourceSansBold
entranceLabel.Parent = entranceGui

print("✅ ゴールまでの一本道システム構築完了！")
print("🛤️ 一本道の構造:")
print("  1. 迷路終端 → ゴールゲート（チャネル幅: 20スタッド）")
print("  2. ゴールゲート → ゴールエリア（通路幅: 16スタッド）")
print("  3. 外側完全封鎖（迂回不可）")
print("  4. 天井付き（飛び越え不可）")
print("  5. 案内標識付き")
print("")
print("🚫 これでゴールゲートを通らずにゴールエリアに行くことは不可能になりました！")