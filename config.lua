--[[ ===================================================== ]]--
--[[         FiveM Real Parking Script by Akkariin         ]]--
--[[ ===================================================== ]]--

Config = {}

Config.UsingOldESX = true      -- If you are using ESX 1.2.0 or higher please leave this to false

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

--[[ Chinese locales
	["only_allow_car"]   = "你只能在這裡停放汽車",
	["car_saved"]        = "你的車輛已經保存",
	["press_to_save"]    = "按下 ~INPUT_CONTEXT~ 來保存你的車輛",
	["not_your_car"]     = "你必須擁有這輛車的所有權才能保存",
	["need_parking_fee"] = "按下 ~INPUT_CONTEXT~ 來繳納 ~g~￥%s元~s~ 停車費後即可離開",
	["not_enough_money"] = "你沒有足夠的錢",
	["parking_fee"]      = "停車費用：~g~￥%s元/天",
	["pay_success"]      = "你已支付了停車費 ~g~￥%s元~s~，現在可以將車開走了",
	["parking_full"]     = "這個停車場已經不能再停放更多的車了",
	["invalid_car"]      = "你沒有在這個停車場存放這輛車",
	["already_parking"]  = "這個停車場已經停著一輛相同車牌的車了",
	["owner"]            = "車主：~y~%s~s~",
	["plate"]            = "車牌：~g~%s~s~",
]]--
