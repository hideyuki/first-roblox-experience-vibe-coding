-- Kanata Maze サインサービス（位置修正版）
local SignService = {}

local workspace = game:GetService("Workspace")

-- サイン初期化フラグ
local signSystemInitialized = false

-- ゴールサイン修正
local function fixGoalSignPosition(mazeGame)
    -- 既存のゴールサインを削除
    local existingGoalSign = mazeGame:FindFirstChild("GoalSign")
    if existingGoalSign then
        existingGoalSign:Destroy()
        print("🗑️ 古いゴールサインを削除しました")
    end
    
    -- 正しい位置に新しいゴールサインを作成
    local goalSign = Instance.new("Part")
    goalSign.Name = "GoalSign"
    goalSign.Size = Vector3.new(8, 3, 0.5)
    goalSign.Position = Vector3.new(0, 12, 75)  -- ゴールゲート上に配置（z=73の少し後ろ）
    goalSign.Anchored = true
    goalSign.Material = Enum.Material.SmoothPlastic
    goalSign.BrickColor = BrickColor.new("Bright red")
    goalSign.Parent = mazeGame
    
    -- サインのGUI
    local goalGui = Instance.new("SurfaceGui")
    goalGui.Name = "GoalGui"
    goalGui.Face = Enum.NormalId.Front
    goalGui.Parent = goalSign
    
    local goalLabel = Instance.new("TextLabel")
    goalLabel.Name = "GoalLabel"
    goalLabel.Size = UDim2.new(1, 0, 1, 0)
    goalLabel.BackgroundTransparency = 1
    goalLabel.Text = "🏆 GOAL 🏆"
    goalLabel.TextColor3 = Color3.new(1, 1, 1)
    goalLabel.TextScaled = true
    goalLabel.Font = Enum.Font.SourceSansBold
    goalLabel.Parent = goalGui
    
    print("🏆 ゴールサインを正しい位置に配置しました（z=75, ゴールゲート上）")
    return goalSign
end

-- スタートサイン修正（念のため）
local function fixStartSignPosition(mazeGame)
    -- 既存のスタートサインを削除
    local existingStartSign = mazeGame:FindFirstChild("StartSign")
    if existingStartSign then
        existingStartSign:Destroy()
        print("🗑️ 古いスタートサインを削除しました")
    end
    
    -- 正しい位置に新しいスタートサインを作成
    local startSign = Instance.new("Part")
    startSign.Name = "StartSign"
    startSign.Size = Vector3.new(8, 3, 0.5)
    startSign.Position = Vector3.new(0, 12, -75)  -- スタートゲート上に配置（z=-73の少し前）
    startSign.Anchored = true
    startSign.Material = Enum.Material.SmoothPlastic
    startSign.BrickColor = BrickColor.new("Bright blue")
    startSign.Parent = mazeGame
    
    -- サインのGUI
    local startGui = Instance.new("SurfaceGui")
    startGui.Name = "StartGui"
    startGui.Face = Enum.NormalId.Front
    startGui.Parent = startSign
    
    local startLabel = Instance.new("TextLabel")
    startLabel.Name = "StartLabel"
    startLabel.Size = UDim2.new(1, 0, 1, 0)
    startLabel.BackgroundTransparency = 1
    startLabel.Text = "🚀 START MAZE 🚀"
    startLabel.TextColor3 = Color3.new(1, 1, 1)
    startLabel.TextScaled = true
    startLabel.Font = Enum.Font.SourceSansBold
    startLabel.Parent = startGui
    
    print("🚀 スタートサインを正しい位置に配置しました（z=-75, スタートゲート上）")
    return startSign
end

-- メイン初期化関数
function SignService.Initialize()
    if signSystemInitialized then
        return
    end
    
    print("🏷️ サインサービスを初期化中...")
    
    -- MazeGameの待機
    local mazeGame = workspace:WaitForChild("MazeGame", 30)
    if not mazeGame then
        warn("❌ MazeGameが見つかりません")
        return
    end
    
    -- サイン位置修正
    fixGoalSignPosition(mazeGame)
    fixStartSignPosition(mazeGame)
    
    signSystemInitialized = true
    print("✅ サインサービスの初期化完了！")
end

-- サービス開始
function SignService.Start()
    spawn(function()
        wait(3) -- 他のシステムの後に実行
        SignService.Initialize()
    end)
end

return SignService