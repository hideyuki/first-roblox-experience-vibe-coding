-- Kanata Maze 照明サービス（自動適用版）
local LightingService = {}

local workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")

-- 照明初期化フラグ
local lightingInitialized = false

-- 環境光設定の適用（自然光重視、眩しさ軽減）
local function setupEnvironmentalLighting()
    Lighting.Ambient = Color3.new(0.4, 0.4, 0.5)  -- 適度な環境光
    Lighting.Brightness = 2  -- 標準的な明るさ
    Lighting.OutdoorAmbient = Color3.new(0.6, 0.6, 0.7)  -- 控えめな屋外光
    Lighting.ColorShift_Bottom = Color3.new(0.3, 0.3, 0.4)
    Lighting.ColorShift_Top = Color3.new(0.8, 0.8, 0.9)
    Lighting.ShadowSoftness = 0.5
    Lighting.TimeOfDay = "14:00:00"  -- 午後の柔らかい光
    Lighting.GeographicLatitude = 30  -- 少し角度をつけた太陽光
    
    print("☀️ 自然な環境光設定を適用しました")
end

-- ガラスパネル作成（照明なし、純粋なガラスのみ）
local function createGlassPanel(position, size, parent)
    local glassPanel = Instance.new("Part")
    glassPanel.Name = "GlassPanel"
    glassPanel.Size = size
    glassPanel.Position = position
    glassPanel.Anchored = true
    glassPanel.CanCollide = true
    glassPanel.Material = Enum.Material.Glass
    glassPanel.BrickColor = BrickColor.new("Institutional white")
    glassPanel.Transparency = 0.1  -- 少し見える程度
    glassPanel.Reflectance = 0.1  -- 控えめな反射
    glassPanel.Parent = parent
    
    return glassPanel
end

-- 削除：天窓と追加照明は不要

-- ガラス天井システムの構築（シンプル版）
local function buildGlassCeilingSystem(mazeGame)
    -- 既存の天井と照明を削除
    local existingCeiling = mazeGame:FindFirstChild("Ceiling")
    if existingCeiling then
        existingCeiling:Destroy()
    end
    
    local existingLighting = mazeGame:FindFirstChild("Lighting")
    if existingLighting then
        existingLighting:Destroy()
    end
    
    local glassCeilingFolder = Instance.new("Folder")
    glassCeilingFolder.Name = "GlassCeiling"
    glassCeilingFolder.Parent = mazeGame
    
    local panelSize = 20
    local glassCount = 0
    
    -- 迷路エリアのガラス天井のみ
    for x = -100, 100, panelSize do
        for z = -80, 80, panelSize do
            local glassPos = Vector3.new(x, 42, z)
            createGlassPanel(glassPos, Vector3.new(panelSize, 2, panelSize), glassCeilingFolder)
            glassCount = glassCount + 1
        end
    end
    
    -- スタートエリアのガラス天井
    for x = -50, 50, panelSize do
        for z = -140, -80, panelSize do
            local glassPos = Vector3.new(x, 42, z)
            createGlassPanel(glassPos, Vector3.new(panelSize, 2, panelSize), glassCeilingFolder)
            glassCount = glassCount + 1
        end
    end
    
    -- ゴールエリアのガラス天井
    for x = -40, 40, panelSize do
        for z = 80, 140, panelSize do
            local glassPos = Vector3.new(x, 42, z)
            createGlassPanel(glassPos, Vector3.new(panelSize, 2, panelSize), glassCeilingFolder)
            glassCount = glassCount + 1
        end
    end
    
    print("🪟 シンプルなガラス天井システムを構築しました: " .. glassCount .. " パネル")
    return glassCeilingFolder
end

-- メイン初期化関数
function LightingService.Initialize()
    if lightingInitialized then
        return
    end
    
    print("💡 照明サービスを初期化中...")
    
    -- 環境光設定
    setupEnvironmentalLighting()
    
    -- MazeGameの待機
    local mazeGame = workspace:WaitForChild("MazeGame", 30)
    if not mazeGame then
        warn("❌ MazeGameが見つかりません")
        return
    end
    
    -- ガラス天井システムの構築
    buildGlassCeilingSystem(mazeGame)
    
    lightingInitialized = true
    print("✅ シンプルなガラス天井システムの初期化完了！")
end

-- サービス開始
function LightingService.Start()
    spawn(function()
        wait(3) -- MazeGameの構築を待つ
        LightingService.Initialize()
    end)
end

return LightingService