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
	parking2 = {
		x      = -340.03,      -- Central location X, Y, Z of the parking
		y      = 285.19,
		z      = 84.77,
		size   = 15.0,         -- The parking range radius (Horizontal)
		height = 10.0,         -- The parking range radius (Vertical)
		name   = "Public Parking", -- The name of the parking (blips)
		fee    = 500,          -- How much parking fee per day (Real life time), set false to disable
		enter  = {x = -338.57, y = 267.16, z = 85.73},
		maxcar = 10,
	},
	parking3 = {
		x      = 446.98,      -- Central location X, Y, Z of the parking
		y      = 246.07,
		z      = 103.86,
		size   = 25.0,         -- The parking range radius (Horizontal)
		height = 10.0,         -- The parking range radius (Vertical)
		name   = "Public Parking", -- The name of the parking (blips)
		fee    = 800,          -- How much parking fee per day (Real life time), set false to disable
		enter  = {x = 467.96, y = 265.07, z = 103.09},
		maxcar = 20,
	},
	parking4 = {
		x      = 374.35,      -- Central location X, Y, Z of the parking
		y      = 279.49,
		z      = 103.32,
		size   = 20.0,         -- The parking range radius (Horizontal)
		height = 10.0,         -- The parking range radius (Vertical)
		name   = "Public Parking", -- The name of the parking (blips)
		fee    = 700,          -- How much parking fee per day (Real life time), set false to disable
		enter  = {x = 364.77, y = 298.98, z = 103.5},
		maxcar = 15,
	},
}
