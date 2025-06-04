-- Kanata Maze ワープサービス（自動構築版）
local WarpService = {}

local workspace = game:GetService("Workspace")

-- ワープシステム初期化フラグ
local warpSystemInitialized = false

-- ワープゾーン作成
local function createWarpZone(position, parent)
    local warpBase = Instance.new("Part")
    warpBase.Name = "WarpZone"
    warpBase.Size = Vector3.new(15, 1, 15)
    warpBase.Position = position
    warpBase.Anchored = true
    warpBase.CanCollide = false
    warpBase.Material = Enum.Material.ForceField
    warpBase.BrickColor = BrickColor.new("Bright blue")
    warpBase.Transparency = 0.3
    warpBase.Parent = parent
    
    return warpBase
end

-- ワープサイン作成
local function createWarpSign(position, parent)
    local warpSign = Instance.new("Part")
    warpSign.Name = "WarpSign"
    warpSign.Size = Vector3.new(12, 6, 1)
    warpSign.Position = position
    warpSign.Anchored = true
    warpSign.Material = Enum.Material.SmoothPlastic
    warpSign.BrickColor = BrickColor.new("Bright blue")
    warpSign.Parent = parent
    
    -- サインのGUI
    local warpGui = Instance.new("SurfaceGui")
    warpGui.Name = "WarpGui"
    warpGui.Face = Enum.NormalId.Front
    warpGui.Parent = warpSign
    
    local warpLabel = Instance.new("TextLabel")
    warpLabel.Name = "WarpLabel"
    warpLabel.Size = UDim2.new(1, 0, 0.5, 0)
    warpLabel.Position = UDim2.new(0, 0, 0, 0)
    warpLabel.BackgroundTransparency = 1
    warpLabel.Text = "🌀 WARP TO START 🌀"
    warpLabel.TextColor3 = Color3.new(1, 1, 1)
    warpLabel.TextScaled = true
    warpLabel.Font = Enum.Font.SourceSansBold
    warpLabel.Parent = warpGui
    
    local instructionLabel = Instance.new("TextLabel")
    instructionLabel.Name = "InstructionLabel"
    instructionLabel.Size = UDim2.new(1, 0, 0.3, 0)
    instructionLabel.Position = UDim2.new(0, 0, 0.5, 0)
    instructionLabel.BackgroundTransparency = 1
    instructionLabel.Text = "Step into the blue zone below!"
    instructionLabel.TextColor3 = Color3.new(0.8, 0.8, 1)
    instructionLabel.TextScaled = true
    instructionLabel.Font = Enum.Font.SourceSans
    instructionLabel.Parent = warpGui
    
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusLabel"
    statusLabel.Size = UDim2.new(1, 0, 0.2, 0)
    statusLabel.Position = UDim2.new(0, 0, 0.8, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "(Available after completing maze)"
    statusLabel.TextColor3 = Color3.new(0.6, 0.6, 0.8)
    statusLabel.TextScaled = true
    statusLabel.Font = Enum.Font.SourceSansItalic
    statusLabel.Parent = warpGui
    
    return warpSign
end

-- ワープエフェクト作成
local function createWarpEffects(position, parent)
    -- 境界線ビーコン
    for i = 1, 8 do
        local angle = (i - 1) * (math.pi * 2 / 8)
        local radius = 8
        
        local beacon = Instance.new("Part")
        beacon.Name = "WarpBeacon" .. i
        beacon.Size = Vector3.new(0.8, 4, 0.8)
        beacon.Position = position + Vector3.new(
            math.cos(angle) * radius,
            2,
            math.sin(angle) * radius
        )
        beacon.Anchored = true
        beacon.CanCollide = false
        beacon.Material = Enum.Material.Neon
        beacon.BrickColor = BrickColor.new("Cyan")
        beacon.Parent = parent
        
        -- ビーコンの光源
        local pointLight = Instance.new("PointLight")
        pointLight.Color = Color3.new(0, 1, 1)
        pointLight.Brightness = 1.5
        pointLight.Range = 12
        pointLight.Parent = beacon
    end
    
    -- ポータルエフェクト
    local portalEffect = Instance.new("Part")
    portalEffect.Name = "PortalEffect"
    portalEffect.Size = Vector3.new(12, 0.3, 12)
    portalEffect.Position = position + Vector3.new(0, 0.1, 0)
    portalEffect.Anchored = true
    portalEffect.CanCollide = false
    portalEffect.Material = Enum.Material.Neon
    portalEffect.BrickColor = BrickColor.new("Bright blue")
    portalEffect.Transparency = 0.5
    portalEffect.Shape = Enum.PartType.Cylinder
    portalEffect.Rotation = Vector3.new(0, 0, 90)
    portalEffect.Parent = parent
end

-- ワープシステム構築
local function buildWarpSystem(mazeGame)
    -- 既存のワープシステムを削除
    local existingWarp = mazeGame:FindFirstChild("WarpSystem")
    if existingWarp then
        existingWarp:Destroy()
    end
    
    local warpFolder = Instance.new("Folder")
    warpFolder.Name = "WarpSystem"
    warpFolder.Parent = mazeGame
    
    -- ワープゾーンの位置（左側配置）
    local WARP_ZONE_POSITION = Vector3.new(-20, 0.5, 135)
    
    -- ワープゾーン作成
    createWarpZone(WARP_ZONE_POSITION, warpFolder)
    
    -- ワープサイン作成
    createWarpSign(Vector3.new(-20, 8, 142), warpFolder)
    
    -- ワープエフェクト作成
    createWarpEffects(WARP_ZONE_POSITION, warpFolder)
    
    print("🌀 ワープシステムを構築しました")
    return warpFolder
end

-- 地面設置ランキングボード構築（完全版）
local function buildGroundRankingBoard(mazeGame)
    -- 既存のランキングボードを削除
    local existingBoard = mazeGame:FindFirstChild("RankingBoard")
    if existingBoard then
        existingBoard:Destroy()
    end
    
    -- 新しいランキングボード（右側配置、高さ調整）
    local rankingBoard = Instance.new("Part")
    rankingBoard.Name = "RankingBoard"
    rankingBoard.Size = Vector3.new(20, 12, 2)
    rankingBoard.Position = Vector3.new(20, 8, 135)  -- 右側奥に配置、高さ調整
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
    titleLabel.Text = "🏆 KANATA MAZE RANKINGS 🏆"
    titleLabel.TextColor3 = Color3.new(1, 1, 0)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.Parent = titleFrame
    
    -- 左側フレーム（1-20位）
    local leftFrame = Instance.new("Frame")
    leftFrame.Name = "LeftFrame"
    leftFrame.Size = UDim2.new(0.5, 0, 0.95, 0)
    leftFrame.Position = UDim2.new(0, 0, 0.1, 0)
    leftFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    leftFrame.BorderSizePixel = 0
    leftFrame.Parent = rankingGui
    
    local leftScrollFrame = Instance.new("ScrollingFrame")
    leftScrollFrame.Name = "LeftScrollFrame"
    leftScrollFrame.Size = UDim2.new(1, 0, 1, 0)
    leftScrollFrame.BackgroundTransparency = 1
    leftScrollFrame.ScrollBarThickness = 6
    leftScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 400)
    leftScrollFrame.Parent = leftFrame
    
    -- 右側フレーム（21-40位）
    local rightFrame = Instance.new("Frame")
    rightFrame.Name = "RightFrame"
    rightFrame.Size = UDim2.new(0.5, 0, 0.95, 0)
    rightFrame.Position = UDim2.new(0.5, 0, 0.1, 0)
    rightFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    rightFrame.BorderSizePixel = 0
    rightFrame.Parent = rankingGui
    
    local rightScrollFrame = Instance.new("ScrollingFrame")
    rightScrollFrame.Name = "RightScrollFrame"
    rightScrollFrame.Size = UDim2.new(1, 0, 1, 0)
    rightScrollFrame.BackgroundTransparency = 1
    rightScrollFrame.ScrollBarThickness = 6
    rightScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 400)
    rightScrollFrame.Parent = rightFrame
    
    -- 左側エントリ（1-20位）
    for i = 1, 20 do
        local entryFrame = Instance.new("Frame")
        entryFrame.Name = "LeftEntry" .. i
        entryFrame.Size = UDim2.new(1, -10, 0, 18)
        entryFrame.Position = UDim2.new(0, 5, 0, (i-1) * 20)
        entryFrame.BackgroundTransparency = 1
        entryFrame.Parent = leftScrollFrame
        
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
    
    -- 右側エントリ（21-40位）
    for i = 21, 40 do
        local entryFrame = Instance.new("Frame")
        entryFrame.Name = "RightEntry" .. i
        entryFrame.Size = UDim2.new(1, -10, 0, 18)
        entryFrame.Position = UDim2.new(0, 5, 0, (i-21) * 20)
        entryFrame.BackgroundTransparency = 1
        entryFrame.Parent = rightScrollFrame
        
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
    
    print("📊 完全な地面設置ランキングボードを構築しました")
    return rankingBoard
end

-- メイン初期化関数
function WarpService.Initialize()
    if warpSystemInitialized then
        return
    end
    
    print("🌀 ワープサービスを初期化中...")
    
    -- MazeGameの待機
    local mazeGame = workspace:WaitForChild("MazeGame", 30)
    if not mazeGame then
        warn("❌ MazeGameが見つかりません")
        return
    end
    
    -- ランキングボード構築
    buildGroundRankingBoard(mazeGame)
    
    -- ワープシステム構築
    buildWarpSystem(mazeGame)
    
    warpSystemInitialized = true
    print("✅ ワープサービスの初期化完了！")
end

-- サービス開始
function WarpService.Start()
    spawn(function()
        wait(2) -- MazeGameの構築を待つ
        WarpService.Initialize()
    end)
end

return WarpService