local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
repeat RunService.RenderStepped:Wait() until Player:FindFirstChildOfClass("PlayerGui")
local PlayerGui = Player:FindFirstChildOfClass("PlayerGui")

local PlaceIds = {
    Sea1 = 8396586868;
    Sea2 = 0; --add
}
local PlaceName = MarketplaceService:GetProductInfo(game.PlaceId).Name

local function fillDefaults(current, default)
	for i, v in pairs(default) do
		if current[i] then
			if typeof(v) == "table" then
				fillDefaults(current[i], v)
			end
		else
			current[i] = v
		end
	end
end

local function run()
    if game.GameId ~= 3213362013 then return end
    local gameCore = {}
        gameCore.devilFruits = ReplicatedStorage:WaitForChild("Fruit Models"):GetChildren()

    local save = {}
    save.default = {
        autodelete = {};
        autobuydelay = 0.1;
        autoselldelay = 1;
    }
    for _, v in pairs(gameCore.devilFruits) do
        save.default.autodelete[v.Name] = false
    end
    save.path = "a0nepiecegame34"..tostring(Player.UserId)..".json"
    if isfile(save.path) then
        save.file = readfile(save.path)
        save.data = HttpService:JSONDecode(save.file)
        fillDefaults(save.data, save.default)
    else
        save.file = HttpService:JSONEncode(save.default)
        save.data = save.default
        writefile(save.path, save.file)
    end
    save.write = function()
        writefile(save.path, HttpService:JSONEncode(save.data))
    end


    local scriptCore = {}
        scriptCore.autoDeletes = save.data.autodelete
        scriptCore.autoBuying = false
        scriptCore.autoSelling = false

    local discordCore = {}
    discordCore.lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/lockermanwxlf/roblox-scripts/main/ui-libraries/discordlib.lua"))()
    discordCore.window = discordCore.lib:Window(PlaceName.." - "..tostring(identifyexecutor()))
    discordCore.server = discordCore.window:Server("A 0ne Piece Game", "http://www.roblox.com/asset/?id=6031075938")
    discordCore.fruitsserver = discordCore.window:Server("Fruits", "")
    discordCore.channels = {}
    
    -- autobuy fruits channel
    discordCore.channels.devilFruits = discordCore.fruitsserver:Channel("Autobuy Fruits")
    coroutine.wrap(function()
        while true do
            if scriptCore.autoBuying then
                print("buying")
                task.wait(save.data.autobuydelay)
            else
                task.wait()
            end
        end
    end)()
    discordCore.channels.devilFruits:Toggle("Autobuy Devil Fruits", scriptCore.autoBuying, function(toggled)
        scriptCore.autoBuying = toggled
    end)
    discordCore.channels.devilFruits:Slider("Delay between buys (tenths of seconds)", 0, 100, save.data.autobuydelay * 10, function(value)
        save.data.autobuydelay = value/10
        save.write()
    end)
    coroutine.wrap(function()
        while true do
            if scriptCore.autoSelling then
                print("selling")
                task.wait(save.data.autoselldelay)
            else
                task.wait()
            end
        end
    end)()
    discordCore.channels.devilFruits:Toggle("Autodelete (2 seconds grace period)", scriptCore.autoSelling, function(toggled)
        scriptCore.autoSelling = toggled
    end)
    discordCore.channels.devilFruits:Slider("Delay between deletes (tenths of seconds)", 0, 100, save.data.autoselldelay * 10, function(value)
        save.data.autoselldelay = value/10
        save.write()
    end)

    -- autodelete fruits channel
    discordCore.channels.autoDeletes = discordCore.fruitsserver:Channel("Autodelete Fruits")
    discordCore.channels.autoDeletes:Label("You have 3 seconds to untoggle a fruit before it gets activated.")
    for _, devilFruit in pairs(gameCore.devilFruits) do
        local lastPress = 0
        discordCore.channels.autoDeletes:Toggle(devilFruit.Name, scriptCore.autoDeletes[devilFruit.Name] or false, function(toggled)
            lastPress+=1
            local oldPress = lastPress
            if toggled then
                task.wait(3)
                if lastPress == oldPress then
                    scriptCore.autoDeletes[devilFruit.Name] = toggled
                    save.write()
                end
            else
                scriptCore.autoDeletes[devilFruit.Name] = toggled
                save.write()
            end
        end)
    end

end

run()