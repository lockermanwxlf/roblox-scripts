local httpService = game:GetService("HttpService")
local fileName = "gameIdsToRootPlaceIds.json"

if not isfile(fileName) then
    writefile(fileName, httpService:JSONEncode({}))
end

-- get root place id if not in file already
local gameId = game.GameId
local rootPlaceIds = httpService:JSONDecode(readfile(fileName))
local placeId = rootPlaceIds[gameId]
if not placeId then
    local apiUrl = "https://games.roblox.com/v1/games?universeIds="..tostring(gameId)
    local response = game:HttpGet(apiUrl)
    local gameData = httpService:JSONDecode(response)
    placeId = gameData["data"][1]["rootPlaceId"]
    rootPlaceIds[gameId] = placeId
    writefile(fileName, httpService:JSONEncode(rootPlaceIds))
end

-- reconnect when disconnected
repeat task.wait() until game.CoreGui:FindFirstChild('RobloxPromptGui')

local player = game:GetService("Players").LocalPlayer
local promptOverlay = game:GetService("CoreGui"):WaitForChild("RobloxPromptGui"):WaitForChild("promptOverlay")
local teleportService = game:GetService("TeleportService")

promptOverlay.ChildAdded:connect(function(child)
    if child.Name == 'ErrorPrompt' then
        repeat
            teleportService:Teleport(placeId or game.PlaceId)
            task.wait(2)
        until false
    end
end)

print("Auto-reconnect enabled.")

--8349889591thegame
--8304191830