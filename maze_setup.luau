-- 完全版迷路ゲーム構築スクリプト
local workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- 既存削除
if workspace:FindFirstChild("MazeGame") then 
    workspace.MazeGame:Destroy() 
end

-- メインフォルダ
local mazeGame = Instance.new("Folder")
mazeGame.Name = "MazeGame"
mazeGame.Parent = workspace

-- 迷路パターン（出入口付き、広い通路）
local pattern = {
    {1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1,1,1,1},
    {1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,1},
    {1,0,1,1,1,1,0,1,0,1,1,1,1,1,1,1,0,1,0,1,1,1,1,0,1},
    {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,1,1,0,1,1,1,1,1,1,1,0,1,0,1,1,1,1,1,1,1,0,1,1,1},
    {1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,0,1,1,1,1,1,0,1,1,1,0,1,0,1,1,1,0,1,1,1,1,1,0,1},
    {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,1,1,0,1,1,1,1,1,0,1,1,1,1,1,0,1,1,1,1,1,0,1,1,1},
    {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,0,1,1,1,0,1,1,1,1,1,0,1,0,1,1,1,1,1,0,1,1,1,0,1},
    {1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,1,1,0,1,1,1,0,1,1,1,1,1,1,1,1,1,0,1,1,1,0,1,1,1},
    {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,0,1,1,1,1,1,0,1,1,1,0,1,0,1,1,1,0,1,1,1,1,1,0,1},
    {1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,1,1,0,1,1,1,1,1,0,1,1,1,1,1,0,1,1,1,1,1,0,1,1,1},
    {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,0,1,1,1,1,1,0,1,1,1,0,1,0,1,1,1,0,1,1,1,1,1,0,1},
    {1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,1,1,0,1,1,1,1,1,1,1,0,1,0,1,1,1,1,1,1,1,0,1,1,1},
    {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,0,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,0,1},
    {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1,1,1,1}
}

-- 1. スタートエリア
local startFolder = Instance.new("Folder")
startFolder.Name = "StartArea"
startFolder.Parent = mazeGame

local startFloor = Instance.new("Part")
startFloor.Size = Vector3.new(30, 1, 15)
startFloor.Position = Vector3.new(0, 0, -35)
startFloor.Anchored = true
startFloor.Material = Enum.Material.Concrete
startFloor.BrickColor = BrickColor.new("Bright green")
startFloor.Parent = startFolder

local startWalls = {
    {Vector3.new(1, 10, 15), Vector3.new(-15.5, 5, -35)},
    {Vector3.new(1, 10, 15), Vector3.new(15.5, 5, -35)},
    {Vector3.new(30, 10, 1), Vector3.new(0, 5, -42.5)},
    {Vector3.new(12, 10, 1), Vector3.new(-9, 5, -27.5)},
    {Vector3.new(12, 10, 1), Vector3.new(9, 5, -27.5)}
}
for i, w in ipairs(startWalls) do
    local wall = Instance.new("Part")
    wall.Size, wall.Position = w[1], w[2]
    wall.Anchored = true
    wall.Material = Enum.Material.Brick
    wall.BrickColor = BrickColor.new("Dark stone grey")
    wall.Parent = startFolder
end

-- 2. ゴールエリア
local goalFolder = Instance.new("Folder")
goalFolder.Name = "GoalArea"
goalFolder.Parent = mazeGame

local goalFloor = Instance.new("Part")
goalFloor.Size = Vector3.new(25, 1, 20)
goalFloor.Position = Vector3.new(0, 0, 45)
goalFloor.Anchored = true
goalFloor.Material = Enum.Material.Concrete
goalFloor.BrickColor = BrickColor.new("Bright red")
goalFloor.Parent = goalFolder

local goalWalls = {
    {Vector3.new(1, 10, 20), Vector3.new(-12.5, 5, 45)},
    {Vector3.new(1, 10, 20), Vector3.new(12.5, 5, 45)},
    {Vector3.new(25, 10, 1), Vector3.new(0, 5, 55)},
    {Vector3.new(9, 10, 1), Vector3.new(-8, 5, 35)},
    {Vector3.new(9, 10, 1), Vector3.new(8, 5, 35)}
}
for i, w in ipairs(goalWalls) do
    local wall = Instance.new("Part")
    wall.Size, wall.Position = w[1], w[2]
    wall.Anchored = true
    wall.Material = Enum.Material.Brick
    wall.BrickColor = BrickColor.new("Dark stone grey")
    wall.Parent = goalFolder
end

-- 3. 迷路の壁
local wallsFolder = Instance.new("Folder")
wallsFolder.Name = "Walls"
wallsFolder.Parent = mazeGame

local wallCount = 0
for row = 1, 25 do
    for col = 1, 25 do
        if pattern[row][col] == 1 then
            local wall = Instance.new("Part")
            wall.Size = Vector3.new(2, 10, 2)
            wall.Position = Vector3.new((col - 13) * 2, 5, (row - 13) * 2)
            wall.Anchored = true
            wall.Material = Enum.Material.Brick
            wall.BrickColor = BrickColor.new("Dark stone grey")
            wall.Parent = wallsFolder
            wallCount = wallCount + 1
        end
    end
end

-- 4. スタートゲート
local startGate = Instance.new("Part")
startGate.Name = "StartGate"
startGate.Size = Vector3.new(6, 12, 1)
startGate.Position = Vector3.new(0, 6, -27.5)
startGate.Anchored = true
startGate.CanCollide = false
startGate.Material = Enum.Material.ForceField
startGate.BrickColor = BrickColor.new("Bright green")
startGate.Transparency = 0.7
startGate.Parent = mazeGame

-- 5. ゴールゲート
local goalGate = Instance.new("Part")
goalGate.Name = "GoalGate"
goalGate.Size = Vector3.new(6, 12, 1)
goalGate.Position = Vector3.new(0, 6, 35)
goalGate.Anchored = true
goalGate.CanCollide = false
goalGate.Material = Enum.Material.ForceField
goalGate.BrickColor = BrickColor.new("Bright red")
goalGate.Transparency = 0.7
goalGate.Parent = mazeGame

-- 6. スポーン地点（スタートエリア内）
local spawnLocation = Instance.new("SpawnLocation")
spawnLocation.Name = "MazeSpawn"
spawnLocation.Size = Vector3.new(6, 1, 6)
spawnLocation.Position = Vector3.new(0, 1, -38)
spawnLocation.Anchored = true
spawnLocation.Material = Enum.Material.SmoothPlastic
spawnLocation.BrickColor = BrickColor.new("Bright blue")
spawnLocation.Parent = mazeGame

-- 7. ランキングボード（ゴールエリアから離して配置）
local rankingBoard = Instance.new("Part")
rankingBoard.Name = "RankingBoard"
rankingBoard.Size = Vector3.new(12, 20, 2)
rankingBoard.Position = Vector3.new(0, 10, 65)  -- ゴールエリアから20スタッド離れた位置
rankingBoard.Anchored = true
rankingBoard.Material = Enum.Material.SmoothPlastic
rankingBoard.BrickColor = BrickColor.new("Dark stone grey")
rankingBoard.Parent = mazeGame

-- ランキング表示用のSurfaceGui
local rankingGui = Instance.new("SurfaceGui")
rankingGui.Name = "RankingGui"
rankingGui.Face = Enum.NormalId.Front
rankingGui.Parent = rankingBoard

-- タイトル
local titleFrame = Instance.new("Frame")
titleFrame.Name = "TitleFrame"
titleFrame.Size = UDim2.new(1, 0, 0.1, 0)
titleFrame.Position = UDim2.new(0, 0, 0, 0)
titleFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
titleFrame.BorderSizePixel = 0
titleFrame.Parent = rankingGui

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, 0, 1, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🏆 MAZE RANKINGS 🏆"
titleLabel.TextColor3 = Color3.new(1, 1, 0)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Parent = titleFrame

-- ランキング表示エリア
local rankingFrame = Instance.new("ScrollingFrame")
rankingFrame.Name = "RankingFrame"
rankingFrame.Size = UDim2.new(1, 0, 0.9, 0)
rankingFrame.Position = UDim2.new(0, 0, 0.1, 0)
rankingFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
rankingFrame.BorderSizePixel = 0
rankingFrame.ScrollBarThickness = 8
rankingFrame.CanvasSize = UDim2.new(0, 0, 0, 2000)
rankingFrame.Parent = rankingGui

-- 初期ランキングエントリ
for i = 1, 10 do
    local entryFrame = Instance.new("Frame")
    entryFrame.Name = "Entry" .. i
    entryFrame.Size = UDim2.new(1, -10, 0, 18)
    entryFrame.Position = UDim2.new(0, 5, 0, (i-1) * 20)
    entryFrame.BackgroundTransparency = 1
    entryFrame.Parent = rankingFrame
    
    local rankLabel = Instance.new("TextLabel")
    rankLabel.Name = "RankLabel"
    rankLabel.Size = UDim2.new(0.15, 0, 1, 0)
    rankLabel.Position = UDim2.new(0, 0, 0, 0)
    rankLabel.BackgroundTransparency = 1
    rankLabel.Text = "#" .. i
    rankLabel.TextColor3 = Color3.new(1, 1, 1)
    rankLabel.TextScaled = true
    rankLabel.Font = Enum.Font.SourceSansBold
    rankLabel.Parent = entryFrame
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.Size = UDim2.new(0.55, 0, 1, 0)
    nameLabel.Position = UDim2.new(0.15, 0, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = "---"
    nameLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.SourceSans
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = entryFrame
    
    local timeLabel = Instance.new("TextLabel")
    timeLabel.Name = "TimeLabel"
    timeLabel.Size = UDim2.new(0.3, 0, 1, 0)
    timeLabel.Position = UDim2.new(0.7, 0, 0, 0)
    timeLabel.BackgroundTransparency = 1
    timeLabel.Text = "--:--"
    timeLabel.TextColor3 = Color3.new(0.6, 0.6, 1)
    timeLabel.TextScaled = true
    timeLabel.Font = Enum.Font.Code
    timeLabel.TextXAlignment = Enum.TextXAlignment.Right
    timeLabel.Parent = entryFrame
end

-- 8. RemoteEventsの作成
local remoteEventsFolder = ReplicatedStorage:FindFirstChild("RemoteEvents")
if not remoteEventsFolder then
    remoteEventsFolder = Instance.new("Folder")
    remoteEventsFolder.Name = "RemoteEvents"
    remoteEventsFolder.Parent = ReplicatedStorage
end

local startTimerEvent = Instance.new("RemoteEvent")
startTimerEvent.Name = "StartTimer"
startTimerEvent.Parent = remoteEventsFolder

local stopTimerEvent = Instance.new("RemoteEvent")
stopTimerEvent.Name = "StopTimer"
stopTimerEvent.Parent = remoteEventsFolder

local updateRankingEvent = Instance.new("RemoteEvent")
updateRankingEvent.Name = "UpdateRanking"
updateRankingEvent.Parent = remoteEventsFolder

-- 9. サインの作成
local startSign = Instance.new("Part")
startSign.Name = "StartSign"
startSign.Size = Vector3.new(8, 3, 0.5)
startSign.Position = Vector3.new(0, 12, -28)
startSign.Anchored = true
startSign.Material = Enum.Material.SmoothPlastic
startSign.BrickColor = BrickColor.new("Bright blue")
startSign.Parent = mazeGame

local startGui = Instance.new("SurfaceGui")
startGui.Face = Enum.NormalId.Front
startGui.Parent = startSign

local startLabel = Instance.new("TextLabel")
startLabel.Size = UDim2.new(1, 0, 1, 0)
startLabel.BackgroundTransparency = 1
startLabel.Text = "🚀 START MAZE 🚀"
startLabel.TextColor3 = Color3.new(1, 1, 1)
startLabel.TextScaled = true
startLabel.Font = Enum.Font.SourceSansBold
startLabel.Parent = startGui

local goalSign = Instance.new("Part")
goalSign.Name = "GoalSign"
goalSign.Size = Vector3.new(8, 3, 0.5)
goalSign.Position = Vector3.new(0, 12, 36)
goalSign.Anchored = true
goalSign.Material = Enum.Material.SmoothPlastic
goalSign.BrickColor = BrickColor.new("Bright red")
goalSign.Parent = mazeGame

local goalGui = Instance.new("SurfaceGui")
goalGui.Face = Enum.NormalId.Front
goalGui.Parent = goalSign

local goalLabel = Instance.new("TextLabel")
goalLabel.Size = UDim2.new(1, 0, 1, 0)
goalLabel.BackgroundTransparency = 1
goalLabel.Text = "🏆 GOAL 🏆"
goalLabel.TextColor3 = Color3.new(1, 1, 1)
goalLabel.TextScaled = true
goalLabel.Font = Enum.Font.SourceSansBold
goalLabel.Parent = goalGui

print("🎉 迷路ゲーム完全構築完了！")
print("✅ 迷路: " .. wallCount .. " 個の壁")
print("✅ スタートエリア: 閉鎖空間")
print("✅ ゴールエリア: 閉鎖空間")
print("✅ スポーン地点: スタートエリア内")
print("✅ ランキングボード: ゴールから20スタッド離れた位置")
print("✅ ゲート: スタート・ゴール")
print("✅ RemoteEvents: 通信用")
print("")
print("🎮 ゲームの流れ:")
print("1. プレイヤーはスタートエリアにスポーン")
print("2. 緑のスタートゲートを通過でタイマー開始")
print("3. 迷路を攻略")
print("4. 赤のゴールゲートを通過でタイマー停止・ランキング更新")
print("5. 再挑戦可能")
