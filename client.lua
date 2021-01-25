---{VARIAVEIS}
local holstered = true
local blocked = false
local playerData = {}


---{NÚCLEO}
Citizen.CreateThread(function()
    while true do
        local idle = 100
        if not IsPedInAnyVehicle(PlayerPedId(), false) then
            if GetPedDrawableVariation(PlayerPedId(),8) == 130 then
                if checkWeapon(PlayerPedId()) then
                    loadAnim()
                    if holstered then
                        idle = 1
                        blocked = true
                        blocking()
                        SetPedCurrentWeaponVisible(PlayerPedId(), false, true, true, true)
                        TaskPlayAnim(PlayerPedId(), "reaction@intimidation@cop@unarmed", "intro", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0)
                        Citizen.Wait(1700)
                        SetPedCurrentWeaponVisible(PlayerPedId(), true, true, true, true)
                        TaskPlayAnim(PlayerPedId(), "rcmjosh4", "josh_leadout_cop2", 8.0, 2.0, -1, 48, 10, 0, 0, 0 )
                        Citizen.Wait(400)
                        ClearPedTasks(PlayerPedId())
                        holstered = false
                        removeAnim()
                    else
                        blocked = false
                    end
                else
                    if not holstered then
                        TaskPlayAnim(PlayerPedId(), "rcmjosh4", "josh_leadout_cop2", 8.0, 2.0, -1, 48, 10, 0, 0, 0)
                        Citizen.Wait(500)
                        TaskPlayAnim(PlayerPedId(), "reaction@intimidation@cop@unarmed", "outro", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0)
                        Citizen.Wait(60)
                        ClearPedTasks(PlayerPedId())
                        holstered = true
                        removeAnim()
                    end
                end
            else
                if checkWeapon(PlayerPedId()) then
                    RequestAnimDict("reaction@intimidation@1h")
                    while not HasAnimDictLoaded("reaction@intimidation@1h") do
                        Wait(1)
                    end
                    if holstered then
                        blocked = true
                        SetPedCurrentWeaponVisible(PlayerPedId(), false, true, true , true)
                        TaskPlayAnim(PlayerPedId(), "reaction@intimidation@1h", "intro", 5.0, 1.0, -1, 50, 0, 0, 0, 0)
                        Citizen.Wait(1250)
                        SetPedCurrentWeaponVisible(PlayerPedId(), true, true, true, true)
                        Citizen.Wait(1700)
                        ClearPedTasks(PlayerPedId())
                        holstered = false
                        RemoveAnimDict("reaction@intimidation@1h")
                    else
                        blocked = false
                    end
                else
                    if not holstered then
                        TaskPlayAnim(PlayerPedId(), "reaction@intimidation@1h", "outro", 8.0, 3.0, -1, 50, 0, 0, 0.125, 0 )
                        Citizen.Wait(1700)
                        ClearPedTasks(PlayerPedId())
                        holstered = true
                        RemoveAnimDict("reaction@intimidation@1h")
                    end
                end
            end
        else
            holstered = true
        end
        Citizen.Wait(idle)
    end
end)





function blocking()
    Citizen.CreateThread(function()
        local block_thread = GetIdOfThisThread()
        while blocked do
            DisableControlAction(1, 25, true )
            DisableControlAction(1, 140, true)
            DisableControlAction(1, 141, true)
            DisableControlAction(1, 142, true)
            DisableControlAction(1, 23, true)
            DisablePlayerFiring(PlayerPedId(), true)
            Citizen.Wait(1)
        end
        TerminateThread(block_thread)
    end)
end

---{CARREGANDO ANIMAÇÕES}
function loadAnim()
    RequestAnimDict('rcmjosh4')
    RequestAnimDict('reaction@intimidation@cop@unarmed')
    RequestAnimSet('intro')
    RequestAnimSet('josh_leadout_cop2')
    RequestAnimSet('outro')
    while not HasAnimDictLoaded('rcmjosh4') and not HasAnimDictLoaded('reaction@intimidation@cop@unarmed') do
        Wait(1)
    end
end

---{REMOVENDO ANIMAÇÕES}
function removeAnim()
    RemoveAnimDict('rcmjosh4')
    RemoveAnimDict('reaction@intimidation@cop@unarmed')
    RemoveAnimSet('intro')
    RemoveAnimSet('josh_leadout_cop2')
    RemoveAnimSet('outro')
end

---{CHECANDO ARMAS}
function checkWeapon(ped)
	if not IsEntityDead(ped) then
		for i = 1, #Config.Weapons do
			if GetHashKey(Config.Weapons[i]) == GetSelectedPedWeapon(ped) then
				return true
			end
		end
    end
    return false
end