function getVehicleInDirection(coordFrom, coordTo)
	local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed(-1), 0)
	local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
	return vehicle
end
function fsn_lookingAt()
	local targetVehicle = false

	local coordA = GetEntityCoords(GetPlayerPed(-1), 1)
	local coordB = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 20.0, -1.0)
	targetVehicle = getVehicleInDirection(coordA, coordB)

	return targetVehicle
end

function fsn_NearestPlayersC(x, y, z, radius)
	local players = {}
	for id = 0, 31 do
		local ppos = GetEntityCoords(GetPlayerPed(id))
		if GetDistanceBetweenCoords(ppos.x, ppos.y, ppos.z, x, y, z) < radius then
			table.insert(players, #players+1, id)
		end
	end
end

function fsn_NearestPlayersS(x, y, z, radius)
	local players = {}
	for id = 0, 32 do
		local ppos = GetEntityCoords(GetPlayerPed(id))
		if GetDistanceBetweenCoords(ppos.x, ppos.y, ppos.z, x, y, z) < radius then
			table.insert(players, #players+1, GetPlayerServerId(id))
		end
	end
	return players
end
-------------------------------------------------------------------------------------------------------------------------------------------------
-- CLOTHING COMMANDS
-------------------------------------------------------------------------------------------------------------------------------------------------
local mask = {
	id = 0,
	txt = 0,
	pal = 0
}
RegisterNetEvent('fsn_commands:clothing:mask')
AddEventHandler('fsn_commands:clothing:mask', function()
	if mask.id ~= 0 then
		SetPedComponentVariation(GetPlayerPed(-1), 1, mask.id, mask.txt, mask.pal)
		mask.id = 0
		mask.txt = 0
		mask.pal = 0
		---
		local pos = GetEntityCoords(GetPlayerPed(-1))
		local players = fsn_NearestPlayersS(pos.x, pos.y, pos.z, 10)
		TriggerServerEvent('fsn_commands:me', 'puts their mask on', players)
	else
		mask.id = GetPedDrawableVariation(GetPlayerPed(-1), 1)
		mask.txt = GetPedTextureVariation(GetPlayerPed(-1), 1)
		mask.pal = GetPedPaletteVariation(GetPlayerPed(-1), 1)
		SetPedComponentVariation(GetPlayerPed(-1), 1, 0, 0, 0)
		---
		local pos = GetEntityCoords(GetPlayerPed(-1))
		local players = fsn_NearestPlayersS(pos.x, pos.y, pos.z, 10)
		TriggerServerEvent('fsn_commands:me', 'takes their mask off', players)
	end
end)

local hat = {
	id = 0,
	txt = 0
}
RegisterNetEvent('fsn_commands:clothing:hat')
AddEventHandler('fsn_commands:clothing:hat', function()
	if hat.id ~= 0 then
		SetPedPropIndex(GetPlayerPed(-1), 0, hat.id, hat.txt, 0, true)
		hat.id = 0
		hat.txt = 0
		---
		local pos = GetEntityCoords(GetPlayerPed(-1))
		local players = fsn_NearestPlayersS(pos.x, pos.y, pos.z, 10)
		TriggerServerEvent('fsn_commands:me', 'puts their hat on', players)
	else
		hat.id = GetPedPropIndex(GetPlayerPed(-1), 0)
		hat.txt = GetPedPropTextureIndex(GetPlayerPed(-1), 0)
		SetPedPropIndex(GetPlayerPed(-1), 0, 8, 0, true)
		---
		local pos = GetEntityCoords(GetPlayerPed(-1))
		local players = fsn_NearestPlayersS(pos.x, pos.y, pos.z, 10)
		TriggerServerEvent('fsn_commands:me', 'takes their hat off', players)
	end
end)
-------------------------------------------------------------------------------------------------------------------------------------------------
-- SERVICE COMMANDS
-------------------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('fsn_commands:service:request')
AddEventHandler('fsn_commands:service:request', function(type)
	local tbl = {x = GetEntityCoords(GetPlayerPed(-1)).x, y = GetEntityCoords(GetPlayerPed(-1)).y, z = GetEntityCoords(GetPlayerPed(-1)).z}
	TriggerServerEvent('fsn_commands:service:sendrequest', type, tbl)
end)
-------------------------------------------------------------------------------------------------------------------------------------------------
-- MISC COMMANDS
-------------------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('fsn_commands:hc:takephone')
AddEventHandler('fsn_commands:hc:takephone', function()
	TriggerEvent('fsn_notify:displayNotification', 'Your phone has been taken!', 'centerRight', 8000, 'success')
	if exports.fsn_inventory:fsn_HasItem('phone') then
		TriggerEvent('fsn_inventory:item:take', 'phone', 1)
	end
end)
RegisterNetEvent('fsn_commands:getHDC')
AddEventHandler('fsn_commands:getHDC', function(hdc)
	handcuffcommand = hdc
end)
function fsn_getHDC()
	return handcuffcommand
end

AddEventHandler('fsn_main:character', function()
	TriggerServerEvent('fsn_commands:requestHDC')
end)

RegisterNetEvent('fsn_commands:dropweapon')
AddEventHandler('fsn_commands:dropweapon', function()
	if exports.fsn_ems:fsn_IsDead() then
			TriggerEvent('fsn_notify:displayNotification', 'Mate, you\'re downed, don\'t be so stupid.', 'centerLeft', 4000, 'error')
	else
		if GetSelectedPedWeapon(GetPlayerPed(-1)) ~= -1569615261 then
			RemoveWeaponFromPed(GetPlayerPed(-1), GetSelectedPedWeapon(GetPlayerPed(-1)))
			TriggerEvent('fsn_notify:displayNotification', 'Weapon dropped', 'centerLeft', 4000, 'success')
		else
			TriggerEvent('fsn_notify:displayNotification', 'You cannot drop your fists!!', 'centerLeft', 4000, 'error')
		end
	end
end)

RegisterNetEvent('fsn_commands:walk:set')
AddEventHandler('fsn_commands:walk:set', function(src, set)
	if src == GetPlayerServerId(PlayerId()) then
		ResetPedMovementClipset(GetPlayerPed(-1), 0.0)
		if set ~= 'reset' then
			SetPedMovementClipset(GetPlayerPed(-1), set, 0)
		end
	else
		ResetPedMovementClipset(GetPlayerPed(GetPlayerFromServerId(src)), 0.0)
		if set ~= 'reset' then
			SetPedMovementClipset(GetPlayerPed(GetPlayerFromServerId(src)), set, 0)
		end
	end
end)

RegisterNetEvent('fsn_commands:me')
AddEventHandler('fsn_commands:me', function(action)
	local pos = GetEntityCoords(GetPlayerPed(-1))
	local players = fsn_NearestPlayersS(pos.x, pos.y, pos.z, 10)
	TriggerServerEvent('fsn_commands:me', action, players)
end)

RegisterNetEvent('fsn_commands:sendxyz')
AddEventHandler('fsn_commands:sendxyz', function()
  local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
  TriggerServerEvent('fsn_commands:printxyz', x, y, z, GetEntityHeading(GetPlayerPed(-1)))
end)

-------------------------------------------------------------------------------------------------------------------------------------------------
-- DEV COMMANDS
-------------------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('fsn_commands:dev:spawnCar')
AddEventHandler('fsn_commands:dev:spawnCar', function(car)
  local myPed = GetPlayerPed(-1)
  local player = PlayerId()
  local vehicle = GetHashKey(car)
  RequestModel(vehicle)
  while not HasModelLoaded(vehicle) do
    Wait(1)
  end
  local coords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, 5.0, 0)
  local spawned_car = CreateVehicle(vehicle, coords, GetEntityHeading(myPed), true, true)
  SetVehicleOnGroundProperly(spawned_car)
  SetModelAsNoLongerNeeded(vehicle)
  Citizen.InvokeNative(0xB736A491E64A32CF,Citizen.PointerValueIntInitialized(spawned_car))
	TriggerEvent('fsn_cargarage:makeMine', spawned_car, GetDisplayNameFromVehicleModel(GetEntityModel(spawned_car)), GetVehicleNumberPlateText(spawned_car))
	TriggerEvent('fsn_notify:displayNotification', 'You now own this vehicle!', 'centerLeft', 4000, 'success')
	TriggerEvent('fsn_notify:displayNotification', 'You spawned '..car, 'centerLeft', 2000, 'info')
end)

RegisterNetEvent('fsn_commands:dev:weapon')
AddEventHandler('fsn_commands:dev:weapon', function(wep)
	GiveWeaponToPed(GetPlayerPed(-1), GetHashKey(wep), GetMaxAmmo(GetPlayerPed(-1), GetHashKey(wep), 250))
	SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey(wep), true)
end)

RegisterNetEvent('fsn_commands:dev:fix')
AddEventHandler('fsn_commands:dev:fix', function()
	if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
		local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
		SetVehicleEngineHealth(vehicle, 1000)
		SetVehicleEngineOn( vehicle, true, true )
		SetVehicleFixed(vehicle)
		SetVehicleDirtLevel(vehicle, 0)
	end
end)

-------------------------------------------------------------------------------------------------------------------------------------------------
-- POLICE COMMANDS
-------------------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('fsn_commands:police:livery')
AddEventHandler('fsn_commands:police:livery', function(num)
	if IsPedInAnyVehicle(GetPlayerPed(-1)) then
		SetVehicleLivery(GetVehiclePedIsIn(GetPlayerPed(-1), false), num)
	end
end)

RegisterNetEvent('fsn_commands:police:extras')
AddEventHandler('fsn_commands:police:extras', function()
	if IsPedInAnyVehicle(GetPlayerPed(-1)) then
		local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
		local a = 0
		TriggerEvent('chatMessage', 'FSN', {255,0,0}, '-----------------------------------------')
		repeat
			a = a + 1
			if DoesExtraExist(veh, a) then
				if IsVehicleExtraTurnedOn(veh, a) then
					TriggerEvent('chatMessage', 'FSN', {255,0,0}, 'Extra ID: '..a..' Toggle: true')
				else
						TriggerEvent('chatMessage', 'FSN', {255,0,0}, 'Extra ID: '..a..' Toggle: false')
				end
			end
    until( a > 25 )
		TriggerEvent('chatMessage', 'FSN', {255,0,0}, '-----------------------------------------')
	end
end)

RegisterNetEvent('fsn_commands:police:extra')
AddEventHandler('fsn_commands:police:extra', function(num)
	if IsPedInAnyVehicle(GetPlayerPed(-1)) then
		if num == 'all' then
			local a = 0
			repeat
				a = a + 1
				if IsVehicleExtraTurnedOn(GetVehiclePedIsIn(GetPlayerPed(-1), false), a) then
					SetVehicleExtra(GetVehiclePedIsIn(GetPlayerPed(-1), false), a, 1)
				else
					SetVehicleExtra(GetVehiclePedIsIn(GetPlayerPed(-1), false), a, 0)
				end
	    until( a > 25 )
		else
			if IsVehicleExtraTurnedOn(GetVehiclePedIsIn(GetPlayerPed(-1), false), tonumber(num)) then
				SetVehicleExtra(GetVehiclePedIsIn(GetPlayerPed(-1), false), tonumber(num), 1)
				TriggerEvent('fsn_notify:displayNotification', 'Setting '..num..' to <b>OFF', 'centerLeft', 4000, 'success')
			else
				SetVehicleExtra(GetVehiclePedIsIn(GetPlayerPed(-1), false), tonumber(num), 0)
				TriggerEvent('fsn_notify:displayNotification', 'Setting '..num..' to <b>ON', 'centerLeft', 4000, 'success')
			end
		end
	end
end)

RegisterNetEvent('fsn_commands:police:car')
AddEventHandler('fsn_commands:police:car', function(car)
  local myPed = GetPlayerPed(-1)
  local player = PlayerId()
  local vehicle = GetHashKey(car)
  RequestModel(vehicle)
  while not HasModelLoaded(vehicle) do
    Wait(1)
  end
  local coords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, 5.0, 0)
  local spawned_car = CreateVehicle(vehicle, coords, GetEntityHeading(myPed), true, true)
  SetVehicleOnGroundProperly(spawned_car)
  SetModelAsNoLongerNeeded(vehicle)
  Citizen.InvokeNative(0xB736A491E64A32CF,Citizen.PointerValueIntInitialized(spawned_car))
	TriggerEvent('fsn_cargarage:makeMine', spawned_car, GetDisplayNameFromVehicleModel(GetEntityModel(spawned_car)), GetVehicleNumberPlateText(spawned_car))
  TriggerEvent('fsn_notify:displayNotification', 'You spawned '..car, 'centerLeft', 2000, 'info')
	TriggerEvent('fsn_notify:displayNotification', 'You now own this vehicle!', 'centerLeft', 4000, 'success')
end)

RegisterNetEvent('fsn_commands:police:fix')
AddEventHandler('fsn_commands:police:fix', function()
	if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
		local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
		FreezeEntityPosition(vehicle, true)
		SetVehicleEngineHealth(vehicle, 1000)
		SetVehicleEngineOn( vehicle, true, true )
		SetVehicleFixed(vehicle)
		SetVehicleDirtLevel(vehicle, 0)
		TriggerEvent('fsn_notify:displayNotification', 'Fabio came to fix & clean your car!', 'centerLeft', 2000, 'info')
		FreezeEntityPosition(vehicle, false)
	else
		TriggerClientEvent('chatMessage', ':FSN:', {255,0,0}, 'You aren\'t in a car!')
	end
end)

DecorRegister("fsn_police:car:booted")
RegisterNetEvent('fsn_commands:police:boot')
AddEventHandler('fsn_commands:police:boot', function()
	if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
    local car = GetVehiclePedIsIn(GetPlayerPed(-1))
		TriggerEvent('fsn_notify:displayNotification', '<b>You <span style="color:#4abf52">added</span> a boot to this car', 'centerLeft', 3000, 'info')
		TriggerServerEvent('fsn_commands:police:booted', GetVehicleNumberPlateText(car), GetEntityModel(car))
  else
    local car = fsn_lookingAt()
		TriggerEvent('fsn_notify:displayNotification', '<b>You <span style="color:#4abf52">added</span> a boot to this car', 'centerLeft', 3000, 'info')
		TriggerServerEvent('fsn_commands:police:booted', GetVehicleNumberPlateText(car), GetEntityModel(car))
  end
end)

RegisterNetEvent('fsn_police:runplate:target')
AddEventHandler('fsn_police:runplate:target', function()
	local car = fsn_lookingAt()
	local plater = GetVehicleNumberPlateText(car)
	TriggerServerEvent('fsn_police:runplate::target', plater)
end)

RegisterNetEvent('fsn_commands:police:unboot')
AddEventHandler('fsn_commands:police:unboot', function()
	if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
    local car = GetVehiclePedIsIn(GetPlayerPed(-1))
		TriggerEvent('fsn_notify:displayNotification', '<b>You <span style="color:#bf4d4a">removed</span> a boot from this car', 'centerLeft', 3000, 'info')
		TriggerServerEvent('fsn_commands:police:unbooted', GetVehicleNumberPlateText(car), GetEntityModel(car))
  else
    local car = fsn_lookingAt()
		TriggerEvent('fsn_notify:displayNotification', '<b>You <span style="color:#bf4d4a">removed</span> a boot from this car', 'centerLeft', 3000, 'info')
		TriggerServerEvent('fsn_commands:police:unbooted', GetVehicleNumberPlateText(car), GetEntityModel(car))
  end
end)

local booted_cars = {}
RegisterNetEvent('fsn_commands:police:updateBoot')
AddEventHandler('fsn_commands:police:updateBoot', function(plate, mdl, toggle)
	if toggle then
		if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
			local car = GetVehiclePedIsIn(GetPlayerPed(-1), false)
			if plate == GetVehicleNumberPlateText(car) and mdl == GetEntityModel(car) then
				FreezeEntityPosition(car, true)
				TriggerEvent('fsn_notify:displayNotification', 'This car has been <b style="color:red">BOOTED', 'centerLeft', 3000, 'error')
			end
		end
		table.insert(booted_cars, #booted_cars+1, {plate=plate, mdl=mdl, status=toggle})
		TriggerEvent('fsn_notify:displayNotification', plate..' with '..mdl..' has been booted', 'centerLeft', 3000, 'info')
	else
		if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
			local car = GetVehiclePedIsIn(GetPlayerPed(-1), false)
			if plate == GetVehicleNumberPlateText(car) and mdl == GetEntityModel(car) then
				FreezeEntityPosition(car, false)
				TriggerEvent('fsn_notify:displayNotification', 'This car has been <b style="color:green">UNBOOTED', 'centerLeft', 3000, 'error')
			end
		end
		for k, v in pairs(booted_cars) do
			if v.plate == plate and v.mdl == mdl then
				table.remove(booted_cars,k)
			end
		end
		TriggerEvent('fsn_notify:displayNotification', plate..' with '..mdl..' has been unbooted', 'centerLeft', 3000, 'info')
	end
end)

local boot_test = false
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
			local car = GetVehiclePedIsIn(GetPlayerPed(-1), false)
			for k, v in pairs(booted_cars) do
				if v.plate == GetVehicleNumberPlateText(car) and v.mdl == GetEntityModel(car) then
					if not boot_test then
						FreezeEntityPosition(car, true)
						TriggerEvent('fsn_notify:displayNotification', 'This car has been <b style="color:red">BOOTED', 'centerLeft', 3000, 'error')
						boot_test = true
					end
				end
			end
			if not boot_test then
				FreezeEntityPosition(car, false)
				boot_test = true
			end
		else
			boot_test = false
		end
	end
end)

RegisterNetEvent('fsn_commands:police:impound')
AddEventHandler('fsn_commands:police:impound', function()
  if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
    local car = GetVehiclePedIsIn(GetPlayerPed(-1))
    SetEntityAsMissionEntity( car, true, true )
    Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( car ) )
  else
    local car = fsn_lookingAt()
    SetEntityAsMissionEntity( car, true, true )
    Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( car ) )
  end
end)

RegisterNetEvent('fsn_commands:police:impound2')
AddEventHandler('fsn_commands:police:impound2', function()
  if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
    local car = GetVehiclePedIsIn(GetPlayerPed(-1))
		TriggerServerEvent('fsn_cargarage:impound', GetVehicleNumberPlateText(car))
    SetEntityAsMissionEntity( car, true, true )
    Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( car ) )
  else
    local car = fsn_lookingAt()
		TriggerServerEvent('fsn_cargarage:impound', GetVehicleNumberPlateText(car))
    SetEntityAsMissionEntity( car, true, true )
    Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( car ) )
  end
end)
