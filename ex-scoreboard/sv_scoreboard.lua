local QBCore = exports['qb-core']:GetCoreObject() 

local ST = ST or {}
ST.Scoreboard = {}
ST._Scoreboard = {}
ST._Scoreboard.PlayersS = {}
ST._Scoreboard.RecentS = {}


QBCore.Functions.CreateCallback('shitidk', function(source, cb)
    local group = QBCore.Functions.GetPermission(source)
    cb(group)
end)

if Config.SteamHex then
RegisterServerEvent('st-scoreboard:AddPlayer')
AddEventHandler("st-scoreboard:AddPlayer", function()

    local identifiers, steamIdentifier = GetPlayerIdentifiers(source)
    for _, v in pairs(identifiers) do
        if string.find(v, "steam") then
            steamIdentifier = v
            break
        end
    end

    local stid = HexIdToSteamId(steamIdentifier)
    local ply = GetPlayerName(source)
    local scomid = steamIdentifier:gsub("steam:", "")
    local ply2 = QBCore.Functions.GetPlayer(source)
    local citizenid = ply2.PlayerData.citizenid
    local data = { src = source, steamid = stid, cid = citizenid, comid = scomid, name = ply }

    TriggerClientEvent("st-scoreboard:AddPlayer", -1, data )
    ST.Scoreboard.AddAllPlayers()
end)
end

if Config.SteamHex then
function ST.Scoreboard.AddAllPlayers(self)
    local xPlayers   = QBCore.Functions.GetPlayers()

    for i=1, #xPlayers, 1 do
        
        local identifiers, steamIdentifier = GetPlayerIdentifiers(xPlayers[i])
        for _, v in pairs(identifiers) do
            if string.find(v, Config.Identifier) then
                steamIdentifier = v
                break
            end
        end

        local stid = HexIdToSteamId(steamIdentifier)
        local ply = GetPlayerName(xPlayers[i])
        local scomid = steamIdentifier:gsub("steam:", "")
        local ply2 = QBCore.Functions.GetPlayer(source)
        local citizenid = ply2.PlayerData.citizenid
        local data = { src = xPlayers[i], steamid = stid, cid = citizenid, comid = scomid, name = ply }

        TriggerClientEvent("st-scoreboard:AddAllPlayers", source, data, recentData)

    end
end
end

if not Config.SteamHex then
function ST.Scoreboard.AddAllPlayers(self)
    local xPlayers   = QBCore.Functions.GetPlayers()

    for i=1, #xPlayers, 1 do
        
        local identifiers, steamIdentifier = GetPlayerIdentifiers(xPlayers[i])
        for _, v in pairs(identifiers) do
            if string.find(v, "license") then
                steamIdentifier = v
                break
            end
        end

        local stid = HexIdToSteamId(steamIdentifier)
        local ply = GetPlayerName(xPlayers[i])
        local scomid = steamIdentifier:gsub("license:", "")
        local ply2 = QBCore.Functions.GetPlayer(source)
        local citizenid = ply2.PlayerData.citizenid
        local data = { src = xPlayers[i], name = ply, cid = citizenid, lcomid = scomid }

        TriggerClientEvent("st-scoreboard:AddAllPlayers", source, data, recentData)

    end
end
end

if not Config.SteamHex then
    RegisterServerEvent('st-scoreboard:AddPlayer')
    AddEventHandler("st-scoreboard:AddPlayer", function()
    
        local identifiers, steamIdentifier = GetPlayerIdentifiers(source)
        for _, v in pairs(identifiers) do
            if string.find(v, "license") then
                steamIdentifier = v
                break
            end
        end
    
        -- local stid = "test"
        local ply = GetPlayerName(source)
        local scomid = steamIdentifier:gsub("license:", "")
        local ply2 = QBCore.Functions.GetPlayer(source)
        local citizenid = ply2.PlayerData.citizenid
        local data = { src = source, cid = citizenid, lcomid = scomid, name = ply }
    
        TriggerClientEvent("st-scoreboard:AddPlayer", -1, data )
        ST.Scoreboard.AddAllPlayers()
    end)
    end

function ST.Scoreboard.AddPlayerS(self, data)
    ST._Scoreboard.PlayersS[data.src] = data
end

AddEventHandler("playerDropped", function()
	local identifiers, steamIdentifier = GetPlayerIdentifiers(source)
    for _, v in pairs(identifiers) do
        if string.find(v, "steam") then
            steamIdentifier = v
            break
        end
    end

    local stid = HexIdToSteamId(steamIdentifier)
    local ply = GetPlayerName(source)
    local scomid = steamIdentifier:gsub("steam:", "")
    local ply2 = QBCore.Functions.GetPlayer(source)
    local citizenid = ply2.PlayerData.citizenid
    local plyid = source
    local data = { src = source, steamid = stid, cid = citizenid, comid = scomid, name = ply }

    TriggerClientEvent("st-scoreboard:RemovePlayer", -1, data )
    Wait(600000)
    TriggerClientEvent("st-scoreboard:RemoveRecent", -1, plyid)
end)

--[[ function ST.Scoreboard.RemovePlayerS(self, data)
    ST._Scoreboard.RecentS = data
end

function ST.Scoreboard.RemoveRecentS(self, src)
    ST._Scoreboard.RecentS.src = nil
end ]]

function HexIdToSteamId(hexId)
    local cid = math.floor(tonumber(string.sub(hexId, 7), 16))
	local steam64 = math.floor(tonumber(string.sub( cid, 2)))
	local a = steam64 % 2 == 0 and 0 or 1
	local b = math.floor(math.abs(6561197960265728 - steam64 - a) / 2)
	local sid = "STEAM_0:"..a..":"..(a == 1 and b -1 or b)
    return sid
end
