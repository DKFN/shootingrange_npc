local debug = false
local serverWeaponData = nil
local weaponsShort
local shootingRangeNPC
local maxStats = {}
local playerBorrowedWeapons = {}
local bounds = {
    low_right = {205235.0, 194388.0, 1358.0},
    up_right = {205242.0, 193139.0, 1358.0}
}

local SHOOTING_RANGE_TRESSPASS_GUARD_TICK = 100

local function getMaxValue(col, value)
    return _.reduce(col, function(a,b)
        if a[value] < b[value] then
            return b
        else
            return a
        end
    end)[value]
end

AddEvent("OnPackageStart", function()
    shootingRangeNPC = CreateNPC(204977.0, 193591.0, 1358.0, 90)
    CreateText3D("Moniteur de tir Sportif", 12, 204977.0, 193591.0, 1358.0 + 130, 0, 0, 0)
    
    local file = io.open('weapons.json', 'r')
    if not file then
        print("Cannot read Weapons.json")
    else
        serverWeaponData = json.parse(file:read("*a"))
        serverWeaponData.weapons = _.map(serverWeaponData.weapons, function(weapon, k)
            return _.assign(weapon, {model = k + 2, id = k})
        end)
    end
    file.close()

    -- TODO
    maxStats = {
        RateOfFire = getMaxValue(serverWeaponData.weapons, 'RateOfFire'),
        Range = getMaxValue(serverWeaponData.weapons, 'Range'),
        MagazineSize = getMaxValue(serverWeaponData.weapons, 'MagazineSize')
    }

    weaponsShort = _.filter(
        _.map(serverWeaponData.weapons, function(weapon, k)
            return {
                n = weapon.Name,
                id = k
            }
        end),
        function(weapon)
            return weapon.id ~= 1
        end)

    _.print(serverWeaponData)
    _.print(weaponsShort)
    _.print(maxStats)
    print("Shooting range NPC has precalculated these values on launch")
    -- SetNPCClothingPreset
end)

local function CheckPlayerInRange(playerid)
    local px, py, pz = GetPlayerLocation(playerid)
    local distance = GetDistance3D(px, py, pz, 204977.0, 193591.0, 1358.0)
    if distance < 200.0 then
        return true
    end
    return false
end

AddRemoteEvent("AskShootingRangeData", function(playerid)
    if CheckPlayerInRange(playerid) then
        CallRemoteEvent(playerid, "ReceiveShootingRangeData" , json.stringify(weaponsShort))
        
    else
        print("Player tried to enter shooting range but is not in range "..playerid)
    end
end)

AddRemoteEvent("AskWeaponDetails", function(playerid, weaponId)
    -- _.print(serverWeaponData.weapons[weaponId])
    CallRemoteEvent(playerid, "ReceiveWeaponMax", json.stringify(maxStats))
    CallRemoteEvent(playerid, "ReceiveWeaponDetails", json.stringify(serverWeaponData.weapons[weaponId]))
end)

AddRemoteEvent("PlayerAskTryWeapon", function(playerid, weaponId)
    local playerEquippedWeapon = GetPlayerWeapon(playerid, 1)
    if playerEquippedWeapon == 1 or _.find(playerBorrowedWeapons, function(pid) return pid == playerid end) ~= nil then
        if CheckPlayerInRange(playerid) then
            _.push(playerBorrowedWeapons, playerid)
            SetPlayerWeapon(playerid, weaponId, 200, true, 1, true)
        else
            AddPlayerChat(playerid, "Vous etes trop loin du NPC pour prendre une arme")
        end
        CallRemoteEvent(playerid, "CloseShootingRangeUI")
    else
        AddPlayerChat(playerid, "Vous avez deja une arme en main")
    end
end)

AddEvent("OnPlayerJoin", function(player)
    SetPlayerRespawnTime(player, 5000)
    CallRemoteEvent(player, "NotifyShootingRangeNPCId", shootingRangeNPC)

    Delay(5000, function()
        if debug then
            SetPlayerSpawnLocation(player, 204964.0, 193999.0, 1358.0, 0)
            SetPlayerHealth(player, 0)
        end
    end)
end)

local function unregisterBorrow(playerId)
    EquipPlayerWeaponSlot(playerId, 2)
    SetPlayerWeapon(playerId, 1, 0, true, 1, true)
    -- TODO: Filter only when client acknoledges not being in possession of weapon anymore
    playerBorrowedWeapons = _.filter(playerBorrowedWeapons, function(p) return p ~= playerId end)
    EquipPlayerWeaponSlot(playerId, 1)
end
-- Le timer regarde si un joueur est hors de la zone de test
CreateTimer(function()
    for k, v in ipairs(playerBorrowedWeapons) do
        local px, py, pz = GetPlayerLocation(v)
        
        -- Fix Player can tresspass bounds while reloading or aiming
        if py > bounds.low_right[2] or py < bounds.up_right[2] or px > bounds.low_right[1] then
            -- print("Disarm player")
            AddPlayerChat(v, "Vous etes sorti de la zone de tir autorisée")
            if not IsPlayerAiming(v) and not IsPlayerReloading(v) then
                unregisterBorrow(v)
            else
                -- Evite que le joueur s'enfuis avec une arme gratuite
                SetPlayerLocation(v, 204971.0, 194063.0, 1358.0)
            end
        end
    end
end, SHOOTING_RANGE_TRESSPASS_GUARD_TICK)