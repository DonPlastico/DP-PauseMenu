Framework = Config.Framework == "qb" and exports['qb-core']:GetCoreObject() or exports['es_extended']:getSharedObject()

function registerServerCallback(...)
	if Config.Framework == "qb" then
		Framework.Functions.CreateCallback(...)
	else
		Framework.RegisterServerCallback(...)
	end
end

RegisterNetEvent('DP-PauseMenu:dropPlayer', function(data)
    DropPlayer(source, "Disconnected")
end)

registerServerCallback("DP-PauseMenu:getPlayerData", function(src, cb)
    local xPlayer = Config.Framework == "esx" and Framework.GetPlayerFromId(src) or Framework.Functions.GetPlayer(src)
    playerId = src
    players = GetPlayers()
    playerCount = #players
    maxPlayers = GetConvarInt("sv_maxclients", 48)

    if Config.Framework == "esx" then
        bank = xPlayer.getAccount("bank").money
        name = xPlayer.getName()
        job = xPlayer.getJob().label
        grade = xPlayer.getJob().grade_label
    else
        bank = xPlayer.PlayerData.money.bank
        job = xPlayer.PlayerData.job.label
        name = xPlayer.PlayerData.charinfo.firstname.." "..xPlayer.PlayerData.charinfo.lastname
        grade = xPlayer.PlayerData.job.grade.name
    end

    cb({id = playerId, players = playerCount, maxPlayers = maxPlayers, bank = bank, name = name, job = job, grade = grade})
end)