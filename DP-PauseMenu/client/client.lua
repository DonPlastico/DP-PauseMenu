local Framework = Config.Framework == "qb" and exports['qb-core']:GetCoreObject() or exports['es_extended']:getSharedObject()
local open = false
local cam

RegisterNUICallback("loaded", function(_, cb)
    cb(Config.Tabs)
end)

RegisterNUICallback("event", function(eType)
    if eType == "close" then
        TriggerServerEvent("DP-PauseMenu:dropPlayer")
    elseif eType == "settings" then
        ActivateFrontendMenu(GetHashKey('FE_MENU_VERSION_LANDING_MENU'),1,-1) 
        SetNuiFocus(false, false)
    elseif eType == "map" then
        CreateThread(function()
            ActivateFrontendMenu(GetHashKey('FE_MENU_VERSION_MP_PAUSE'), 0, -1)
            Wait(100)
            PauseMenuceptionGoDeeper(0)
            while true do
                Wait(10)
                if IsControlJustPressed(0, 200) then
                    SetFrontendActive(0)
                    Wait(10)
                    break
                end
            end
        end)
        SetNuiFocus(false, false)
    elseif eType == "resume" then
        SetNuiFocus(false, false)
    end

    local playerPed = PlayerPedId()
    open = false
    FreezeEntityPosition(playerPed, false)
    DestroyCam(cam, false)
    DisplayRadar(true)
    RenderScriptCams(false, false, 0, false, false)
end)

RegisterCommand('OpenPauseMenu', function()
    if GetCurrentFrontendMenuVersion() == -1 and not IsNuiFocused() then
        open = true
        OpenPauseMenu()
    end
end)

RegisterKeyMapping('OpenPauseMenu', 'Open Pause Menu', 'keyboard', 'ESCAPE')

CreateThread(function()
    while true do 
        if open then
            SetPauseMenuActive(false)
        end

        Wait(1)
    end
end)

function triggerServerCallback(...)
	if Config.Framework == "qb" then
		Framework.Functions.TriggerCallback(...)
	else
		Framework.TriggerServerCallback(...)
	end
end

function OpenPauseMenu()
    triggerServerCallback("DP-PauseMenu:getPlayerData", function(cb)
        SetNuiFocus(true, true)

        SendNUIMessage({
            action = "setData",
            id = cb?.id,
            players = cb?.players,
            maxPlayers = cb?.maxPlayers,
            bank = cb?.bank,
            name = cb?.name,
            job = cb?.job,
            grade = cb?.grade,
        })
    end)
end