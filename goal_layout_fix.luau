-- ゴールエリアレイアウト修正
print("🎨 ゴールエリアのレイアウトを修正中...")

local workspace = game:GetService("Workspace")

-- MazeGameフォルダの取得
local mazeGame = workspace:FindFirstChild("MazeGame")
if not mazeGame then
    warn("❌ MazeGameフォルダが見つかりません")
    return
end

-- 既存のアイテムを削除
local itemsToRemove = {
    "CelebrationArch", "RankingBoard", "RankingPedestal", "WarpArea", 
    "GoalEntranceSign", "WarpSystem"
}

for _, itemName in ipairs(itemsToRemove) do
    local item = mazeGame:FindFirstChild(itemName)
    if item then
        item:Destroy()
        print("🗑️ " .. itemName .. " を削除しました")
    end
end

-- === 1. Congratulationsアーチを右側の壁に配置 ===
print("🎊 Congratulationsアーチを右側壁に配置中...")

local celebrationArch = Instance.new("Part")
celebrationArch.Name = "CelebrationArch"
celebrationArch.Size = Vector3.new(2, 8, 15)  -- 縦長に変更（壁貼り付け用）
celebrationArch.Position = Vector3.new(38, 4, 100)  -- 右側の壁に配置
celebrationArch.Anchored = true
celebrationArch.Material = Enum.Material.Marble
celebrationArch.BrickColor = BrickColor.new("Bright yellow")
celebrationArch.Parent = mazeGame

-- アーチのテキスト（右側面）
local archGui = Instance.new("SurfaceGui")
archGui.Name = "ArchGui"
archGui.Face = Enum.NormalId.Left  -- 左面（中央向き）
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

print("✅ Congratulationsアーチを右側壁に配置しました")

-- === 2. ランキングボード台座を右側に配置 ===
print("📊 ランキングボードを右側に配置中...")

local rankingPedestal = Instance.new("Part")
rankingPedestal.Name = "RankingPedestal"
rankingPedestal.Size = Vector3.new(22, 2, 4)
rankingPedestal.Position = Vector3.new(20, 1, 135)  -- 右側に配置
rankingPedestal.Anchored = true
rankingPedestal.Material = Enum.Material.Marble
rankingPedestal.BrickColor = BrickColor.new("Institutional white")
rankingPedestal.Parent = mazeGame

-- ランキングボード
local rankingBoard = Instance.new("Part")
rankingBoard.Name = "RankingBoard"
rankingBoard.Size = Vector3.new(20, 15, 2)
rankingBoard.Position = Vector3.new(20, 9.5, 135)  -- 台座の上、右側
rankingBoard.Anchored = true
rankingBoard.Material = Enum.Material.SmoothPlastic
rankingBoard.BrickColor = BrickColor.new("Dark stone grey")
rankingBoard.Parent = mazeGame

-- ランキング表示用のSurfaceGui（簡略版、WarpServiceで詳細構築）
local rankingGui = Instance.new("SurfaceGui")
rankingGui.Name = "RankingGui"
rankingGui.Face = Enum.NormalId.Front
rankingGui.Parent = rankingBoard

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, 0, 0.2, 0)
titleLabel.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
titleLabel.Text = "🏆 KANATA MAZE RANKINGS 🏆"
titleLabel.TextColor3 = Color3.new(1, 1, 0)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Parent = rankingGui

print("✅ ランキングボードを右側に配置しました")

-- === 3. ワープゾーンを左側に配置 ===
print("🌀 ワープゾーンを左側に配置中...")

-- ワープシステムフォルダ
local warpFolder = Instance.new("Folder")
warpFolder.Name = "WarpSystem"
warpFolder.Parent = mazeGame

-- ワープゾーンのベース（左側）
local warpBase = Instance.new("Part")
warpBase.Name = "WarpZone"
warpBase.Size = Vector3.new(15, 1, 15)
warpBase.Position = Vector3.new(-20, 0.5, 135)  -- 左側に配置
warpBase.Anchored = true
warpBase.CanCollide = false
warpBase.Material = Enum.Material.ForceField
warpBase.BrickColor = BrickColor.new("Bright blue")
warpBase.Transparency = 0.3
warpBase.Parent = warpFolder

-- ワープエリアの床マーキング（左側）
local warpArea = Instance.new("Part")
warpArea.Name = "WarpArea"
warpArea.Size = Vector3.new(18, 0.1, 18)
warpArea.Position = Vector3.new(-20, 0.55, 135)  -- 左側
warpArea.Anchored = true
warpArea.Material = Enum.Material.Neon
warpArea.BrickColor = BrickColor.new("Bright blue")
warpArea.Transparency = 0.7
warpArea.Parent = warpFolder

-- ワープサイン（左側）
local warpSign = Instance.new("Part")
warpSign.Name = "WarpSign"
warpSign.Size = Vector3.new(12, 6, 1)
warpSign.Position = Vector3.new(-20, 8, 142)  -- 左側の奥
warpSign.Anchored = true
warpSign.Material = Enum.Material.SmoothPlastic
warpSign.BrickColor = BrickColor.new("Bright blue")
warpSign.Parent = warpFolder

-- ワープサインのGUI
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

-- ワープエフェクトの境界線（左側）
for i = 1, 8 do
    local angle = (i - 1) * (math.pi * 2 / 8)
    local radius = 9
    
    local beacon = Instance.new("Part")
    beacon.Name = "WarpBeacon" .. i
    beacon.Size = Vector3.new(0.8, 4, 0.8)
    beacon.Position = Vector3.new(-20, 2, 135) + Vector3.new(
        math.cos(angle) * radius,
        0,
        math.sin(angle) * radius
    )
    beacon.Anchored = true
    beacon.CanCollide = false
    beacon.Material = Enum.Material.Neon
    beacon.BrickColor = BrickColor.new("Cyan")
    beacon.Parent = warpFolder
    
    -- ビーコンの光源
    local pointLight = Instance.new("PointLight")
    pointLight.Color = Color3.new(0, 1, 1)
    pointLight.Brightness = 1.5
    pointLight.Range = 12
    pointLight.Parent = beacon
end

-- ワープポータルエフェクト（左側）
local portalEffect = Instance.new("Part")
portalEffect.Name = "PortalEffect"
portalEffect.Size = Vector3.new(12, 0.3, 12)
portalEffect.Position = Vector3.new(-20, 0.6, 135)
portalEffect.Anchored = true
portalEffect.CanCollide = false
portalEffect.Material = Enum.Material.Neon
portalEffect.BrickColor = BrickColor.new("Bright blue")
portalEffect.Transparency = 0.5
portalEffect.Shape = Enum.PartType.Cylinder
portalEffect.Rotation = Vector3.new(0, 0, 90)
portalEffect.Parent = warpFolder

print("✅ ワープゾーンを左側に配置しました")

-- === 4. エリア案内標識 ===
print("🏷️ エリア案内標識を設置中...")

-- 「RANKING」標識（右側）
local rankingSign = Instance.new("Part")
rankingSign.Name = "RankingSign"
rankingSign.Size = Vector3.new(8, 2, 0.5)
rankingSign.Position = Vector3.new(20, 6, 125)  -- ランキングボード手前
rankingSign.Anchored = true
rankingSign.Material = Enum.Material.SmoothPlastic
rankingSign.BrickColor = BrickColor.new("Bright yellow")
rankingSign.Parent = mazeGame

local rankingSignGui = Instance.new("SurfaceGui")
rankingSignGui.Name = "RankingSignGui"
rankingSignGui.Face = Enum.NormalId.Front
rankingSignGui.Parent = rankingSign

local rankingSignLabel = Instance.new("TextLabel")
rankingSignLabel.Size = UDim2.new(1, 0, 1, 0)
rankingSignLabel.BackgroundTransparency = 1
rankingSignLabel.Text = "📊 RANKING BOARD →"
rankingSignLabel.TextColor3 = Color3.new(0, 0, 0)
rankingSignLabel.TextScaled = true
rankingSignLabel.Font = Enum.Font.SourceSansBold
rankingSignLabel.Parent = rankingSignGui

-- 「WARP」標識（左側）
local warpDirectionSign = Instance.new("Part")
warpDirectionSign.Name = "WarpDirectionSign"
warpDirectionSign.Size = Vector3.new(8, 2, 0.5)
warpDirectionSign.Position = Vector3.new(-20, 6, 125)  -- ワープゾーン手前
warpDirectionSign.Anchored = true
warpDirectionSign.Material = Enum.Material.SmoothPlastic
warpDirectionSign.BrickColor = BrickColor.new("Bright blue")
warpDirectionSign.Parent = mazeGame

local warpDirectionGui = Instance.new("SurfaceGui")
warpDirectionGui.Name = "WarpDirectionGui"
warpDirectionGui.Face = Enum.NormalId.Front
warpDirectionGui.Parent = warpDirectionSign

local warpDirectionLabel = Instance.new("TextLabel")
warpDirectionLabel.Size = UDim2.new(1, 0, 1, 0)
warpDirectionLabel.BackgroundTransparency = 1
warpDirectionLabel.Text = "← 🌀 WARP ZONE"
warpDirectionLabel.TextColor3 = Color3.new(1, 1, 1)
warpDirectionLabel.TextScaled = true
warpDirectionLabel.Font = Enum.Font.SourceSansBold
warpDirectionLabel.Parent = warpDirectionGui

print("✅ ゴールエリアレイアウト修正完了！")
print("🎨 新しいレイアウト:")
print("  🎊 Congratulationsアーチ: 右側壁 (x=38)")
print("  📊 ランキングボード: 右側奥 (x=20, z=135)")
print("  🌀 ワープゾーン: 左側奥 (x=-20, z=135)")
print("  🏷️ 案内標識: 各エリア手前に配置")
print("")
print("🎮 プレイヤーは左右に分かれた機能を選択できます！")