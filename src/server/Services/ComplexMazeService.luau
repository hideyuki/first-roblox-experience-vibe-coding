-- Kanata Maze 複雑迷路生成サービス
local ComplexMazeService = {}

local workspace = game:GetService("Workspace")

-- 迷路システム初期化フラグ
local mazeSystemInitialized = false

-- 迷路の設定（Constants.luauから）
local MAZE_WIDTH = 186  -- 迷路の幅（スタッド）
local MAZE_HEIGHT = 150 -- 迷路の奥行き（スタッド）
local WALL_SIZE = 6     -- 各壁セルのサイズ（スタッド）
local WALL_HEIGHT = 40  -- 壁の高さ（スタッド）

-- 迷路グリッドサイズ（31x25 = 186x150スタッドに対応）
local GRID_WIDTH = math.floor(MAZE_WIDTH / WALL_SIZE)   -- 31
local GRID_HEIGHT = math.floor(MAZE_HEIGHT / WALL_SIZE) -- 25

-- 壁作成関数
local function createWall(position, size, name, parent)
    local wall = Instance.new("Part")
    wall.Name = name
    wall.Size = size
    wall.Position = position
    wall.Anchored = true
    wall.Material = Enum.Material.Brick
    wall.BrickColor = BrickColor.new("Dark stone grey")
    wall.Parent = parent
    return wall
end

-- 複雑迷路パターン生成（改良版 Recursive Backtracking）
local function generateComplexMaze()
    -- 1 = 壁, 0 = 通路
    local maze = {}
    
    -- 初期化：全て壁
    for y = 1, GRID_HEIGHT do
        maze[y] = {}
        for x = 1, GRID_WIDTH do
            maze[y][x] = 1
        end
    end
    
    -- 方向定義（上、右、下、左）- 1セルずつ移動
    local directions = {
        {0, -1}, {1, 0}, {0, 1}, {-1, 0}
    }
    
    -- スタック（Recursive Backtracking用）
    local stack = {}
    
    -- 開始点計算（スタートゲート付近から開始）
    local centerX = math.floor(GRID_WIDTH / 2) + 1
    local startGateGridZ = math.floor(((-73) - (-(MAZE_HEIGHT/2))) / WALL_SIZE) + 1
    
    -- 開始点をスタートゲート付近に設定（安全な範囲内）
    local startX = centerX
    local startY = math.max(2, math.min(GRID_HEIGHT-1, startGateGridZ))
    
    maze[startY][startX] = 0
    table.insert(stack, {startX, startY})
    
    -- Recursive Backtracking アルゴリズム（改良版）
    while #stack > 0 do
        local current = stack[#stack]
        local x, y = current[1], current[2]
        
        -- 隣接する未訪問のセルを探す
        local neighbors = {}
        for _, dir in ipairs(directions) do
            local nx, ny = x + dir[1], y + dir[2]
            if nx >= 2 and nx <= GRID_WIDTH-1 and ny >= 2 and ny <= GRID_HEIGHT-1 then
                if maze[ny][nx] == 1 then
                    table.insert(neighbors, {nx, ny, dir})
                end
            end
        end
        
        if #neighbors > 0 then
            -- ランダムに隣接セルを選択
            local next = neighbors[math.random(#neighbors)]
            local nx, ny, dir = next[1], next[2], next[3]
            
            -- 隣接セルを通路にする
            maze[ny][nx] = 0
            
            table.insert(stack, {nx, ny})
        else
            -- 行き止まり - バックトラック
            table.remove(stack)
        end
    end
    
    -- 追加の通路を作成（連結性を向上）
    for attempts = 1, math.floor(GRID_WIDTH * GRID_HEIGHT * 0.1) do
        local x = math.random(2, GRID_WIDTH-1)
        local y = math.random(2, GRID_HEIGHT-1)
        
        if maze[y][x] == 1 then
            -- 周辺に通路があるかチェック
            local hasPathNeighbor = false
            for _, dir in ipairs(directions) do
                local nx, ny = x + dir[1], y + dir[2]
                if nx >= 1 and nx <= GRID_WIDTH and ny >= 1 and ny <= GRID_HEIGHT then
                    if maze[ny] and maze[ny][nx] == 0 then
                        hasPathNeighbor = true
                        break
                    end
                end
            end
            
            -- 隣に通路があれば、この壁を通路に変換（30%の確率）
            if hasPathNeighbor and math.random() < 0.3 then
                maze[y][x] = 0
            end
        end
    end
    
    -- スタートとゴールの入口確保
    local centerX = math.floor(GRID_WIDTH / 2) + 1
    
    -- スタート入口の座標計算（z=-73の位置）
    -- 迷路の範囲は z=-75 から z=+75 なので、z=-73は迷路の下端付近
    local startGateGridZ = math.floor(((-73) - (-(MAZE_HEIGHT/2))) / WALL_SIZE) + 1
    
    -- ゴール入口の座標計算（z=73の位置）  
    -- z=73は迷路の上端付近
    local goalGateGridZ = math.floor(((73) - (-(MAZE_HEIGHT/2))) / WALL_SIZE) + 1
    
    -- スタート入口（スタートゲート z=-73 付近）- 広範囲クリア
    if startGateGridZ >= 1 and startGateGridZ <= GRID_HEIGHT then
        -- 中央の通路
        maze[startGateGridZ][centerX] = 0
        -- 前後の通路（3マス分確保）
        for offset = -2, 2 do
            local targetY = startGateGridZ + offset
            if targetY >= 1 and targetY <= GRID_HEIGHT then
                maze[targetY][centerX] = 0
                -- 左右にも少し通路を作成（T字路を作る）
                if centerX > 1 then maze[targetY][centerX-1] = 0 end
                if centerX < GRID_WIDTH then maze[targetY][centerX+1] = 0 end
            end
        end
    end
    
    -- ゴール入口（ゴールゲート z=73 付近）- 広範囲クリア
    if goalGateGridZ >= 1 and goalGateGridZ <= GRID_HEIGHT then
        -- 中央の通路
        maze[goalGateGridZ][centerX] = 0
        -- 前後の通路（3マス分確保）
        for offset = -2, 2 do
            local targetY = goalGateGridZ + offset
            if targetY >= 1 and targetY <= GRID_HEIGHT then
                maze[targetY][centerX] = 0
                -- 左右にも少し通路を作成（T字路を作る）
                if centerX > 1 then maze[targetY][centerX-1] = 0 end
                if centerX < GRID_WIDTH then maze[targetY][centerX+1] = 0 end
            end
        end
    end
    
    -- デバッグ情報
    print("🚪 入口座標計算:")
    print("  スタートゲート z=-73 → グリッド行: " .. (startGateGridZ or "範囲外"))
    print("  ゴールゲート z=73 → グリッド行: " .. (goalGateGridZ or "範囲外"))
    print("  中央列: " .. centerX)
    
    -- 確実な中央通路の作成（スタートからゴールまで）
    print("🛤️ 中央基幹通路を作成中...")
    for y = math.min(startGateGridZ, goalGateGridZ), math.max(startGateGridZ, goalGateGridZ) do
        if y >= 1 and y <= GRID_HEIGHT then
            maze[y][centerX] = 0
            -- 基幹通路から左右に分岐も作成
            if centerX > 2 and math.random() < 0.4 then
                maze[y][centerX-1] = 0
            end
            if centerX < GRID_WIDTH-1 and math.random() < 0.4 then
                maze[y][centerX+1] = 0
            end
        end
    end
    
    -- 複雑化：ランダムに追加の通路を作成（難易度調整）
    local complexityFactor = 0.08 -- 8%の壁をランダムに除去（連結性向上のため増加）
    for y = 2, GRID_HEIGHT-1 do
        for x = 2, GRID_WIDTH-1 do
            if maze[y][x] == 1 and math.random() < complexityFactor then
                maze[y][x] = 0
            end
        end
    end
    
    -- 行き止まり削減：一部の行き止まりに追加出口を作成
    for y = 2, GRID_HEIGHT-1 do
        for x = 2, GRID_WIDTH-1 do
            if maze[y][x] == 0 then
                local neighbors = 0
                for _, dir in ipairs(directions) do
                    local nx, ny = x + dir[1]/2, y + dir[2]/2
                    if nx >= 1 and nx <= GRID_WIDTH and ny >= 1 and ny <= GRID_HEIGHT then
                        if maze[ny] and maze[ny][nx] == 0 then
                            neighbors = neighbors + 1
                        end
                    end
                end
                
                -- 行き止まり（隣接通路が1つのみ）に30%の確率で追加出口
                if neighbors == 1 and math.random() < 0.3 then
                    local validDirs = {}
                    for _, dir in ipairs(directions) do
                        local nx, ny = x + dir[1]/2, y + dir[2]/2
                        if nx >= 2 and nx <= GRID_WIDTH-1 and ny >= 2 and ny <= GRID_HEIGHT-1 then
                            if maze[ny] and maze[ny][nx] == 1 then
                                table.insert(validDirs, {nx, ny})
                            end
                        end
                    end
                    
                    if #validDirs > 0 then
                        local target = validDirs[math.random(#validDirs)]
                        maze[target[2]][target[1]] = 0
                    end
                end
            end
        end
    end
    
    -- 統計情報の計算
    local totalCells = GRID_WIDTH * GRID_HEIGHT
    local pathCells = 0
    local wallCells = 0
    
    for y = 1, GRID_HEIGHT do
        for x = 1, GRID_WIDTH do
            if maze[y][x] == 0 then
                pathCells = pathCells + 1
            else
                wallCells = wallCells + 1
            end
        end
    end
    
    local pathPercentage = math.floor((pathCells / totalCells) * 100)
    
    print("📊 迷路生成統計:")
    print("  - 総セル数: " .. totalCells)
    print("  - 通路セル: " .. pathCells .. " (" .. pathPercentage .. "%)")
    print("  - 壁セル: " .. wallCells .. " (" .. (100-pathPercentage) .. "%)")
    
    return maze
end

-- 複雑迷路の構築
local function buildComplexMaze(mazeGame)
    print("🏗️ 複雑迷路生成中...")
    
    -- 既存の迷路壁を削除
    local existingWalls = mazeGame:FindFirstChild("Walls")
    if existingWalls then
        for _, wall in ipairs(existingWalls:GetChildren()) do
            if wall.Name:find("MazeWall") then
                wall:Destroy()
            end
        end
    else
        existingWalls = Instance.new("Folder")
        existingWalls.Name = "Walls"
        existingWalls.Parent = mazeGame
    end
    
    -- 迷路パターン生成
    local mazePattern = generateComplexMaze()
    
    -- 重要な座標計算
    local startGateZ = -73  -- スタートゲートのZ座標
    local goalGateZ = 73    -- ゴールゲートのZ座標
    local mazeStartZ = -75  -- 迷路の開始Z座標
    local mazeEndZ = 75     -- 迷路の終了Z座標
    
    -- 迷路の壁を配置（ただし、ゲート付近は特別処理）
    local wallCount = 0
    for y = 1, GRID_HEIGHT do
        for x = 1, GRID_WIDTH do
            if mazePattern[y][x] == 1 then
                -- グリッド座標を実世界座標に変換
                local worldX = (x - (GRID_WIDTH + 1) / 2) * WALL_SIZE
                local worldZ = (y - (GRID_HEIGHT + 1) / 2) * WALL_SIZE
                
                -- スタートゲート付近（z=-73周辺）の壁は作らない
                local centerX = 0  -- 中央列
                local gateWidth = 18  -- ゲート周辺の開口部の幅
                
                local isStartGateArea = math.abs(worldZ - startGateZ) <= 12 and math.abs(worldX - centerX) <= gateWidth
                local isGoalGateArea = math.abs(worldZ - goalGateZ) <= 12 and math.abs(worldX - centerX) <= gateWidth
                
                -- ゲートエリアでなければ壁を作成
                if not isStartGateArea and not isGoalGateArea then
                    createWall(
                        Vector3.new(worldX, WALL_HEIGHT / 2, worldZ),
                        Vector3.new(WALL_SIZE, WALL_HEIGHT, WALL_SIZE),
                        "MazeWall_" .. x .. "_" .. y,
                        existingWalls
                    )
                    wallCount = wallCount + 1
                end
            end
        end
    end
    
    -- 外周壁の追加（迷路を完全に囲む、ただしゲート開口部は除く）
    local outerWallThickness = 3
    local gateOpeningWidth = 24  -- ゲート開口部の幅
    
    -- 上下の外周壁（ゲート開口部を避ける）
    for x = -(MAZE_WIDTH/2 + outerWallThickness), (MAZE_WIDTH/2 + outerWallThickness), WALL_SIZE do
        -- 上側（ゴールゲート側）- 中央開口部を避ける
        if math.abs(x) > gateOpeningWidth / 2 then
            createWall(
                Vector3.new(x, WALL_HEIGHT / 2, -(MAZE_HEIGHT/2 + outerWallThickness)),
                Vector3.new(WALL_SIZE, WALL_HEIGHT, outerWallThickness * 2),
                "OuterWall_Top_" .. x,
                existingWalls
            )
            wallCount = wallCount + 1
        end
        
        -- 下側（スタートゲート側）- 中央開口部を避ける  
        if math.abs(x) > gateOpeningWidth / 2 then
            createWall(
                Vector3.new(x, WALL_HEIGHT / 2, (MAZE_HEIGHT/2 + outerWallThickness)),
                Vector3.new(WALL_SIZE, WALL_HEIGHT, outerWallThickness * 2),
                "OuterWall_Bottom_" .. x,
                existingWalls
            )
            wallCount = wallCount + 1
        end
    end
    
    -- 左右の外周壁（通常通り）
    for z = -(MAZE_HEIGHT/2), (MAZE_HEIGHT/2), WALL_SIZE do
        -- 左側
        createWall(
            Vector3.new(-(MAZE_WIDTH/2 + outerWallThickness), WALL_HEIGHT / 2, z),
            Vector3.new(outerWallThickness * 2, WALL_HEIGHT, WALL_SIZE),
            "OuterWall_Left_" .. z,
            existingWalls
        )
        
        -- 右側
        createWall(
            Vector3.new((MAZE_WIDTH/2 + outerWallThickness), WALL_HEIGHT / 2, z),
            Vector3.new(outerWallThickness * 2, WALL_HEIGHT, WALL_SIZE),
            "OuterWall_Right_" .. z,
            existingWalls
        )
        wallCount = wallCount + 2
    end
    
    print("✅ 複雑迷路構築完了!")
    print("📊 迷路統計:")
    print("  - グリッドサイズ: " .. GRID_WIDTH .. "x" .. GRID_HEIGHT)
    print("  - 壁の総数: " .. wallCount .. " 個")
    print("  - 迷路サイズ: " .. MAZE_WIDTH .. "x" .. MAZE_HEIGHT .. " スタッド")
    print("🚪 入口状況:")
    print("  - スタートゲート: z=" .. startGateZ .. " (開口部幅: " .. gateOpeningWidth .. ")")
    print("  - ゴールゲート: z=" .. goalGateZ .. " (開口部幅: " .. gateOpeningWidth .. ")")
    print("  - 迷路範囲: z=" .. mazeStartZ .. " から z=" .. mazeEndZ)
    
    return wallCount
end

-- メイン初期化関数
function ComplexMazeService.Initialize()
    if mazeSystemInitialized then
        return
    end
    
    print("🌟 複雑迷路サービスを初期化中...")
    
    -- MazeGameの待機
    local mazeGame = workspace:WaitForChild("MazeGame", 30)
    if not mazeGame then
        warn("❌ MazeGameが見つかりません")
        return
    end
    
    -- 複雑迷路構築
    buildComplexMaze(mazeGame)
    
    mazeSystemInitialized = true
    print("✅ 複雑迷路サービスの初期化完了！")
end

-- サービス開始
function ComplexMazeService.Start()
    spawn(function()
        wait(3) -- 初期構造構築後に実行
        ComplexMazeService.Initialize()
    end)
end

return ComplexMazeService