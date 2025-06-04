-- ゴールエリア拡張（ランキングボード配置対応）
print("🏟️ ゴールエリアを拡張中...")

local workspace = game:GetService("Workspace")

-- MazeGameフォルダの取得
local mazeGame = workspace:FindFirstChild("MazeGame")
if not mazeGame then
    warn("❌ MazeGameフォルダが見つかりません")
    return
end

-- 既存のゴールエリアを削除
local existingGoalArea = mazeGame:FindFirstChild("GoalArea")
if existingGoalArea then
    existingGoalArea:Destroy()
    print("🗑️ 既存のゴールエリアを削除しました")
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

-- スポーン地点の更新（拡張ゴールエリア用）
local goalSpawn = Instance.new("SpawnLocation")
goalSpawn.Name = "GoalSpawn"
goalSpawn.Size = Vector3.new(6, 1, 6)
goalSpawn.Position = Vector3.new(10, 1, 110)  -- ゴールエリア内にスポーン地点
goalSpawn.Anchored = true
goalSpawn.Material = Enum.Material.SmoothPlastic
goalSpawn.BrickColor = BrickColor.new("Bright green")
goalSpawn.Enabled = false  -- デフォルトでは無効（メインスポーンは別）
goalSpawn.Parent = goalFolder

print("✅ 拡張ゴールエリアの構築完了！")
print("📏 新しいサイズ: 80x60スタッド")
print("📍 範囲: z=85 から z=145")
print("🏛️ ランキングボード台座: z=130")
print("🌀 ワープエリア: z=140")
print("🎊 お祝いアーチ: z=100")
print("")
print("⚠️ 次にランキングボードとワープゾーンの位置を調整してください")