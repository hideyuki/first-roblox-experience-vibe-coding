-- Kanata Maze 強化照明システム（暗さ解決版）
print("💡 強化照明システムを設置中...")

local workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

-- MazeGameフォルダの取得
local mazeGame = workspace:FindFirstChild("MazeGame")
if not mazeGame then
    warn("❌ MazeGameフォルダが見つかりません")
    return
end

-- 既存の照明を削除
local existingLighting = mazeGame:FindFirstChild("Lighting")
if existingLighting then
    existingLighting:Destroy()
end

-- 新しい照明フォルダ
local lightingFolder = Instance.new("Folder")
lightingFolder.Name = "Lighting"
lightingFolder.Parent = mazeGame

-- 環境光の大幅改善
Lighting.Ambient = Color3.new(0.6, 0.6, 0.7)  -- 大幅に明るく
Lighting.Brightness = 3  -- より明るく
Lighting.OutdoorAmbient = Color3.new(0.7, 0.7, 0.8)  -- 屋外環境光も明るく
Lighting.ColorShift_Bottom = Color3.new(0.3, 0.3, 0.4)
Lighting.ColorShift_Top = Color3.new(0.9, 0.9, 1)

-- 強力な松明作成関数
local function createPowerfulTorch(position, parent)
    local torchFolder = Instance.new("Folder")
    torchFolder.Name = "PowerfulTorch"
    torchFolder.Parent = parent
    
    -- 松明の台座
    local base = Instance.new("Part")
    base.Name = "Base"
    base.Size = Vector3.new(1, 1, 1)
    base.Position = position
    base.Anchored = true
    base.Material = Enum.Material.Rock
    base.BrickColor = BrickColor.new("Dark stone grey")
    base.Parent = torchFolder
    
    -- 松明の支柱
    local pole = Instance.new("Part")
    pole.Name = "Pole"
    pole.Size = Vector3.new(0.5, 8, 0.5)
    pole.Position = position + Vector3.new(0, 4.5, 0)
    pole.Anchored = true
    pole.Material = Enum.Material.Wood
    pole.BrickColor = BrickColor.new("Brown")
    pole.Parent = torchFolder
    
    -- 巨大な炎の頭部
    local torchHead = Instance.new("Part")
    torchHead.Name = "TorchHead"
    torchHead.Size = Vector3.new(3, 3, 3)  -- 大きくした
    torchHead.Position = position + Vector3.new(0, 9, 0)
    torchHead.Anchored = true
    torchHead.Material = Enum.Material.Neon
    torchHead.BrickColor = BrickColor.new("Bright orange")
    torchHead.Shape = Enum.PartType.Ball
    torchHead.Parent = torchFolder
    
    -- 超強力な光源
    local pointLight = Instance.new("PointLight")
    pointLight.Color = Color3.new(1, 0.8, 0.4)  -- 暖かい白色光
    pointLight.Brightness = 5  -- 非常に明るく
    pointLight.Range = 50  -- 範囲を大幅拡大
    pointLight.Parent = torchHead
    
    -- 大きな炎のエフェクト
    local fire = Instance.new("Fire")
    fire.Size = 8  -- 炎のサイズを大きく
    fire.Heat = 15
    fire.Color = Color3.new(1, 0.6, 0)
    fire.SecondaryColor = Color3.new(1, 0.2, 0)
    fire.Parent = torchHead
    
    return torchFolder
end

-- 巨大なキャンプファイヤー作成関数
local function createMegaCampfire(position, parent)
    local campfireFolder = Instance.new("Folder")
    campfireFolder.Name = "MegaCampfire"
    campfireFolder.Parent = parent
    
    -- 大きな石の輪
    for i = 1, 12 do
        local angle = (i - 1) * (math.pi * 2 / 12)
        local stone = Instance.new("Part")
        stone.Name = "Stone" .. i
        stone.Size = Vector3.new(2, 1.5, 2)
        stone.Position = position + Vector3.new(math.cos(angle) * 5, 0.75, math.sin(angle) * 5)
        stone.Anchored = true
        stone.Material = Enum.Material.Rock
        stone.BrickColor = BrickColor.new("Dark stone grey")
        stone.Rotation = Vector3.new(0, math.deg(angle), 0)
        stone.Parent = campfireFolder
    end
    
    -- 大量の薪
    for i = 1, 12 do
        local log = Instance.new("Part")
        log.Name = "Log" .. i
        log.Size = Vector3.new(1.2, 1.2, 6)
        log.Position = position + Vector3.new(
            math.random(-30, 30) / 10,
            0.6,
            math.random(-30, 30) / 10
        )
        log.Anchored = true
        log.Material = Enum.Material.Wood
        log.BrickColor = BrickColor.new("Brown")
        log.Rotation = Vector3.new(0, math.random(0, 360), math.random(-15, 15))
        log.Parent = campfireFolder
    end
    
    -- 巨大な炎の基盤
    local fireBase = Instance.new("Part")
    fireBase.Name = "FireBase"
    fireBase.Size = Vector3.new(6, 0.2, 6)
    fireBase.Position = position + Vector3.new(0, 0.1, 0)
    fireBase.Anchored = true
    fireBase.Material = Enum.Material.Neon
    fireBase.BrickColor = BrickColor.new("Bright red")
    fireBase.Transparency = 0.5
    fireBase.Parent = campfireFolder
    
    -- 超強力な光源
    local pointLight = Instance.new("PointLight")
    pointLight.Color = Color3.new(1, 0.7, 0.3)
    pointLight.Brightness = 8  -- 非常に明るく
    pointLight.Range = 80  -- 超広範囲
    pointLight.Parent = fireBase
    
    -- 巨大な炎のエフェクト
    local fire = Instance.new("Fire")
    fire.Size = 15  -- 非常に大きな炎
    fire.Heat = 20
    fire.Color = Color3.new(1, 0.5, 0)
    fire.SecondaryColor = Color3.new(1, 0, 0)
    fire.Parent = fireBase
    
    -- 煙のエフェクト
    local smoke = Instance.new("Smoke")
    smoke.Size = 10
    smoke.Opacity = 0.2
    smoke.RiseVelocity = 25
    smoke.Color = Color3.new(0.4, 0.4, 0.4)
    smoke.Parent = fireBase
    
    return campfireFolder
end

-- 天井照明システム
local function createCeilingLight(position, parent)
    local lightFixture = Instance.new("Part")
    lightFixture.Name = "CeilingLight"
    lightFixture.Size = Vector3.new(4, 1, 4)
    lightFixture.Position = position
    lightFixture.Anchored = true
    lightFixture.Material = Enum.Material.Neon
    lightFixture.BrickColor = BrickColor.new("Institutional white")
    lightFixture.Parent = parent
    
    -- 非常に強い光源
    local pointLight = Instance.new("PointLight")
    pointLight.Color = Color3.new(1, 1, 0.9)  -- 白色光
    pointLight.Brightness = 6
    pointLight.Range = 60
    pointLight.Parent = lightFixture
    
    return lightFixture
end

-- 迷路エリアに密集した松明を設置
local wallsFolder = mazeGame:FindFirstChild("Walls")
if wallsFolder then
    local walls = wallsFolder:GetChildren()
    local torchCount = 0
    
    -- 5個ごとに松明を設置（密度を2倍に）
    for i = 1, #walls, 5 do
        local wall = walls[i]
        if wall:IsA("Part") then
            -- 壁の四方向に松明を設置
            local positions = {
                wall.Position + Vector3.new(4, 0, 0),
                wall.Position + Vector3.new(-4, 0, 0),
                wall.Position + Vector3.new(0, 0, 4),
                wall.Position + Vector3.new(0, 0, -4)
            }
            
            for _, pos in ipairs(positions) do
                createPowerfulTorch(pos, lightingFolder)
                torchCount = torchCount + 1
            end
        end
    end
    
    print("🔥 迷路に強力な松明を " .. torchCount .. " 個設置しました")
end

-- 天井に照明を追加（格子状配置）
for x = -90, 90, 30 do
    for z = -70, 70, 30 do
        local ceilingPos = Vector3.new(x, 35, z)  -- 天井付近
        createCeilingLight(ceilingPos, lightingFolder)
    end
end
print("💡 天井に格子状照明を設置しました")

-- スタートエリアの強化照明
local startPositions = {
    Vector3.new(-30, 0, -105),  Vector3.new(0, 0, -105),   Vector3.new(30, 0, -105),
    Vector3.new(-30, 0, -115),  Vector3.new(0, 0, -115),   Vector3.new(30, 0, -115),
    Vector3.new(-30, 0, -125),  Vector3.new(0, 0, -125),   Vector3.new(30, 0, -125),
}

for _, pos in ipairs(startPositions) do
    createPowerfulTorch(pos, lightingFolder)
end

-- スタートエリアに巨大キャンプファイヤー
createMegaCampfire(Vector3.new(-15, 0, -110), lightingFolder)
createMegaCampfire(Vector3.new(15, 0, -110), lightingFolder)
createMegaCampfire(Vector3.new(0, 0, -120), lightingFolder)

print("🔥 スタートエリアに強化照明を設置しました")

-- ゴールエリアの強化照明
local goalPositions = {
    Vector3.new(-20, 0, 85),   Vector3.new(0, 0, 85),     Vector3.new(20, 0, 85),
    Vector3.new(-20, 0, 105),  Vector3.new(0, 0, 105),    Vector3.new(20, 0, 105),
    Vector3.new(-20, 0, 125),  Vector3.new(0, 0, 125),    Vector3.new(20, 0, 125),
}

for _, pos in ipairs(goalPositions) do
    createPowerfulTorch(pos, lightingFolder)
end

-- ゴールエリアに巨大キャンプファイヤー
createMegaCampfire(Vector3.new(-15, 0, 100), lightingFolder)
createMegaCampfire(Vector3.new(15, 0, 100), lightingFolder)
createMegaCampfire(Vector3.new(0, 0, 120), lightingFolder)

print("🔥 ゴールエリアに強化照明を設置しました")

-- 追加の環境光源（見えない光源を配置）
for x = -80, 80, 20 do
    for z = -100, 100, 20 do
        local invisibleLight = Instance.new("Part")
        invisibleLight.Name = "InvisibleLight"
        invisibleLight.Size = Vector3.new(1, 1, 1)
        invisibleLight.Position = Vector3.new(x, 20, z)
        invisibleLight.Anchored = true
        invisibleLight.Transparency = 1  -- 完全に透明
        invisibleLight.CanCollide = false
        invisibleLight.Parent = lightingFolder
        
        local pointLight = Instance.new("PointLight")
        pointLight.Color = Color3.new(0.9, 0.9, 1)
        pointLight.Brightness = 3
        pointLight.Range = 30
        pointLight.Parent = invisibleLight
    end
end

print("✅ 強化照明システムの設置完了！")
print("🔥 超強力松明: 迷路全域 + エリア照明")
print("🔥 巨大キャンプファイヤー: 各エリア3個")
print("💡 天井照明: 格子状配置")
print("💡 見えない環境光源: 全域カバー")
print("🌅 環境光設定: 大幅に明るく調整")
print("")
print("🌟 これで迷路が非常に明るくなりました！")