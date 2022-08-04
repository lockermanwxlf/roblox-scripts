if game.GameId == 3183403065 then -- Anime Adventures
    -- auto-farm / gui
    coroutine.wrap(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ArponAG/Scripts/main/AnimeAdventures.lua"))()
    end)()
    -- merchant sniper
    coroutine.wrap(function()
        wait(5)
	    loadstring(game:HttpGet("https://raw.githubusercontent.com/lockermanwxlf/roblox-scripts/main/anime-adventures/merchant-sniper.lua"))()
    end)()

elseif game.GameId == 3213362013 then -- A 0ne Piece Game

end

-- Auto reconnect
coroutine.wrap(function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/lockermanwxlf/roblox-scripts/main/general-scripts/auto-reconnect.lua"))()
end)()