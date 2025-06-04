-- DataStore ランキングクリアスクリプト（本番環境用）
-- 注意: このスクリプトは本番環境のDataStoreを完全にクリアします
-- 実行前に必ずバックアップを取ってください

local DataStoreService = game:GetService("DataStoreService")

-- DataStore設定（サーバーコードと同じ設定を使用）
local DATASTORE_NAME = "MazeRankings"
local RANKING_KEY = "GlobalRankings"

print("🚨 DataStore ランキングクリアスクリプト開始")
print("⚠️  警告: 本番環境のランキングデータを完全削除します")
print("📊 DataStore: " .. DATASTORE_NAME)
print("🔑 キー: " .. RANKING_KEY)

-- DataStoreに接続
local success, rankingDataStore = pcall(function()
    return DataStoreService:GetDataStore(DATASTORE_NAME)
end)

if not success then
    error("❌ DataStore接続失敗: " .. tostring(rankingDataStore))
end

print("✅ DataStore接続成功")

-- 現在のデータを確認
print("📋 現在のランキングデータを確認中...")
local success, currentData = pcall(function()
    return rankingDataStore:GetAsync(RANKING_KEY)
end)

if success and currentData then
    print("📊 現在のランキング数: " .. #currentData .. " エントリ")
    print("🥇 上位3位:")
    for i = 1, math.min(3, #currentData) do
        local entry = currentData[i]
        local minutes = math.floor(entry.time / 60)
        local seconds = entry.time % 60
        print("  #" .. i .. ": " .. entry.name .. " - " .. string.format("%02d:%05.2f", minutes, seconds))
    end
else
    print("📊 現在のランキング: データなしまたは読み込み失敗")
end

-- 5秒待機（実行者が内容を確認する時間）
print("⏰ 5秒後にデータを削除します...")
print("⏰ 今すぐ中止したい場合はStudioを停止してください")
wait(5)

-- ランキングデータをクリア
print("🗑️ ランキングデータをクリア中...")
local success, error = pcall(function()
    -- 空の配列でデータを上書き
    rankingDataStore:SetAsync(RANKING_KEY, {})
end)

if success then
    print("✅ ランキングデータを正常にクリアしました")
    print("📊 新しいランキング: 空（0エントリ）")
else
    error("❌ ランキングクリア失敗: " .. tostring(error))
end

-- 削除確認
print("🔍 削除確認中...")
wait(2)

local success, verifyData = pcall(function()
    return rankingDataStore:GetAsync(RANKING_KEY)
end)

if success then
    local count = verifyData and #verifyData or 0
    print("📊 確認結果: " .. count .. " エントリ")
    
    if count == 0 then
        print("✅ ランキングデータのクリアが完了しました")
        print("🎮 ゲームを再起動すると空のランキングが表示されます")
    else
        print("⚠️ 警告: まだ " .. count .. " エントリが残っています")
    end
else
    print("⚠️ 削除確認に失敗しました: " .. tostring(verifyData))
end

print("🏁 DataStoreクリアスクリプト完了")

-- 使用方法の説明
print("")
print("📖 使用方法:")
print("1. Roblox Studio で Game Settings → Security → Enable API Services をチェック")
print("2. このスクリプトを ServerScriptService に配置")
print("3. Studio でゲームをテスト実行（F5）")
print("4. スクリプトが自動実行されてDataStoreをクリア")
print("5. 完了後、このスクリプトを削除")