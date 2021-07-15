ESX                             = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) 
			ESX = obj 
		end)
		Citizen.Wait(0)
	end
end)

local oldveh = nil
local turbulence = 0.7
local roll = 0.4

local failureChance = 5 --in %

local license = {
	plane = 'plane',
	heli = 'heli'
}

local inAircraft = false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		local ped = GetPlayerPed(-1)
		if IsPedInAnyVehicle(ped, false) then
			local veh = GetVehiclePedIsIn(ped, false)
			if oldveh == nil or veh ~= oldveh then
				oldveh = veh
				if IsPedInAnyHeli(ped) then
					inAircraft = true
					ESX.TriggerServerCallback('esx_license:checkLicense', function(hasLicense)
						if hasLicense then
							SetHeliTurbulenceScalar(veh, 0.0)
							SetHelicopterRollPitchYawMult(veh, 0.0)
						else
							SetHelicopterRollPitchYawMult(veh, turbulence)
							SetHeliTurbulenceScalar(veh, roll)
							--SetVehicleGeneratesEngineShockingEvents(veh, CEventShockingHelicopterOverhead) --param not a string thus undefined
						end
					end, GetPlayerServerId(ped), license.heli)
				elseif IsPedInAnyPlane(ped) then
					inAircraft = true
					ESX.TriggerServerCallback('esx_license:checkLicense', function(hasLicense)
						if hasLicense then
							SetPlaneTurbulenceMultiplier(veh, 0.0)
						else
							SetPlaneTurbulenceMultiplier(veh, turbulence)
							--SetVehicleGeneratesEngineShockingEvents(veh, CEventShockingHelicopterOverhead) --param not a string thus undefined
						end
					end, GetPlayerServerId(ped), license.plane)
				else
					inAircraft = false
				end
			end
			if inAircraft then
				local chance = math.random(100)
				if chance >= failureChance then
					SetVehicleEngineOn(veh, false, true, false)
				end
			end
		else
			inAircraft = false
		end
	end
end)
