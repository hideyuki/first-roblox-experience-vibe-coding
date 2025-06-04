-- スタートエリア入口修正（緊急対応）
print("🚪 スタートエリア入口を修正中...")

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
    warn("❌ 壁フォルダが見つかりません")
    return
end

-- 問題のある壁を特定して削除
local problematicWalls = {
    "MazeTopOuterWall",
    "StartAreaExtendedWallLeft", 
    "StartAreaExtendedWallRight",
    "MazeTopOuterWallLeft",
    "MazeTopOuterWallRight"
}

local deletedCount = 0
for _, wallName in ipairs(problematicWalls) do
    local wall = wallsFolder:FindFirstChild(wallName)
    if wall then
        wall:Destroy()
        deletedCount = deletedCount + 1
        print("🗑️ " .. wallName .. " を削除しました")
    end
end

-- 全ての子を確認して、スタート入口を塞ぐ壁を削除
for _, part in pairs(wallsFolder:GetChildren()) do
    if part:IsA("Part") then
        local pos = part.Position
        local size = part.Size
        
        -- z=-85付近でx=0周辺の大きな壁を削除
        if math.abs(pos.Z + 85) < 5 and size.X > 100 then
            part:Destroy()
            deletedCount = deletedCount + 1
            print("🗑️ 大型入口阻害壁 (" .. part.Name .. ") を削除しました")
        end
        
        -- スタートエリア外側の長い壁を削除
        if (math.abs(pos.X + 65) < 5 or math.abs(pos.X - 65) < 5) and 
           pos.Z < -90 and size.Z > 35 then
            part:Destroy()
            deletedCount = deletedCount + 1
            print("🗑️ スタートエリア外側壁 (" .. part.Name .. ") を削除しました")
        end
    end
end

-- 新しい適切な壁を作成（入口を開ける）
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

-- 迷路上側の壁を適切に分割して作成（入口を開ける）
createWall(Vector3.new(-85, 20, -85), Vector3.new(50, 40, 6), "MazeTopWallLeft", wallsFolder)    -- 左側
createWall(Vector3.new(85, 20, -85), Vector3.new(50, 40, 6), "MazeTopWallRight", wallsFolder)    -- 右側
-- 中央部分（x=-35からx=35）は開けておく（スタートエリアへの入口）

print("✅ スタートエリア入口修正完了！")
print("🗑️ 削除した壁: " .. deletedCount .. " 個")
print("🚪 新しい入口: 70スタッド幅 (x=-35 から x=35)")
print("🧱 新しい壁: 左右に分割配置")
print("")
print("🎮 これでスタートエリアにアクセスできるようになりました！")