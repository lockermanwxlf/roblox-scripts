local player = game:GetService("Players").LocalPlayer
local runService = game:GetService("RunService")
local httpService = game:GetService("HttpService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local marketplaceService = game:GetService("MarketplaceService")
repeat task.wait() until player:FindFirstChildOfClass("Backpack")

local saveFileName = "A0PG GUI - "..player.UserId..".json"
local fruits = replicatedStorage:WaitForChild("Fruit Models"):GetChildren()
local accessories = replicatedStorage:WaitForChild("Assets"):WaitForChild("Accessorys"):GetChildren()

local defaultSave = {
    sellingFruits = {};
    fruitPurchaseDelay = 0.1;
    fruitDeletionDelay = 0.5;
}
for _, fruit in pairs(fruits) do
    defaultSave.sellingFruits[fruit.Name] = false
end


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
local function getFruitCounts()
    local backpack = player:FindFirstChildOfClass("Backpack")
    local counts = {}
    for _, fruit in pairs(fruits) do
        counts[fruit.Name] = 0
    end
    for _, tool in pairs(backpack:GetChildren()) do
        if tool.Name:find("Fruit") then
            counts[tool.Name] += 1
        end
    end
    return counts
end
local save = defaultSave
local function getSave()
    if isfile(saveFileName) then
        save = httpService:JSONDecode(readfile(saveFileName))
        fillDefaults(save, defaultSave)
    end
    return save
end
getSave()
local function writeSave()
    writefile(saveFileName, httpService:JSONEncode(save))
end
local function buyFruits()
    local A_1 = "2"
    local Event = replicatedStorage.Remotes.buyrngdf
    Event:FireServer(A_1)
end
local function deleteUnwantedFruits()
    for fruitName, selling in pairs(save.sellingFruits) do
        local A_1 = player:FindFirstChildOfClass("Backpack"):FindFirstChild(fruitName)
        if A_1 and selling == true then
            replicatedStorage.Remotes.dropall:FireServer(A_1)
        end
    end
end
local function removeDevilFruit()
    local Event = game:GetService("ReplicatedStorage").Remotes.removedf
    Event:FireServer()
end

if game.GameId == 3213362013 then
    local placeName = marketplaceService:GetProductInfo(game.PlaceId).Name
    local discord = {}
    discord.library = loadstring(game:HttpGet("https://raw.githubusercontent.com/lockermanwxlf/roblox-scripts/main/ui-libraries/discordlib.lua"))()
    discord.window = discord.library:Window(placeName.." - "..tostring(identifyexecutor()))
    discord.servers = {}
    discord.channels = {}

    discord.servers.general = discord.window:Server("General", "")
    discord.servers.autofarm = discord.window:Server("Autofarm", "")
    discord.servers.fruits = discord.window:Server("Devil Fruits", "")
    discord.servers.config = discord.window:Server("Configuration", "")

    --general

    --autofarm

    --fruits
    local fruitsChannels = {}
    fruitsChannels.inventoryPage = discord.servers.fruits:Channel("Activate Farm")
    fruitsChannels.speedPage = discord.servers.fruits:Channel("Buy & Delete Speed")
    fruitsChannels.deletePage = discord.servers.fruits:Channel("Autodelete")
    fruitsChannels.changeDevilFruit = discord.servers.fruits:Channel("Delete Devil Fruit")

    local farmFruitsEnabled = false
    local buyFruitsEnabled = true
    local deleteFruitsEnabled = false

    coroutine.wrap(function()
        while true do
            if farmFruitsEnabled and buyFruitsEnabled then
                print("Buying")
                buyFruits()
                task.wait(save.fruitPurchaseDelay)
            else
                task.wait()
            end
        end
    end)()
    coroutine.wrap(function()
        while true do
            if farmFruitsEnabled and deleteFruitsEnabled then
                print("Selling")
                deleteUnwantedFruits()
                task.wait(save.fruitDeletionDelay)
            else
                task.wait()
            end
        end
    end)()

        -- inventory and activation page
    fruitsChannels.inventoryPage:Toggle("Enable farm (configure other pages first)", farmFruitsEnabled, function(toggled)
        farmFruitsEnabled = toggled
    end)
    local fruitInventories = {}
    local fruitCounts = getFruitCounts()
    for _, fruit in pairs(fruits) do
        fruitInventories[fruit.Name] = fruitsChannels.inventoryPage:Label(fruit.Name..": "..fruitCounts[fruit.Name], fruitCounts[fruit.Name]~=0)
    end
    coroutine.wrap(function()
        while true do
            fruitCounts = getFruitCounts()
            for fruitName, retextFunction in pairs(fruitInventories) do
                retextFunction(fruitName..": "..fruitCounts[fruitName], fruitCounts[fruitName] ~=0)
            end
            task.wait(0.5)
        end
    end)()
        -- speed page
    fruitsChannels.speedPage:Toggle("Buy fruits when farm is enabled", buyFruitsEnabled, function(toggled)
        buyFruitsEnabled = toggled
    end)
    fruitsChannels.speedPage:Slider("Time between each buy (in tenths of seconds)", 0, 100, save.fruitPurchaseDelay, function(value)
        save.fruitPurchaseDelay = value/10
    end)
    fruitsChannels.speedPage:Toggle("Delete fruits when farm is enabled", deleteFruitsEnabled, function(toggled)
        deleteFruitsEnabled = toggled
    end)
    fruitsChannels.speedPage:Slider("Time between each delete (in tenths of seconds)", 0, 100, save.fruitPurchaseDelay, function(value)
        save.fruitDeletionDelay = value/10
    end)

        --toggle page
    fruitsChannels.deletePage:Label("Toggle on's have a 3 second grace period before the fruits are deleted.")
    for _, fruit in pairs(fruits) do
        local lastPress = 0
        fruitsChannels.deletePage:Toggle(fruit.Name, save.sellingFruits[fruit.Name], function(toggled)
            lastPress+=1
            local oldPress = lastPress
            if toggled then
                task.wait(3)
                if lastPress == oldPress then
                    save.sellingFruits[fruit.Name] = toggled
                    writeSave()
                end
            else
                save.sellingFruits[fruit.Name] = toggled
                writeSave()
            end
        end)
    end

        --delete page
    local devilFruitRemovalLock = true
    fruitsChannels.changeDevilFruit:Label("This button will remove your current devil fruit (need 5,000,000 belly)")
    fruitsChannels.changeDevilFruit:Toggle("Removal Lock - unlock to be able to remove devil fruit", devilFruitRemovalLock, function(toggled)
        devilFruitRemovalLock = toggled
    end)
    fruitsChannels.changeDevilFruit:Button("Remove devil fruit", function()
        if devilFruitRemovalLock == false then
            removeDevilFruit()
        end
    end)
    --config


end