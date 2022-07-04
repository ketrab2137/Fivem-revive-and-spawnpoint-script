local setspawnpoint
local isset=false

--Turning off autospawn while insuring the player loads

AddEventHandler('onClientMapStart', function()
	Citizen.Trace("wylaczanie autospawnu")
	exports.spawnmanager:spawnPlayer() 
	Citizen.Wait(2500)
	exports.spawnmanager:setAutoSpawn(false)
	Citizen.Trace("autospawn wylaczony")
end)

--Respawn

AddEventHandler("respawn", function()

    local spawnpoint

    if IsEntityDead(PlayerPedId()) == 1 and setspawnpoint == nil then       --if there isnt any spawnpoint set and player is dead respawn at the death location
        spawnpoint = GetEntityCoords(PlayerPedId())
        exports.spawnmanager:spawnPlayer({
            x = spawnpoint.x,
            y = spawnpoint.y,
            z = spawnpoint.z
        })
    elseif IsEntityDead(PlayerPedId()) == 1 and setspawnpoint ~= nil then       --if there isn a spawnpoint set respawn at that spawnpoint
        exports.spawnmanager:spawnPlayer({
            x = setspawnpoint.x,
            y = setspawnpoint.y,
            z = setspawnpoint.z
        })
    end
end)




--Registering commands

RegisterCommand("spawn",function() --Respawn command
TriggerEvent("respawn")
end)

RegisterCommand("spawnpoint",function()  --Set/clear spawnpoint command
    if isset == false then
        setspawnpoint = GetEntityCoords(PlayerPedId())
        TriggerEvent('chat:addMessage', {
            color = { 255, 0, 0},
            multiline = true,
            args = {"SPAWN","Spawnpoint created, type again to delete"}
          })
        isset = true
    else
        setspawnpoint = nil
        TriggerEvent('chat:addMessage', {
            color = { 255, 0, 0},
            multiline = true,
            args = {"SPAWN","Spawnpoint deleted"}
          })
        isset = false
    end


end)

--Events

AddEventHandler('baseevents:onPlayerDied', function()       -- A message asking to respawn
    TriggerEvent('chat:addMessage', {
        color = { 255, 0, 0},
        multiline = true,
        args = {"SPAWN","Press 'E' or type /spawn to respawn"}
      })
end)



--Registering a key to respawn

RegisterKeyMapping('spawn', 'Respawn', 'keyboard', 'E' )

