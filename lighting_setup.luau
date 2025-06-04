-- 迷路照明システム（松明・キャンプファイヤー）
print("🔥 迷路照明システムを設置中...")

local workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

-- MazeGameフォルダの取得
local mazeGame = workspace:FindFirstChild("MazeGame")
if not mazeGame then
    warn("❌ MazeGameフォルダが見つかりません")
    return
end

-- 照明フォルダの作成
local lightingFolder = mazeGame:FindFirstChild("Lighting")
if lightingFolder then
    lightingFolder:Destroy()
end
lightingFolder = Instance.new("Folder")
lightingFolder.Name = "Lighting"
lightingFolder.Parent = mazeGame

-- 松明作成関数
local function createTorch(position, parent)
    local torchFolder = Instance.new("Folder")
    torchFolder.Name = "Torch"
    torchFolder.Parent = parent
    
    -- 松明の支柱
    local pole = Instance.new("Part")
    pole.Name = "Pole"
    pole.Size = Vector3.new(0.3, 6, 0.3)
    pole.Position = position + Vector3.new(0, 3, 0)
    pole.Anchored = true
    pole.Material = Enum.Material.Wood
    pole.BrickColor = BrickColor.new("Dark orange")
    pole.Parent = torchFolder
    
    -- 松明の頭部
    local torchHead = Instance.new("Part")
    torchHead.Name = "TorchHead"
    torchHead.Size = Vector3.new(1, 1, 1)
    torchHead.Position = position + Vector3.new(0, 6.5, 0)
    torchHead.Anchored = true
    torchHead.Material = Enum.Material.Neon
    torchHead.BrickColor = BrickColor.new("Bright orange")
    torchHead.Shape = Enum.PartType.Ball
    torchHead.Parent = torchFolder
    
    -- 光源
    local pointLight = Instance.new("PointLight")
    pointLight.Color = Color3.new(1, 0.7, 0.3)  -- 温かいオレンジ色
    pointLight.Brightness = 2
    pointLight.Range = 25
    pointLight.Parent = torchHead
    
    -- 炎のエフェクト
    local fire = Instance.new("Fire")
    fire.Size = 3
    fire.Heat = 5
    fire.Color = Color3.new(1, 0.5, 0)
    fire.SecondaryColor = Color3.new(1, 0, 0)
    fire.Parent = torchHead
    
    -- ちらつきエフェクト
    spawn(function()
        while torchHead.Parent do
            local targetBrightness = math.random(15, 25) / 10
            local tween = TweenService:Create(
                pointLight,
                TweenInfo.new(0.5, Enum.EasingStyle.Sine),
                {Brightness = targetBrightness}
            )
            tween:Play()
            wait(0.5)
        end
    end)
    
    return torchFolder
end

-- キャンプファイヤー作成関数
local function createCampfire(position, parent)
    local campfireFolder = Instance.new("Folder")
    campfireFolder.Name = "Campfire"
    campfireFolder.Parent = parent
    
    -- 石の輪
    for i = 1, 8 do
        local angle = (i - 1) * (math.pi * 2 / 8)
        local stone = Instance.new("Part")
        stone.Name = "Stone" .. i
        stone.Size = Vector3.new(1.5, 1, 1.5)
        stone.Position = position + Vector3.new(math.cos(angle) * 3, 0.5, math.sin(angle) * 3)
        stone.Anchored = true
        stone.Material = Enum.Material.Rock
        stone.BrickColor = BrickColor.new("Dark stone grey")
        stone.Shape = Enum.PartType.Block
        
        -- 石を少し回転
        stone.Rotation = Vector3.new(0, math.deg(angle), 0)
        stone.Parent = campfireFolder
    end
    
    -- 薪
    for i = 1, 6 do
        local log = Instance.new("Part")
        log.Name = "Log" .. i
        log.Size = Vector3.new(0.8, 0.8, 4)
        log.Position = position + Vector3.new(
            math.random(-15, 15) / 10,
            0.4,
            math.random(-15, 15) / 10
        )
        log.Anchored = true
        log.Material = Enum.Material.Wood
        log.BrickColor = BrickColor.new("Brown")
        log.Rotation = Vector3.new(0, math.random(0, 360), 0)
        log.Parent = campfireFolder
    end
    
    -- 中央の炎
    local fireBase = Instance.new("Part")
    fireBase.Name = "FireBase"
    fireBase.Size = Vector3.new(2, 0.1, 2)
    fireBase.Position = position + Vector3.new(0, 0.05, 0)
    fireBase.Anchored = true
    fireBase.Material = Enum.Material.Neon
    fireBase.BrickColor = BrickColor.new("Bright red")
    fireBase.Transparency = 0.8
    fireBase.Parent = campfireFolder
    
    -- 大きな光源
    local pointLight = Instance.new("PointLight")
    pointLight.Color = Color3.new(1, 0.6, 0.2)
    pointLight.Brightness = 3
    pointLight.Range = 40
    pointLight.Parent = fireBase
    
    -- 大きな炎のエフェクト
    local fire = Instance.new("Fire")
    fire.Size = 8
    fire.Heat = 10
    fire.Color = Color3.new(1, 0.4, 0)
    fire.SecondaryColor = Color3.new(1, 0, 0)
    fire.Parent = fireBase
    
    -- 煙のエフェクト
    local smoke = Instance.new("Smoke")
    smoke.Size = 5
    smoke.Opacity = 0.3
    smoke.RiseVelocity = 15
    smoke.Color = Color3.new(0.3, 0.3, 0.3)
    smoke.Parent = fireBase
    
    -- 炎のちらつき
    spawn(function()
        while fireBase.Parent do
            local targetBrightness = math.random(25, 35) / 10
            local tween = TweenService:Create(
                pointLight,
                TweenInfo.new(0.7, Enum.EasingStyle.Sine),
                {Brightness = targetBrightness}
            )
            tween:Play()
            wait(0.7)
        end
    end)
    
    return campfireFolder
end

-- 迷路の壁に松明を設置
local wallsFolder = mazeGame:FindFirstChild("Walls")
if wallsFolder then
    local walls = wallsFolder:GetChildren()
    local torchCount = 0
    
    -- 10個ごとに松明を設置（間隔を調整）
    for i = 1, #walls, 10 do
        local wall = walls[i]
        if wall:IsA("Part") then
            -- 壁の横に松明を設置
            local torchPos = wall.Position + Vector3.new(2.5, 0, 0)
            createTorch(torchPos, lightingFolder)
            torchCount = torchCount + 1
        end
    end
    
    print("🔥 迷路に松明を " .. torchCount .. " 個設置しました")
else
    warn("❌ 迷路の壁フォルダが見つかりません")
end

-- スタートエリアに照明を追加
local startArea = mazeGame:FindFirstChild("StartArea")
if startArea then
    -- スタートエリアの四隅に松明
    local startPositions = {
        Vector3.new(-35, 0, -105),  -- 左前
        Vector3.new(35, 0, -105),   -- 右前
        Vector3.new(-35, 0, -125),  -- 左奥
        Vector3.new(35, 0, -125)    -- 右奥
    }
    
    for _, pos in ipairs(startPositions) do
        createTorch(pos, lightingFolder)
    end
    
    -- スタートエリア中央にキャンプファイヤー
    createCampfire(Vector3.new(-10, 0, -115), lightingFolder)
    createCampfire(Vector3.new(10, 0, -115), lightingFolder)
    
    print("🔥 スタートエリアに松明4個、キャンプファイヤー2個を設置しました")
else
    warn("❌ スタートエリアが見つかりません")
end

-- ゴールエリアに照明を追加
local goalArea = mazeGame:FindFirstChild("GoalArea")
if goalArea then
    -- ゴールエリアの四隅に松明
    local goalPositions = {
        Vector3.new(-25, 0, 85),   -- 左前
        Vector3.new(25, 0, 85),    -- 右前
        Vector3.new(-25, 0, 125),  -- 左奥
        Vector3.new(25, 0, 125)    -- 右奥
    }
    
    for _, pos in ipairs(goalPositions) do
        createTorch(pos, lightingFolder)
    end
    
    -- ゴールエリア中央にキャンプファイヤー
    createCampfire(Vector3.new(-10, 0, 105), lightingFolder)
    createCampfire(Vector3.new(10, 0, 105), lightingFolder)
    
    print("🔥 ゴールエリアに松明4個、キャンプファイヤー2個を設置しました")
else
    warn("❌ ゴールエリアが見つかりません")
end

-- 天井の一部に明かり取り用の隙間を作成
local ceilingFolder = mazeGame:FindFirstChild("Ceiling")
if ceilingFolder then
    local ceilings = ceilingFolder:GetChildren()
    
    -- 20個ごとに天井ブロックを削除して明かり取りを作る
    for i = 1, #ceilings, 20 do
        local ceiling = ceilings[i]
        if ceiling:IsA("Part") then
            ceiling:Destroy()
        end
    end
    
    print("💡 天井に明かり取りの隙間を作成しました")
end

-- 環境光の調整
local lighting = game:GetService("Lighting")
lighting.Ambient = Color3.new(0.2, 0.2, 0.3)  -- 少し明るくする
lighting.Brightness = 1.5
lighting.OutdoorAmbient = Color3.new(0.3, 0.3, 0.4)

print("✅ 迷路照明システムの設置完了！")
print("🔥 松明: 迷路内 + スタート・ゴールエリア各4個")
print("🔥 キャンプファイヤー: スタート・ゴールエリア各2個")
print("💡 天井に明かり取りの隙間追加")
print("🌅 環境光を調整して全体を明るくしました")
print("")
print("🎮 迷路が明るく快適になりました！")