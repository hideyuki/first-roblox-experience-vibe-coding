-- Kanata Maze ガラス天井システム（自然光導入版）
print("🪟 ガラス天井システムを設置中...")

local workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

-- MazeGameフォルダの取得
local mazeGame = workspace:FindFirstChild("MazeGame")
if not mazeGame then
    warn("❌ MazeGameフォルダが見つかりません")
    return
end

-- 既存の天井を削除
local existingCeiling = mazeGame:FindFirstChild("Ceiling")
if existingCeiling then
    existingCeiling:Destroy()
    print("🗑️ 既存の天井を削除しました")
end

-- 新しいガラス天井フォルダ
local glassCeilingFolder = Instance.new("Folder")
glassCeilingFolder.Name = "GlassCeiling"
glassCeilingFolder.Parent = mazeGame

-- 環境光設定を自然光重視に調整
Lighting.Ambient = Color3.new(0.8, 0.8, 0.9)  -- 明るい自然光
Lighting.Brightness = 4  -- より明るく
Lighting.OutdoorAmbient = Color3.new(0.9, 0.9, 1)  -- 自然な屋外光
Lighting.ColorShift_Bottom = Color3.new(0.7, 0.7, 0.8)
Lighting.ColorShift_Top = Color3.new(1, 1, 1)
Lighting.ShadowSoftness = 0.2  -- 柔らかい影

-- 時刻を昼間に設定（自然光を最大化）
Lighting.TimeOfDay = "12:00:00"  -- 正午
Lighting.GeographicLatitude = 0  -- 赤道（太陽が真上）

-- ガラスパネル作成関数
local function createGlassPanel(position, size)
    local glassPanel = Instance.new("Part")
    glassPanel.Name = "GlassPanel"
    glassPanel.Size = size
    glassPanel.Position = position
    glassPanel.Anchored = true
    glassPanel.CanCollide = true  -- 天井として機能
    glassPanel.Material = Enum.Material.Glass
    glassPanel.BrickColor = BrickColor.new("Institutional white")
    glassPanel.Transparency = 0.1  -- ほぼ透明（わずかに見える）
    glassPanel.Reflectance = 0.1  -- 少しの反射
    glassPanel.Parent = glassCeilingFolder
    
    return glassPanel
end

-- 大型ガラスパネルで迷路全体をカバー
print("🪟 迷路エリアにガラス天井を設置中...")

-- 迷路エリア（186x150スタッド）をカバーする大型ガラスパネル
local mazeGlassWidth = 200  -- 迷路より少し大きく
local mazeGlassHeight = 160
local panelSize = 20  -- 1パネルのサイズ

local glassCount = 0
for x = -mazeGlassWidth/2, mazeGlassWidth/2, panelSize do
    for z = -mazeGlassHeight/2, mazeGlassHeight/2, panelSize do
        local glassPos = Vector3.new(x, 42, z)  -- 天井の高さ
        createGlassPanel(glassPos, Vector3.new(panelSize, 2, panelSize))
        glassCount = glassCount + 1
    end
end

print("🪟 迷路エリアにガラスパネル " .. glassCount .. " 枚を設置")

-- スタートエリアのガラス天井
print("🪟 スタートエリアにガラス天井を設置中...")
for x = -50, 50, panelSize do
    for z = -140, -80, panelSize do
        local glassPos = Vector3.new(x, 42, z)
        createGlassPanel(glassPos, Vector3.new(panelSize, 2, panelSize))
        glassCount = glassCount + 1
    end
end

-- ゴールエリアのガラス天井
print("🪟 ゴールエリアにガラス天井を設置中...")
for x = -40, 40, panelSize do
    for z = 80, 140, panelSize do
        local glassPos = Vector3.new(x, 42, z)
        createGlassPanel(glassPos, Vector3.new(panelSize, 2, panelSize))
        glassCount = glassCount + 1
    end
end

-- 天窓（スカイライト）の追加
print("☀️ 天窓を追加中...")
local skylightPositions = {
    Vector3.new(0, 42, 0),      -- 迷路中央
    Vector3.new(-50, 42, -25),  -- 迷路左
    Vector3.new(50, 42, -25),   -- 迷路右
    Vector3.new(-50, 42, 25),   -- 迷路左下
    Vector3.new(50, 42, 25),    -- 迷路右下
    Vector3.new(0, 42, -110),   -- スタートエリア
    Vector3.new(0, 42, 110),    -- ゴールエリア
}

for _, pos in ipairs(skylightPositions) do
    local skylight = Instance.new("Part")
    skylight.Name = "Skylight"
    skylight.Size = Vector3.new(15, 1, 15)
    skylight.Position = pos
    skylight.Anchored = true
    skylight.CanCollide = false  -- 光を通すために当たり判定なし
    skylight.Material = Enum.Material.ForceField
    skylight.BrickColor = BrickColor.new("Bright blue")
    skylight.Transparency = 0.7
    skylight.Parent = glassCeilingFolder
    
    -- 天窓からの強い光源
    local skylightLight = Instance.new("PointLight")
    skylightLight.Color = Color3.new(1, 1, 0.9)  -- 自然な白色光
    skylightLight.Brightness = 10  -- 非常に明るい
    skylightLight.Range = 100  -- 広範囲
    skylightLight.Parent = skylight
end

-- 自然光を模倣する追加の環境光源
print("☀️ 自然光源を追加中...")
for x = -80, 80, 40 do
    for z = -120, 120, 40 do
        local naturalLight = Instance.new("Part")
        naturalLight.Name = "NaturalLight"
        naturalLight.Size = Vector3.new(1, 1, 1)
        naturalLight.Position = Vector3.new(x, 50, z)  -- ガラス天井より上
        naturalLight.Anchored = true
        naturalLight.Transparency = 1  -- 完全に透明
        naturalLight.CanCollide = false
        naturalLight.Parent = glassCeilingFolder
        
        local sunLight = Instance.new("PointLight")
        sunLight.Color = Color3.new(1, 0.95, 0.8)  -- 太陽光の色
        sunLight.Brightness = 5
        sunLight.Range = 60
        sunLight.Parent = naturalLight
    end
end

-- ガラスの反射効果を追加
for _, glass in pairs(glassCeilingFolder:GetChildren()) do
    if glass.Name == "GlassPanel" then
        -- ガラスパネルに反射エフェクトを追加
        glass.Reflectance = 0.3  -- 反射を増加
        glass.Transparency = 0.05  -- わずかに見える
        
        -- 表面に光の反射効果
        local surfaceLight = Instance.new("SurfaceLight")
        surfaceLight.Face = Enum.NormalId.Bottom  -- 下向きに光を放つ
        surfaceLight.Color = Color3.new(1, 1, 0.9)
        surfaceLight.Brightness = 2
        surfaceLight.Range = 30
        surfaceLight.Parent = glass
    end
end

print("✅ ガラス天井システムの設置完了！")
print("🪟 ガラスパネル: " .. glassCount .. " 枚")
print("☀️ 天窓: 7個の大型スカイライト")
print("💡 自然光源: 全域に配置")
print("🌅 環境設定: 正午の自然光")
print("✨ 反射効果: ガラス表面からの光")
print("")
print("🌞 ガラス天井により自然光が迷路全体を照らします！")