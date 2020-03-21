--[[ ===================================================== ]]--
--[[         FiveM Real Parking Script by Akkariin         ]]--
--[[ ===================================================== ]]--

Config = {}

Config.UsingOldESX = true      -- If you are using ESX 1.2.0 or higher please leave this to false

Config.Locale = 'en' -- locale

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
