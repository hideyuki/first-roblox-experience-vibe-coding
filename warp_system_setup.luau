-- Kanata Maze ワープシステム設置スクリプト
print("🌀 ワープシステムを設置中...")

local workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

-- MazeGameフォルダの取得
local mazeGame = workspace:FindFirstChild("MazeGame")
if not mazeGame then
    warn("❌ MazeGameフォルダが見つかりません")
    return
end

-- ワープゾーンフォルダの作成
local warpFolder = mazeGame:FindFirstChild("WarpSystem")
if warpFolder then
    warpFolder:Destroy()
end
warpFolder = Instance.new("Folder")
warpFolder.Name = "WarpSystem"
warpFolder.Parent = mazeGame

-- ワープゾーンの設定（Constants.luauから）
local WARP_ZONE_SIZE = Vector3.new(12, 1, 12)
local WARP_ZONE_POSITION = Vector3.new(0, 0, 115)

-- ワープゾーンのベース（実際の当たり判定）
local warpBase = Instance.new("Part")
warpBase.Name = "WarpZone"
warpBase.Size = WARP_ZONE_SIZE
warpBase.Position = WARP_ZONE_POSITION + Vector3.new(0, 0.5, 0)
warpBase.Anchored = true
warpBase.CanCollide = false  -- プレイヤーが通り抜けられる
warpBase.Material = Enum.Material.ForceField
warpBase.BrickColor = BrickColor.new("Bright blue")
warpBase.Transparency = 0.3
warpBase.Parent = warpFolder

-- ワープエフェクトの視覚的要素
local function createWarpEffect(parent, position, size)
    -- 光る境界線
    for i = 1, 8 do
        local angle = (i - 1) * (math.pi * 2 / 8)
        local radius = size.X / 2 + 1
        
        local beacon = Instance.new("Part")
        beacon.Name = "WarpBeacon" .. i
        beacon.Size = Vector3.new(0.5, 3, 0.5)
        beacon.Position = position + Vector3.new(
            math.cos(angle) * radius,
            1.5,
            math.sin(angle) * radius
        )
        beacon.Anchored = true
        beacon.CanCollide = false
        beacon.Material = Enum.Material.Neon
        beacon.BrickColor = BrickColor.new("Cyan")
        beacon.Shape = Enum.PartType.Cylinder
        beacon.Rotation = Vector3.new(0, 0, 90)
        beacon.Parent = parent
        
        -- ビーコンの光源
        local pointLight = Instance.new("PointLight")
        pointLight.Color = Color3.new(0, 1, 1)  -- シアン色
        pointLight.Brightness = 2
        pointLight.Range = 15
        pointLight.Parent = beacon
        
        -- 回転アニメーション
        spawn(function()
            while beacon.Parent do
                local tween = TweenService:Create(
                    beacon,
                    TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
                    {Rotation = Vector3.new(0, 360, 90)}
                )
                tween:Play()
                wait(2)
            end
        end)
        
        -- 明滅エフェクト
        spawn(function()
            while beacon.Parent do
                local targetBrightness = math.random(15, 25) / 10
                local tween = TweenService:Create(
                    pointLight,
                    TweenInfo.new(0.8, Enum.EasingStyle.Sine),
                    {Brightness = targetBrightness}
                )
                tween:Play()
                wait(0.8)
            end
        end)
    end
end

-- ワープポータルの視覚エフェクト
local portalEffect = Instance.new("Part")
portalEffect.Name = "PortalEffect"
portalEffect.Size = Vector3.new(10, 0.2, 10)
portalEffect.Position = WARP_ZONE_POSITION + Vector3.new(0, 0.1, 0)
portalEffect.Anchored = true
portalEffect.CanCollide = false
portalEffect.Material = Enum.Material.Neon
portalEffect.BrickColor = BrickColor.new("Bright blue")
portalEffect.Transparency = 0.5
portalEffect.Shape = Enum.PartType.Cylinder
portalEffect.Rotation = Vector3.new(0, 0, 90)
portalEffect.Parent = warpFolder

-- ポータルの回転エフェクト
spawn(function()
    while portalEffect.Parent do
        local tween = TweenService:Create(
            portalEffect,
            TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
            {Rotation = Vector3.new(0, 360, 90)}
        )
        tween:Play()
        wait(3)
    end
end)

-- ワープエフェクトの設置
createWarpEffect(warpFolder, WARP_ZONE_POSITION, WARP_ZONE_SIZE)

-- ワープゾーンのサイン
local warpSign = Instance.new("Part")
warpSign.Name = "WarpSign"
warpSign.Size = Vector3.new(8, 4, 0.5)
warpSign.Position = WARP_ZONE_POSITION + Vector3.new(0, 8, -8)
warpSign.Anchored = true
warpSign.Material = Enum.Material.SmoothPlastic
warpSign.BrickColor = BrickColor.new("Bright blue")
warpSign.Parent = warpFolder

-- サインのGUI
local warpGui = Instance.new("SurfaceGui")
warpGui.Name = "WarpGui"
warpGui.Face = Enum.NormalId.Front
warpGui.Parent = warpSign

local warpLabel = Instance.new("TextLabel")
warpLabel.Name = "WarpLabel"
warpLabel.Size = UDim2.new(1, 0, 0.6, 0)
warpLabel.Position = UDim2.new(0, 0, 0, 0)
warpLabel.BackgroundTransparency = 1
warpLabel.Text = "🌀 WARP TO START 🌀"
warpLabel.TextColor3 = Color3.new(1, 1, 1)
warpLabel.TextScaled = true
warpLabel.Font = Enum.Font.SourceSansBold
warpLabel.Parent = warpGui

local instructionLabel = Instance.new("TextLabel")
instructionLabel.Name = "InstructionLabel"
instructionLabel.Size = UDim2.new(1, 0, 0.4, 0)
instructionLabel.Position = UDim2.new(0, 0, 0.6, 0)
instructionLabel.BackgroundTransparency = 1
instructionLabel.Text = "Step into the blue zone to teleport!"
instructionLabel.TextColor3 = Color3.new(0.8, 0.8, 1)
warpLabel.TextScaled = true
instructionLabel.Font = Enum.Font.SourceSans
instructionLabel.Parent = warpGui

-- サインの光源
local signLight = Instance.new("PointLight")
signLight.Color = Color3.new(0, 0.8, 1)
signLight.Brightness = 1.5
signLight.Range = 20
signLight.Parent = warpSign

print("✅ ワープシステムの物理構造を設置完了！")
print("🌀 ワープゾーン: " .. tostring(WARP_ZONE_POSITION))
print("📏 サイズ: " .. tostring(WARP_ZONE_SIZE))
print("🎯 ビーコン: 8個の光る境界線")
print("💫 ポータルエフェクト: 回転する青い円盤")
print("🏷️ サイン: 使用方法の表示")
print("")
print("⚠️ 次に必要: サーバー側のテレポートロジック実装")
print("📝 ファイル: src/server/init.server.luau にワープ検出を追加してください")