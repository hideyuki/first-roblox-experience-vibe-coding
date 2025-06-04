-- Kanata Maze - ゲーム全体で使用する定数（リニューアル版）
local Constants = {
    -- 迷路の設定（大幅リニューアル）
    MAZE_WIDTH = 186, -- 迷路の幅（スタッド）
    MAZE_HEIGHT = 150, -- 迷路の奥行き（スタッド）
    MAZE_PATH_WIDTH = 12, -- 通路の幅（スタッド）
    WALL_HEIGHT = 40, -- 壁の高さ（スタッド）
    WALL_THICKNESS = 6, -- 壁の厚さ（スタッド）
    CEILING_HEIGHT = 45, -- 天井の高さ（スタッド）
    
    -- ゲーム設定
    MAX_PLAYERS = 100, -- 最大プレイヤー数
    RANKING_DISPLAY_COUNT = 100, -- ランキング表示数（1-100位）
    
    -- DataStore設定
    RANKING_DATASTORE_NAME = "KanataMazeRankings",
    RANKING_DATASTORE_KEY = "GlobalRankings20250604",
    
    -- UI設定
    TIMER_UPDATE_INTERVAL = 0.1, -- タイマー更新間隔（秒）
    RANKING_UPDATE_INTERVAL = 5, -- ランキング更新間隔（秒）
    
    -- ゲートの位置（新配置）
    START_GATE_POSITION = Vector3.new(0, 20, -73), -- スタートゲート位置
    GOAL_GATE_POSITION = Vector3.new(0, 20, 73), -- ゴールゲート位置
    
    -- スタートエリアの設定（大型化）
    START_AREA_SIZE = Vector3.new(80, 1, 40), -- スタートエリアのサイズ
    START_AREA_POSITION = Vector3.new(0, 0, -110), -- スタートエリアの位置
    SPAWN_POSITION = Vector3.new(0, 1, -110), -- プレイヤースポーン位置
    
    -- ゴールエリアの設定（大型化）
    GOAL_AREA_SIZE = Vector3.new(60, 1, 50), -- ゴールエリアのサイズ
    GOAL_AREA_POSITION = Vector3.new(0, 0, 110), -- ゴールエリアの位置
    
    -- ワープゾーンの設定
    WARP_ZONE_SIZE = Vector3.new(12, 1, 12), -- ワープゾーンのサイズ
    WARP_ZONE_POSITION = Vector3.new(0, 0, 115), -- ワープゾーンの位置
    WARP_DESTINATION = Vector3.new(0, 1, -110), -- ワープ先（スタートエリア）
    
    -- ランキングボードの設定
    RANKING_BOARD_SIZE = Vector3.new(20, 15, 2), -- 横長ランキングボード
    RANKING_BOARD_POSITION = Vector3.new(0, 7.5, 125), -- ランキングボード位置
    
    -- 重複防止システム設定
    DUPLICATE_PREVENTION_COOLDOWN = 2, -- 重複防止クールダウン（秒）
    
    -- 照明システム設定
    TORCH_SPACING = 10, -- 松明設置間隔（壁何個おき）
    TORCH_LIGHT_RANGE = 25, -- 松明の光の範囲
    CAMPFIRE_LIGHT_RANGE = 40, -- キャンプファイヤーの光の範囲
    
    -- プレイヤー状態
    PLAYER_STATE = {
        WAITING = "WAITING", -- 待機中（スタート可能）
        STARTED = "STARTED", -- タイマー実行中（ゴール可能）
        COMPLETED = "COMPLETED" -- ゴール済み（再スタート必要）
    },
}

return Constants
