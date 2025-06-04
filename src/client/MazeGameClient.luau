-- 迷路ゲームのクライアントUI
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- RemoteEventsの取得
local remoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local startTimerEvent = remoteEvents:WaitForChild("StartTimer")
local stopTimerEvent = remoteEvents:WaitForChild("StopTimer")
local updateRankingEvent = remoteEvents:WaitForChild("UpdateRanking")

-- UI要素
local timerGui = nil
local timerLabel = nil
local resultGui = nil
local isTimerRunning = false
local startTime = 0

-- 時間を文字列形式に変換
local function formatTime(seconds)
    local minutes = math.floor(seconds / 60)
    local secs = seconds % 60
    return string.format("%02d:%05.2f", minutes, secs)
end

-- タイマーUIの作成
local function createTimerUI()
    -- 既存のUIを削除
    if timerGui then
        timerGui:Destroy()
    end
    
    timerGui = Instance.new("ScreenGui")
    timerGui.Name = "MazeTimerGui"
    timerGui.Parent = playerGui
    
    -- タイマー表示フレーム
    local timerFrame = Instance.new("Frame")
    timerFrame.Name = "TimerFrame"
    timerFrame.Size = UDim2.new(0, 200, 0, 80)
    timerFrame.Position = UDim2.new(0.5, -100, 0, 20)
    timerFrame.BackgroundColor3 = Color3.new(0, 0, 0)
    timerFrame.BackgroundTransparency = 0.3
    timerFrame.BorderSizePixel = 0
    timerFrame.Parent = timerGui
    
    -- 角を丸くする
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = timerFrame
    
    -- タイトルラベル
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Size = UDim2.new(1, 0, 0.4, 0)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "MAZE TIMER"
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.Parent = timerFrame
    
    -- タイマーラベル
    timerLabel = Instance.new("TextLabel")
    timerLabel.Name = "TimerLabel"
    timerLabel.Size = UDim2.new(1, 0, 0.6, 0)
    timerLabel.Position = UDim2.new(0, 0, 0.4, 0)
    timerLabel.BackgroundTransparency = 1
    timerLabel.Text = "00:00.00"
    timerLabel.TextColor3 = Color3.new(0, 1, 0)
    timerLabel.TextScaled = true
    timerLabel.Font = Enum.Font.Code
    timerLabel.Parent = timerFrame
    
    -- 初期状態では非表示
    timerFrame.Visible = false
end

-- 結果表示UIの作成
local function createResultUI(completionTime, rank)
    -- 既存の結果UIを削除
    if resultGui then
        resultGui:Destroy()
    end
    
    resultGui = Instance.new("ScreenGui")
    resultGui.Name = "MazeResultGui"
    resultGui.Parent = playerGui
    
    -- 背景フレーム
    local backgroundFrame = Instance.new("Frame")
    backgroundFrame.Name = "BackgroundFrame"
    backgroundFrame.Size = UDim2.new(1, 0, 1, 0)
    backgroundFrame.Position = UDim2.new(0, 0, 0, 0)
    backgroundFrame.BackgroundColor3 = Color3.new(0, 0, 0)
    backgroundFrame.BackgroundTransparency = 0.5
    backgroundFrame.BorderSizePixel = 0
    backgroundFrame.Parent = resultGui
    
    -- 結果表示フレーム
    local resultFrame = Instance.new("Frame")
    resultFrame.Name = "ResultFrame"
    resultFrame.Size = UDim2.new(0, 400, 0, 300)
    resultFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    resultFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    resultFrame.BorderSizePixel = 0
    resultFrame.Parent = backgroundFrame
    
    -- 角を丸くする
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = resultFrame
    
    -- 境界線
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.new(1, 1, 0)
    stroke.Thickness = 3
    stroke.Parent = resultFrame
    
    -- 完了テキスト
    local completedLabel = Instance.new("TextLabel")
    completedLabel.Name = "CompletedLabel"
    completedLabel.Size = UDim2.new(1, 0, 0.3, 0)
    completedLabel.Position = UDim2.new(0, 0, 0, 0)
    completedLabel.BackgroundTransparency = 1
    completedLabel.Text = "🎉 MAZE COMPLETED! 🎉"
    completedLabel.TextColor3 = Color3.new(1, 1, 0)
    completedLabel.TextScaled = true
    completedLabel.Font = Enum.Font.SourceSansBold
    completedLabel.Parent = resultFrame
    
    -- 時間表示
    local timeLabel = Instance.new("TextLabel")
    timeLabel.Name = "TimeLabel"
    timeLabel.Size = UDim2.new(1, 0, 0.2, 0)
    timeLabel.Position = UDim2.new(0, 0, 0.3, 0)
    timeLabel.BackgroundTransparency = 1
    timeLabel.Text = "Time: " .. formatTime(completionTime)
    timeLabel.TextColor3 = Color3.new(0, 1, 0)
    timeLabel.TextScaled = true
    timeLabel.Font = Enum.Font.Code
    timeLabel.Parent = resultFrame
    
    -- 順位表示
    local rankLabel = Instance.new("TextLabel")
    rankLabel.Name = "RankLabel"
    rankLabel.Size = UDim2.new(1, 0, 0.2, 0)
    rankLabel.Position = UDim2.new(0, 0, 0.5, 0)
    rankLabel.BackgroundTransparency = 1
    rankLabel.Text = rank and ("Rank: #" .. rank) or "Rank: --"
    rankLabel.TextColor3 = Color3.new(1, 0.5, 0)
    rankLabel.TextScaled = true
    rankLabel.Font = Enum.Font.SourceSansBold
    rankLabel.Parent = resultFrame
    
    -- 閉じるボタン
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0.6, 0, 0.15, 0)
    closeButton.Position = UDim2.new(0.2, 0, 0.8, 0)
    closeButton.BackgroundColor3 = Color3.new(0.2, 0.7, 0.2)
    closeButton.Text = "Continue"
    closeButton.TextColor3 = Color3.new(1, 1, 1)
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.SourceSansBold
    closeButton.Parent = resultFrame
    
    -- 閉じるボタンの角を丸くする
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = closeButton
    
    -- 閉じるボタンのイベント
    closeButton.MouseButton1Click:Connect(function()
        resultGui:Destroy()
        resultGui = nil
    end)
    
    -- アニメーション効果
    resultFrame.Size = UDim2.new(0, 0, 0, 0)
    local tween = TweenService:Create(
        resultFrame,
        TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Size = UDim2.new(0, 400, 0, 300)}
    )
    tween:Play()
end

-- ランキング表示の更新
local function updateRankingDisplay(rankings)
    local rankingBoard = workspace.MazeGame:FindFirstChild("RankingBoard")
    if not rankingBoard then return end
    
    local rankingGui = rankingBoard:FindFirstChild("RankingGui")
    if not rankingGui then return end
    
    local rankingFrame = rankingGui:FindFirstChild("RankingFrame")
    if not rankingFrame then return end
    
    -- 既存のエントリをクリア
    for _, child in pairs(rankingFrame:GetChildren()) do
        if child.Name:find("Entry") then
            child:Destroy()
        end
    end
    
    -- 新しいランキングエントリを作成
    for i = 1, math.min(#rankings, 100) do
        local entry = rankings[i]
        
        local entryFrame = Instance.new("Frame")
        entryFrame.Name = "Entry" .. i
        entryFrame.Size = UDim2.new(1, -10, 0, 18)
        entryFrame.Position = UDim2.new(0, 5, 0, (i-1) * 20)
        entryFrame.BackgroundTransparency = 1
        entryFrame.Parent = rankingFrame
        
        -- 順位ラベル
        local rankLabel = Instance.new("TextLabel")
        rankLabel.Name = "RankLabel"
        rankLabel.Size = UDim2.new(0.15, 0, 1, 0)
        rankLabel.Position = UDim2.new(0, 0, 0, 0)
        rankLabel.BackgroundTransparency = 1
        rankLabel.Text = "#" .. i
        rankLabel.TextColor3 = i <= 3 and Color3.new(1, 1, 0) or Color3.new(1, 1, 1)
        rankLabel.TextScaled = true
        rankLabel.Font = Enum.Font.SourceSansBold
        rankLabel.Parent = entryFrame
        
        -- 名前ラベル
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Name = "NameLabel"
        nameLabel.Size = UDim2.new(0.55, 0, 1, 0)
        nameLabel.Position = UDim2.new(0.15, 0, 0, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = entry.name
        nameLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
        nameLabel.TextScaled = true
        nameLabel.Font = Enum.Font.SourceSans
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.Parent = entryFrame
        
        -- 時間ラベル
        local timeLabel = Instance.new("TextLabel")
        timeLabel.Name = "TimeLabel"
        timeLabel.Size = UDim2.new(0.3, 0, 1, 0)
        timeLabel.Position = UDim2.new(0.7, 0, 0, 0)
        timeLabel.BackgroundTransparency = 1
        timeLabel.Text = formatTime(entry.time)
        timeLabel.TextColor3 = Color3.new(0.6, 0.6, 1)
        timeLabel.TextScaled = true
        timeLabel.Font = Enum.Font.Code
        timeLabel.TextXAlignment = Enum.TextXAlignment.Right
        timeLabel.Parent = entryFrame
    end
    
    -- CanvasSizeを更新
    rankingFrame.CanvasSize = UDim2.new(0, 0, 0, #rankings * 20)
end

-- タイマー更新ループ
local timerConnection = nil

-- スタートタイマーイベント
startTimerEvent.OnClientEvent:Connect(function()
    isTimerRunning = true
    startTime = tick()
    
    -- タイマーUIを表示
    if timerGui then
        timerGui.TimerFrame.Visible = true
    end
    
    -- タイマー更新ループを開始
    if timerConnection then
        timerConnection:Disconnect()
    end
    
    timerConnection = RunService.Heartbeat:Connect(function()
        if isTimerRunning and timerLabel then
            local currentTime = tick() - startTime
            timerLabel.Text = formatTime(currentTime)
        end
    end)
    
    print("タイマー開始!")
end)

-- ストップタイマーイベント
stopTimerEvent.OnClientEvent:Connect(function(completionTime, rank)
    isTimerRunning = false
    
    -- タイマー更新ループを停止
    if timerConnection then
        timerConnection:Disconnect()
        timerConnection = nil
    end
    
    -- タイマーUIを非表示
    if timerGui then
        timerGui.TimerFrame.Visible = false
    end
    
    -- 結果UIを表示
    createResultUI(completionTime, rank)
    
    print("ゴール! 時間: " .. formatTime(completionTime) .. " 順位: " .. (rank or "不明"))
end)

-- ランキング更新イベント
updateRankingEvent.OnClientEvent:Connect(function(rankings)
    updateRankingDisplay(rankings)
end)

-- 初期化
local function initialize()
    createTimerUI()
    print("迷路ゲームクライアントUI初期化完了!")
end

-- クライアント起動時に初期化
initialize()
