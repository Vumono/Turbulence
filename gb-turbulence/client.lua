ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
    TriggerEvent('esx_license:getLicenses')
end)


Citizen.CreateThread(function()
while true do
    Citizen.Wait(1000)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local identifier = GetPlayerIdentifiers(source)
    local ped = GetPlayerPed(-1)
    local heli = GetVehiclePedIsIn(ped, false)
    local chance = math.random(1,100)
    local model = GetEntityModel(heli)
    if IsThisModelAHeli(model) then
        MySQL.Async.fetchAll('SELECT type FROM user_licenses WHERE identifier = @owner', {["@owner"] = xPlayer.identifier},
            function (licenses)
                if type ~= nil then
                    for i=1, #licenses, 1 do
                        if type == 'heli' and IsPedInAnyHeli(ped) then
                            if licenses[i].type == 'heli' then
                                SetHeliTurbulenceScalar(heli, 0.0)
                                SetHelicopterRollPitchYawMult(heli, 0.0)
                            end
                        else
                            SetHelicopterRollPitchYawMult(heli, 0.4)
                            SetHeliTurbulenceScalar(heli, 0.7)
                            SetVehicleGeneratesEngineShockingEvents(heli, CEventShockingHelicopterOverhead)
                            if chance then
                                SetVehicleEngineOn(heli, false, true, false)
                            end
                        end
                    end 
                end 
            end)
        end
    end
end)

Citizen.CreateThread(function()
while true do
    Citizen.Wait(1000)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local identifier = GetPlayerIdentifiers(source)
    local ped = GetPlayerPed(-1)
    local heli = GetVehiclePedIsIn(ped, false)
    local chance = math.random(1,100)
    local model = GetEntityModel(heli)
    if IsThisModelAPlane(model) then
        MySQL.Async.fetchAll('SELECT type FROM user_licenses WHERE identifier = @owner', {["@owner"] = xPlayer.identifier},
            function (licenses)
                if type ~= nil then
                    for i=1, #licenses, 1 do
                        if type == 'plane' and IsPedInAnyPlane(ped) then
                            if licenses[i].type == 'plane' then
                                SetPlaneTurbulenceMultiplier(heli, 0.0)
                            end
                        else
                            SetPlaneTurbulenceMultiplier(heli, 0.6)
                            SetVehicleGeneratesEngineShockingEvents(heli, CEventShockingHelicopterOverhead)
                            if chance then
                                SetVehicleEngineOn(heli, false, true, false)
                            end
                        end
                    end 
                end 
            end)
        end
    end
end)