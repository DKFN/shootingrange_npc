local shootingRangeNPCID = nil
local menuGui = nil

local function makeMenuGUI()
    menuGui = CreateWebUI(0, 0, 0, 0, 1, 60)
	LoadWebFile(menuGui, "http://asset/shootingrange_npc/gui/build/index.html")
	SetWebAlignment(menuGui, 0.0, 0.0)
	SetWebAnchors(menuGui, 0.0, 0.0, 1.0, 1.0)
    SetWebVisibility(menuGui, WEB_VISIBLE)
    SetInputMode(INPUT_GAMEANDUI)
end

local function destroyUI()
    SetInputMode(INPUT_GAME)
    DestroyWebUI(menuGui)
    menuGui = nil
end

AddEvent("OnKeyPress", function(key)
    --AddPlayerChat(key)
    
    if key == "E" and shootingRangeNPCID ~= nil and not menuGui then
        local px, py, pz = GetPlayerLocation()
        for k,v in ipairs(GetStreamedNPC()) do
            if v == shootingRangeNPCID then
                local nx, ny, nz = GetNPCLocation(v)
                local distance = GetDistance3D(px, py, pz, nx, ny, nz)
                if distance < 200 then                
                    AddPlayerChat("NPC is in range")
                    makeMenuGUI()
                end
            end
        end     
    end
    if (key == "Escape" or key == "F4") and menuGui then
        destroyUI()
    end
end)

AddRemoteEvent("NotifyShootingRangeNPCId", function(npcID)
    shootingRangeNPCID = npcID
end)

AddRemoteEvent("ReceiveShootingRangeData", function(data)
    -- AddPlayerChat(data)
    local fullWeapons = _.map(json.parse(data), function(weapon)
        local u, type = GetWeaponType(weapon.id)
        --AddPlayerChat("Nom : "..weapon.n.." Type : "..type)
        return {
            id = weapon.id,
            type = type,
            name = weapon.n,
            model = weapon.id + 2
        }
    end)
    --AddPlayerChat(_.str(fullWeapons))
    ExecuteWebJS(menuGui, "SetWeaponData('"..json.stringify(fullWeapons).."')")
end)

AddEvent("OnWebLoadComplete", function(web)
    if web == menuGui then
        CallRemoteEvent("AskShootingRangeData")
    end
end)

AddEvent("AskWeaponDetails", function(weaponId)
    CallRemoteEvent("AskWeaponDetails", math.floor(weaponId))
end)

AddEvent("AskTryWeapon", function(weaponId)
    CallRemoteEvent("PlayerAskTryWeapon", math.floor(weaponId))
end)

AddRemoteEvent("CloseShootingRangeUI", function()
    destroyUI()
end)

AddRemoteEvent("ReceiveWeaponDetails", function(weaponData)
    ExecuteWebJS(menuGui, "SetWeaponDetails('"..weaponData.."')")
end)

AddRemoteEvent("ReceiveWeaponMax", function(data)
    ExecuteWebJS(menuGui, "SetWeaponMax('"..data.."')")
end)


AddEvent("OnScriptError", function(message)
    AddPlayerChat(message)
end)

AddEvent("OnNPCStreamIn", function(npc, player)
    if npc == shootingRangeNPCID then
        SetNPCClothingPreset(shootingRangeNPCID, 26)
    end
end)

