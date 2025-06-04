-- 不要なサインボード削除
print("🧹 不要なサインボードを削除中...")

local workspace = game:GetService("Workspace")

-- MazeGameフォルダの取得
local mazeGame = workspace:FindFirstChild("MazeGame")
if not mazeGame then
    warn("❌ MazeGameフォルダが見つかりません")
    return
end

-- 削除対象のアイテム
local itemsToDelete = {
    "CelebrationArch",        -- Congratulationsアーチ（壁）
    "GoalEntranceSign",       -- ゲート先のCongratulationsサイン
    "RankingSign",           -- ランキングボードのサイン
    "WarpDirectionSign"      -- ワープゾーンのサインは残す
}

local deletedCount = 0

-- 指定されたアイテムを削除
for _, itemName in ipairs(itemsToDelete) do
    local item = mazeGame:FindFirstChild(itemName)
    if item then
        item:Destroy()
        deletedCount = deletedCount + 1
        print("🗑️ " .. itemName .. " を削除しました")
    end
end

-- 追加で、名前に"congratulations"や"ranking"が含まれるアイテムを検索して削除
for _, child in pairs(mazeGame:GetChildren()) do
    if child:IsA("Part") then
        local name = string.lower(child.Name)
        if string.find(name, "congratulations") or 
           string.find(name, "celebration") or 
           (string.find(name, "ranking") and string.find(name, "sign")) then
            child:Destroy()
            deletedCount = deletedCount + 1
            print("🗑️ " .. child.Name .. " を削除しました（パターンマッチ）")
        end
    end
end

-- GoalAreaフォルダ内もチェック
local goalArea = mazeGame:FindFirstChild("GoalArea")
if goalArea then
    for _, child in pairs(goalArea:GetChildren()) do
        if child:IsA("Part") then
            local name = string.lower(child.Name)
            if string.find(name, "congratulations") or 
               string.find(name, "celebration") or 
               (string.find(name, "ranking") and string.find(name, "sign")) then
                child:Destroy()
                deletedCount = deletedCount + 1
                print("🗑️ " .. child.Name .. " を削除しました（GoalArea内）")
            end
        end
    end
end

print("✅ サインボード削除完了！")
print("🗑️ 削除したアイテム数: " .. deletedCount)
print("🎮 シンプルなゴールエリアになりました！")