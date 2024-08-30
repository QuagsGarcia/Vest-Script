
VestTable = {}
VestEnabled = false
previousArmor = nil
RegisterNetEvent( "checkVest-Quags" )
AddEventHandler( "checkVest-Quags", function()
    local noVest = true
    for _, i in pairs(Config.Vests) do
        if i == tostring(GetPedDrawableVariation(GetPlayerPed(-1), 9)+1) then
            print(i)
            local checkForExistingData = false
            local VestArmorData = 0
            for k, l in pairs(VestTable) do
                if l.name == i then
                    VestArmorData = l.armor
                    checkForExistingData = true
                end
            end
            if checkForExistingData then
                SetPedArmour(GetPlayerPed(-1), VestArmorData)
            else
                table.insert(VestTable, {name=i, armor=100})
                SetPedArmour(GetPlayerPed(-1), 225)
            end
            noVest = false
        end
    end
    if noVest then
        VestEnabled = false
        SetPedArmour(GetPlayerPed(-1), 0)
    end
end)
local timer = 0
CreateThread(function()
    local prevVest = nil
    while true do
        Citizen.Wait(50)
        local vest = tostring(GetPedDrawableVariation(GetPlayerPed(-1), 9)+1)
        if IsEntityDead(GetPlayerPed(-1)) then
            VestTable = {}
        end
        if GetPlayerMaxArmour(PlayerId()) ~= 225 then
            SetPlayerMaxArmour(PlayerId(), 225)
            print("here")
        end
        if prevVest ~= vest then
            if prevVest ~= nil then
                for _, i in pairs(VestTable) do
                    if i.name == prevVest then
                        i.armor = GetPedArmour(GetPlayerPed(-1))
                    end
                end
            end
            prevVest = vest
            TriggerEvent("checkVest-Quags")
        end
        local health = 100
        if IsPedMale(GetPlayerPed(-1)) then
            health = 200
        end
        if IsPedStopped(GetPlayerPed(-1)) and GetEntityHealth(GetPlayerPed(-1)) < health and timer < GetGameTimer() and not IsEntityDead(GetPlayerPed(-1)) then
            SetEntityHealth(GetPlayerPed(-1), GetEntityHealth(GetPlayerPed(-1)) + 4)
            timer = GetGameTimer() + 1750
        end
    end
end)