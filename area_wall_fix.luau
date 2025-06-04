-- エリア間隙間修正（壁追加）
print("🧱 エリア間の隙間を修正中...")

local workspace = game:GetService("Workspace")

-- MazeGameフォルダの取得
local mazeGame = workspace:FindFirstChild("MazeGame")
if not mazeGame then
    warn("❌ MazeGameフォルダが見つかりません")
    return
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

-- 壁フォルダの取得（既存の壁と統合）
local wallsFolder = mazeGame:FindFirstChild("Walls")
if not wallsFolder then
    wallsFolder = Instance.new("Folder")
    wallsFolder.Name = "Walls"
    wallsFolder.Parent = mazeGame
end

-- === スタートエリアの隙間修正 ===
print("🧱 スタートエリアの隙間を修正中...")

-- スタートエリア: z=-90 から z=-130
-- スタートゲート: z=-73
-- 隙間: z=-90 から z=-73 の間

-- 左側の壁（スタートエリアとスタートゲート間）
createWall(
    Vector3.new(-50, 20, -81.5),  -- 中間位置 (-90 + -73) / 2 = -81.5
    Vector3.new(6, 40, 17),       -- 幅6, 高さ40, 長さ17 (-90 - (-73) = 17)
    "StartGapWallLeft",
    wallsFolder
)

-- 右側の壁（スタートエリアとスタートゲート間）
createWall(
    Vector3.new(50, 20, -81.5),
    Vector3.new(6, 40, 17),
    "StartGapWallRight", 
    wallsFolder
)

-- スタートエリアの左右外側の延長壁
createWall(
    Vector3.new(-65, 20, -110),   -- スタートエリア左外側
    Vector3.new(6, 40, 40),       -- スタートエリア全体をカバー
    "StartAreaExtendedWallLeft",
    wallsFolder
)

createWall(
    Vector3.new(65, 20, -110),    -- スタートエリア右外側
    Vector3.new(6, 40, 40),
    "StartAreaExtendedWallRight",
    wallsFolder
)

print("✅ スタートエリアの隙間修正完了")

-- === ゴールエリアの隙間修正 ===
print("🧱 ゴールエリアの隙間を修正中...")

-- ゴールエリア: z=85 から z=135
-- ゴールゲート: z=73
-- 隙間: z=73 から z=85 の間

-- 左側の壁（ゴールゲートとゴールエリア間）
createWall(
    Vector3.new(-50, 20, 79),     -- 中間位置 (73 + 85) / 2 = 79
    Vector3.new(6, 40, 12),       -- 長さ12 (85 - 73 = 12)
    "GoalGapWallLeft",
    wallsFolder
)

-- 右側の壁（ゴールゲートとゴールエリア間）
createWall(
    Vector3.new(50, 20, 79),
    Vector3.new(6, 40, 12),
    "GoalGapWallRight",
    wallsFolder
)

-- ゴールエリアの左右外側の延長壁
createWall(
    Vector3.new(-65, 20, 110),    -- ゴールエリア左外側
    Vector3.new(6, 40, 50),       -- ゴールエリア全体をカバー
    "GoalAreaExtendedWallLeft",
    wallsFolder
)

createWall(
    Vector3.new(65, 20, 110),     -- ゴールエリア右外側
    Vector3.new(6, 40, 50),
    "GoalAreaExtendedWallRight",
    wallsFolder
)

print("✅ ゴールエリアの隙間修正完了")

-- === 迷路外周の完全封鎖 ===
print("🧱 迷路外周の封鎖を強化中...")

-- 迷路の左右外側に追加の壁
createWall(
    Vector3.new(-110, 20, 0),     -- 迷路左外側
    Vector3.new(6, 40, 160),      -- 迷路全体の高さをカバー
    "MazeLeftOuterWall",
    wallsFolder
)

createWall(
    Vector3.new(110, 20, 0),      -- 迷路右外側
    Vector3.new(6, 40, 160),
    "MazeRightOuterWall",
    wallsFolder
)

-- 迷路上下の外側壁
createWall(
    Vector3.new(0, 20, -85),      -- 迷路上外側（スタートゲート前）
    Vector3.new(220, 40, 6),      -- 幅を大きくして完全封鎖
    "MazeTopOuterWall",
    wallsFolder
)

createWall(
    Vector3.new(0, 20, 85),       -- 迷路下外側（ゴールゲート後）
    Vector3.new(220, 40, 6),
    "MazeBottomOuterWall",
    wallsFolder
)

print("✅ 迷路外周の封鎖強化完了")

-- === 天井の追加（隙間部分） ===
print("🏠 隙間部分の天井を追加中...")

-- ガラス天井フォルダの取得
local glassCeilingFolder = mazeGame:FindFirstChild("GlassCeiling")
if glassCeilingFolder then
    -- スタートエリアとスタートゲート間の天井
    for x = -60, 60, 20 do
        for z = -90, -70, 20 do
            local ceiling = Instance.new("Part")
            ceiling.Name = "StartGapCeiling"
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
    
    -- ゴールゲートとゴールエリア間の天井
    for x = -60, 60, 20 do
        for z = 70, 90, 20 do
            local ceiling = Instance.new("Part")
            ceiling.Name = "GoalGapCeiling"
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
    
    print("🏠 隙間部分の天井追加完了")
end

print("✅ エリア間隙間修正システム完了！")
print("🧱 追加した壁:")
print("  • スタートエリア隙間封鎖: 左右2面")
print("  • ゴールエリア隙間封鎖: 左右2面") 
print("  • エリア外側延長壁: 各4面")
print("  • 迷路外周強化壁: 4面")
print("🏠 追加した天井:")
print("  • スタートエリア隙間天井")
print("  • ゴールエリア隙間天井")
print("")
print("🚫 これで迷路外側を通ったズルができなくなりました！")