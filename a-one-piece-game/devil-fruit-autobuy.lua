local function dropAll(name)
    local A_1 = game.Players.LocalPlayer.Backpack:FindFirstChild(name)
    if A_1 then
        local Event = game:GetService("ReplicatedStorage").Remotes.dropall
        Event:FireServer(A_1)
    end
end

local dontWant = {
    "Invisible Fruit",
    "Gas Fruit",
    "Lightning Fruit",
    "Venom Fruit",
    "Chop Fruit",
    "Smoke Fruit",
    "Fire Fruit",
    "Ice Fruit",
    "Sand Fruit",
    "String Fruit",
    "Light Fruit",
    "Barrier Fruit",
  --  "Phoenix Fruit",
    "Magma Fruit",
    "Mochi Fruit",
    "Buddha Fruit";
    "Quake Fruit"
}
coroutine.wrap(function()
    while wait(0.2) do
        for _,v in pairs(dontWant) do
            dropAll(v)
            wait()
        end
    end
end)()
coroutine.wrap(function()
    for i = 1, 3000 do
        local t = {}
        for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
            if v.Name:find("Fruit") then t[v.Name] = (t[v.Name] or 0) + 1 end
        end
        print()
        for i,v in pairs(t) do
            print(i.."-"..v)
        end
        
        local A_1 = "2"
        local Event = game:GetService("ReplicatedStorage").Remotes.buyrngdf
        Event:FireServer(A_1)
        wait()
    end
end)()