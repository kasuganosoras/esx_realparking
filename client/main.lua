--[[ ===================================================== ]]--
--[[         FiveM Real Parking Script by Akkariin         ]]--
--[[ ===================================================== ]]--

-- Arrays
PlayerData       = {}
LocalVehicles    = {}
GlobalVehicles   = {}

-- Variables
ESX              = nil
CurrentFee       = nil
LastPlate        = nil
PlayerIdentifier = nil
SpawnedVehicles  = false
DeletingEntities = false

-- Refresh the vehicles

RegisterNetEvent("esx_realparking:refreshVehicles")
AddEventHandler("esx_realparking:refreshVehicles", function(vehicles)
	DebugLog("Server request refresh vehicles list")
	GlobalVehicles = vehicles
	RemoveVehicles(vehicles)
	Citizen.Wait(1000)
	SpawnVehicles(vehicles)
end)

RegisterNetEvent("esx_realparking:addVehicle")
AddEventHandler("esx_realparking:addVehicle", function(vehicle, owner)
	if owner == GetPlayerServerId(PlayerId()) then
		DeleteEntity(GetVehiclePedIsIn(GetPlayerPed(-1), false))
	end
	SpawnVehicle(vehicle)
end)

RegisterNetEvent("esx_realparking:deleteVehicle")
AddEventHandler("esx_realparking:deleteVehicle", function(vehicle)
	DeleteLocalVehicle(vehicle)
end)

RegisterNetEvent("esx_realparking:impoundVehicle")
AddEventHandler("esx_realparking:impoundVehicle", function(vehicle)
	ImpoundVehicle(vehicle)
end)

function DebugLog(text)
	if Config.debug then
		print(string.format("[DEBUG] %s", text))
	end
end

-- Get the stored vehicle player is in

function GetPedInStoredCar(ped)
	local tempVeh = GetVehiclePedIsIn(ped)
	local findVeh = false
	for i = 1, #LocalVehicles do
		if LocalVehicles[i] ~= nil and LocalVehicles[i].entity == tempVeh then
			findVeh = LocalVehicles[i]
			break
		end
	end
	-- Clean memory
	tempVeh = nil
	return findVeh
end

-- Spawn local vehicles

function SpawnVehicles(vehicles)
	Citizen.CreateThread(function()
		while DeletingEntities do
			Citizen.Wait(100)
		end
		DebugLog("Start spawn all vehicles")
		for i = 1, #vehicles, 1 do
			local vehicleProps = vehicles[i].vehicle.props
			DeleteLocalVehicle(vehicles[i].vehicle)
			DeleteNearVehicle(vec3(vehicles[i].vehicle.location.x, vehicles[i].vehicle.location.y, vehicles[i].vehicle.location.z))
			local carLivery    = -1
			if type(vehicles[i].vehicle.livery) ~= 'nil' then
				carLivery = vehicles[i].vehicle.livery
			end
			LoadModel(vehicleProps["model"])
			local tempVeh = CreateVehicle(vehicleProps["model"], vehicles[i].vehicle.location.x, vehicles[i].vehicle.location.y, vehicles[i].vehicle.location.z, vehicles[i].vehicle.location.h, false)
			ESX.Game.SetVehicleProperties(tempVeh, vehicleProps)
			RequestCollisionAtCoord(vehicles[i].vehicle.location.x, vehicles[i].vehicle.location.y, vehicles[i].vehicle.location.z)
			SetVehicleOnGroundProperly(tempVeh)
			SetEntityAsMissionEntity(tempVeh, true, true)
			SetModelAsNoLongerNeeded(vehicleProps["model"])
			SetEntityInvincible(tempVeh, true)
			SetVehicleLivery(tempVeh, vehicles[i].vehicle.livery)
			NetworkFadeInEntity(tempVeh, false)
			Wait(100)
			FreezeEntityPosition(tempVeh, true)
			if vehicles[i].owner ~= PlayerData.identifier then
				SetVehicleDoorsLocked(tempVeh, 2)
			end
			table.insert(LocalVehicles, {
				entity   = tempVeh,
				data     = vehicles[i].vehicle,
				plate    = vehicles[i].plate,
				fee      = vehicles[i].fee,
				owner    = vehicles[i].owner,
				name     = vehicles[i].name,
				livery   = carLivery,
				health   = vehicles[i].vehicle.health,
				location = vehicles[i].vehicle.location,
			})
			if LastPlate ~= nil and vehicles[i].plate == LastPlate then
				TaskWarpPedIntoVehicle(GetPlayerPed(-1), tempVeh, -1)
				Wait(500)
				TaskLeaveVehicle(GetPlayerPed(-1), tempVeh)
				LastPlate = nil
			end
			Wait(300)
			-- Clean memory
			vehicleProps, carLivery, tempVeh = nil
		end
	end)
end

-- Spawn single vehicle

function SpawnVehicle(vehicleData)
	Citizen.CreateThread(function()
		while DeletingEntities do
			Citizen.Wait(100)
		end
		DeleteLocalVehicle(vehicleData.vehicle)
		DeleteNearVehicle(vec3(vehicleData.vehicle.location.x, vehicleData.vehicle.location.y, vehicleData.vehicle.location.z))
		local vehicleProps = vehicleData.vehicle.props
		local carLivery    = -1
		if type(vehicleData.vehicle.livery) ~= 'nil' then
			carLivery = vehicleData.vehicle.livery
		end
		LoadModel(vehicleProps["model"])
		local tempVeh = CreateVehicle(vehicleProps["model"], vehicleData.vehicle.location.x, vehicleData.vehicle.location.y, vehicleData.vehicle.location.z, vehicleData.vehicle.location.h, false)
		ESX.Game.SetVehicleProperties(tempVeh, vehicleProps)
		RequestCollisionAtCoord(vehicleData.vehicle.location.x, vehicleData.vehicle.location.y, vehicleData.vehicle.location.z)
		SetVehicleOnGroundProperly(tempVeh)
		SetEntityAsMissionEntity(tempVeh, true, true)
		SetModelAsNoLongerNeeded(vehicleProps["model"])
		SetEntityInvincible(tempVeh, true)
		SetVehicleLivery(tempVeh, vehicleData.vehicle.livery)
		SetVehicleEngineHealth(tempVeh, vehicleData.vehicle.health.engine)
		SetVehicleBodyHealth(tempVeh, vehicleData.vehicle.health.body)
		SetVehiclePetrolTankHealth(tempVeh, vehicleData.vehicle.health.tank)
		NetworkFadeInEntity(tempVeh, false)
		Wait(100)
		FreezeEntityPosition(tempVeh, true)
		if vehicleData.owner ~= PlayerData.identifier then
			SetVehicleDoorsLocked(tempVeh, 2)
		end
		table.insert(LocalVehicles, {
			entity   = tempVeh,
			data     = vehicleData.vehicle,
			plate    = vehicleData.plate,
			fee      = vehicleData.fee,
			owner    = vehicleData.owner,
			name     = vehicleData.name,
			livery   = carLivery,
			health   = vehicleData.vehicle.health,
			location = vehicleData.vehicle.location,
		})
		if LastPlate ~= nil and vehicleData.plate == LastPlate then
			TaskWarpPedIntoVehicle(GetPlayerPed(-1), tempVeh, -1)
			Wait(500)
			TaskLeaveVehicle(GetPlayerPed(-1), tempVeh)
			LastPlate = nil
		end
		-- Clean memory
		vehicleProps, carLivery, tempVeh = nil
	end)
end

-- When player drive the car

function DriveVehicle(vehicle)
	-- Delete the local entity first
	DeleteNearVehicle(vector3(vehicle.location.x, vehicle.location.y, vehicle.location.z))
	local vehicleProps = vehicle.props
	LoadModel(vehicleProps["model"])
	local tempVeh = CreateVehicle(vehicleProps["model"], vehicle.location.x, vehicle.location.y, vehicle.location.z, vehicle.location.h, true)
	ESX.Game.SetVehicleProperties(tempVeh, vehicleProps)
	SetVehicleOnGroundProperly(tempVeh)
	SetVehicleLivery(tempVeh, vehicle.livery)
	SetVehicleEngineHealth(tempVeh, vehicle.health.engine)
	SetVehicleBodyHealth(tempVeh, vehicle.health.body)
	SetVehiclePetrolTankHealth(tempVeh, vehicle.health.tank)
	TaskWarpPedIntoVehicle(GetPlayerPed(-1), tempVeh, -1)
	-- Clean memory
	vehicleProps, tempVeh = nil
end

-- Remove the local vehicles

function RemoveVehicles(vehicles)
	DebugLog("Start delete vehicles")
	DeletingEntities = true
	for i = 1, #vehicles, 1 do
		local tmpLoc = {
			["x"] = vehicles[i].vehicle.location.x,
			["y"] = vehicles[i].vehicle.location.y,
			["z"] = vehicles[i].vehicle.location.z,
			["h"] = 0.0,
		}
		local veh, distance = ESX.Game.GetClosestVehicle(tmpLoc)
		if NetworkGetEntityIsLocal(veh) and distance < 1 then
			local driver = GetPedInVehicleSeat(veh, -1)
			if not DoesEntityExist(driver) or not IsPedAPlayer(driver) then
				local tmpModel = GetEntityModel(veh)
				SetModelAsNoLongerNeeded(tmpModel)
				DeleteEntity(veh)
				Citizen.Wait(300)
			end
		end
		-- Clean memory
		tmpLoc, veh, distance, driver, tmpModel = nil
	end
	LocalVehicles    = {}
	DeletingEntities = false
	DebugLog("Finished delete vehicles")
end

function CheckVehicleImpound()
	for i = 1, #LocalVehicles do
		if type(LocalVehicles[i]) ~= 'nil' and type(LocalVehicles[i].entity) ~= 'nil' then
			if not DoesEntityExist(LocalVehicles[i].entity) then
				DebugLog("Vehicle" .. tostring(LocalVehicles[i].entity) .. " has been impound, remove from database")
				ImpoundVehicle(LocalVehicles[i].entity)
				LocalVehicles[i] = nil
			end
		end
	end
end

function UpdateVehicleStatus()
	for i = 1, #LocalVehicles do
		if type(LocalVehicles[i]) ~= 'nil' and type(LocalVehicles[i].entity) ~= 'nil' then
			if DoesEntityExist(LocalVehicles[i].entity) and type(LocalVehicles[i].onground) == 'nil' then
				if GetDistanceBetweenCoords(GetEntityCoords(LocalVehicles[i].entity), GetEntityCoords(GetPlayerPed(-1))) < 50.0 then
					SetEntityCoords(LocalVehicles[i].entity, LocalVehicles[i].location.x, LocalVehicles[i].location.y, LocalVehicles[i].location.z)
					SetVehicleOnGroundProperly(LocalVehicles[i].entity)
					LocalVehicles[i].onground = true
				end
			end
		end
	end
end

-- Delete single vehicle

function DeleteLocalVehicle(vehicle)
	for i = 1, #LocalVehicles do
		if type(vehicle.plate) ~= 'nil' and type(LocalVehicles[i]) ~= 'nil' and type(LocalVehicles[i].plate) ~= 'nil' then
			if vehicle.plate == LocalVehicles[i].plate then
				NetworkRequestControlOfEntity(LocalVehicles[i].entity)
				local tmpModel = GetEntityModel(LocalVehicles[i].entity)
				SetModelAsNoLongerNeeded(tmpModel)
				DeleteEntity(LocalVehicles[i].entity)
				LocalVehicles[i] = nil
				tmpModel = nil
			end
		end
	end
end

-- Delete the vehicle near the location

function DeleteNearVehicle(location)
	local veh, distance = ESX.Game.GetClosestVehicle(location)
	if distance <= 1 then
		for i = 1, #LocalVehicles do
			if LocalVehicles[i] ~= nil and LocalVehicles[i].entity == veh then
				LocalVehicles[i] = nil
			end
		end
		local driver = GetPedInVehicleSeat(veh, -1)
		if not DoesEntityExist(driver) or not IsPedAPlayer(driver) then
			NetworkRequestControlOfEntity(veh)
			local tmpModel = GetEntityModel(veh)
			SetModelAsNoLongerNeeded(tmpModel)
			DeleteEntity(veh)
			tmpModel = nil
		end
	end
end

-- Impound vehicle for esx_policejob

function ImpoundVehicle(vehicle)
	for i = 1, #LocalVehicles do
		if LocalVehicles[i] ~= nil and vehicle == LocalVehicles[i].entity then
			local deleteData = LocalVehicles[i]
			ESX.TriggerServerCallback("esx_realparking:impoundVehicle", function(callback)
				if callback.status then
					DeleteEntity(deleteData.entity)
					LocalVehicles[i] = nil
				end
				deleteData = nil
			end, LocalVehicles[i])
		end
	end
end

-- Just some help text

function DisplayHelpText(text)
	SetTextComponentFormat('STRING')
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

-- Load car model

function LoadModel(model)
	while not HasModelLoaded(model) do
		RequestModel(model)
		Citizen.Wait(1)
	end
end

-- Draw 3d text on screen

function Draw3DText(x, y, z, textInput, fontId, scaleX, scaleY)
	local px, py, pz = table.unpack(GetGameplayCamCoords())
	local dist       = GetDistanceBetweenCoords(px, py, pz, x, y, z, 1)    
	local scale      = (1 / dist) * 20
	local fov        = (1 / GetGameplayCamFov()) * 100
	local scale      = scale * fov   
	SetTextScale(scaleX * scale, scaleY * scale)
	SetTextFont(fontId)
	SetTextProportional(1)
	SetTextColour(250, 250, 250, 255)
	SetTextDropshadow(1, 1, 1, 1, 255)
	SetTextEdge(2, 0, 0, 0, 150)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(textInput)
	SetDrawOrigin(x, y, z + 2, 0)
	DrawText(0.0, 0.0)
	ClearDrawOrigin()
	px, py, pz, dist, scale, fov, scale = nil
end

-- Main thread

Citizen.CreateThread(function()
	while ESX == nil do
		Citizen.Wait(10)
		TriggerEvent("esx:getSharedObject", function(obj)
			ESX = obj
		end)
	end
	Wait(1000)
	while not ESX.IsPlayerLoaded() do
		Citizen.Wait(10)
	end
	PlayerData = ESX.GetPlayerData()
	ESX.TriggerServerCallback("esx_realparking:getPlayerIdentifier", function(callback)
		PlayerIdentifier = callback
		Citizen.Wait(500)
	end)
end)

-- Check distance

Citizen.CreateThread(function()
	while PlayerIdentifier == nil do
		Citizen.Wait(10)
	end
	while true do
		Wait(100)
		local pl = GetEntityCoords(GetPlayerPed(-1))
		local inParking = false
		local crParking = nil
		for k, v in pairs(Config.ParkingLocations) do
			if GetDistanceBetweenCoords(pl.x, pl.y, pl.z, v.x, v.y, v.z, true) < v.size + 20.0 then
				inParking = true
				crParking = k
			end
		end
		if inParking then
			if not SpawnedVehicles then
				RemoveVehicles(GlobalVehicles)
				while DeletingEntities do
					Wait(100)
				end
				DebugLog("Player enter parking radius")
				TriggerServerEvent("esx_realparking:refreshVehicles", crParking)
				SpawnedVehicles = true
				Wait(2000)
			end
			CheckVehicleImpound()
			UpdateVehicleStatus()
		else
			if SpawnedVehicles then
				DebugLog("Player leave parking radius")
				RemoveVehicles(GlobalVehicles)
				SpawnedVehicles = false
			end
		end
		-- Clean memory
		pl, inParking, crParking = nil
	end
end)

-- Update vehicle coords

Citizen.CreateThread(function()
	while true do
		if #LocalVehicles ~= 0 then
			UpdateVehicleStatus()
		end
		collectgarbage("collect")
		Wait(1000)
	end
end)

-- Draw text thread

Citizen.CreateThread(function()
	while true do
		Wait(0)
		local fd = true
		local pl = GetEntityCoords(GetPlayerPed(-1))
		if fd then
			fd = false
			for k, v in pairs(Config.ParkingLocations) do
				if GetDistanceBetweenCoords(pl.x, pl.y, pl.z, v.enter.x, v.enter.y, v.enter.z, true) < 20 then
					Draw3DText(v.enter.x, v.enter.y, v.enter.z, v.name, 0, 0.2, 0.2)
					Draw3DText(v.enter.x, v.enter.y, v.enter.z - 0.5, string.format(_U("parking_fee", v.fee)), 0, 0.1, 0.1)
					fd = true
				end
			end
			for k, v in pairs(LocalVehicles) do
				if GetDistanceBetweenCoords(pl.x, pl.y, pl.z, v.data.location.x, v.data.location.y, v.data.location.z, true) < 3.0 then
					Draw3DText(v.data.location.x, v.data.location.y, v.data.location.z, string.format(_U("owner", v.name)), 0, 0.08, 0.08)
					Draw3DText(v.data.location.x, v.data.location.y, v.data.location.z - 0.2, string.format(_U("plate", v.plate)), 0, 0.05, 0.05)
					fd = true
				end
			end
		else
			Wait(100)
		end
		-- Clean memory
		pl = nil
	end
end)

-- Creating blips

Citizen.CreateThread(function()
	for k, v in pairs(Config.ParkingLocations) do
		local tempBlip = AddBlipForCoord(v.enter.x, v.enter.y, v.enter.z)
		SetBlipSprite(tempBlip, 523)
		SetBlipColour(tempBlip, 11)
		SetBlipAsShortRange(tempBlip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(v.name)
		EndTextCommandSetBlipName(tempBlip)
		-- Clean memory
		tempBlip = nil
	end
end)

-- Logic thread

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local pl        = GetEntityCoords(GetPlayerPed(-1))
		local inParking = false
		local parkName  = nil
		local parkData  = nil
		for k, v in pairs(Config.ParkingLocations) do
			if pl.x > v.x - v.size and pl.x < v.x + v.size and pl.y > v.y - v.size and pl.y < v.y + v.size and pl.z > v.z - v.height and pl.z < v.z + v.height then
			    inParking = true
				parkName  = k
				parkData  = v
			end
		end
		if inParking and IsPedInAnyVehicle(GetPlayerPed(-1)) then
			local storedVehicle = GetPedInStoredCar(GetPlayerPed(-1))
			if storedVehicle ~= false then
				DisplayHelpText(string.format(_U("need_parking_fee", storedVehicle.fee)))
			else
				if parkData.notify == nil or parkData.notify then
					DisplayHelpText(_U("press_to_save"))
				end
			end
			if IsControlJustReleased(0, Config.KeyToSave) then
				if storedVehicle ~= false then
					DoScreenFadeOut(250)
					Wait(500)
					ESX.TriggerServerCallback("esx_realparking:driveCar", function(callback)
						if callback.status then
							DeleteVehicle(storedVehicle.entity)
							DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1)))
							storedVehicle = nil
							Wait(500)
							DriveVehicle(callback.vehData)
							ESX.ShowNotification(callback.message)
						else
							ESX.ShowNotification(callback.message)
						end
						Wait(1000)
						DoScreenFadeIn(250)
						-- Clean memory
						storedVehicle = nil
					end, storedVehicle)
				else
					local veh = GetVehiclePedIsIn(GetPlayerPed(-1))
					if veh ~= 0 then
						local speed = GetEntitySpeed(veh)
						if speed > 0 then
							ESX.ShowNotification(_U("stop_the_car"))
						elseif IsThisModelACar(GetEntityModel(veh)) or IsThisModelABike(GetEntityModel(veh)) or IsThisModelABicycle(GetEntityModel(veh)) then
							local vehProps  = ESX.Game.GetVehicleProperties(veh)
							local vehPos    = GetEntityCoords(veh)
							local vehHead   = GetEntityHeading(veh)
							local engHealth = GetVehicleEngineHealth(veh)
							local bdyHealth = GetVehicleBodyHealth(veh)
							local tnkHealth = GetVehiclePetrolTankHealth(veh)
							LastPlate       = vehProps.plate
							DoScreenFadeOut(250)
							Wait(500)
							ESX.TriggerServerCallback("esx_realparking:saveCar", function(callback)
								if callback.status then
									DeleteVehicle(veh)
									ESX.ShowNotification(callback.message)
								else
									ESX.ShowNotification(callback.message)
								end
								Wait(1000)
								DoScreenFadeIn(250)
								-- Clean memory
								vehProps, vehPos, vehHead, engHealth, bdyHealth, tnkHealth = nil
							end, {
								location = {x = vehPos.x, y = vehPos.y, z = vehPos.z, h = vehHead},
								props    = vehProps,
								parking  = parkName,
								livery   = GetVehicleLivery(veh),
								health   = {
									engine = engHealth,
									body   = bdyHealth,
									tank   = tnkHealth
								}
							})
						else
							ESX.ShowNotification(_U("only_allow_car"))
						end
					end
					-- Clean memory
					veh = nil
				end
			end
		else
			Citizen.Wait(500)
		end
		-- Clean memory
		pl = nil
		parkName = nil
		parkData = nil
	end
end)
