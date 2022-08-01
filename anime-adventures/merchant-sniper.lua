--lockermanwxlf#2293
local keywords {
	StarFruit = "starfruit";
	LuckPotion = "luckpotion";
	SummonTicket = "summon_ticket";
	StarRemnant = "star_remnant";
	StrawHat = "straw";
	MagmaFruit = "magma";
}

local buying = {
	keywords.StrawHat;
	keywords.MagmaFruit;
	keywords.SummonTicket;
	keywords.StarFruit;
}
local merchant = workspace:FindFirstChild("travelling_merchant", true)
if merchant and merchant:FindFirstChild("is_open").Value == true then
	local items = merchant.stand.items:GetChildren()
	for i,v in pairs(items) do
		for _, item in pairs(buying) do
			if v.Name:lower():find(item) then
				local A_1 = v.Name
				local Event = game:GetService("ReplicatedStorage").endpoints["client_to_server"]["buy_travelling_merchant_item"]
				Event:InvokeServer(A_1)
			end
		end
	end
end