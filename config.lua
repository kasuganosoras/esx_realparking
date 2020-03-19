--[[ ===================================================== ]]--
--[[         FiveM Real Parking Script by Akkariin         ]]--
--[[ ===================================================== ]]--

Config = {}

Config.ParkingLocations = {
	parking1 = {
		x      = -327.73,                               -- Central location X, Y, Z of the parking
		y      = -934.12,                               -- Y
		z      = 31.08,                                 -- Z
		size   = 50.0,                                  -- The parking range radius (Horizontal)
		height = 10.0,                                  -- The parking range radius (Vertical)
		name   = "Public Parking",                      -- The name of the parking (blips)
		fee    = 1000,                                  -- How much parking fee per day (Real life time), set 0 to disable
		enter  = {x = -279.25, y = -890.39, z = 30.08}, -- The entrance of the parking
		maxcar = 30,
	},
}

Config.Locales = {
	["only_allow_car"]   = "You only can store cars here",
	["car_saved"]        = "You car has been stored",
	["press_to_save"]    = "Press ~INPUT_CONTEXT~ to store your car",
	["not_your_car"]     = "You have to own the car to store it",
	["need_parking_fee"] = "Press ~INPUT_CONTEXT~ to pay the parking fees for ~g~$%s~s~",
	["not_enough_money"] = "You don't have enough money",
	["parking_fee"]      = "Parking fees: ~g~$%s/day",
	["pay_success"]      = "You paid parking fee for ~g~$%s~s~ and you can drive the car now",
	["parking_full"]     = "This parking is full, you can't parking here",
	["invalid_car"]      = "You didn't store the car here or you don't have permission to drive this car",
	["already_parking"]  = "This car parking has already stored a car with same plate",
	["owner"]            = "Owner: ~y~%s~s~",
	["plate"]            = "Plate: ~g~%s~s~",
}
