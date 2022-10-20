local fixingvehicle, justUsed, retardCounter, lastCounter, HeadBone, IsDead, binoculars = false, false, 0, 0, 0x796e, false, false
local isdrunk = false
local drunkLevel = 0
local overdoseC = 0
local isFueling = false

local canOpenInventory = true

local DriftHandlings = {}

CreateThread(function()
    while true do

        if overdoseC < 0 then
            overdoseC = 0
        end

        if overdoseC >= 500 then
            SetPedToRagdoll(PlayerPedId(), 5000, 5000, 0, 0, 0, 0)
            DoScreenFadeOut(1000)
            Wait(math.random(1500, 3000))
            DoScreenFadeIn(math.random(500, 1000))
            SetEntityHealth(PlayerPedId(), 0)
            overdoseC = 0
            Normal()
        end

        if drunkLevel >= 37 then
            isdrunk = true
            local playerPed = PlayerPedId()
            SetTimecycleModifier("spectator5")
            RequestAnimSet("move_m@drunk@verydrunk")
            while not HasAnimSetLoaded("move_m@drunk@verydrunk") do Wait(0) end
            SetPedMovementClipset(playerPed, "move_m@drunk@verydrunk", true)
            TriggerEvent('saveWalk', "move_m@drunk@verydrunk")
            if math.random(100) >= 90 then
                TriggerServerEvent('erp-status:applyStatus', 'Breath smells like Alcohol')
            end
            if math.random(100) >= 90 then
                TriggerServerEvent('erp-status:applyStatus', 'Uncoordinated')
            end

            if (not IsPedArmed(PlayerPedId(), 4)) and (GetVehiclePedIsIn(plyPed, false) == 0) then
                SetCamEffect(1)
                Wait(math.random(6000, 8000))
                if math.random(1, 3) == math.random(1, 3) then
                    ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.06)
                    SetPedToRagdoll(PlayerPedId(), 5511, 5511, 0, 0, 0, 0)
                end
                Wait(math.random(6000, 8000))
                SetCamEffect(0)
            end

        elseif drunkLevel >= 25 then
            isdrunk = true
            local playerPed = PlayerPedId()
            SetTimecycleModifier("spectator5")
            SetPedIsDrunk(playerPed, true)
            RequestAnimSet("move_m@drunk@moderatedrunk")
            while not HasAnimSetLoaded("move_m@drunk@moderatedrunk") do Wait(0) end
            SetPedMovementClipset(playerPed, "move_m@drunk@moderatedrunk", true)
            TriggerEvent('saveWalk', "move_m@drunk@moderatedrunk")
            if math.random(100) >= 95 then
                TriggerServerEvent('erp-status:applyStatus', 'Breath smells like Alcohol')
            end
            if math.random(100) >= 95 then
                TriggerServerEvent('erp-status:applyStatus', 'Uncoordinated')
            end
            if (not IsPedArmed(PlayerPedId(), 4)) and (GetVehiclePedIsIn(plyPed, false) == 0) then
                SetCamEffect(1)
                Wait(math.random(4000, 6000))
                if math.random(1, 3) == math.random(1, 3) then
                    ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.04)
                    SetPedToRagdoll(PlayerPedId(), 5511, 5511, 0, 0, 0, 0)
                end
                Wait(math.random(4000, 6000))
                SetCamEffect(0)
            end
        elseif drunkLevel >= 10 then
            local playerPed = PlayerPedId()
            if isdrunk then
                ClearTimecycleModifier()
                ResetScenarioTypesEnabled()
                SetPedIsDrunk(playerPed, false)
            end
            isdrunk = true
            SetPedMotionBlur(playerPed, true)
            RequestAnimSet("move_m@drunk@slightlydrunk")
            while not HasAnimSetLoaded("move_m@drunk@slightlydrunk") do Wait(0) end
            SetPedMovementClipset(playerPed, "move_m@drunk@slightlydrunk", true)
            TriggerEvent('saveWalk', "move_m@drunk@slightlydrunk")
            if math.random(100) >= 97 then
                TriggerServerEvent('erp-status:applyStatus', 'Uncoordinated')
            end
        end
        if drunkLevel > 0 then
            local smth = math.random(1, 10)
            local fSmth = smth / 10
            drunkLevel = drunkLevel - fSmth
            if isdrunk and drunkLevel < 10 then isdrunk = false Normal() end
        end
        Wait(3000)
    end
end)

local validWaterItem = {
    ["oxygentank"] = true,
    ["water"] = true,
    ["vodka"] = true,
    ["beer"] = true,
    ["whiskey"] = true,
    ["coffee"] = true,
    ["fishtaco"] = true,
    ["taco"] = true,
    ["vegantaco"] = true,
    ["burrito"] = true,
    ["churro"] = true,
    ["hotdogs"] = true,
    ["greencow"] = true,
    ["donut"] = true,
    ["eggsbacon"] = true,
    ["icecream"] = true,
    ["mshake"] = true,
    ["sandwich"] = true,
    ["hamburger"] = true,
    ["cola"] = true,
    ["jailfood"] = true,
    ["bleederburger"] = true,
    ["heartstopper"] = true,
    ["torpedo"] = true,
    ["meatfree"] = true,
    ["moneyshot"] = true,
    ["fries"] = true,
    ["slushy"] = true,
    ["bucket"] = true,
    ["goldenpeachtea"] = true,
}

local cooldown = false

RegisterKeyMapping("openinv", "Open Inventory", "keyboard", "F2")
RegisterCommand("-openinv", function() end, false) -- Disables chat from opening.

RegisterCommand("openinv", function(source, args, rawCommand)
    print("Can you open inventory?", canOpenInventory)
    if not canOpenInventory then return end;
    if exports["erp-characterui"]:InCharacterUI() then return end if exports["erp_clothing"]:inMenu() then return end 
    if not cooldown then
        CreateThread(function() cooldown = true Wait(1000) cooldown = false end)
        TriggerEvent("OpenInv")
    end
end, false)

function Breakfast()
    return GetClockHours() >= 6 and GetClockHours() <= 12
end

local function GetClosePlayers()
    local myself = PlayerPedId()
    local closePlayers = {}
    for _, player in ipairs(GetActivePlayers()) do
        local ped = GetPlayerPed(player)
        local dist = #(GetEntityCoords(myself) - GetEntityCoords(ped))
        if dist < 5 then table.insert(closePlayers, player) end
    end
    return closePlayers
end

local DNAInfo = {}

local DigSoil = {
    [2409420175] = true,
    [3008270349] = true,
    [3833216577] = true,
    [223086562] = true,
    [1333033863] = true,
    [4170197704] = true,
    [3594309083] = true,
    [2461440131] = true,
    [1109728704] = true,
    [2352068586] = true,
    [1144315879] = true,
    [581794674] = true,
    [2128369009] = true,
    [-461750719] = true,
    [-1286696947] = true,
}

RegisterNetEvent('RunUseItem')
AddEventHandler('RunUseItem', function(itemid, slot, inventoryName, isWeapon, durability)
    if itemid == nil then print("Item was invalid apparently?") return end

    canOpenInventory = false

    if durability ~= nil then
        if tonumber(durability) <= 1 then
            exports['mythic_notify']:SendAlert('inform', 'This item is too worn out to be used.', 3000)
            if isWeapon then TriggerEvent("brokenWeapon") end
            canOpenInventory = true
            return
        end
    end

    if justUsed then retardCounter = retardCounter + 1 if retardCounter > 10 and retardCounter > lastCounter+5 then lastCounter = retardCounter end return end

    justUsed = true

    if (not hasEnoughOfItem(itemid,1,false)) then
        print("You don't appear to have this item on you... "..itemid)
        justUsed, retardCounter, lastCounter = false, 0, 0
        canOpenInventory = true
        return
    end

    local ItemInfo = GetItemInfo(slot)

    if itemid == 'evidence' then
        if ItemInfo and ItemInfo['information'] then
            local dist = #(vector3(482.85, -988.73, 30.68) - GetEntityCoords(PlayerPedId()))
            if dist < 10.0 then
                local uhh = json.decode(ItemInfo['information'])
                local type = uhh['type']
                if DNAInfo['id'] == nil then
                    local msg = "Scanning Evidence"
                    if type == 'Blood' then msg = "Scanning Blood" end
                    local finished = exports["erp-progressbar"]:taskBar(5000, msg)
                    if (finished == 100) then
                        DNAInfo = { ItemID = ItemInfo['id'], information = json.decode(ItemInfo['information']) }
                        CreateThread(function()
                            exports['mythic_notify']:SendAlert('inform', 'DNA scanning... results will appear in 1 hour (60s)', 5000)
                            Wait(60000)
                            TriggerServerEvent('erp-inventory:runEvidence', DNAInfo['information'])
                        end)
                    end
                end
            else
                exports['mythic_notify']:SendAlert('inform', 'Too far from the lab.', 5000)
            end 
        end 
    end

    if itemid == 'ipodnano' then
        TriggerEvent('erp-soundcloud:useItem', ItemInfo)
    end

    if itemid == 'cottonswab' then
        if ItemInfo and (ItemInfo['information'] ~= "{}") then
            local dist = #(vector3(484.22, -987.77, 30.68) - GetEntityCoords(PlayerPedId()))
            if dist < 10.0 then
                local finished = exports["erp-progressbar"]:taskBar(5000,"Scanning Cotton Swab")
                if finished == 100 then
                    TriggerServerEvent('erp-inventory:finishCottonSwab', ItemInfo['id'], json.decode(ItemInfo['information']))
                end 
            end 
        else
            t, distance = GetClosestPlayer()
            if(distance ~= -1 and distance < 5) then
                TriggerServerEvent('erp-inventory:runCottonSwab', ItemInfo['id'], GetPlayerServerId(t))
            end
        end
    end


    if itemid == "-72657034" then
        TriggerEvent("hud-display-item",tonumber(itemid),"Equip")
        local plyPed = PlayerPedId()
        if not HasPedGotWeapon(plyPed, `GADGET_PARACHUTE`, false) then
            SetPedGadget(plyPed, `GADGET_PARACHUTE`, true)
            GiveWeaponToPed(plyPed, `GADGET_PARACHUTE`, 1, false, true)
            if HasPedGotWeapon(plyPed, `GADGET_PARACHUTE`, false) == 1 then
                TriggerEvent("inventory:removeItem",itemid, 1)
                exports['mythic_notify']:SendAlert('inform', 'Parachute applied.', 3000)
            else
                exports['mythic_notify']:SendAlert('inform', 'Parachute not applied.', 3000)
            end
        else
            exports['mythic_notify']:SendAlert('inform', 'You already have a parachute applied.', 4000)
        end
        justUsed, retardCounter, lastCounter = false, 0, 0
        canOpenInventory = true
        return
    end

    if not isValidUseCase(itemid,isWeapon) then justUsed, retardCounter, lastCounter, canOpenInventory = false, 0, 0, true return end
    if (itemid == nil) then justUsed, retardCounter, lastCounter, canOpenInventory = false, 0, 0, true return end

    if itemid == "883325847" then
        remove = false
        if isFueling then canOpenInventory = true return end;
        local plyPed = PlayerPedId()
        local coordA = GetEntityCoords(plyPed)
        local coordB = GetOffsetFromEntityInWorldCoords(plyPed, 0.0, 100.0, 0.0)
        local targetVehicle = getVehicleInDirection(coordA, coordB)
        if IsPedInAnyVehicle(PlayerPedId(), false) then return end
        if targetVehicle ~= 0 then
            if not GetIsVehicleEngineRunning(targetVehicle) then
                if #(GetEntityCoords(targetVehicle) - coordA) < 3.0 then
                    local fuelLevel = exports["erp-fuel"]:GetFuel(targetVehicle)
                    local duhLevel = math.ceil(fuelLevel)
                    local timer = 0
                    while duhLevel ~= 100 do Wait(10)
                        timer = timer + math.random(750, 1000)
                        duhLevel = duhLevel + 1
                    end
                    isFueling = true
                    TriggerEvent('jerrycananimation', plyPed, targetVehicle)
                    local finished = exports["erp-progressbar"]:taskBar(timer,"Fueling",false,false)
                    if (finished == 100) then
                        isFueling = false
                        if hasEnoughOfItem(itemid,1,false) then 
                            exports["erp-fuel"]:SetFuel(targetVehicle, 100)
                            TriggerEvent("inventory:removeItem",itemid, 1)
                        end                       
                    else
                        isFueling = false
                        exports['mythic_notify']:SendAlert('error', 'Failed to fuel the vehicle', 5000)
                    end
                else
                    exports['mythic_notify']:SendAlert('inform', 'The jerrycan is not long enough to reach the vehicle', 5000)
                end 
            else 
                exports['mythic_notify']:SendAlert('inform', 'Please turn the engine off.', 5000)
            end 
        else 
            TriggerEvent("equipWeaponID",itemid,ItemInfo)
            justUsed, retardCounter, lastCounter = false, 0, 0 
            canOpenInventory = true
            return
        end 
    elseif (isWeapon) then
        TriggerEvent("equipWeaponID",itemid,ItemInfo)
        justUsed, retardCounter, lastCounter = false, 0, 0 
        canOpenInventory = true
        return
    end

    TriggerEvent("hud-display-item",itemid,"Used")

    Wait(400)

    local player = PlayerPedId()
    local playerVeh = GetVehiclePedIsIn(player, false)

    if (not IsPedInAnyVehicle(player)) then
        if (itemid == "Suitcase") then TriggerEvent('attach:suitcase')
        elseif (itemid == "Boombox") then TriggerEvent('attach:boombox')
        elseif (itemid == "wheelchair") then TriggerEvent('attach:wheelchair')
        elseif (itemid == "Box") then TriggerEvent('attach:box')
        elseif (itemid == "DuffelBag") then TriggerEvent('attach:blackDuffelBag')
        elseif (itemid == "MedicalBag") then TriggerEvent('attach:medicalBag')
        elseif (itemid == "SecurityCase") then TriggerEvent('attach:securityCase')
        elseif (itemid == "Toolbox") then TriggerEvent('attach:toolbox')
        end
    end

    local remove, fooditem, drinkitem, healitem = false, false, false, false

    if itemid == 'vape' then
        TriggerEvent('Vape:toggleVaping', ItemInfo['id'])
    end

    if itemid == 'cigarette' then
        if hasEnoughOfItem('lighter',1,false) then
            remove = true
            local finished = exports["erp-progressbar"]:taskBar(1000,"Lighting Up")
            if (finished == 100) then
                local animDict = "amb@world_human_smoking@male@male_a@base"
                local animation = "base"
                if IsPedArmed(ped, 7) then SetCurrentPedWeapon(ped, 0xA2719263, true) end
                if IsEntityPlayingAnim(ped, animDict, animation, 3) then
                    ClearPedSecondaryTask(ped)
                else
                    loadAnimDict(animDict)
                    local animLength = GetAnimDuration(animDict, animation)
                    TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,  animLength, 49, 0, 0, 0, 0)
                    TriggerEvent("destroyProp")
                end
                TriggerEvent("attachItem", "cigarette")
    
                CreateThread(function()    
                    local timer = GetGameTimer() + math.random(180000, 200000)
                    local shouldEnd = false
                    while true do
                        Wait(1000)
                        if GetGameTimer() >= timer then shouldEnd = true end
                        if shouldEnd then
                            exports['mythic_notify']:SendAlert('inform', 'You finished your cigarette.', 6000)
                            ClearPedSecondaryTask(PlayerPedId())
                            return
                        end
    
                        if IsEntityPlayingAnim(PlayerPedId(), "amb@world_human_smoking@male@male_a@base", "base", 3) then
                            if math.random(1, 100) > 85 then TriggerEvent("updatestress", -math.random(200,300)) end
                            if math.random(100) >= 90 then
                                local closestPlayers = GetClosePlayers()
                                if closestPlayers then
                                    for k,v in pairs(closestPlayers) do
                                        TriggerServerEvent('erp-status:applyStatus', 'Smells like smoke', GetPlayerServerId(v))
                                    end
                                end
                            end
                        else
                            exports['mythic_notify']:SendAlert('inform', 'You dropped your cigarette before you could finish it.', 6000)
                            return
                        end
                    end
                end)            
            end
        else
            exports['mythic_notify']:SendAlert('inform', 'Missing lighter.')
        end
        
    end

    if (itemid == 'washkit') then TriggerEvent('erp-washkit:onUse', itemid) end

    if (itemid == 'cocainebrick') then
        CreateCraftOption('coke', 100, true)
    end

    if (itemid == "tuning_laptop") then
        TriggerEvent('tuner:open', source)
    elseif itemid == 'thermal_charge' then
        --[[TriggerServerEvent('erp-robbery:thermiteBank')
        TriggerServerEvent('erp-vault:thermiteBox')
        TriggerEvent('erp-vault:thermDoor')]]
        TriggerEvent('erp-robberies:truck:itemuse', itemid)
    elseif itemid == 'laptop_h' then
        TriggerEvent('erp-powerplant:itemused', itemid)
        TriggerEvent('erp-robbery:securityBlueUsed')
    end

    if itemid == 'weazelmicrophone' then
        TriggerServerEvent('item_mic')
    elseif itemid == 'weazelcamera' then
        TriggerServerEvent('item_cam')
    elseif itemid == 'weazelboommic' then
        TriggerServerEvent('item_boommi')
    end

    if itemid == 'blackcard' then
        TriggerEvent('erp-vault:blackCard')
    end

    if itemid == 'dice' then
        ExecuteCommand('rolldice')
    end

    if itemid == "fishingrod" then
        TriggerEvent('erp-fishing:findLoc', false)
    end

    if itemid == "fishbait" then
        TriggerEvent('erp-fishing:applyBait', GetPlayerServerId(PlayerId()))
    end

    if itemid == 'shovel' then
        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped) then
            canOpenInventory = true
            return
        end
    
        local playerCoord = GetEntityCoords(ped)
        local target = GetOffsetFromEntityInWorldCoords(ped, vector3(0,2,-3))
        local testRay = StartShapeTestRay(playerCoord, target, 17, ped, 7) -- This 7 is entirely cargo cult. No idea what it does.
        local _, hit, hitLocation, surfaceNormal, material, _ = GetShapeTestResultEx(testRay)
    
        if hit == 1 then
            print('Material:', material)
            print('Hit location:', hitLocation)
            print('Surface normal:', surfaceNormal)
            if DigSoil[material] then
                TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_GARDENER_PLANT', 0, true)
                local finished = exports["erp-skillbar"]:taskBar(math.random(5000, 10000),math.random(4,6))
                if finished == 100 then
                    TriggerEvent('player:receiveItem', 'bagofsoil', math.random(1, 3))
                    ClearPedTasksImmediately(PlayerPedId())
                end
            else
                exports['mythic_notify']:SendAlert('inform', 'Unable to dig here.', 4000)
            end
        end
    end

    if itemid == 'bagofsoil' then
        TriggerEvent("server-inventory-open", 203, "Craft");
    end

    if (itemid == "weed_seed") or (itemid == 'weed_seed_h') or (itemid == 'phoenix_seed') then
        TriggerEvent('erp-weed:plantSeed', itemid)
        TriggerServerEvent('erp-status:applyStatus', 'Smells Like Marijuana')
    end

    if (itemid == "potato_seed") then
        TriggerEvent('erp-weed:plantSeed', itemid)
    end

    if (itemid == "weed") then
        TriggerEvent("server-inventory-open", 554, "Craft");
        TriggerServerEvent('erp-status:applyStatus', 'Smells Like Marijuana')
        remove = false
    end

    if (itemid == "weed_h") then
        TriggerEvent("server-inventory-open", 553, "Craft");
        TriggerServerEvent('erp-status:applyStatus', 'Smells Like Marijuana')
        remove = false
    end

    if (itemid == "phoenix_flowers") then
        TriggerEvent("server-inventory-open", 556, "Craft");
        TriggerServerEvent('erp-status:applyStatus', 'Smells Like Marijuana')
        remove = false
    end

    if (itemid == "lighter") then
        TriggerEvent("animation:PlayAnimation","lighter")
        local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
        local ground, groundZ = GetGroundZFor_3dCoord(x,y,z,0)
        local finished = exports["erp-progressbar"]:taskBar(2000,"Starting Fire",false,false,playerVeh)
        if (finished == 100) then
            if hasEnoughOfItem(itemid,1,false) then
                TriggerEvent('erp-weed:destroyPlant')
                CreateThread(function()
                    local fire = StartScriptFire(x,y,groundZ,math.random(10,20),true)
                    TriggerServerEvent('erp-status:applyStatus', 'Smells like smoke')
                    local endTime = GetGameTimer() + math.random(7500, 12500)
                    while true do
                        Wait(0)

                        if GetGameTimer() >= endTime then
                            RemoveScriptFire(fire)
                            return
                        end
                    end
                end)
            else
                print("DONT EXPLOIT ME BITCH.")
            end
        end
    end

    local DrunkItems = {
        ['vodka'] = true,
        ['champagne'] = true,
        ['potatovodka'] = true,
        ['beer'] = true,
        ['whiskey'] = true,
        ['dirtyshirley'] = true,
        ['jac'] = true,
        ['icedteafmb'] = true,
        ['arnoldpalmer'] = true,
        -- Legacy
        ['jelloshot'] = true,
        ['baconbloodymary'] = true,
        ['tequilasprite'] = true,
        ['rumpunch'] = true,
        ['gintonic'] = true,
        ['redsangria'] = true,
        ['milkdudsliders'] = true,
        ['badbitchmartini'] = true,
        ['valkkiss'] = true,
		['oldfashioned'] = true,
		['patriotbeer'] = true,
		['watermelonfrozerita'] = true,
        -- END
        ['cognac'] = true,
        ['redwine'] = true,
        ['tequilasunrise'] = true,
        ['whiteclaw'] = true,
        -- SooChi
        ['sake'] = true,
        ['awamori'] = true,
        ['yuzushu'] = true,
    }

    local FoodPack2 = {
        ['crabcakes'] = true,
        ['hotdogs'] = true,
        ['fishtaco'] = true,
        ['chips'] = true,
        ['bakedpotato'] = true,
        ['nachos'] = true,
        ['bagofnuts'] = true,
        ['bread'] = true,
        ['chocolate'] = true,
        ['energybar'] = true,
        ['sandwich'] = true,
        ['bfsandwich'] = true,
        ['hamburger'] = true,
        ['donut'] = true,
        ['cookie'] = true,
        ['vegantaco'] = true,
        ['burrito'] = true,
        ['breakfastburrito'] = true,
        ['taco'] = true,
        ['munchies'] = true,
        ['momssandwhiches'] = true,
        -- Legacy Records
        ['shrimptaco'] = true,
        ['caesarsalad'] = true,
        ['lobstersliders'] = true,
        ['pretzels'] = true,
        ['onionrings'] = true,
        ['deepfriedpickles'] = true,
        ['chipsandsalsa'] = true,
        ['goldenlavacake'] = true,
        -- END
        ['chickensandwich'] = true,
        ['lobsterbisque'] = true,
        ['impossibleburger'] = true,
        ['bbqbcburger'] = true,
        ['dbaconcb'] = true,
        ['bbqribsandwich'] = true,
        ['icecream'] = true,
        ['turtlecheesecake'] = true,
        ['pastasalad'] = true,
        ['curlyfries'] = true,
        ['bbqribmeal'] = true,
        ['steakdinner'] = true,
        ['speghetti'] = true,
        ['sliders'] = true,
        -- SooChi
        ['misoramen'] = true,
        ['tonkotsuramen'] = true,
        ['spicyshoyuramen'] = true,
        ['californiaroll'] = true,
        ['salmontempura'] = true,
        ['spicydragonroll'] = true,
        ['gyoza'] = true,
        ['edamame'] = true,
        ['teriyakichickenskewers'] = true,
        ['sakuramochi'] = true,
        ['mitarashi'] = true,
        ['matchaicecream'] = true,
    }

    if DrunkItems[itemid] then
        AttachPropAndPlayAnimation("amb@world_human_drinking@coffee@male@idle_a", "idle_c", 49,6000,"Drink","drinkalcahol",true,itemid)
    elseif FoodPack2[itemid] then
        AttachPropAndPlayAnimation("mp_player_inteat@burger", "mp_player_int_eat_burger", 49,6000,"Eating","changehunger",true,itemid)
    end

    local DrinkPack1 = {
        ["slushy"] = true,
        ["potatojuice"] = true,
        ["potatoshake"] = true,
        ["colada"] = true,
        ['milkshake'] = true,
        ['water'] = true,
        ['cocacola'] = true,
        ['mtnshlew'] = true,
        ["coffee"] = true,
        ["hotchoccy"] = true,
        ["frappuccino"] = true,
        ["goldenpeachtea"] = true,
        ['rootbeerfloat'] = true,
        ["bullbetea"] = true,
        ["milktea"] = true,
        ["lycheesoda"] = true,
        ["cannedcoffee"] = true
    }

    if DrinkPack1[itemid] then
        AttachPropAndPlayAnimation("amb@world_human_drinking@coffee@male@idle_a", "idle_c", 49,6000,"Drink","changehunger",true,itemid)
    end

    if (itemid == "churro" or itemid == "hotdog" or itemid == "cheesesticks" or itemid == "cwings" or itemid == "pizza" or itemid == "hashbrown") then
        TaskItem("mp_player_inteat@burger", "mp_player_int_eat_burger", 49,6000,"Eating","changehunger",true,itemid,playerVeh)
    end

    if itemid == 'icetea' then
        TaskItem("amb@world_human_drinking@coffee@male@idle_a", "idle_c", 49,6000,"Drink","changehunger",true,itemid,playerVeh)
    end

    if (itemid == "eggsbacon") or (itemid == "fishchips") then
        AttachPropAndPlayAnimation("mp_player_inteat@burger", "mp_player_int_eat_burger", 49,10000,"Eating","food:breakfast",true,itemid,playerVeh)
    end

    if (itemid == "advlockpick") then
        TriggerEvent('houseRobberies:attempt', 1, false, function(res) if not res then TriggerServerEvent('erp-storerobberies:findRegister', ItemInfo.id) end end)
    end

    if itemid == 'bluecard' then
        TriggerEvent('erp-robberies:vangelico:usecard', ItemInfo.id)
    end

    if itemid == 'commonsc' then
        if IsPedInAnyVehicle(PlayerPedId(), false) then
            exports['mythic_notify']:SendAlert('inform', 'Unable to do this in a vehicle', 5000)
        else
            TriggerEvent('erp-scratchcard:useItem', 'common', itemid)
        end
    elseif itemid == 'raresc' then
        if IsPedInAnyVehicle(PlayerPedId(), false) then
            exports['mythic_notify']:SendAlert('inform', 'Unable to do this in a vehicle', 5000)
        else
            TriggerEvent('erp-scratchcard:useItem', 'rare', itemid)
        end
    elseif itemid == 'epicsc' then
        if IsPedInAnyVehicle(PlayerPedId(), false) then
            exports['mythic_notify']:SendAlert('inform', 'Unable to do this in a vehicle', 5000)
        else
            TriggerEvent('erp-scratchcard:useItem', 'epic', itemid)
        end
    elseif itemid == 'legendarysc' then
        if IsPedInAnyVehicle(PlayerPedId(), false) then
            exports['mythic_notify']:SendAlert('inform', 'Unable to do this in a vehicle', 5000)
        else
            TriggerEvent('erp-scratchcard:useItem', 'legendary', itemid)
        end
    end

    if itemid == 'greencard' then
        TriggerServerEvent('erp-robberies:findFleeca:securitypanel', ItemInfo.id)
    elseif itemid == 'laptop' then
        TriggerServerEvent('erp-robberies:findFleeca:vault')
    elseif itemid == 'fakeplate' then
        if IsPedInAnyVehicle(PlayerPedId(), false) then return end
        local plyPed = PlayerPedId()
        local coordA = GetEntityCoords(plyPed)
        local coordB = GetOffsetFromEntityInWorldCoords(plyPed, 0.0, 100.0, 0.0)
        local targetVehicle = getVehicleInDirection(coordA, coordB)
        if DoesEntityExist(targetVehicle) then
            if GetEntityType(targetVehicle) ~= 2 then
                exports['mythic_notify']:SendAlert('inform', 'Not a vehicle')
                return
            end
            TriggerEvent('dp:playEmote', "mechanic3")
            local finished = exports["erp-progressbar"]:taskBar(math.random(1500, 3000),"Applying Plate",false,false,playerVeh)
            if (finished == 100) then
                if hasEnoughOfItem(itemid,1,false) then
                    TriggerServerEvent('fakeplate', VehToNet(targetVehicle))
                    SetVehicleNumberPlateTextIndex(targetVehicle, math.random(1, 6) - 1)
                    remove = true
                end
            end
            TriggerEvent('dp:playEmote', "c")
        end
    end

    if itemid == 'plastic' then
        TriggerEvent("server-inventory-open", 555, "Craft");
        remove = false
    end

    if itemid == "notepad" then
        TriggerEvent('erp-notepad:OpenNotepadGui')
    end

    if (itemid == "sniperammo") then
        local finished = exports["erp-progressbar"]:taskBar(5000,"Reloading",false,false,playerVeh)
        if (finished == 100) then
            if hasEnoughOfItem(itemid,1,false) then
                if GetSelectedPedWeapon(PlayerPedId()) ~= `WEAPON_UNARMED` then
                    TriggerEvent("actionbar:ammo",itemid,30,true)
                else
                    exports['mythic_notify']:SendAlert('inform', 'No weapon in your hand.', 4000)
                end
            end
        end
    end

    if (itemid == "heavyammo") then
        local finished = exports["erp-progressbar"]:taskBar(3000,"Reloading",false,false,playerVeh)
        if (finished == 100) then
            if hasEnoughOfItem(itemid,1,false) then
                if GetSelectedPedWeapon(PlayerPedId()) ~= `WEAPON_UNARMED` then
                    TriggerEvent("actionbar:ammo",itemid,50,true)
                else
                    exports['mythic_notify']:SendAlert('inform', 'No weapon in your hand.', 4000)
                end
            end
        end
    end

    if (itemid == "pistolammo") then
        local finished = exports["erp-progressbar"]:taskBar(2000,"Reloading",false,false,playerVeh)
        if (finished == 100) then
            if hasEnoughOfItem(itemid,1,false) then
                if GetSelectedPedWeapon(PlayerPedId()) ~= `WEAPON_UNARMED` then
                    TriggerEvent("actionbar:ammo",itemid,50,true)
                else
                    exports['mythic_notify']:SendAlert('inform', 'No weapon in your hand.', 4000)
                end
            end
        end
    end

    if (itemid == "rifleammo") then
        local finished = exports["erp-progressbar"]:taskBar(3000,"Reloading",false,false,playerVeh)
        if (finished == 100) then
            if hasEnoughOfItem(itemid,1,false) then
                local type = 0
                local hasWeapon, weaponHash = GetCurrentPedWeapon(PlayerPedId(), 1)
                if GetSelectedPedWeapon(PlayerPedId()) ~= `WEAPON_UNARMED` then
                    TriggerEvent("actionbar:ammo",itemid,50,true)
                else
                    exports['mythic_notify']:SendAlert('inform', 'No weapon in your hand.', 4000)
                end                
            end
        end
    end

    if (itemid == "radio") then
        TriggerEvent('erp-radio:openRadio')
    elseif (itemid == "policescanner") then
        local finished = exports["erp-progressbar"]:taskBar(math.random(5000, 7500),"Scanning")
        if (finished == 100) then
            TriggerServerEvent('policescanner')
        end
    end

    if (itemid == "shotgunammo") then
        local finished = exports["erp-progressbar"]:taskBar(2500,"Reloading",false,false,playerVeh)
        if (finished == 100) then
            if hasEnoughOfItem(itemid,1,false) then
                if GetSelectedPedWeapon(PlayerPedId()) ~= `WEAPON_UNARMED` then
                    TriggerEvent("actionbar:ammo",itemid,50,true)
                end
            end
        end
    end

    if (itemid == "subammo") then
        local finished = exports["erp-progressbar"]:taskBar(1500,"Reloading",false,false,playerVeh)
        if (finished == 100) then
            if hasEnoughOfItem(itemid,1,false) then
                TriggerEvent("actionbar:ammo",itemid,50,true)
            else
                exports['mythic_notify']:SendAlert('inform', 'No weapon in your hand.', 4000)
            end
        end
    end

    if (itemid == "HeavyArmor") then
        remove = false
        RequestAnimDict("clothingshirt")
        while not HasAnimDictLoaded("clothingshirt") do Citizen.Wait(100) end
        
        RequestAnimDict('anim@narcotics@trash')
        while not HasAnimDictLoaded("anim@narcotics@trash") do Citizen.Wait(100) end
        TaskPlayAnim(player,'anim@narcotics@trash', 'drop_front',1.0, -1, 1900, 49, 3.0, 0, 0, 0)
        CreateThread(function()
            Wait(1950)
            TaskPlayAnim(player, "clothingshirt", "try_shirt_positive_d", 1.0, -1, -1, 50, 0, 0, 0, 0)
        end)
        local finished = exports["erp-progressbar"]:taskBar(math.random(10000, 15000),"Heavy Armor",false,false,playerVeh)
        if (finished == 100) then
            if hasEnoughOfItem(itemid,1,false) then
                AddArmourToPed(player, 100)
                TriggerEvent("inventory:removeItem",itemid, 1)
                ClearPedTasks(player)
            end
        end
    end

    if (itemid == "MedArmor") then
        remove = false
        RequestAnimDict("clothingshirt")
        while not HasAnimDictLoaded("clothingshirt") do Citizen.Wait(100) end
        
        RequestAnimDict('anim@narcotics@trash')
        while not HasAnimDictLoaded("anim@narcotics@trash") do Citizen.Wait(100) end
        TaskPlayAnim(player,'anim@narcotics@trash', 'drop_front',1.0, -1, 1900, 49, 3.0, 0, 0, 0)
        CreateThread(function()
            Wait(1950)
            TaskPlayAnim(player, "clothingshirt", "try_shirt_positive_d", 1.0, -1, -1, 50, 0, 0, 0, 0)
        end)
        local finished = exports["erp-progressbar"]:taskBar(math.random(7500, 10000),"Medium Armor",falsefalsesmalla,false,playerVeh)
        if (finished == 100) then
            if hasEnoughOfItem(itemid,1,false) then
                AddArmourToPed(player, 60)
                TriggerEvent("inventory:removeItem",itemid, 1)
                ClearPedTasks(player)
            end
        end
    end

    if (itemid == "ibuprofen") then
        AttachPropAndPlayAnimation("mp_suicide", "pill", 49,3000,"Poppin' Pills","mythic_hospital:items:ibuprofen",true,itemid,playerVeh)
    end

    if (itemid == "SmallArmor") then
        remove = false
        RequestAnimDict("clothingshirt")
        while not HasAnimDictLoaded("clothingshirt") do Citizen.Wait(100) end
        
        RequestAnimDict('anim@narcotics@trash')
        while not HasAnimDictLoaded("anim@narcotics@trash") do Citizen.Wait(100) end
        TaskPlayAnim(player,'anim@narcotics@trash', 'drop_front',1.0, -1, 1900, 49, 3.0, 0, 0, 0)
        CreateThread(function()
            Wait(1950)
            TaskPlayAnim(player, "clothingshirt", "try_shirt_positive_d", 1.0, -1, -1, 50, 0, 0, 0, 0)
        end)
        local finished = exports["erp-progressbar"]:taskBar(math.random(5000, 7500),"Light Armor",false,false,playerVeh)
        if (finished == 100) then
            if hasEnoughOfItem(itemid,1,false) then
                TriggerEvent("inventory:removeItem",itemid, 1)
                AddArmourToPed(player, 30)
                ClearPedTasks(player)
            end
        end
    end

    if (itemid == "binoculars") then
        TriggerEvent("binoculars:Activate")
    end

    if (itemid == "camera") then
        TriggerEvent("camera:Activate")
    end

    if itemid == "spikes" then 
        TriggerEvent('c_setSpike')
    end

    if (itemid == "bucket") then
        remove = false
        if IsPedSwimmingUnderWater(PlayerPedId()) or IsPedSwimming(PlayerPedId()) then 
            local finished = exports["erp-progressbar"]:taskBar(math.random(10000, 15000),"Filling Bucket")
            if finished == 100 then 
                if hasEnoughOfItem(itemid,1,false) then
                    TriggerEvent("inventory:removeItem", itemid, 1)
                    TriggerEvent('player:receiveItem', 'chwater', 1)
                end
            end
        end
    end

    if (itemid == "nitrous") then
        local currentVehicle = GetVehiclePedIsIn(player, false)
        
        if not IsToggleModOn(currentVehicle,18) then
            TriggerEvent("notification","You need a Turbo to use NOS!",2)
        else
            local finished = 0
            local cancelNos = false
            Citizen.CreateThread(function()
                while finished ~= 100 and not cancelNos do
                    Citizen.Wait(100)
                    if GetEntitySpeed(GetVehiclePedIsIn(player, false)) > 11 then
                        exports["erp-progressbar"]:closeGuiFail()
                        cancelNos = true
                    end
                end
            end)
            finished = exports["erp-progressbar"]:taskBar(math.random(15000,20000),"Nitrous")
            if (finished == 100 and not cancelNos) then
                if hasEnoughOfItem(itemid,1,false) then
                    local veh = GetVehiclePedIsIn(PlayerPedId())
                    TriggerServerEvent('erp-carstatus:attemptnitrous', veh, GetVehicleNumberPlateText(veh))
                    remove = false
                else
                    remove = false
                    print("DAFUQ.")
                end
            else
                TriggerEvent("notification","You can't drive and hook up nos at the same time.",2)
            end
        end
    end

    if itemid == 'blackoutkey' then
        TriggerEvent('erp-powerplant:itemused', itemid)
        remove = false
    end

    if (itemid == "harness") then
        local finished = 0
        local cancelHarness = false
        Citizen.CreateThread(function()
            while finished ~= 100 and not cancelHarness do
                Citizen.Wait(100)
                if GetEntitySpeed(GetVehiclePedIsIn(player, false)) > 11 then
                    exports["erp-progressbar"]:closeGuiFail()
                    cancelHarness = true
                end
            end
        end)
        
        finished = exports["erp-progressbar"]:taskBar(math.random(12500,15000),"Harness")
        if (finished == 100 and not cancelHarness) then
            if hasEnoughOfItem(itemid,1,false) then
                TriggerEvent("harness", true)
                TriggerServerEvent("inventory:degItem", ItemInfo.id, math.random(1265016685, 2530033370))
                remove = false
            else
                remove = false
                print("DAFUQ.")
            end
        else
            exports['mythic_notify']:SendAlert('inform', "You can't drive and enable drift mode at the same time.", 5000)
        end
    end

    --[[if (itemid == "drift") then
        remove = false
        local finished = 0
        local cancelDrift = false
        Citizen.CreateThread(function()
            while finished ~= 100 and not cancelDrift do
                Citizen.Wait(100)
                if GetEntitySpeed(GetVehiclePedIsIn(player, false)) > 11 then
                    exports["erp-progressbar"]:closeGuiFail()
                    cancelDrift = true
                end
            end
        end)
        
        finished = exports["erp-progressbar"]:taskBar(math.random(5000,7500),"Toggling Drift Mode")
        if (finished == 100 and not cancelDrift) then
            if hasEnoughOfItem(itemid,1,false) then
                local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                local driftstate = Entity(vehicle).state.drift
                TriggerServerEvent('driftmode', VehToNet(vehicle))
                Wait(250)
                local newdriftstate = Entity(vehicle).state.drift
                print("Current drift state:", newdriftstate)
                local model = GetEntityModel(vehicle)
                if newdriftstate then
                    DriftHandlings[model] = {
                        ['fInitialDragCoeff'] = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDragCoeff"),
                        ['fInitialDriveForce'] = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDriveForce"),
                        ['fDriveInertia'] = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fDriveInertia"),
                        ['fInitialDriveMaxFlatVel'] = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDriveMaxFlatVel"),
                        ['nInitialDriveGears'] = GetVehicleHandlingFloat(vehicle, "CHandlingData", "nInitialDriveGears"),
                        ['fClutchChangeRateScaleUpShift'] = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fClutchChangeRateScaleUpShift"),
                        ['fClutchChangeRateScaleDownShift'] = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fClutchChangeRateScaleDownShift"),
                        ['fSteeringLock'] = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fSteeringLock"),
                        ['fTractionCurveMax'] = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fTractionCurveMax"),
                        ['fTractionCurveMin'] = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fTractionCurveMin"),
                        ['fTractionCurveLateral'] = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fTractionCurveLateral"),
                        ['fLowSpeedTractionLossMult'] = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fLowSpeedTractionLossMult")
                    }
                    Wait(100)
                    SetVehicleHandlingField(vehicle, "CHandlingData", "fInitialDragCoeff", 30.0)
                    SetVehicleHandlingField(vehicle, "CHandlingData", "fInitialDriveForce", 0.5)
                    SetVehicleEnginePowerMultiplier(vehicle, 30.0)
                    SetVehicleHandlingField(vehicle, "CHandlingData", "fDriveInertia", 1.0)
                    SetVehicleHandlingField(vehicle, "CHandlingData", "fInitialDriveMaxFlatVel", 300.0)
                    SetVehicleHandlingField(vehicle, "CHandlingData", "nInitialDriveGears", 4.0)
                    SetVehicleHandlingField(vehicle, "CHandlingData", "fClutchChangeRateScaleUpShift", 100.0)
                    SetVehicleHandlingField(vehicle, "CHandlingData", "fClutchChangeRateScaleDownShift", 100.0)
                    SetVehicleHandlingField(vehicle, "CHandlingData", "fSteeringLock", 60.0)
                    SetVehicleHandlingField(vehicle, "CHandlingData", "fTractionCurveMax", 1.7)
                    SetVehicleHandlingField(vehicle, "CHandlingData", "fTractionCurveMin", 1.3)
                    SetVehicleHandlingField(vehicle, "CHandlingData", "fTractionCurveLateral", 30.0)
                    SetVehicleHandlingField(vehicle, "CHandlingData", "fLowSpeedTractionLossMult", 0.0)
                    exports['mythic_notify']:SendAlert('inform', 'Drift mode enabled.')
                    Entity(vehicle).state:set('localdrift', true, false)
                else
                    SetVehicleHandlingField(vehicle, "CHandlingData", "fInitialDragCoeff", DriftHandlings[model]['fInitialDragCoeff'])
                    SetVehicleHandlingField(vehicle, "CHandlingData", "fInitialDriveForce", DriftHandlings[model]['fInitialDriveForce'])
                    SetVehicleEnginePowerMultiplier(vehicle, 0.0)
                    SetVehicleHandlingField(vehicle, "CHandlingData", "fDriveInertia", DriftHandlings[model]['fDriveInertia'])
                    SetVehicleHandlingField(vehicle, "CHandlingData", "fInitialDriveMaxFlatVel", DriftHandlings[model]['fInitialDriveMaxFlatVel'])
                    SetVehicleHandlingField(vehicle, "CHandlingData", "nInitialDriveGears", DriftHandlings[model]['nInitialDriveGears'])
                    SetVehicleHandlingField(vehicle, "CHandlingData", "fClutchChangeRateScaleUpShift", DriftHandlings[model]['fClutchChangeRateScaleUpShift'])
                    SetVehicleHandlingField(vehicle, "CHandlingData", "fClutchChangeRateScaleDownShift", DriftHandlings[model]['fClutchChangeRateScaleDownShift'])
                    SetVehicleHandlingField(vehicle, "CHandlingData", "fSteeringLock", DriftHandlings[model]['fSteeringLock'])
                    SetVehicleHandlingField(vehicle, "CHandlingData", "fTractionCurveMax", DriftHandlings[model]['fTractionCurveMax'])
                    SetVehicleHandlingField(vehicle, "CHandlingData", "fTractionCurveMin", DriftHandlings[model]['fTractionCurveMin'])
                    SetVehicleHandlingField(vehicle, "CHandlingData", "fTractionCurveLateral", DriftHandlings[model]['fTractionCurveLateral'])
                    SetVehicleHandlingField(vehicle, "CHandlingData", "fLowSpeedTractionLossMult", DriftHandlings[model]['fLowSpeedTractionLossMult'])
                    exports['mythic_notify']:SendAlert('inform', 'Drift mode disabled.')
                    Entity(vehicle).state:set('localdrift', false, false)
                end
            end
        else
            exports['mythic_notify']:SendAlert('inform', "You can't drive and enable drift mode at the same time.", 5000)
        end
    end]]

    if (itemid == "lockpick") then
        TriggerEvent("inv:lockPick",false,inventoryName,slot,ItemInfo.id)
    end

    if (itemid == "umbrella") then
        TriggerEvent("animation:PlayAnimation","umbrella")
    end

    if (itemid == "repairkit") then
        TriggerEvent('veh:repairing',itemid)
    end

    if (itemid =="weakrepairkit") then
      TriggerEvent('veh:repairing',itemid)
    end

    if itemid == "casinodiamond" or itemid == "casinogold" or itemid == "casinoplat" then 
        if ItemInfo and ItemInfo['information'] then
            local uhh = json.decode(ItemInfo['information'])
            local cid = uhh['Cid']
            local plyData = exports['echorp']:GetPlayerData()
            if tonumber(cid) == plyData['cid'] then 
                local shouldHighTable = true
                
                if itemid == "casinodiamond" then
                    local pos = GetEntityCoords(PlayerPedId())
                    local door = vector3(967.89, 63.56, 112.55)
                    local otherside = vector3(969.36, 63.26, 112.55)
                    
                    local dist1 = #(pos - door)
                    local dist2 = #(pos - otherside)
            
                    if dist1 < 1.0 then
                        shouldHighTable = false
                        local heading = GetGameplayCamRelativeHeading()
                        DoScreenFadeOut(1000)
                        Citizen.Wait(3000)
                        SetEntityCoords(PlayerPedId(), otherside)
                        SetEntityHeading(PlayerPedId(), 238.11)
                        SetGameplayCamRelativeHeading(heading)
                        DoScreenFadeIn(1000)
                    elseif dist2 < 1.0 then
                        shouldHighTable = false
                        local heading = GetGameplayCamRelativeHeading()
                        DoScreenFadeOut(1000)
                        Citizen.Wait(3000)
                        SetEntityCoords(PlayerPedId(), door)
                        SetEntityHeading(PlayerPedId(), 238.11 - 180.0)
                        SetGameplayCamRelativeHeading(heading)
                        DoScreenFadeIn(1000)
                    end
                end

                if shouldHighTable then TriggerEvent('erp-casino:hightable', true) end
            else
                exports['mythic_notify']:SendAlert('inform', 'This card is not registered to you.')
            end
        else
            exports['mythic_notify']:SendAlert('inform', 'Seems like an invalid card.')
        end
    end

    


    if (itemid == "cigar") then
        local finished = exports["erp-progressbar"]:taskBar(1000,"Lighting Up",false,false,playerVeh)
        if (finished == 100) then
            Wait(300)
            TriggerEvent("animation:PlayAnimation","cigar")
        end
    end

    if (itemid == "oxygentank") then
        CreateThread(function()
            loadAnimDict("clothingspecs")
            TaskPlayAnim(PlayerPedId(), "clothingspecs", "take_off", 4.0, 3.0, -1, 49, 1.0, 0, 0, 0 )
            Wait(1500)
            ClearPedTasks(PlayerPedId())
            return
        end)
        local skillbar =  exports["erp-skillbar"]:taskBar(math.random(7500, 10000),math.random(9,12))
        if skillbar == 100 then
            loadAnimDict("oddjobs@basejump@ig_15")
            TaskPlayAnim(PlayerPedId(), "oddjobs@basejump@ig_15", "puton_parachute", 4.0, 3.0, -1, 49, 1.0, 0, 0, 0 )
            local finished = exports["erp-progressbar"]:taskBar(math.random(5000, 7500),"Oxygen Tank")
            ClearPedTasks(PlayerPedId())
            if finished == 100 then
                if hasEnoughOfItem(itemid,1,false) then
                    TriggerEvent('oxygentank')
                    remove = true
                end
            else
                ClearPedTasks(PlayerPedId())
            end
        else
            ClearPedTasks(PlayerPedId())
        end
    end
 
    if (itemid == "phone") then
        TriggerEvent('phone:registeritem')
    end

    if (itemid == "assphone") then
        TriggerEvent('phone:registeritem')
    end

    if (itemid == "blowtorch") then
        TriggerServerEvent('erp-storerobberies:findSafe', ItemInfo.id)
    end

    if (itemid == "bandage") then
        TaskItem("amb@world_human_clipboard@male@idle_a", "idle_c", 49,10000,"Bandaging Wounds ","mythic_hospital:items:bandage",true,itemid,playerVeh)
        TriggerServerEvent('erp-status:applyStatus', 'Fresh Bandaging')
    end

    if (itemid == "medbag") then
        AttachPropAndPlayAnimation("missheistdockssetup1clipboard@idle_a", "idle_a", 49,15000,"Working Magic","mythic_hospital:items:medbag",true,itemid,playerVeh)
        TriggerServerEvent('erp-status:applyStatus', 'Fresh Bandaging')
    end

    if (itemid == "firstaidkit") then
        AttachPropAndPlayAnimation("missheistdockssetup1clipboard@idle_a", "idle_a", 49,15000,"Healing Wounds","mythic_hospital:items:firstaidkit",true,itemid,playerVeh)
        TriggerServerEvent('erp-status:applyStatus', 'Fresh Bandaging')
    end

    if (itemid == "gpstransponder") then
        TriggerEvent("erp-police:toggleDispatchBlips")
    end
    
    if (itemid == "unoreversecard") then 
        local ItemInfo = GetItemInfo(slot)
        TriggerEvent("erp-police:showUnoReverseCard", ItemInfo.information)   
    end

    if (itemid == "weazel_mediabadge") then
        local ItemInfo = GetItemInfo(slot)
        TriggerEvent("erp-police:showMediaBadge", ItemInfo.information)   
    end

    if (itemid == "idcard") then 
        local ItemInfo = GetItemInfo(slot)
        TriggerEvent("erp-police:showId", ItemInfo.information)   
    end

    if (itemid == "policebadge") then 
        local ItemInfo = GetItemInfo(slot)
        TriggerEvent("erp-police:showPoliceBadge", ItemInfo.information)   
    end

    if (itemid == "emsbadge") then 
        local ItemInfo = GetItemInfo(slot)
        TriggerEvent("erp-police:showEMSBadge", ItemInfo.information)   
    end

    if (itemid == "coke" or itemid == "meth" or itemid == "refinedmeth" or itemid == "opium" or itemid == "joint" or itemid == "ecstasy" or itemid == "shroom" or itemid == "blunt" or itemid == "adderall" or itemid == "xanax" or itemid == "lean" or itemid == "phoenix_joint" or itemid == "pill_ftl") then
        TriggerEvent('takedrugs', itemid)
        remove = false
    end

    if (itemid == "treat") then
        TriggerEvent('houseRobberies:friendlyDog')
        local model = GetEntityModel(PlayerPedId())
        if model == `a_c_shepherd` then
            local t = exports["erp-progressbar"]:taskBar(2000,"Eating Treat")
            if t == 100 then
                TriggerEvent('erp-status:add', 'hunger', math.random(1625, 2000))
                TriggerEvent('erp-status:add', 'thirst', math.random(1625, 2000))
            end
        end
    end  

    if (itemid == "IFAK") then
        TriggerEvent('vicodin:heal', itemid)
    end

    if (itemid == "cleanwipes") then
        loadAnimDict("move_m@_idles@shake_off")
        TaskPlayAnim( PlayerPedId(), "move_m@_idles@shake_off", "shakeoff_1", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
        Wait(3500)
        ClearPedTasks(PlayerPedId())
        ClearPedBloodDamage(PlayerPedId())
        TriggerServerEvent('erp-status:removeStatus', 'Body Sweat')
        TriggerEvent("inventory:removeItem",itemid, 1)
    end

    if (itemid == "potbrownie" or itemid == "potcookie") then
        local itemname = ""
        if itemid == "potbrownie" then itemname = "Brownie" else itemname = "Cookie" end
        AttachPropAndPlayAnimation("mp_player_inteat@burger", "mp_player_int_eat_burger", 49,6000,"Eating "..itemname,"changehunger",true,itemid)
        TriggerEvent('erp-status:add', 'hunger', math.random(400, 600))
        TriggerEvent('erp-status:add', 'thirst', math.random(400, 600))
        TriggerEvent("updatestress", -math.random(100,200))
        SetTimecycleModifier("DRUG_2_drive") -- BloomMid, Barry1_Stoned, DRUG_2_drive
        SetPedMotionBlur(playerPed, true)
        ClearPedTasks(PlayerPedId())
        TriggerServerEvent('erp-status:applyStatus', 'Red Eyes')
        TriggerServerEvent('erp-status:applyStatus', 'Smells Like Marijuana')
        canOpenInventory = true
        Wait(math.random(15000, 45000))
        Normal()
    end

    TriggerEvent('erp-carstatus:itemUsage', itemid)

    if (itemid == "vicodin") then
        TriggerEvent('vicodin:heal', itemid)
        remove = false
    end

    if (itemid == "jailfood" or itemid == "bleederburger" or itemid == "heartstopper" or itemid == "torpedo" or itemid == "meatfree" or itemid == "moneyshot" or itemid == "fries" or itemid == "gummybears") then
        AttachPropAndPlayAnimation("mp_player_inteat@burger", "mp_player_int_eat_burger", 49,6000,"Eating","changehunger",true,itemid,playerVeh)
    end

    if (itemid == "legacyvipcard_gold") or (itemid == "legacyvipcard_platinum") or (itemid == "legacyvipcard_diamond") or (itemid == "legacyvipcard_legendary") then
        local validCards = {
            ['legacyvipcard_gold'] = "Gold",
            ['legacyvipcard_platinum'] = "Platinum",
            ['legacyvipcard_diamond'] = "Diamond",
            ['legacyvipcard_legendary'] = "Legendary",
        }
        local card = validCards[itemid]
        if ItemInfo and ItemInfo['information'] then
            local uhh = json.decode(ItemInfo['information'])
            local cid = uhh['Cid']
            local plyData = exports['echorp']:GetPlayerData()
            if tonumber(cid) == plyData['cid'] then 
                local info = {cid = plyData['cid'], msg = "Legacy VIP("..card..") - "..plyData['fullname']}
                TriggerServerEvent('erp-scripts:showCard',card,info)
            else
                exports['mythic_notify']:SendAlert('inform', 'This card is not registered to you.')
            end
        else
            exports['mythic_notify']:SendAlert('inform', 'Seems like an invalid card.')
        end
    end

    if (itemid == "cncmembership_bronze") or (itemid == "cncmembership_silver") or (itemid == "cncmembership_gold") or (itemid == "cncmembership_diamond") or (itemid == "cncmembership_sapphire") then
        local validCards = {
            ['cncmembership_bronze'] = "Bronze",
            ['cncmembership_silver'] = "Silver",
            ['cncmembership_gold'] = "Gold",
            ['cncmembership_diamond'] = "Diamond",
            ['cncmembership_sapphire'] = "Sapphire",
        }
        local card = validCards[itemid]
        if ItemInfo and ItemInfo['information'] then
            local uhh = json.decode(ItemInfo['information'])
            local cid = uhh['Cid']
            local plyData = exports['echorp']:GetPlayerData()
            if tonumber(cid) == plyData['cid'] then 
                local info = {cid = plyData['cid'], msg = "CNC Member("..card..") - "..plyData['fullname']}
                TriggerServerEvent('erp-scripts:showCard',card,info)
            else
                exports['mythic_notify']:SendAlert('inform', 'This card is not registered to you.')
            end
        else
            exports['mythic_notify']:SendAlert('inform', 'Seems like an invalid card.')
        end
    end

    if (itemid == "mzinsurance_bronze") or (itemid == "mzinsurance_silver") or (itemid == "mzinsurance_gold") or (itemid == "mzinsurance_diamond") then
        local validCards = {
            ['mzinsurance_bronze'] = "Bronze",
            ['mzinsurance_silver'] = "Silver",
            ['mzinsurance_gold'] = "Gold",
            ['mzinsurance_diamond'] = "Diamond",
        }
        local card = validCards[itemid]
        if ItemInfo and ItemInfo['information'] then
            local uhh = json.decode(ItemInfo['information'])
            local cid = uhh['Cid']
            local plyData = exports['echorp']:GetPlayerData()
            if tonumber(cid) == plyData['cid'] then 
                local info = {cid = plyData['cid'], msg = "MZ Insurance("..card..") - "..plyData['fullname']}
                TriggerServerEvent('erp-scripts:showCard',card,info)
            else
                exports['mythic_notify']:SendAlert('inform', 'This card is not registered to you.')
            end
        else
            exports['mythic_notify']:SendAlert('inform', 'Seems like an invalid card.')
        end
    end

    if remove then
        TriggerEvent("inventory:removeItem",itemid, 1)
    end

    Wait(250)
    retardCounter = 0
    canOpenInventory = true
    justUsed, retardCounter, lastCounter = false, 0, 0
end)

function AttachPropAndPlayAnimation(dictionary,animation,typeAnim,timer,message,func,remove,itemid,vehicle)
    if itemid == "hamburger" or itemid == "bbqbcburger" or itemid == "dbaconcb" or itemid == "hamburger" or itemid == 'impossibleburger' then
        TriggerEvent("attachItem", "hamburger")
    elseif itemid == "sandwich" or itemid == "bbqribsandwich" or itemid == "bread" or itemid == "bfsandwich" then
        TriggerEvent("attachItem", "sandwich")
    elseif itemid == "chocolate" or itemid == "cookie" or itemid == "energybar" then
        TriggerEvent("attachItem", "chocolate")
    elseif itemid == "donut" then
        TriggerEvent("attachItem", "donut")
    elseif itemid == "chips" or itemid == "nachos" or itemid == "bagofnuts" then
        TriggerEvent("attachItem", "chips")
    elseif itemid == "water" or itemid == "cocacola" or itemid == 'mtnshlew' or itemid == "vodka" or itemid == "tequilasunrise" or itemid == 'cognac' or itemid == 'champagne' or itemid == "potatovodka" or itemid == "whiskey" or itemid == "beer" or itemid == "colada" or itemid == "coffee" or itemid == "hotchoccy" or itemid == 'icetea' or itemid == 'frappuccino' then
        if itemid == 'frappuccino' or itemid == "hotchoccy" then 
            local itemid = 'coffee'
            TriggerEvent("attachItem", itemid)
        elseif itemid == 'dirtyshirley' or itemid == "colada" or itemid == "potatovodka" or itemid == 'cognac' or itemid == 'tequilasunrise' then
            local itemid = 'vodka'
            TriggerEvent("attachItem", itemid)
        elseif itemid == 'jac' then
            local itemid = 'whiskey'
            TriggerEvent("attachItem", itemid)
        elseif itemid == 'icedteafmb' then 
            local itemid = 'whiskey'
            TriggerEvent("attachItem", itemid)
        elseif itemid == 'arnoldpalmer' then 
            local itemid = 'whiskey'
            TriggerEvent("attachItem", itemid)
        elseif itemid == 'mtnshlew' then
            local itemid = 'cocacola'
            TriggerEvent("attachItem", itemid)
        else
            TriggerEvent("attachItem", itemid)
        end
    elseif itemid == "fishtaco" or itemid == "taco" or itemid == "vegantaco" or itemid == "breakfastburrito" then
        TriggerEvent("attachItem", "taco")
    elseif itemid == "greencow" or itemid == "potatojuice" or itemid == "potatoshake" then
        TriggerEvent("attachItem", "energydrink")
    elseif itemid == "slushy" or itemid == 'rootbeerfloat' then
        TriggerEvent("attachItem", "cup")
    elseif itemid == "firstaidkit" or itemid == "medbag" then
        TriggerEvent("attachItem", "firstaidkit")
    elseif itemid == "ibuprofen" then
        TriggerEvent("attachItem", "pills")
    end
    TaskItem(dictionary, animation, typeAnim, timer, message, func, remove, itemid,vehicle)
    TriggerEvent("destroyProp")
end

RegisterNetEvent('randPickupAnim')
AddEventHandler('randPickupAnim', function()
    local model = GetEntityModel(PlayerPedId())
    if model ~= `a_c_shepherd` then
        loadAnimDict('pickup_object')
        TaskPlayAnim(PlayerPedId(),'pickup_object', 'putdown_low',5.0, 1.5, 1.0, 48, 0.0, 0, 0, 0)
        Wait(1000)
        ClearPedSecondaryTask(PlayerPedId())
    end
end)

local clientInventory = {};

RegisterNetEvent('current-items')
AddEventHandler('current-items', function(inv)
    clientInventory = inv
    checkForAttachItem()
end)

function checkForAttachItem()
    local AttatchItems = {
        "stolenledtv",
        "stolenmicrowave",
        "stolenpc",
        "stolenlqart",
        "stolenmqart",
        "stolenhqart",
        "stolenoldtv",
        "stolenlamp",
        "stolenmonitor",
        "stolenwashingmachine",
        "stolenspeakers",
        "stolenposter"
    }

    local itemToAttach = "none"
    local itemId = 0
    local itemInformation = {}

    for k,v in pairs(clientInventory) do
        if v['item_id'] == 'weedplant' then
            itemToAttach = 'weedplant'
            itemId = v['id']
            itemInformation = json.decode(v['information'])
            break
        end
    end

    for k,v in pairs(AttatchItems) do
        if getQuantity(v) >= 1 then
            itemToAttach = v
            break
        end
    end

    TriggerEvent("animation:carry",itemToAttach,true,itemId)
end

AddEventHandler('oxygentank', function()
    local plyPed = PlayerPedId()
    local coords = GetEntityCoords(plyPed)
	local boneIndex = GetPedBoneIndex(plyPed, 12844)
	local boneIndex2 = GetPedBoneIndex(plyPed, 24818)

    if not HasModelLoaded(`p_s_scuba_mask_s`) and IsModelInCdimage(`p_s_scuba_mask_s`) then RequestModel(`p_s_scuba_mask_s`) while not HasModelLoaded(`p_s_scuba_mask_s`) do Wait(50) end end
    local scubamask = CreateObject(`p_s_scuba_mask_s`, coords, true, false, true)
    

    if not HasModelLoaded(`p_s_scuba_tank_s`) and IsModelInCdimage(`p_s_scuba_tank_s`) then RequestModel(`p_s_scuba_tank_s`) while not HasModelLoaded(`p_s_scuba_tank_s`) do Wait(50) end end
    local scubatank = CreateObject(`p_s_scuba_tank_s`, coords.x, coords.y, coords.z-3, true, false, true)
    
    AttachEntityToEntity(scubatank, plyPed, boneIndex2, -0.30, -0.22, 0.0, 0.0, 90.0, 180.0, true, true, false, true, 1, true)
	AttachEntityToEntity(scubamask, plyPed, boneIndex, 0.0, 0.0, 0.0, 0.0, 90.0, 180.0, true, true, false, true, 1, true)

    local oxygenTime = 30000

    CreateThread(function()

        SetPedDiesInWater(plyPed, false)
        exports['mythic_notify']:SendAlert('inform', 'Oxygen tank applied at 100%', 7500)

        while true do
            Wait(0)

            if IsEntityInWater(plyPed) then
                oxygenTime = oxygenTime - 1
            else 
                oxygenTime = oxygenTime - 0.5
            end

            if math.ceil(oxygenTime) == 22500 then
                exports['mythic_notify']:SendAlert('inform', '75% oxygen tank usage remaining', 7500)
            elseif math.ceil(oxygenTime) == 15000 then
                exports['mythic_notify']:SendAlert('inform', '50% oxygen tank usage remaining', 7500)
            elseif math.ceil(oxygenTime) == 7500 then
                exports['mythic_notify']:SendAlert('inform', '25% oxygen tank usage remaining', 7500)
            elseif math.ceil(oxygenTime) == 3000 then
                exports['mythic_notify']:SendAlert('inform', '10% oxygen tank usage remaining', 7500)
            elseif math.ceil(oxygenTime) == 1500 then
                exports['mythic_notify']:SendAlert('inform', '5% oxygen tank usage remaining', 7500)
            elseif math.ceil(oxygenTime) <= 0 then
                SetPedDiesInWater(plyPed, true)
                DeleteObject(scubamask)
                DeleteObject(scubatank)
            end                        
        end
    end)

    SetModelAsNoLongerNeeded(`p_s_scuba_mask_s`)
    SetModelAsNoLongerNeeded(`p_s_scuba_tank_s`)

end)

function GetItemInfo(checkslot)
    for i,v in pairs(clientInventory) do
        if (tonumber(v.slot) == tonumber(checkslot)) then
            local info = {["information"] = v.information,["id"] = v.id, ["quality"] = v.quality }
            return info
        end
    end
    return "No information stored";
end

exports("getInventory", function() 
    return clientInventory 
end) -- exports['erp-inventory']:getInventory()

exports("canOpenInventory", function() 
    return canOpenInventory 
end) -- exports['erp-inventory']:canOpenInventory()

-- item id, amount allowed, crafting.
function CreateCraftOption(id, add, craft)
    TriggerEvent("CreateCraftOption", id, add, craft)
end

-- Animations
function loadAnimDict(dict) while (not HasAnimDictLoaded(dict)) do RequestAnimDict(dict) Citizen.Wait(5) end end

function TaskItem(dictionary,animation,typeAnim,timer,message,func,remove,itemid,playerVeh)
    loadAnimDict( dictionary ) 
    TaskPlayAnim( PlayerPedId(), dictionary, animation, 8.0, 1.0, -1, typeAnim, 0, 0, 0, 0 )
    local timer = tonumber(timer)
    if timer > 0 then
        local finished = exports["erp-progressbar"]:taskBar(timer,message,true,false,playerVeh)
        if finished == 100 or timer == 0 then
            if hasEnoughOfItem(itemid,1,false) then
                TriggerEvent(func, itemid)
            else
                print("Tried to exploit me?!")
            end
        end
    else
        if hasEnoughOfItem(itemid,1,false) then
            TriggerEvent(func, itemid)
        else
            print("Tried to exploit me?!")
        end
    end

    ClearPedTasks(PlayerPedId())
    if remove then
        TriggerEvent("inventory:removeItem",itemid, 1)
    end
end

RegisterNetEvent('food:breakfast')
AddEventHandler('food:breakfast', function(item)
    if item == 'eggsbacon' then
        if Breakfast() then
            if hasEnoughOfItem(item,1,false) then
                exports['mythic_notify']:SendAlert('inform', 'Good morning! What a great time to have some breakfast.', 7500)
                TriggerEvent('erp-status:add', 'hunger', math.random(2250, 2500))
            else
                print("dONT exploit me motheryacker.")
            end
        else
            if hasEnoughOfItem(item,1,false) then
                exports['mythic_notify']:SendAlert('inform', 'Good mor- oh, it\'s not... not the best time to have some breakfast.', 7500)
                TriggerEvent('erp-status:add', 'hunger', math.random(1750, 2250))
            else
                print("DID I NOT TEACH YOU ANYTHING?")
            end
        end
    elseif item == 'fishchips' then
        if Breakfast() then
            if hasEnoughOfItem(item,1,false) then
                exports['mythic_notify']:SendAlert('inform', 'Yummy! Some Fish & Chips... are we in Britain?', 7500)
                TriggerEvent('erp-status:add', 'hunger', math.random(2500, 2750))
            else
                print("dONT exploit me motheryacker.")
            end
        else
            if hasEnoughOfItem(item,1,false) then
                exports['mythic_notify']:SendAlert('inform', 'Yummy! Some Fish & Chips... are we in Britain?', 7500)
                TriggerEvent('erp-status:add', 'hunger', math.random(2250, 2500))
            else
                print("DID I NOT TEACH YOU ANYTHING?")
            end
        end
    end
end)


function GetCurrentWeapons()
    local returnTable = {}
    for i,v in pairs(clientInventory) do
        if (tonumber(v.item_id)) then
            local t = { ["hash"] = v.item_id, ["id"] = v.id, ["information"] = v.information, ["name"] = v.item_id, ["slot"] = v.slot }
            returnTable[#returnTable+1]=t
        end
    end   
    if returnTable == nil then
        return {}
    end
    return returnTable
end

function getQuantity(itemid)
    local amount = 0
    for i,v in pairs(clientInventory) do
        if (v.item_id == itemid) then
            amount = amount + v.amount
        end
    end
    return amount
end

function getItemDetails(itemid)
    local items = {}
    for i,v in pairs(clientInventory) do
        if (v.item_id == itemid) then
            items[#items+1] = v
        end
    end
    return items
end
exports("getItemDetails", getItemDetails)

function hasEnoughOfItem(itemid,amount,shouldReturnText)
    if shouldReturnText == nil then shouldReturnText = true end
    if itemid == nil or itemid == 0 or amount == nil or amount == 0 then if shouldReturnText then TriggerEvent("notification","I dont seem to have " .. itemid .. " in my pockets.",2) end return false end
    amount = tonumber(amount)
    local slot = 0
    local found = false

    if getQuantity(itemid) >= amount then
        return true
    end
    return false
end


function isValidUseCase(itemID,isWeapon)
    local player = PlayerPedId()
    local playerVeh = GetVehiclePedIsIn(player, false)
    if playerVeh ~= 0 then
        local model = GetEntityModel(playerVeh)
        if IsThisModelACar(model) or IsThisModelABike(model) or IsThisModelAQuadbike(model) then
            if IsEntityInAir(playerVeh) then
                Wait(1000)
                if IsEntityInAir(playerVeh) then
                    exports['mythic_notify']:SendAlert('inform', 'You appear to be flying through the air.', 5000)
                    return false
                end
            end
        end
    end

    if not validWaterItem[itemID] and not isWeapon then
        if IsPedSwimming(player) then
            local targetCoords = GetEntityCoords(player, 0)
            Wait(700)
            local plyCoords = GetEntityCoords(player, 0)
            if #(targetCoords - plyCoords) > 1.3 then
                exports['mythic_notify']:SendAlert('inform', 'You cannot swim whilst using this item.', 5000)
                return false
            end
        end

        if IsPedSwimmingUnderWater(player) then
            exports['mythic_notify']:SendAlert('inform', 'You cannot be underwater and use this item.', 5000)
            return false
        end
    end

    return true
end

-- Drugs

function Normal()
    ClearTimecycleModifier() ResetScenarioTypesEnabled()
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
    SetPedMotionBlur(PlayerPedId(), false)
    ResetPedMovementClipset(PlayerPedId())
    ResetPedWeaponMovementClipset(PlayerPedId())
    ResetPedStrafeClipset(PlayerPedId())
    Opium = false
end

local methActive = false

function isMethActive() return methActive end
exports("isMethActive", isMethActive) -- exports["erp-inventory"]:isMethActive()

local canJoint = true

RegisterNetEvent('takedrugs')
AddEventHandler('takedrugs', function(type)
    local playerPed = PlayerPedId()
    local maxHealth = 200
    local player = PlayerId()
    local health = GetEntityHealth(playerPed)

    canOpenInventory = false

    -- TriggerEvent("inventory:removeItem",itemid, 1)
    
    if type == "meth" then
        TriggerEvent("inventory:removeItem",type, 1)
        TriggerEvent('play:anim', type)
        local f = exports["erp-progressbar"]:taskBar(5000,"Meth")
        canOpenInventory = true
        if f == 100 then

            SetTimecycleModifier("BeastIntro01")
            SetPedMotionBlur(playerPed, true)

            RequestAnimSet("move_f@hurry@a") 
            while not HasAnimSetLoaded("move_f@hurry@a") do Wait(0) end
            SetPedMovementClipset(playerPed, "move_f@hurry@a", true)
            TriggerEvent('saveWalk', "move_f@hurry@a")

            overdoseC = overdoseC + math.random(200, 300)
            methActive = true

            TriggerServerEvent('erp-status:applyStatus', 'Dialated Eyes')
            TriggerServerEvent('erp-status:applyStatus', 'Body Sweat')
            TriggerServerEvent('erp-status:applyStatus', 'Labored Breathing')

            Wait(math.random(45000, 75000))

            methActive = false
            TriggerEvent("updatestress", math.random(750, 1250))

            Normal()
        end
    elseif type == "refinedmeth" then 
        TriggerEvent("inventory:removeItem",type, 1)
        TriggerEvent('play:anim', type)
        local f = exports["erp-progressbar"]:taskBar(5000,"Meth")
        canOpenInventory = true
        if f == 100 then

            SetTimecycleModifier("BeastIntro01")
            SetPedMotionBlur(playerPed, true)

            RequestAnimSet("move_f@hurry@a") 
            while not HasAnimSetLoaded("move_f@hurry@a") do Wait(0) end
            SetPedMovementClipset(playerPed, "move_f@hurry@a", true)
            TriggerEvent('saveWalk', "move_f@hurry@a")

            overdoseC = overdoseC + math.random(200, 300)
            methActive = true

            CreateThread(function() -- No tazing
                while methActive do
                    Wait(0)
                    if IsPedBeingStunned(playerPed, 0) then
                        ClearPedTasksImmediately(playerPed)
                    end 
                    SetPedCanRagdoll(playerPed, false)
                end
            end)

            TriggerServerEvent('erp-status:applyStatus', 'Dialated Eyes')
            TriggerServerEvent('erp-status:applyStatus', 'Body Sweat')
            TriggerServerEvent('erp-status:applyStatus', 'Labored Breathing')

            Wait(math.random(60000, 90000))

            methActive = false
            SetPedCanRagdoll(playerPed, true)
            TriggerEvent("updatestress", math.random(750, 1250))

            Normal()
        end
    elseif type == "coke" then
        TriggerEvent("inventory:removeItem",type, 1)
        CokeAnim()
        local finished = exports["erp-progressbar"]:taskBar(9000,"Enjoying Coke")
        canOpenInventory = true
        if finished == 100 then
            SetTimecycleModifier("Barry1_Stoned") 
            SetPedMotionBlur(playerPed, true)
            SetTimecycleModifierStrength(2.0)
            SetPedMovementClipset(playerPed, "anim@amb@nightclub@peds@", true)
            TriggerEvent('saveWalk', "anim@amb@nightclub@peds@")
            overdoseC = overdoseC + math.random(175, 225)
            AddArmourToPed(playerPed, 50)
            local newHealth = math.min(maxHealth , math.floor(health + maxHealth/6))
            SetEntityHealth(playerPed, newHealth)
            --SetRunSprintMultiplierForPlayer(player, 1.3)
            Wait(2500)
            ClearPedTasks(PlayerPedId())
            TriggerServerEvent('erp-status:applyStatus', 'Dialated Eyes')
            if math.random(100) >= 75 then
                TriggerServerEvent('erp-status:applyStatus', 'Agitated')
            end
            Wait(math.random(45000, 75000))
            TriggerEvent("updatestress", 500)
            overdoseC = overdoseC - math.random(150, 200)
            --SetRunSprintMultiplierForPlayer(player, 1.0)            
            Normal()
        end
    elseif type == "adderall" then
        TriggerEvent("inventory:removeItem",type, 1)
        TriggerEvent('play:anim', type)
        local finished = exports["erp-progressbar"]:taskBar(5500,"Adderall Time")
        canOpenInventory = true
        if finished == 100 then
            SetTimecycleModifier("LostTimeFlash") -- BloomMid, Barry1_Stoned, DRUG_2_drive
            SetTimecycleModifierStrength(1.0)
            SetPedMotionBlur(playerPed, true)
            RequestAnimSet("move_m@quick")
            while not HasAnimSetLoaded("move_m@quick") do Wait(0) end
            SetPedMovementClipset(playerPed, "move_m@quick", true)
            TriggerEvent('saveWalk', "move_m@quick")
            overdoseC = overdoseC + math.random(150, 200)
            SetRunSprintMultiplierForPlayer(player, 1.3)
            TriggerServerEvent('erp-status:applyStatus', 'Dialated Eyes')
            TriggerServerEvent('erp-status:applyStatus', 'Body Sweat')
            Wait(math.random(25000, 35000))
            TriggerEvent("updatestress", 500)
            overdoseC = overdoseC - math.random(125, 175)
            Normal()
        end
    elseif type == "xanax" then
        TriggerEvent("inventory:removeItem",type, 1)
        TriggerEvent('play:anim', type)

        local finished = exports["erp-progressbar"]:taskBar(math.random(4000, 4500),"Xanny")
        canOpenInventory = true
        if finished == 100 then
            TriggerEvent('xanax:screeneffect')
            SetPedMotionBlur(playerPed, true)

            RequestAnimSet("move_m@hobo@a")
            while not HasAnimSetLoaded("move_m@hobo@a") do Wait(0) end
            SetPedMovementClipset(playerPed, "move_m@hobo@a", true)
            TriggerEvent('saveWalk', "move_m@hobo@a")

            overdoseC = overdoseC + math.random(150, 200)
            TriggerServerEvent('erp-status:applyStatus', 'Dialated Eyes')
            Wait(math.random(25000, 35000))
            TriggerEvent("updatestress", -math.random(1200, 1500))
            overdoseC = overdoseC - math.random(125, 175)
            Normal()
        end
    elseif type == "lean" then
        TriggerEvent("inventory:removeItem",type, 1)
        TriggerEvent('play:anim', type)

        local finished = exports["erp-progressbar"]:taskBar(math.random(7500, 8000),"Lean")
        canOpenInventory = true
        if finished == 100 then
            DoScreenFadeOut(math.random(250, 500))
            drunkLevel = drunkLevel + math.random(45, 50)
            Wait(math.random(500, 750))
            DoScreenFadeIn(math.random(250, 500))
            TriggerServerEvent('erp-status:applyStatus', 'Enlarged Pupils')
            SetPedMotionBlur(playerPed, true)
            TriggerServerEvent('erp-status:applyStatus', 'Body Sweat')
            TriggerEvent("updatestress", math.random(400, 600))
        end
    elseif type == "opium" then
        TriggerEvent("inventory:removeItem",type, 1)
        RequestAnimSet("move_m@drunk@moderatedrunk") 
        while not HasAnimSetLoaded("move_m@drunk@moderatedrunk") do Wait(0) end
        TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_SMOKING_POT", 0, 1)

        --if hasEnoughOfItem(type,1,false) then
            local opiumyababy = exports["erp-progressbar"]:taskBar(5000,"Smoking Opium")
            canOpenInventory = true
            if opiumyababy == 100 then
                SetTimecycleModifier("BlackOut") SetTimecycleModifierStrength(0.7)
                SetPedMotionBlur(playerPed, true)
                SetPedMovementClipset(playerPed, "move_m@drunk@moderatedrunk", true)
                TriggerEvent('saveWalk', "move_m@drunk@moderatedrunk")
                overdoseC = overdoseC + math.random(100, 200)
                SetSwimMultiplierForPlayer(player, 1.3)
                TriggerServerEvent('erp-status:applyStatus', 'Red Eyes')
                Opium = true
                CreateThread(function()
                    while true do
                        Wait(5000)
                        if not Opium then return end
                        if math.random(1, 100) > 80 then SetPedToRagdoll(PlayerPedId(), 10000, 7500, 0, 0, 0, 0) Wait(7500) end
                    end
                end)
                if math.random(100) >= 75 then
                    TriggerServerEvent('erp-status:applyStatus', 'Uncoordinated')
                end
                TriggerEvent("updatestress", -1250)
                ClearPedTasks(PlayerPedId())
                Wait(math.random(60000, 90000))
                overdoseC = overdoseC - 100
                Opium = false
                SetRunSprintMultiplierForPlayer(player, 1.0)
                SetSwimMultiplierForPlayer(player, 1.0)
                Normal()
            end
        ----else
           -- print("Hmm, tryna exploit drugs in the inventory... I see.")
       -- end
    elseif type == "joint" then

        if not canJoint then
            exports['mythic_notify']:SendAlert('inform', 'Unable to use this just yet.', 5000)
            return
        end

        TriggerEvent("inventory:removeItem",type, 1)
        WeedAnim()
        canJoint = false
        local m = exports["erp-progressbar"]:taskBar(5000,"Smoking Joint",true,true,true)
        canOpenInventory = true
        if m == 100 then
            SetTimecycleModifier("DRUG_2_drive") -- BloomMid, Barry1_Stoned, DRUG_2_drive
            SetPedMotionBlur(playerPed, true)
            local newHealth = math.min(maxHealth , math.floor(health + maxHealth/8))
            SetEntityHealth(playerPed, newHealth)
            TriggerEvent('erp-status:remove', 'hunger', math.random(400, 600))
            TriggerEvent('erp-status:remove', 'thirst', math.random(400, 600))
            --TriggerEvent("updatestress", -1000)
            --ClearPedTasks(PlayerPedId())
            TriggerServerEvent('erp-status:applyStatus', 'Red Eyes')
            TriggerServerEvent('erp-status:applyStatus', 'Smells Like Marijuana')
            Wait(math.random(20000, 35000))
            canJoint = true
            Wait(math.random(40000, 55000))
            Normal()
        else
            canJoint = true
        end
    elseif type == "blunt" then

        if not canJoint then
            exports['mythic_notify']:SendAlert('inform', 'Unable to use this just yet.', 5000)
            return
        end

        TriggerEvent("inventory:removeItem",type, 1)
        BluntAnim()
        canJoint = false
        local b = exports["erp-progressbar"]:taskBar(5000,"Smoking Blunt",true,true,true)
        canOpenInventory = true
        if b == 100 then
            SetTimecycleModifier("DRUG_2_drive") -- BloomMid, Barry1_Stoned, DRUG_2_drive
            SetPedMotionBlur(playerPed, true)
            local newHealth = math.min(maxHealth , math.floor(health + maxHealth/6))
            SetEntityHealth(playerPed, newHealth)
            TriggerEvent('erp-status:remove', 'hunger', math.random(300, 500))
            TriggerEvent('erp-status:remove', 'thirst', math.random(300, 500))
            TriggerServerEvent('erp-status:applyStatus', 'Red Eyes')
            TriggerServerEvent('erp-status:applyStatus', 'Smells Like Marijuana')
            Wait(math.random(25000, 40000))
            canJoint = true
            Wait(math.random(45000, 60000))
            Normal()
        else 
            canJoint = true
        end
    elseif type == "phoenix_joint" then

        if not canJoint then
            exports['mythic_notify']:SendAlert('inform', 'Unable to use this just yet.', 5000)
            return
        end

        TriggerEvent("inventory:removeItem",type, 1)
        PhoenixAnim()
        canJoint = false
        local b = exports["erp-progressbar"]:taskBar(5000,"Smoking Phoenix",true,true,true)
        canOpenInventory = true
        if b == 100 then
            SetTimecycleModifier("DRUG_2_drive") -- BloomMid, Barry1_Stoned, DRUG_2_drive
            SetPedMotionBlur(playerPed, true)
            local newHealth = math.min(maxHealth , math.floor(health + maxHealth/6))
            SetEntityHealth(playerPed, newHealth)
            TriggerEvent('erp-status:remove', 'hunger', math.random(200, 400))
            TriggerEvent('erp-status:remove', 'thirst', math.random(200, 400))
            TriggerServerEvent('erp-status:applyStatus', 'Red Eyes')
            TriggerServerEvent('erp-status:applyStatus', 'Smells Like Marijuana')
            Wait(math.random(30000, 45000))
            canJoint = true
            Wait(math.random(50000, 65000))
            Normal()
        else
            canJoint = true
        end
    elseif type == "ecstasy" then
        TriggerEvent("inventory:removeItem",type, 1)
        local biggie = exports["erp-progressbar"]:taskBar(5000,"I warned ya")
        canOpenInventory = true
        if biggie == 100 then
            overdoseC = overdoseC + math.random(150, 300)
            AddArmourToPed(playerPed, math.random(5, 15))
            if IsPedMale(playerPed) then
                RequestAnimSet("move_m@sassy")
                SetPedMovementClipset(playerPed, "move_m@sassy", true)
                TriggerEvent('saveWalk', "move_m@sassy")
            else
                RequestAnimSet("move_f@sassy")
                SetPedMovementClipset(playerPed, "move_f@sassy", true)
                TriggerEvent('saveWalk', "move_f@sassy")
            end        
            
            if math.random(100) >= 75 then
                TriggerServerEvent('erp-status:applyStatus', 'Uncoordinated')
            end

            TriggerServerEvent('erp-status:applyStatus', 'Dialated Eyes')
            exports["acidtrip"]:DoAcid(180000 + 30000, 'JloEBKe64_4')
            TriggerEvent('erp-status:remove', 'thirst', math.random(500, 750))
            Wait(180000 + 30000)
            overdoseC = overdoseC - 225
            Normal()
            ResetPedMovementClipset(playerPed)
            ResetPedWeaponMovementClipset(playerPed)
            ResetPedStrafeClipset(playerPed)
        end
    elseif type == "shroom" then
        TriggerEvent("inventory:removeItem",type, 1)
        local fungitime = exports["erp-progressbar"]:taskBar(5000,"Yum, some fungi...")
        canOpenInventory = true
        if fungitime == 100 then
            exports["acidtrip"]:DoAcid(180000 + 12000, 'lCkd4SdCIoo')
        end
    elseif type == "pill_ftl" then
        TriggerEvent("inventory:removeItem",type, 1)
        TriggerEvent('play:anim', "adderall")
        local finished = exports["erp-progressbar"]:taskBar(5500,"You actually took it?!?!")
        canOpenInventory = true
        if finished == 100 then
            local timer = math.random(6000, 12000)
            SetRunSprintMultiplierForPlayer(player, 1.49)
            SetTimecycleModifier("LostTimeFlash") -- BloomMid, Barry1_Stoned, DRUG_2_drive
            SetTimecycleModifierStrength(1.0)
            SetPedMotionBlur(playerPed, true)
            RequestAnimSet("move_m@quick")
            while not HasAnimSetLoaded("move_m@quick") do Wait(0) end
            SetPedMovementClipset(playerPed, "move_m@quick", true)
            TriggerEvent('saveWalk', "move_m@quick")
            overdoseC = overdoseC + math.random(200, 250)
            TriggerServerEvent('erp-status:applyStatus', 'Dialated Eyes')
            TriggerServerEvent('erp-status:applyStatus', 'Body Sweat')
            while timer ~= 0 do
                Wait(10)
                local hadap = GetEntityForwardVector(playerPed)
                if IsPedRunning(playerPed) then
                    ApplyForceToEntity(playerPed, 1, hadap.x*1.2, hadap.y*1.2, hadap.z*1.2, 0, 0, 0, 1, false, true, true, true, true);
                end
                timer = timer - 1
            end
            TriggerEvent('erp-status:remove', 'hunger', math.random(2500, 5000))
            TriggerEvent('erp-status:remove', 'thirst', math.random(2500, 5000))
            TriggerEvent("updatestress", 2500)
            overdoseC = overdoseC - math.random(150, 200)
            Normal()
        end
    end
end)

AddEventHandler('xanax:screeneffect', function()
    for i=1, math.random(6, 9) do
        Wait(math.random(500, 750))
        DoScreenFadeOut(math.random(250, 500))
        Wait(math.random(500, 750))
        DoScreenFadeIn(math.random(250, 500))
        if math.random(1, 5) == math.random(1, 5) then
            Wait(100)
            ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.04) -- change this float to increase/decrease camera shake
            SetPedToRagdollWithFall(PlayerPedId(), math.random(750, 1500), 9000, 1, GetEntityForwardVector(PlayerPedId()), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
            Wait(100)
        end
    end
end)

RegisterCommand("magannoying", function(source, args, rawCommand)
    TriggerEvent("updatestress", 500)
end, false) -- set this to false to allow anyo

function CokeAnim()
    RequestAnimDict("anim@amb@nightclub@peds@")
    while not HasAnimDictLoaded("anim@amb@nightclub@peds@") do Citizen.Wait(0) end
    local anim3 = IsEntityPlayingAnim(PlayerPedId(), "anim@amb@nightclub@peds@", "missfbi3_party_snort_coke_b_male3", 3)
    if not anim3 then TaskPlayAnim(PlayerPedId(), "anim@amb@nightclub@peds@", "missfbi3_party_snort_coke_b_male3", 8.0, -8, -1, 16, 0, 0, 0, 0) end
end

function BluntAnim()
    RequestAnimDict("amb@world_human_smoking_pot@male@base")
    while not HasAnimDictLoaded("amb@world_human_smoking_pot@male@base") do Citizen.Wait(0) end
    local ped = PlayerPedId()
    local x, y, z = table.unpack(GetEntityCoords(ped))
    jointProp = CreateObject(`prop_sh_joint_01`, x, y, z+0.2,  true,  true, true)
    AttachEntityToEntity(jointProp, ped, GetPedBoneIndex(ped, 60309), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
    TaskPlayAnim(ped, 'amb@world_human_smoking_pot@male@base', 'base', 8.0, -8, -1, 49, 0, 0, 0, 0)

    local isSmoking = true

    CreateThread(function()
        while true do
            Wait(0)
            if isSmoking then
                if IsPedShooting(ped) then
                    exports['mythic_notify']:SendAlert('inform', 'Shooting and smoking, bad.', 6000)
                    isSmoking = false
                end
            elseif not isSmoking then
                ClearPedTasks(PlayerPedId())
                TriggerServerEvent('deletevehicle:server', NetworkGetNetworkIdFromEntity(jointProp))
                return
            end
        end
    end)

    CreateThread(function()
        local weedCooldown = false
        local timer = GetGameTimer() + math.random(30000, 35000)
        local shouldEnd = false
        
        while isSmoking do
            Wait(500)
           
            print(isSmoking)

            if GetGameTimer() >= timer then shouldEnd = true end

            if shouldEnd then
                exports['mythic_notify']:SendAlert('inform', 'You finished your blunt.', 6000)
                isSmoking = false
                return
            elseif not IsEntityPlayingAnim(ped, "amb@world_human_smoking_pot@male@base", 'base', 3) then
                isSmoking = false
                return
            elseif not weedCooldown and math.random(1, 2) == math.random(1, 2) then
                TriggerEvent("updatestress", -math.random(750,850))
                CreateThread(function() weedCooldown = true Wait(math.random(5000,10000)) weedCooldown = false end)

                if math.random(1, 100) >= 75 then
                    local closestPlayers = GetClosePlayers()
                    if closestPlayers then
                        for k,v in pairs(closestPlayers) do
                            TriggerServerEvent('erp-status:applyStatus', 'Smells Like Marijuana', GetPlayerServerId(v))
                        end
                    end
                end
            elseif math.random(1, 2) == 1 then
                AddArmourToPed(ped, 1)
            end
        end
    end)
end

function WeedAnim()
    RequestAnimDict("amb@world_human_smoking_pot@male@base")
    while not HasAnimDictLoaded("amb@world_human_smoking_pot@male@base") do Citizen.Wait(0) end
    local ped = PlayerPedId()
    local x, y, z = table.unpack(GetEntityCoords(ped))
    jointProp = CreateObject(`prop_sh_joint_01`, x, y, z+0.2,  true,  true, true)
    AttachEntityToEntity(jointProp, ped, GetPedBoneIndex(ped, 60309), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
    TaskPlayAnim(ped, 'amb@world_human_smoking_pot@male@base', 'base', 8.0, -8, -1, 49, 0, 0, 0, 0)

    local isSmoking = true

    CreateThread(function()
        while true do
            Wait(0)
            if isSmoking then
                if IsPedShooting(ped) then
                    exports['mythic_notify']:SendAlert('inform', 'Shooting and smoking, bad.', 6000)
                    isSmoking = false
                end
            elseif not isSmoking then
                ClearPedTasks(PlayerPedId())
                TriggerServerEvent('deletevehicle:server', NetworkGetNetworkIdFromEntity(jointProp))
                return
            end
        end
    end)

    CreateThread(function()
        local weedCooldown = false
        local timer = GetGameTimer() + math.random(30000, 35000)
        local shouldEnd = false
        
        while isSmoking do
            Wait(500)
           
            if GetGameTimer() >= timer then shouldEnd = true end

            if shouldEnd then
                exports['mythic_notify']:SendAlert('inform', 'You finished your joint.', 6000)
                isSmoking = false
                return
            elseif not IsEntityPlayingAnim(ped, "amb@world_human_smoking_pot@male@base", 'base', 3) then
                isSmoking = false
                return
            elseif not weedCooldown and math.random(1, 2) == math.random(1, 2) then
                TriggerEvent("updatestress", -math.random(550,650))
                CreateThread(function() weedCooldown = true Wait(math.random(5000,10000)) weedCooldown = false end)
                if math.random(100) >= 75 then
                    local closestPlayers = GetClosePlayers()
                    if closestPlayers then
                        for k,v in pairs(closestPlayers) do
                            TriggerServerEvent('erp-status:applyStatus', 'Smells Like Marijuana', GetPlayerServerId(v))
                        end
                    end
                end
            elseif math.random(1, 3) == 1 then
                AddArmourToPed(ped, 1)
            end            
        end
    end)
end

function PhoenixAnim()
    RequestAnimDict("amb@world_human_smoking_pot@male@base")
    while not HasAnimDictLoaded("amb@world_human_smoking_pot@male@base") do Citizen.Wait(0) end
    local ped = PlayerPedId()
    local x, y, z = table.unpack(GetEntityCoords(ped))
    jointProp = CreateObject(`prop_sh_joint_01`, x, y, z+0.2,  true,  true, true)
    AttachEntityToEntity(jointProp, ped, GetPedBoneIndex(ped, 60309), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
    TaskPlayAnim(ped, 'amb@world_human_smoking_pot@male@base', 'base', 8.0, -8, -1, 49, 0, 0, 0, 0)

    local isSmoking = true

    CreateThread(function()
        while true do
            Wait(0)
            if isSmoking then
                if IsPedShooting(ped) then
                    exports['mythic_notify']:SendAlert('inform', 'Shooting and smoking, bad.', 6000)
                    isSmoking = false
                end
            elseif not isSmoking then
                ClearPedTasks(PlayerPedId())
                TriggerServerEvent('deletevehicle:server', NetworkGetNetworkIdFromEntity(jointProp))
                return
            end
        end
    end)

    CreateThread(function()
        local weedCooldown = false
        local timer = GetGameTimer() + math.random(30000, 35000)
        local shouldEnd = false
        
        while isSmoking do
            Wait(500)
           
            if GetGameTimer() >= timer then shouldEnd = true end

            if shouldEnd then
                exports['mythic_notify']:SendAlert('inform', 'You finished your joint.', 6000)
                isSmoking = false
                return
            elseif not IsEntityPlayingAnim(ped, "amb@world_human_smoking_pot@male@base", 'base', 3) then
                isSmoking = false
                return
            elseif not weedCooldown and math.random(1, 2) == math.random(1, 2) then
                TriggerEvent("updatestress", -math.random(850,950))
                CreateThread(function() weedCooldown = true Wait(math.random(5000,10000)) weedCooldown = false end)
                if math.random(100) >= 75 then
                    local closestPlayers = GetClosePlayers()
                    if closestPlayers then
                        for k,v in pairs(closestPlayers) do
                            TriggerServerEvent('erp-status:applyStatus', 'Smells Like Marijuana', GetPlayerServerId(v))
                        end
                    end
                end
            else
                AddArmourToPed(ped, 1)
            end            
        end
    end)
end

CreateThread(function()
    while true do
        Wait(2500)
        local plyPed = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(plyPed, false)

        if vehicle ~= 0 then
            local driftState = Entity(vehicle).state.drift
            if driftState then
                if not Entity(vehicle).state.localdrift then
                    DriftHandlings[GetEntityModel(vehicle)] = {
                        ['fInitialDragCoeff'] = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDragCoeff"),
                        ['fInitialDriveForce'] = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDriveForce"),
                        ['fDriveInertia'] = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fDriveInertia"),
                        ['fInitialDriveMaxFlatVel'] = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDriveMaxFlatVel"),
                        ['nInitialDriveGears'] = GetVehicleHandlingFloat(vehicle, "CHandlingData", "nInitialDriveGears"),
                        ['fClutchChangeRateScaleUpShift'] = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fClutchChangeRateScaleUpShift"),
                        ['fClutchChangeRateScaleDownShift'] = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fClutchChangeRateScaleDownShift"),
                        ['fSteeringLock'] = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fSteeringLock"),
                        ['fTractionCurveMax'] = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fTractionCurveMax"),
                        ['fTractionCurveMin'] = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fTractionCurveMin"),
                        ['fTractionCurveLateral'] = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fTractionCurveLateral"),
                        ['fLowSpeedTractionLossMult'] = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fLowSpeedTractionLossMult")
                    }
                    Wait(100)
                    SetVehicleHandlingField(vehicle, "CHandlingData", "fInitialDragCoeff", 30.0)
                    SetVehicleHandlingField(vehicle, "CHandlingData", "fInitialDriveForce", 0.5)
                    SetVehicleEnginePowerMultiplier(vehicle, 30.0)
                    SetVehicleHandlingField(vehicle, "CHandlingData", "fDriveInertia", 1.0)
                    SetVehicleHandlingField(vehicle, "CHandlingData", "fInitialDriveMaxFlatVel", 300.0)
                    SetVehicleHandlingField(vehicle, "CHandlingData", "nInitialDriveGears", 4.0)
                    SetVehicleHandlingField(vehicle, "CHandlingData", "fClutchChangeRateScaleUpShift", 100.0)
                    SetVehicleHandlingField(vehicle, "CHandlingData", "fClutchChangeRateScaleDownShift", 100.0)
                    SetVehicleHandlingField(vehicle, "CHandlingData", "fSteeringLock", 60.0)
                    SetVehicleHandlingField(vehicle, "CHandlingData", "fTractionCurveMax", 1.7)
                    SetVehicleHandlingField(vehicle, "CHandlingData", "fTractionCurveMin", 1.3)
                    SetVehicleHandlingField(vehicle, "CHandlingData", "fTractionCurveLateral", 30.0)
                    SetVehicleHandlingField(vehicle, "CHandlingData", "fLowSpeedTractionLossMult", 0.0)
                    exports['mythic_notify']:SendAlert('inform', 'Drift mode enabled.')
                    Entity(vehicle).state:set('localdrift', true, false)
                end
            elseif Entity(vehicle).state.localdrift then
                local model = GetEntityModel(vehicle)
                SetVehicleHandlingField(vehicle, "CHandlingData", "fInitialDragCoeff", DriftHandlings[model]['fInitialDragCoeff'])
                SetVehicleHandlingField(vehicle, "CHandlingData", "fInitialDriveForce", DriftHandlings[model]['fInitialDriveForce'])
                SetVehicleEnginePowerMultiplier(vehicle, 0.0)
                SetVehicleHandlingField(vehicle, "CHandlingData", "fDriveInertia", DriftHandlings[model]['fDriveInertia'])
                SetVehicleHandlingField(vehicle, "CHandlingData", "fInitialDriveMaxFlatVel", DriftHandlings[model]['fInitialDriveMaxFlatVel'])
                SetVehicleHandlingField(vehicle, "CHandlingData", "nInitialDriveGears", DriftHandlings[model]['nInitialDriveGears'])
                SetVehicleHandlingField(vehicle, "CHandlingData", "fClutchChangeRateScaleUpShift", DriftHandlings[model]['fClutchChangeRateScaleUpShift'])
                SetVehicleHandlingField(vehicle, "CHandlingData", "fClutchChangeRateScaleDownShift", DriftHandlings[model]['fClutchChangeRateScaleDownShift'])
                SetVehicleHandlingField(vehicle, "CHandlingData", "fSteeringLock", DriftHandlings[model]['fSteeringLock'])
                SetVehicleHandlingField(vehicle, "CHandlingData", "fTractionCurveMax", DDriftHandlings[model]['fTractionCurveMax'])
                SetVehicleHandlingField(vehicle, "CHandlingData", "fTractionCurveMin", DriftHandlings[model]['fTractionCurveMin'])
                SetVehicleHandlingField(vehicle, "CHandlingData", "fTractionCurveLateral", DriftHandlings[model]['fTractionCurveLateral'])
                SetVehicleHandlingField(vehicle, "CHandlingData", "fLowSpeedTractionLossMult", DriftHandlings[model]['fLowSpeedTractionLossMult'])
                exports['mythic_notify']:SendAlert('inform', 'Drift mode disabled.')
                Entity(vehicle).state:set('localdrift', false, false)
            end
        end
    end
end)

-- DNA


RegisterNetEvent('evidence:addDnaSwab')
AddEventHandler('evidence:addDnaSwab', function(dna)
    TriggerEvent("notification", "DNA Result: " .. dna,1)    
end)

RegisterNetEvent('CheckDNA')
AddEventHandler('CheckDNA', function()
    TriggerServerEvent("Evidence:checkDna")
end)

RegisterNetEvent('evidence:dnaSwab')
AddEventHandler('evidence:dnaSwab', function()
    t, distance = GetClosestPlayer()
    if(distance ~= -1 and distance < 5) then
        TriggerServerEvent("police:dnaAsk", GetPlayerServerId(t))
    end
end)

RegisterNetEvent('evidence:swabNotify')
AddEventHandler('evidence:swabNotify', function()
    TriggerEvent("notification", "DNA swab taken.",1)
end)

RegisterNetEvent('gloveBox:open')
AddEventHandler('gloveBox:open', function()
    TriggerEvent("server-inventory-open", "DNA swab taken.",1)
end)


function GetPlayers()
    local players = {}

    for i = 0, 255 do
        if NetworkIsPlayerActive(i) then
            players[#players+1]= i
        end
    end

    return players
end

function GetClosestPlayer()
    local closestDistance, closestPlayer = -1, -1
    local plyCoords, plyId, players = GetEntityCoords(PlayerPedId()), PlayerId(), GetActivePlayers()
    for i=1, #players do
        local target = GetPlayerPed(players[i])
        if (players[i] ~= plyId) then
            local targetCoords = GetEntityCoords(target)
            local distance = #(targetCoords - plyCoords)
            if (closestDistance == -1 or closestDistance > distance) then
				closestPlayer = players[i]
				closestDistance = distance
            end
        end 
    end 
    
	return closestPlayer, closestDistance
end


-- DNA AND EVIDENCE END
-- this is the upside down world, be careful.


function getVehicleInDirection(coordFrom, coordTo, specifiedDistance)
    local offset = 0
    local rayHandle
    local vehicle

    if specifiedDistance == nil then specifiedDistance = 20 end

    for i = 0, 100 do
        rayHandle = StartExpensiveSynchronousShapeTestLosProbe(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z + offset, 10, PlayerPedId(), 0)   
        a, b, c, d, vehicle = GetRaycastResult(rayHandle)
        
        offset = offset - 1

        if vehicle ~= 0 then break end
    end

    local distance = #(coordFrom - GetEntityCoords(vehicle))
    if distance > specifiedDistance then vehicle = nil end
    return vehicle ~= nil and vehicle or 0
end
function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)

end

local burgies = 0
RegisterNetEvent('inv:wellfed')
AddEventHandler('inv:wellfed', function()
    TriggerEvent("Evidence:StateSet",25,3600)
    TriggerEvent("changehunger")
    TriggerEvent("changehunger")
    TriggerEvent("client:newStress",false,10)
    TriggerEvent("changehunger")
    TriggerEvent("changethirst")
    burgies = 0
end)

RegisterNetEvent("jerrycananimation")
AddEventHandler("jerrycananimation",function(ped, vehicle)
    while isFueling do
        if #(GetEntityCoords(vehicle) - GetEntityCoords(ped)) > 2.5 then
            if isFueling then
                exports["erp-progressbar"]:closeGuiFail()
                isFueling = false
                exports['mythic_notify']:SendAlert('inform', 'You went too far away from the vehicle.', 5000)
            end
        end

        if GetPedInVehicleSeat(vehicle, -1) ~= 0 then
            if isFueling then
                exports["erp-progressbar"]:closeGuiFail()
                isFueling = false
                exports['mythic_notify']:SendAlert('inform', 'The vehicle drivers seat is occupied!', 5000)
            end
        end

        if IsEntityDead(vehicle) then
            if isFueling then
                exports["erp-progressbar"]:closeGuiFail()
                isFueling = false
                exports['mythic_notify']:SendAlert('inform', 'Somehow the vehicle is dead idk', 5000)
            end
        end
        
        if not IsEntityPlayingAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 3) and isFueling then
	        loadAnimDict("timetable@gardener@filling_can")
            TaskPlayAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 2.0, 8.0, -1, 50, 0, 0, 0, 0)
        end 

        Wait(500)
    end

    ClearPedSecondaryTask(PlayerPedId())
end)

local ChangeHungerItems = {
    ['impossibleburger'] = { ['hunger'] = {['low'] = 2000, ['high'] = 2500}, },
    ['bakedpotato'] = { ['hunger'] = {['low'] = 2000, ['high'] = 2500}, },
    ['bbqribsandwich'] = { ['hunger'] = {['low'] = 2000, ['high'] = 2500}, },
    ['bbqbcburger'] = { ['hunger'] = {['low'] = 2000, ['high'] = 2500}, },
    ['dbaconcb'] = { ['hunger'] = {['low'] = 2000, ['high'] = 2500}, },
    ['burrito'] = { ['hunger'] = {['low'] = 2000, ['high'] = 2500}, },
    ['breakfastburrito'] = { ['hunger'] = {['low'] = 2000, ['high'] = 2500}, },
    ['taco'] = { ['hunger'] = {['low'] = 2000, ['high'] = 2500}, },
    ['fishtaco'] = { ['hunger'] = {['low'] = 2000, ['high'] = 2500}, },
    ['vegantaco'] = { ['hunger'] = {['low'] = 2000, ['high'] = 2500}, },
    --
    ['shrimptaco'] = { ['hunger'] = {['low'] = 2000, ['high'] = 2500}, },
    ['caesarsalad'] = { ['hunger'] = {['low'] = 2000, ['high'] = 2500}, },
    ['lobstersliders'] = { ['hunger'] = {['low'] = 2000, ['high'] = 2500}, },
    ['pretzels'] = { ['hunger'] = {['low'] = 2000, ['high'] = 2500}, },
    ['onionrings'] = { ['hunger'] = {['low'] = 2000, ['high'] = 2500}, },
    ['deepfriedpickles'] = { ['hunger'] = {['low'] = 2000, ['high'] = 2500}, },
    ['goldenlavacake'] = { ['hunger'] = {['low'] = 2000, ['high'] = 2500}, },
    ['chipsandsalsa'] = { ['hunger'] = {['low'] = 2000, ['high'] = 2500}, },
    --
    ['crabcakes'] = { ['hunger'] = {['low'] = 2000, ['high'] = 2500}, },
    ['hotdogs'] = { ['hunger'] = {['low'] = 2000, ['high'] = 2500}, },
    ['bfsandwich'] = { ['hunger'] = {['low'] = 2000, ['high'] = 2500}, },
    ['cwings'] = { ['hunger'] = {['low'] = 2000, ['high'] = 2500}, },
    ['pizza'] = { ['hunger'] = {['low'] = 2000, ['high'] = 2500}, },
    --
    ['sandwich'] = { ['hunger'] = {['low'] = 1500, ['high'] = 1750}, },
    ['hamburger'] = { ['hunger'] = {['low'] = 1500, ['high'] = 1750}, },
    --
    ['gummybears'] = { ['hunger'] = {['low'] = 1250, ['high'] = 1500}, },
    ['fries'] = { ['hunger'] = {['low'] = 1250, ['high'] = 1500}, },
    ['donut'] = { ['hunger'] = {['low'] = 1250, ['high'] = 1500}, ['stress'] = -250 },
    ['energybar'] = { ['hunger'] = {['low'] = 350, ['high'] = 600}, ['stress'] = -100 },
    ['bread'] = { ['hunger'] = {['low'] = 1250, ['high'] = 1500}, },
    ['chips'] = { ['hunger'] = {['low'] = 1250, ['high'] = 1500}, },    
    ['munchies'] = { ['hunger'] = {['low'] = 1800, ['high'] = 2500}, },
    ['chocolate'] = { ['hunger'] = {['low'] = 1250, ['high'] = 1500}, ['stress'] = -200 },
    ['cookie'] = { ['hunger'] = {['low'] = 1250, ['high'] = 1500}, ['stress'] = -200 },
    ['icecream'] = { ['hunger'] = {['low'] = 1250, ['high'] = 1500}, ['stress'] = -275 },
    ['turtlecheesecake'] = { ['hunger'] = {['low'] = 1250, ['high'] = 1500}, ['stress'] = -225 },
    ['jailfood'] = { ['hunger'] = {['low'] = 1250, ['high'] = 1500}, ['thirst'] = {['low'] = 1250, ['high'] = 1500}, },
    ['nachos'] = { ['hunger'] = {['low'] = 1250, ['high'] = 1500} },
    ['bagofnuts'] = { ['hunger'] = {['low'] = 1250, ['high'] = 1500} },
    ['cheesesticks'] = { ['hunger'] = {['low'] = 1250, ['high'] = 1500} },
    ['churro'] = { ['hunger'] = {['low'] = 1250, ['high'] = 1500} },
    ['hashbrown'] = { ['hunger'] = {['low'] = 1250, ['high'] = 1500} },
    --
    ['milkshake'] = { ['hunger'] = {['low'] = 325, ['high'] = 500}, ['stress'] = -175, ['thirst'] = {['low'] = 1750, ['high'] = 2250} },
    ['colada'] = { ['hunger'] = {['low'] = 500, ['high'] = 750}, ['stress'] = -200, ['thirst'] = {['low'] = 2000, ['high'] = 2500} },
    ['slushy'] = { ['hunger'] = {['low'] = 300, ['high'] = 400}, ['stress'] = -200, ['thirst'] = {['low'] = 1250, ['high'] = 1750} },
    ['goldenpeachtea'] = { ['stress'] = -200, ['thirst'] = {['low'] = 1500, ['high'] = 2000 } },
    ['water'] = { ['thirst'] = {['low'] = 1500, ['high'] = 2000 } },
    -- 
    ['cocacola'] = { ['thirst'] = {['low'] = 1750, ['high'] = 2250 } },
    ['mtnshlew'] = { ['thirst'] = {['low'] = 1750, ['high'] = 2250 } },
    ['cola'] = { ['thirst'] = {['low'] = 1750, ['high'] = 2250 } },
    ['icetea'] = { ['thirst'] = {['low'] = 1750, ['high'] = 2250 } },
    ['coffee'] = { ['thirst'] = {['low'] = 1750, ['high'] = 2250 }, ['stress'] = -math.random(100,150) },
    ['hotchoccy'] = { ['thirst'] = {['low'] = 1750, ['high'] = 2250 } },
    ['energydrink'] = { ['thirst'] = {['low'] = 1750, ['high'] = 2250 } },
    ['potatojuice'] = { ['thirst'] = {['low'] = 2000, ['high'] = 2500 }, ['hunger'] = {['low'] = 350, ['high'] = 600 }, ['stress'] = -100 },
    ['potatoshake'] = { ['thirst'] = {['low'] = 1750, ['high'] = 2250 }, ['hunger'] = {['low'] = 350, ['high'] = 600 } },
    ['icedteafmb'] = { ['thirst'] = {['low'] = 1750, ['high'] = 2250 } },
    ['arnoldpalmer'] = { ['thirst'] = {['low'] = 1750, ['high'] = 2250 } },
    ['frappuccino'] = { ['thirst'] = {['low'] = 1750, ['high'] = 2250 }, ['stress'] = -math.random(100,150) },
    -- 
    ['pastasalad'] = { ['hunger'] = {['low'] = 2250, ['high'] = 2500} },
    ['curlyfries'] = { ['hunger'] = {['low'] = 1500, ['high'] = 1750} },
    ['chickensandwich'] = { ['hunger'] = {['low'] = 2100, ['high'] = 2300} },
    ['bbqribmeal'] = { ['hunger'] = {['low'] = 2000, ['high'] = 2500} },
    ['lobsterbisque'] = { ['hunger'] = {['low'] = 2150, ['high'] = 2400} },
    ['steakdinner'] = { ['hunger'] = {['low'] = 2000, ['high'] = 2500} },
    ['speghetti'] = { ['hunger'] = {['low'] = 2000, ['high'] = 2350} },
    ['sliders'] = { ['hunger'] = {['low'] = 1900, ['high'] = 2350} },
    ['rootbeerfloat'] = { ['hunger'] = {['low'] = 300, ['high'] = 400}, ['stress'] = -200, ['thirst'] = {['low'] = 1250, ['high'] = 1750} },
    -- SooChi
    ['bullbetea'] = { ['hunger'] = {['low'] = 100, ['high'] = 400}, ['stress'] = -200, ['thirst'] = {['low'] = 1250, ['high'] = 1750} },
    ['milktea'] = { ['hunger'] = {['low'] = 100, ['high'] = 400}, ['stress'] = -200, ['thirst'] = {['low'] = 1250, ['high'] = 1750} },
    ['lycheesoda'] = {['thirst'] = {['low'] = 1250, ['high'] = 1750} },
    ['cannedcoffee'] = { ['stress'] = 100, ['thirst'] = {['low'] = 1500, ['high'] = 1750} },
    ['misoramen'] = { ['hunger'] = {['low'] = 1700, ['high'] = 1900}, ['thirst'] = {['low'] = 1250, ['high'] = 1750} },
    ['tonkotsuramen'] = { ['hunger'] = {['low'] = 2500, ['high'] = 2750}, ['thirst'] = {['low'] = 850, ['high'] = 1050} },
    ['spicyshoyuramen'] = { ['hunger'] = {['low'] = 2100, ['high'] = 2300}, ['thirst'] = {['low'] = 650, ['high'] = 950} },
    ['californiaroll'] = { ['hunger'] = {['low'] = 2000, ['high'] = 2500} },
    ['salmontempura'] = { ['hunger'] = {['low'] = 2150, ['high'] = 2400} },
    ['spicydragonroll'] = { ['hunger'] = {['low'] = 2000, ['high'] = 2500} },
    ['gyoza'] = { ['hunger'] = {['low'] = 1000, ['high'] = 1550} },
    ['edamame'] = { ['hunger'] = {['low'] = 600, ['high'] = 750} },
    ['teriyakichickenskewers'] = { ['hunger'] = {['low'] = 1300, ['high'] = 1700} },
    ['sakuramochi'] = { ['stress'] = -100, ['hunger'] = {['low'] = 1500, ['high'] = 1750} },
    ['mitarashi'] = { ['stress'] = -100, ['hunger'] = {['low'] = 1500, ['high'] = 1750} },
    ['matchaicecream'] = { ['stress'] = -100, ['hunger'] = {['low'] = 1500, ['high'] = 1750} },
    
    -- Ranom
    ['momssandwhiches'] = { ['hunger'] = {['low'] = 100, ['high'] = 500} },
}

RegisterNetEvent('changehunger')
AddEventHandler('changehunger', function(item)
    if ChangeHungerItems[item] then
        local HungerInfo = ChangeHungerItems[item]['hunger']
        if HungerInfo then TriggerEvent('erp-status:add', 'hunger', math.random(HungerInfo['low'], HungerInfo['high'])) end
        local ThirstInfo = ChangeHungerItems[item]['thirst']
        if ThirstInfo then TriggerEvent('erp-status:add', 'thirst', math.random(ThirstInfo['low'], ThirstInfo['high'])) end
        local StressInfo = ChangeHungerItems[item]['stress']
        if StressInfo then TriggerEvent("updatestress", StressInfo, true) end
    end

    if item == 'chips' then
        if math.random(1,100) >= 85 then
            exports['mythic_notify']:SendAlert('inform', 'You broke the bag down into a sheet of plastic.', 6000)
            TriggerEvent('player:receiveItem', 'plastic', 1)
        end
    elseif item == 'milkshake' then
        if math.random(1,100) >= 75 then
            exports['mythic_notify']:SendAlert('inform', 'You broke the milkshake bottle down into 3 sheets of plastic.', 6000)
            TriggerEvent('player:receiveItem', 'plastic', 3)
        end
    elseif item == 'water' then
        if math.random(1,100) >= 75 then
            exports['mythic_notify']:SendAlert('inform', 'You broke the bottle down into 2 sheets of plastic.', 6000)
            TriggerEvent('player:receiveItem', 'plastic', 2)
        end
    elseif item == "energybar" then
        CreateThread(function()
            local endTime = GetGameTimer() + math.random(22500, 30000)
            local id = PlayerId()
            while true do
                Wait(1000)
                if GetGameTimer() >= endTime then return end
                ResetPlayerStamina(id)
            end
        end)
    end
end)

local AlcaholShit = {
    ['beer'] = { ['low'] = 5, ['high'] = 7 },
    ['champagne'] = { ['low'] = 9, ['high'] = 13 },
    ['dirtyshirley'] = { ['low'] = 9, ['high'] = 13 },
    ['arnoldpalmer'] = { ['low'] = 9, ['high'] = 13 },
    ['icedteafmb'] = { ['low'] = 10, ['high'] = 13 },
    ['vodka'] = { ['low'] = 11, ['high'] = 15 },
    ['potatovodka'] = { ['low'] = 11, ['high'] = 15 },
    ['jac'] = { ['low'] = 11, ['high'] = 15 },
    ['whiskey'] = { ['low'] = 13, ['high'] = 17 },
    -- Legacy
    ['jelloshot'] = { ['low'] = 9, ['high'] = 11 },
    ['baconbloodymary'] = { ['low'] = 9, ['high'] = 11 },
    ['tequilasprite'] = { ['low'] = 9, ['high'] = 11 },
    ['rumpunch'] = { ['low'] = 8, ['high'] = 10 },
    ['gintonic'] = { ['low'] = 9, ['high'] = 11 },
    ['redsangria'] = { ['low'] = 9, ['high'] = 11 },
    ['milkdudsliders'] = { ['low'] = 9, ['high'] = 11 },
    ['badbitchmartini'] = { ['low'] = 9, ['high'] = 11 },
    ['valkkiss'] = { ['low'] = 9, ['high'] = 11 },
	['patriotbeer'] = { ['low'] = 7, ['high'] = 11 },
    ['oldfashioned'] = { ['low'] = 9, ['high'] = 11 },
    ['watermelonfrozerita'] = { ['low'] = 9, ['high'] = 11 },
    -- END
    ['cognac'] = { ['low'] = 13, ['high'] = 15 },
    ['redwine'] = { ['low'] = 5, ['high'] = 8 },
    ['whiteclaw'] = { ['low'] = 7, ['high'] = 11 },
    ['tequilasunrise'] = { ['low'] = 11, ['high'] = 15 },
    -- SooChi
    ['sake'] = { ['low'] = 7, ['high'] = 10 },
    ['awamori'] = { ['low'] = 12, ['high'] = 15 },
    ['yuzushu'] = { ['low'] = 5, ['high'] = 8 },
}

RegisterNetEvent('drinkalcahol')
AddEventHandler('drinkalcahol', function(itemid)

    if math.random(100) >= 50 then TriggerServerEvent('erp-status:applyStatus', 'Uncoordinated') end
    if math.random(100) >= 50 then TriggerServerEvent('erp-status:applyStatus', 'Breath smells like Alcohol') end

    if AlcaholShit[itemid] then
        drunkLevel = drunkLevel + math.random(AlcaholShit[itemid]['low'], AlcaholShit[itemid]['high'])
    end

    if itemid == 'champagne' or itemid == 'dirtyshirley' then TriggerEvent("updatestress", -150, true) end

end)

RegisterNetEvent('animation:lockpickinvtestoutside')
AddEventHandler('animation:lockpickinvtestoutside', function()
    local lPed = PlayerPedId()
    RequestAnimDict("veh@break_in@0h@p_m_one@")
    while not HasAnimDictLoaded("veh@break_in@0h@p_m_one@") do
        Citizen.Wait(0)
    end
    
    while lockpicking do        
        TaskPlayAnim(lPed, "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 1.0, 1.0, 1.0, 16, 0.0, 0, 0, 0)
        Citizen.Wait(2500)
    end
    ClearPedTasks(lPed)
end)

RegisterNetEvent('animation:lockpickinvtest')
AddEventHandler('animation:lockpickinvtest', function(disable)
    local lPed = PlayerPedId()
    RequestAnimDict("mini@repair")
    while not HasAnimDictLoaded("mini@repair") do
        Citizen.Wait(0)
    end
    if disable ~= nil then
        if not disable then
            lockpicking = false
            return
        else
            lockpicking = true
        end
    end
    while lockpicking do

        if not IsEntityPlayingAnim(lPed, "mini@repair", "fixing_a_player", 3) then
            ClearPedSecondaryTask(lPed)
            TaskPlayAnim(lPed, "mini@repair", "fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)
        end
        Citizen.Wait(1)
    end
    ClearPedTasks(lPed)
end)

RegisterNetEvent('inv:lockPick')
AddEventHandler('inv:lockPick', function(isForced,inventoryName,slot,iteminfoid)
    TriggerEvent("robbery:scanLock",true)
    if lockpicking then return end

    lockpicking = true
    playerped = PlayerPedId()
    targetVehicle = GetVehiclePedIsUsing(playerped)
    local itemid = 21

    if targetVehicle == 0 then
        coordA = GetEntityCoords(playerped, 1)
        coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 100.0, 0.0)
        targetVehicle = getVehicleInDirection(coordA, coordB, 5)
        local driverPed = GetPedInVehicleSeat(targetVehicle, -1)
        if targetVehicle == 0 or GetEntityType(targetVehicle) ~= 2 then
            return
        end
        if IsPedInAnyVehicle(PlayerPedId(), false) then return end

        if driverPed ~= 0 then
            lockpicking = false
            return
        end
            local d1,d2 = GetModelDimensions(GetEntityModel(targetVehicle))
            local leftfront = GetOffsetFromEntityInWorldCoords(targetVehicle, d1["x"]-0.25,0.25,0.0)

            local count = 5000
            local dist = #(vector3(leftfront["x"],leftfront["y"],leftfront["z"]) - GetEntityCoords(PlayerPedId()))
            while dist > 2.0 and count > 0 do
                dist = #(vector3(leftfront["x"],leftfront["y"],leftfront["z"]) - GetEntityCoords(PlayerPedId()))
                Citizen.Wait(1)
                count = count - 1
                DrawText3Ds(leftfront["x"],leftfront["y"],leftfront["z"],"Move here to lockpick.")
            end

            if dist > 2.0 then
                lockpicking = false
                return
            end


            TaskTurnPedToFaceEntity(PlayerPedId(), targetVehicle, 1.0)
            Citizen.Wait(1000)
            TriggerServerEvent('erp-sounds:PlayWithinDistance', 3.0, 'lockpick', 0.4)
            local triggerAlarm = GetVehicleDoorLockStatus(targetVehicle) > 1
            if triggerAlarm then
                SetVehicleAlarm(targetVehicle, true)
                StartVehicleAlarm(targetVehicle)
            end


            TriggerEvent("civilian:alertPolice",20.0,"lockpick",targetVehicle)
           
            TriggerEvent("animation:lockpickinvtestoutside")
            TriggerServerEvent('erp-sounds:PlayWithinDistance', 3.0, 'lockpick', 0.4)



 
            local finished = exports["erp-skillbar"]:taskBar(25000,3)

            if finished ~= 100 then
                 lockpicking = false
                 TriggerServerEvent('erp-status:applyStatus', 'Agitated')
                return
            end

            local finished = exports["erp-skillbar"]:taskBar(2200,10)

            if finished ~= 100 then
                 lockpicking = false
                 TriggerServerEvent('erp-status:applyStatus', 'Agitated')
                return
            end

            TriggerServerEvent('erp-status:applyStatus', 'Has scratches on hands')


            if finished == 100 then
                if triggerAlarm then
                    SetVehicleAlarm(targetVehicle, false)
                end
                local chance = math.random(50)
                if #(GetEntityCoords(targetVehicle) - GetEntityCoords(PlayerPedId())) < 10.0 and targetVehicle ~= 0 and GetEntitySpeed(targetVehicle) < 5.0 then
                    NetworkRequestControlOfEntity(targetVehicle)
                    SetVehicleDoorsLockedForAllPlayers(targetVehicle, false)
                    exports['mythic_notify']:SendAlert('inform', 'Vehicle Unlocked', 3000)
                    TriggerEvent('erp-sounds:PlayOnOne', 'unlock', 0.1)

                end
            end
        lockpicking = false
    elseif targetVehicle ~= 0 and not isForced then
        TriggerServerEvent('erp-sounds:PlayWithinDistance', 3.0, 'lockpick', 0.4)
        local triggerAlarm = GetVehicleDoorLockStatus(targetVehicle) > 1
        if triggerAlarm then SetVehicleAlarm(targetVehicle, true) StartVehicleAlarm(targetVehicle) end
        SetVehicleHasBeenOwnedByPlayer(targetVehicle,true)
        TriggerEvent("animation:lockpickinvtest")
        TriggerServerEvent('erp-sounds:PlayWithinDistance', 3.0, 'lockpick', 0.4)
        TriggerEvent("civilian:alertPolice",12.0,"lockpick",targetVehicle)
        local pickhealth, pickdamage, pickPadding, distance = math.random(32, 48), math.random(15, 40), math.random(7, 60), math.random(1, 100)
        local idfk = exports["erp-lockpick"]:lockpick(pickhealth, pickdamage, pickPadding, distance)
        if math.random(100) >= 50 then TriggerServerEvent('erp-status:applyStatus', 'Has scratches on hands') end
        if idfk ~= 100 then
            TriggerEvent("inventory:removeItem","lockpick", 1)
            lockpicking = false
            return
        end

        Wait(500)

        if idfk == 100 then
            if triggerAlarm then SetVehicleAlarm(targetVehicle, false) end
            if #(GetEntityCoords(targetVehicle) - GetEntityCoords(PlayerPedId())) < 10.0 and targetVehicle ~= 0 and GetEntitySpeed(targetVehicle) < 5.0 then
                local plate = GetVehicleNumberPlateText(targetVehicle)
                NetworkRequestControlOfEntity(targetVehicle)
                SetVehicleDoorsLockedForAllPlayers(targetVehicle, false)
                TriggerEvent("keys:addNew",targetVehicle,plate)
                exports['mythic_notify']:SendAlert('inform', 'Ignition Working', 3000)
                SetEntityAsMissionEntity(targetVehicle,false,true)
                SetVehicleHasBeenOwnedByPlayer(targetVehicle,true)
            end
            lockpicking = false
        end
    end

    lockpicking = false
end)

local reapiring = false
RegisterNetEvent('veh:repairing')
AddEventHandler('veh:repairing', function(itemid, targetVehicle)
    local playerped = PlayerPedId()
    local coordA = GetEntityCoords(playerped, 1)
    local coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 100.0, 0.0)

    if targetVehicle == nil then
        targetVehicle = getVehicleInDirection(coordA, coordB, 15)
    end

    if IsPedInAnyVehicle(PlayerPedId(), false) then return end

    local advanced = false
    local bypass = false

    if itemid == "repairkit" then advanced = true
    elseif itemid == "bypass" then bypass = true end

    if targetVehicle ~= 0 then

        if GetEntityType(targetVehicle) ~= 2 then
            exports['mythic_notify']:SendAlert('inform', 'Not a vehicle')
            return
        end

        local d1,d2 = GetModelDimensions(GetEntityModel(targetVehicle))
        local moveto = GetOffsetFromEntityInWorldCoords(targetVehicle, 0.0,d2["y"]+0.5,0.2)
        local dist = #(vector3(moveto["x"],moveto["y"],moveto["z"]) - GetEntityCoords(PlayerPedId()))
        local count = 1000
        local fueltankhealth = GetVehiclePetrolTankHealth(targetVehicle)

        while dist > 1.5 and count > 0 do
            dist = #(vector3(moveto["x"],moveto["y"],moveto["z"]) - GetEntityCoords(PlayerPedId()))
            Citizen.Wait(1)
            count = count - 1
            DrawText3Ds(moveto["x"],moveto["y"],moveto["z"],"Move here to repair.")
        end

        if reapiring then return end
        reapiring = true
        
        local timeout = 20

        NetworkRequestControlOfEntity(targetVehicle)

        while not NetworkHasControlOfEntity(targetVehicle) and timeout > 0 do 
            NetworkRequestControlOfEntity(targetVehicle)
            Citizen.Wait(100)
            timeout = timeout -1
        end


        local repairlength = 1000
        local originalHealth = GetEntityHealth(targetVehicle)
        if originalHealth < 0 then originalHealth = 0 end

        if dist < 1.5 then
            TriggerEvent("animation:repair",targetVehicle)
            fixingvehicle = true

            

            if advanced then
                local timeAdded = 0
                for i=0,5 do
                    if IsVehicleTyreBurst(targetVehicle, i, false) then
                        if IsVehicleTyreBurst(targetVehicle, i, true) then
                            timeAdded = timeAdded + 1200
                        else
                           timeAdded = timeAdded + 800
                        end
                    end
                end
                local fuelDamage = 48000 - (math.ceil(fueltankhealth)*12)
                repairlength = ((3500 - (GetVehicleEngineHealth(targetVehicle) * 3) - (GetVehicleBodyHealth(targetVehicle)) / 2) * 5) + 2000
                repairlength = repairlength + timeAdded + fuelDamage
            else
                local timeAdded = 0
                for i=0,5 do
                    --if math.random(1, 10) > 3 then
                        if IsVehicleTyreBurst(targetVehicle, i, false) then
                            if IsVehicleTyreBurst(targetVehicle, i, true) then
                                timeAdded = timeAdded + 1600
                            else
                            timeAdded = timeAdded + 1200
                            end
                        end
                    --end
                end
                local fuelDamage = 48000 - (math.ceil(fueltankhealth)*12)
                repairlength = ((3500 - (GetVehicleEngineHealth(targetVehicle) * 3) - (GetVehicleBodyHealth(targetVehicle)) / 2) * 3) + 1000
                repairlength = repairlength + timeAdded + fuelDamage
            end



            local finished = exports["erp-skillbar"]:taskBar(15000,math.random(10,20))
            if finished ~= 100 then
                fixingvehicle = false
                reapiring = false
                ClearPedTasks(playerped)
                return
            end

            if finished == 100 then
                
                if bypass then
                    SetVehicleEngineHealth(targetVehicle, 1000.0)
                    SetVehicleBodyHealth(targetVehicle, 1000.0)
                    SetVehiclePetrolTankHealth(targetVehicle, 4000.0)
                else

                    TriggerEvent('veh.randomDegredation',30,targetVehicle,3)

                    if advanced and (bypass or hasEnoughOfItem(itemid,1,false)) then
                        TriggerEvent("inventory:removeItem",itemid, 1)
                        TriggerEvent('veh.randomDegredation',30,targetVehicle,3)
                        print("Doing this 1.")
                        if GetVehicleEngineHealth(targetVehicle) < 900.0 then
                            SetVehicleEngineHealth(targetVehicle, 900.0)
                        end
                        if GetVehicleBodyHealth(targetVehicle) < 945.0 then
                            SetVehicleBodyHealth(targetVehicle, 945.0)
                        end

                        if fueltankhealth < 3800.0 then
                            SetVehiclePetrolTankHealth(targetVehicle, 3800.0)
                        end

                    else

                        if bypass or hasEnoughOfItem(itemid,1,false) then
                            local timer = math.ceil(GetVehicleEngineHealth(targetVehicle) * 5)
                            if timer < 2000 then
                                timer = 2000
                            end
                            local finished = exports["erp-skillbar"]:taskBar(timer,math.random(5,15))
                            if finished ~= 100 then
                                fixingvehicle = false
                                reapiring = false
                                ClearPedTasks(playerped)
                                return
                            end

                            TriggerEvent("inventory:removeItem",itemid,1)

                            print("Doing this 2.")
                            if GetVehicleEngineHealth(targetVehicle) < 200.0 then
                                SetVehicleEngineHealth(targetVehicle, 200.0)
                            end
                            if GetVehicleBodyHealth(targetVehicle) < 945.0 then
                                SetVehicleBodyHealth(targetVehicle, 945.0)
                            end

                            if fueltankhealth < 2900.0 then
                                SetVehiclePetrolTankHealth(targetVehicle, 2900.0)
                            end                        

                            if GetEntityModel(targetVehicle) == `BLAZER` then
                                SetVehicleEngineHealth(targetVehicle, 600.0)
                                SetVehicleBodyHealth(targetVehicle, 800.0)
                            end
                        end
                    end                    
                end

                for i = 0, 5 do
                    if bypass or advanced then
                        SetVehicleTyreFixed(targetVehicle, i) 
                    else
                        if math.random(1, 3) >= 2 then
                            SetVehicleTyreFixed(targetVehicle, i) 
                        end
                    end
                end
            end
            ClearPedTasks(playerped)
        end
        if bypass then
            local finished = exports['erp-progressbar']:taskBar(repairlength, "Full Repair")
            if finished == 100 then
                SetVehicleEngineHealth(targetVehicle, 1000.0)
                SetVehicleBodyHealth(targetVehicle, 1000.0)
                SetVehiclePetrolTankHealth(targetVehicle, 4000.0)
                SetVehicleFixed(targetVehicle)
                SetVehicleDeformationFixed(targetVehicle)
                
                TriggerServerEvent('erp-repair:charge', math.ceil((GetEntityMaxHealth(targetVehicle) - originalHealth) / 1.5))
            end
        end
        fixingvehicle = false
    end
    reapiring = false
end)

-- Animations
RegisterNetEvent('animation:load')
AddEventHandler('animation:load', function(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do Wait(5) end
end)

RegisterNetEvent('animation:repair')
AddEventHandler('animation:repair', function(veh)
    SetVehicleDoorOpen(veh, 4, 0, 0)
    RequestAnimDict("mini@repair")
    while not HasAnimDictLoaded("mini@repair") do
        Citizen.Wait(0)
    end

    TaskTurnPedToFaceEntity(PlayerPedId(), veh, 1.0)
    Citizen.Wait(1000)

    while fixingvehicle do
        local anim3 = IsEntityPlayingAnim(PlayerPedId(), "mini@repair", "fixing_a_player", 3)
        if not anim3 then
            TaskPlayAnim(PlayerPedId(), "mini@repair", "fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)
        end
        Citizen.Wait(1)
    end
    SetVehicleDoorShut(veh, 4, 1, 1)
end)

-- IFAK

local healing = false
local finished = 0

RegisterNetEvent("vicodin:heal")
AddEventHandler("vicodin:heal", function(item)
    if not healing then
        if hasEnoughOfItem(item,1,false) then
            if item ~= 'IFAK' then
                overdoseC = overdoseC + math.random(150, 175)
            end
            TriggerEvent("inventory:removeItem",item, 1)
            TriggerEvent('vicodin:finalheal', item)
        else
            print("Attempted to exploit vicodin.")
        end
	else
		exports['mythic_notify']:SendAlert('inform', 'Already healing.', 2000)
	end
end)

local healType = 'none'

RegisterNetEvent("vicodin:finalheal")
AddEventHandler("vicodin:finalheal", function(item) 
	TriggerEvent('play:anim', item)
    healType = item
    
	if item == 'vicodin' then item = 'Vicodin' item = 'IFAK' end

	local finished = exports["erp-progressbar"]:taskBar(3500,item)
    if finished == 100 then
        ClearPedTasks(PlayerPedId())

        CreateThread(function()
            healing = true
            local count = math.random(30, 60)

            while count > 0 do
                Wait(1000)
                count = count - 1
                local healAmount = 1
                if healType == 'vicodin' then
                    healAmount = math.random(1, 2)
                end
                SetEntityHealth(PlayerPedId(), GetEntityHealth(PlayerPedId()) + healAmount) 
            end

            healing = false

            if item == 'Vicodin' then
                CreateThread(function()
                    Wait(math.random(40000, 45000))
                    overdoseC = overdoseC - math.random(150, 175)
                end)
            end
            
            return
        end)

        if math.random(1, 10) > math.random(1, 3) then
            TriggerEvent('mythic_hospital:client:UseAdrenaline', math.random(60000, 90000))
        end
    end
end)

RegisterNetEvent("play:anim")
AddEventHandler('play:anim', function(item)
	local ped = PlayerPedId()
	if item == 'vicodin' then
        RequestAnimDict("mp_suicide")
        while not HasAnimDictLoaded("mp_suicide") do Citizen.Wait(0) end
        TaskPlayAnim(ped, "mp_suicide", "pill", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
        Wait(3500)
        ClearPedTasks(ped)
    elseif item == 'adderall' then
        RequestAnimDict("mp_suicide")
        while not HasAnimDictLoaded("mp_suicide") do Citizen.Wait(0) end
        TaskPlayAnim(ped, "mp_suicide", "pill", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
        Wait(5000)
        ClearPedTasks(ped)
    elseif item == 'xanax' then
        RequestAnimDict("mp_suicide")
        while not HasAnimDictLoaded("mp_suicide") do Citizen.Wait(0) end
        TaskPlayAnim(ped, "mp_suicide", "pill", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
        Wait(2000)
        ClearPedTasks(ped)
    elseif item == 'IFAK' then 
        RequestAnimDict("amb@world_human_clipboard@male@idle_a")
        while not HasAnimDictLoaded("amb@world_human_clipboard@male@idle_a") do Citizen.Wait(0) end
        TaskPlayAnim(ped, "amb@world_human_clipboard@male@idle_a", "idle_c", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
        Wait(3500)
        ClearPedTasks(ped)
    elseif item == 'lean' then
        TriggerEvent("attachItem", "cup")
        loadAnimDict( "amb@world_human_drinking@coffee@male@idle_a" ) 
        TaskPlayAnim( PlayerPedId(), "amb@world_human_drinking@coffee@male@idle_a", "idle_c", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
        Wait(7500)
        ClearPedTasks(ped)
        TriggerEvent('destroyProp')
    elseif item == 'meth' or item == 'refinedmeth' then
        loadAnimDict( "anim@mp_fm_event@intro" ) 
        TaskPlayAnim( PlayerPedId(), "anim@mp_fm_event@intro","beast_transform", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
        Wait(5000)
        ClearPedTasks(ped)
    end
end)

-- Binoculars

local keybindEnabled = false -- When enabled, binocular are available by keybind
local binocularKey = 108
local storeBinoclarKey = 177
local fov_max = 70.0
local fov_min = 5.0 -- max zoom level (smaller fov is more zoom)
local zoomspeed = 10.0 -- camera zoom speed
local speed_lr = 8.0 -- speed by which the camera pans left-right
local speed_ud = 8.0 -- speed by which the camera pans up-down
local fov = (fov_max+fov_min)*0.5
local camera = false

RegisterNetEvent('binoculars:Activate')
AddEventHandler('binoculars:Activate', function()
	TriggerEvent("binoculars:Activate2")
end)

RegisterNetEvent('binoculars:Activate2')
AddEventHandler('binoculars:Activate2', function()
    binoculars = not binoculars
    if not binoculars then
        TriggerEvent("animation:c")
    end
end)

function HideHUDThisFrame()
    HideHelpTextThisFrame()
    HideHudAndRadarThisFrame()
    HideHudComponentThisFrame(1) -- Wanted Stars
    HideHudComponentThisFrame(2) -- Weapon icon
    HideHudComponentThisFrame(3) -- Cash
    HideHudComponentThisFrame(4) -- MP CASH
    HideHudComponentThisFrame(6)
    HideHudComponentThisFrame(7)
    HideHudComponentThisFrame(8)
    HideHudComponentThisFrame(9)
    HideHudComponentThisFrame(13) -- Cash Change
    HideHudComponentThisFrame(11) -- Floating Help Text
    HideHudComponentThisFrame(12) -- more floating help text
    HideHudComponentThisFrame(15) -- Subtitle Text
    HideHudComponentThisFrame(18) -- Game Stream
    HideHudComponentThisFrame(19) -- weapon wheel
end

function CheckInputRotation(cam, zoomvalue)
    local rightAxisX = GetDisabledControlNormal(0, 220)
    local rightAxisY = GetDisabledControlNormal(0, 221)
    local rotation = GetCamRot(cam, 2)
    if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
        new_z = rotation.z + rightAxisX*-1.0*(speed_ud)*(zoomvalue+0.1)
        new_x = math.max(math.min(20.0, rotation.x + rightAxisY*-1.0*(speed_lr)*(zoomvalue+0.1)), -89.5)
        SetCamRot(cam, new_x, 0.0, new_z, 2)
        SetEntityHeading(PlayerPedId(),new_z)
    end
end

function HandleZoom(cam)
    local lPed = PlayerPedId()
    if not ( IsPedSittingInAnyVehicle( lPed ) ) then

        if IsControlJustPressed(0,241) then -- Scrollup
            fov = math.max(fov - zoomspeed, fov_min)
        end
        if IsControlJustPressed(0,242) then
            fov = math.min(fov + zoomspeed, fov_max) -- ScrollDown
        end
        local current_fov = GetCamFov(cam)
        if math.abs(fov-current_fov) < 0.1 then
            fov = current_fov
        end
        SetCamFov(cam, current_fov + (fov - current_fov)*0.05)
    else
        if IsControlJustPressed(0,17) then -- Scrollup
            fov = math.max(fov - zoomspeed, fov_min)
        end
        if IsControlJustPressed(0,16) then
            fov = math.min(fov + zoomspeed, fov_max) -- ScrollDown
        end
        local current_fov = GetCamFov(cam)
        if math.abs(fov-current_fov) < 0.1 then -- the difference is too small, just set the value directly to avoid unneeded updates to FOV of order 10^-5
            fov = current_fov
        end
        SetCamFov(cam, current_fov + (fov - current_fov)*0.05) -- Smoothing of camera zoom
    end
end

--[[ Camera ]]--

local camera = false

RegisterNetEvent('camera:Activate')
AddEventHandler('camera:Activate', function()
    camera = not camera
    TriggerEvent('camera:Activate2')
end)

-- Activate camera
RegisterNetEvent('camera:Activate2')
AddEventHandler('camera:Activate2', function()
    TriggerEvent('timeheader', GetClockHours(), GetClockMinutes())
    if not camera then
        TriggerEvent("animation:c")
    end
end)

local zoneNames = {
    AIRP = "Los Santos International Airport",
    ALAMO = "Alamo Sea",
    ALTA = "Alta",
    ARMYB = "Fort Zancudo",
    BANHAMC = "Banham Canyon Dr",
    BANNING = "Banning",
    BAYTRE = "Baytree Canyon", 
    BEACH = "Vespucci Beach",
    BHAMCA = "Banham Canyon",
    BRADP = "Braddock Pass",
    BRADT = "Braddock Tunnel",
    BURTON = "Burton",
    CALAFB = "Calafia Bridge",
    CANNY = "Raton Canyon",
    CCREAK = "Cassidy Creek",
    CHAMH = "Chamberlain Hills",
    CHIL = "Vinewood Hills",
    CHU = "Chumash",
    CMSW = "Chiliad Mountain State Wilderness",
    CYPRE = "Cypress Flats",
    DAVIS = "Davis",
    DELBE = "Del Perro Beach",
    DELPE = "Del Perro",
    DELSOL = "La Puerta",
    DESRT = "Grand Senora Desert",
    DOWNT = "Downtown",
    DTVINE = "Downtown Vinewood",
    EAST_V = "East Vinewood",
    EBURO = "El Burro Heights",
    ELGORL = "El Gordo Lighthouse",
    ELYSIAN = "Elysian Island",
    GALFISH = "Galilee",
    GALLI = "Galileo Park",
    golf = "GWC and Golfing Society",
    GRAPES = "Grapeseed",
    GREATC = "Great Chaparral",
    HARMO = "Harmony",
    HAWICK = "Hawick",
    HORS = "Vinewood Racetrack",
    HUMLAB = "Humane Labs and Research",
    JAIL = "Bolingbroke Penitentiary",
    KOREAT = "Little Seoul",
    LACT = "Land Act Reservoir",
    LAGO = "Lago Zancudo",
    LDAM = "Land Act Dam",
    LEGSQU = "Legion Square",
    LMESA = "La Mesa",
    LOSPUER = "La Puerta",
    MIRR = "Mirror Park",
    MORN = "Morningwood",
    MOVIE = "Richards Majestic",
    MTCHIL = "Mount Chiliad",
    MTGORDO = "Mount Gordo",
    MTJOSE = "Mount Josiah",
    MURRI = "Murrieta Heights",
    NCHU = "North Chumash",
    NOOSE = "N.O.O.S.E",
    OCEANA = "Pacific Ocean",
    PALCOV = "Paleto Cove",
    PALETO = "Paleto Bay",
    PALFOR = "Paleto Forest",
    PALHIGH = "Palomino Highlands",
    PALMPOW = "Palmer-Taylor Power Station",
    PBLUFF = "Pacific Bluffs",
    PBOX = "Pillbox Hill",
    PROCOB = "Procopio Beach",
    RANCHO = "Rancho",
    RGLEN = "Richman Glen",
    RICHM = "Richman",
    ROCKF = "Rockford Hills",
    RTRAK = "Redwood Lights Track",
    SanAnd = "San Andreas",
    SANCHIA = "San Chianski Mountain Range",
    SANDY = "Sandy Shores",
    SKID = "Mission Row",
    SLAB = "Stab City",
    STAD = "Maze Bank Arena",
    STRAW = "Strawberry",
    TATAMO = "Tataviam Mountains",
    TERMINA = "Terminal",
    TEXTI = "Textile City",
    TONGVAH = "Tongva Hills",
    TONGVAV = "Tongva Valley",
    VCANA = "Vespucci Canals",
    VESP = "Vespucci",
    VINE = "Vinewood",
    WINDF = "Ron Alternates Wind Farm",
    WVINE = "West Vinewood",
    ZANCUDO = "Zancudo River",
    ZP_ORT = "Port of South Los Santos",
    ZQ_UAR = "Davis Quartz"
}

local camfov_max = 40.0
local camfov_min = 4 -- max zoom level (smaller camfov is more zoom)
local camzoomspeed = 10.0 -- camera zoom speed
local speed_lr_cam = 5.0 -- speed by which the camera pans left-right
local speed_ud_cam = 5.0 -- speed by which the camera pans up-down
local currentTime = "00:00"
local camfov = (camfov_max+camfov_min)*0.5

RegisterNetEvent("timeheader")
AddEventHandler("timeheader", function(hrs,mins)
  currentTime = hrs .. ":" .. mins
end)

Citizen.CreateThread(function()
    while true do

        Citizen.Wait(1000)

        if camera then
            TriggerEvent("togglehud",true)
            local prop = nil
            camera = true
            if not (IsPedSittingInAnyVehicle(PlayerPedId())) then
                Citizen.CreateThread(function()
                    local ped = PlayerPedId()
                    local x,y,z = table.unpack(GetEntityCoords(ped))
                    prop = CreateObject(`prop_pap_camera_01`, x, y, z+0.2,  true,  true, true)
                    AttachEntityToEntity(prop, ped, GetPedBoneIndex(ped, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
                    RequestAnimDict("amb@world_human_paparazzi@male@base")
                    while not HasAnimDictLoaded("amb@world_human_paparazzi@male@base") do Wait(0) end
                    TaskPlayAnim(PlayerPedId(), "amb@world_human_paparazzi@male@base", 'base', 8.0, -8, -1, 49, 0, 0, 0, 0)
                    PlayAmbientSpeech1(PlayerPedId(), "GENERIC_CURSE_MED", "SPEECH_PARAMS_FORCE")
                end)
            end

            Wait(1500)

            SetTimecycleModifier("default")

            SetTimecycleModifierStrength(0.3)

            local scaleform = RequestScaleformMovie("security_cam")

            while not HasScaleformMovieLoaded(scaleform) do
                Citizen.Wait(10)
            end

            local lPed = PlayerPedId()
            local vehicle = GetVehiclePedIsIn(lPed)
            local cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)

            local plyPos = GetEntityCoords(PlayerPedId(),  true)
            local s1, s2 = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, plyPos.x, plyPos.y, plyPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
            local street1 = GetStreetNameFromHashKey(s1)
            local street2 = GetStreetNameFromHashKey(s2)
            local zone = GetNameOfZone(plyPos.x, plyPos.y, plyPos.z)
            local playerZoneName = zoneNames[zone]

            AttachCamToEntity(cam, lPed, 0.0,0.0,1.0, true)
            SetCamRot(cam, 0.0,0.0,GetEntityHeading(lPed))
            SetCamFov(cam, camfov)
            RenderScriptCams(true, false, 0, 1, 0)
            PushScaleformMovieFunction(scaleform, "SET_LOCATION")
            PushScaleformMovieFunctionParameterString(playerZoneName)
            PopScaleformMovieFunctionVoid()
            PushScaleformMovieFunction(scaleform, "SET_DETAILS")
            PushScaleformMovieFunctionParameterString(street1 .. " / " .. street2)
            PopScaleformMovieFunctionVoid()
            PushScaleformMovieFunction(scaleform, "SET_TIME")
            PushScaleformMovieFunctionParameterString(currentTime[1])
            PushScaleformMovieFunctionParameterString(currentTime[2])
            PopScaleformMovieFunctionVoid()

            while camera and not IsEntityDead(lPed) and (GetVehiclePedIsIn(lPed) == vehicle) and IsEntityPlayingAnim(lPed, "amb@world_human_paparazzi@male@base", 'base', 3) and true do
                TriggerEvent("disabledWeapons",true)
                if IsControlJustPressed(0, storeBinoclarKey) then -- Toggle camera
                    TriggerEvent("togglehud",false)
                    PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                    ClearPedTasks(PlayerPedId())
                    camera = false
                end

                local zoomvalue = (1.0/(camfov_max-camfov_min))*(camfov-camfov_min)
                CheckInputRotation(cam, zoomvalue)

                HandleZoom(cam)
                HideHUDThisFrame()

                DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
                Citizen.Wait(1)
            end

            TriggerEvent("disabledWeapons",false)
            camera = false
            ClearTimecycleModifier()
            camfov = (camfov_max+camfov_min)*0.5
            RenderScriptCams(false, false, 0, 1, 0)
            SetScaleformMovieAsNoLongerNeeded(scaleform)
            DeleteEntity(prop)
            DestroyCam(cam, false)
            SetNightvision(false)
            SetSeethrough(false)
        elseif binoculars then
            TriggerEvent("togglehud",true)
            if not (IsPedSittingInAnyVehicle(PlayerPedId())) then
                CreateThread(function()
                    TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_BINOCULARS", 0, 1)
                    PlayAmbientSpeech1(PlayerPedId(), "GENERIC_CURSE_MED", "SPEECH_PARAMS_FORCE")
                end)
            end

            Wait(2000)

            SetTimecycleModifier("default")
            SetTimecycleModifierStrength(0.3)

            local scaleform = RequestScaleformMovie("BINOCULARS")

            while not HasScaleformMovieLoaded(scaleform) do
                Wait(10)
            end

            local lPed = PlayerPedId()
            local vehicle = GetVehiclePedIsIn(lPed)
            local cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)

            AttachCamToEntity(cam, lPed, 0.0,0.0,1.0, true)
            SetCamRot(cam, 0.0,0.0,GetEntityHeading(lPed))
            SetCamFov(cam, fov)
            RenderScriptCams(true, false, 0, 1, 0)
            PushScaleformMovieFunction(scaleform, "SET_CAM_LOGO")
            PushScaleformMovieFunctionParameterInt(0) -- 0 for nothing, 1 for LSPD logo
            PopScaleformMovieFunctionVoid()

            while binoculars and not IsEntityDead(lPed) and (GetVehiclePedIsIn(lPed) == vehicle) and IsPedUsingScenario(PlayerPedId(), "WORLD_HUMAN_BINOCULARS") and true do
                TriggerEvent("disabledWeapons",true)
                if IsControlJustPressed(0, storeBinoclarKey) then -- Toggle binoculars
                    TriggerEvent("togglehud",false)
                    PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                    ClearPedTasks(PlayerPedId())
                    binoculars = false
                end

                local zoomvalue = (1.0/(fov_max-fov_min))*(fov-fov_min)
                CheckInputRotation(cam, zoomvalue)

                HandleZoom(cam)
                HideHUDThisFrame()

                DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
                Citizen.Wait(1)
            end

            TriggerEvent("disabledWeapons",false)
            binoculars = false
            ClearTimecycleModifier()
            fov = (fov_max+fov_min)*0.5
            RenderScriptCams(false, false, 0, 1, 0)
            SetScaleformMovieAsNoLongerNeeded(scaleform)
            DestroyCam(cam, false)
            SetNightvision(false)
            SetSeethrough(false)
        else
            Wait(1000)
        end
    end
end)

RegisterNetEvent('erp-washkit:onUse')
AddEventHandler('erp-washkit:onUse', function(itemid)
    if reapiring then return end
	local playerped = PlayerPedId()
    local coordA = GetEntityCoords(playerped, 1)
    local coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 20.0, 0.0)
    local targetVehicle = getVehicleInDirection(coordA, coordB)

    if IsPedInAnyVehicle(PlayerPedId(), false) then return end
    
    if targetVehicle ~= 0 then

        if GetEntityType(targetVehicle) ~= 2 then
            exports['mythic_notify']:SendAlert('inform', 'Not a vehicle')
            return
        end

        local d1,d2 = GetModelDimensions(GetEntityModel(targetVehicle))
        local moveto = GetOffsetFromEntityInWorldCoords(targetVehicle, 1.0,d2["y"]-2.0,0.0)
        local dist = #(vector3(moveto["x"],moveto["y"],moveto["z"]) - GetEntityCoords(playerped))
        local count = 1000

        while dist > 1.0 and count > 0 do
            dist = #(vector3(moveto["x"],moveto["y"],moveto["z"]) - GetEntityCoords(playerped))
            Citizen.Wait(1)
            count = count - 1
            DrawText3Ds(moveto["x"],moveto["y"],moveto["z"],"Move here to clean.")
        end

        if reapiring then return end
        reapiring = true
        
        local timeout = 40

        NetworkRequestControlOfEntity(targetVehicle)

        while not NetworkHasControlOfEntity(targetVehicle) and timeout > 0 do 
            NetworkRequestControlOfEntity(targetVehicle)
            Citizen.Wait(100)
            timeout = timeout -1
        end

        if dist < 1.0 then
            local cleanlength = 0
            if itemid ~= "bypass" then 
                if not hasEnoughOfItem(itemid, 1, false) then return end
                TriggerEvent('inventory:removeItem', itemid, 1)
                cleanlength = math.random(7500, 10000)
            end
            TriggerEvent("animation:clean",targetVehicle)
            fixingvehicle = true
            cleanlength = (3500 - (GetVehicleDirtLevel(targetVehicle) * math.random(3, 7)) + math.random(2000, 3500)) + cleanlength
            local finished = exports["erp-progressbar"]:taskBar(cleanlength,"Cleaning")
            if finished == 100 then
                SetVehicleDirtLevel(targetVehicle, 0)
                exports['mythic_notify']:SendAlert('inform', 'Vehicle Cleaned.')
            end
            ClearPedTasks(playerped)
        end
        fixingvehicle = false
    end
    reapiring = false
end)

RegisterNetEvent('animation:clean')
AddEventHandler('animation:clean', function(veh)
    local playerPed = PlayerPedId()
    TaskTurnPedToFaceEntity(playerPed, veh, 1.0)
    TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_MAID_CLEAN', 0, true)
end)

local MYEWIJEFOIEFJ = 0

function MyWeightSadFace() return MYEWIJEFOIEFJ end

exports("MyWeightSadFace", MyWeightSadFace)

RegisterNetEvent('weight:sendWeight')
AddEventHandler('weight:sendWeight', function(sentWeight)
    if sentWeight then
        MYEWIJEFOIEFJ = tonumber(sentWeight)
    end 
end)

-- Paleto bank


--[[
Status:
0 - Not being robbed
1 - Being robbed
]]

local PaletoInfo = {
    [1] = { type = 'door', doorId = 171, status = 0},
    [2] = { type = 'door', doorId = 172, status = 0},
    [3] = { type = 'loot', coords = vector4(-103.35, 6475.89, 31.64, 221.1), status = 0},
    [4] = { type = 'loot', coords = vector4(-103.78, 6477.8, 31.62, 317.48), status = 0},
    [5] = { type = 'loot', coords = vector4(-105.6, 6478.07, 31.62, 36.85), status = 0},
}

AddEventHandler('erp-robberies:client:tryrob', function(sentInfo, sentId)
    TriggerEvent('inventory:removeItem', 'thermal_charge', 1)
    TaskPlayAnim(PlayerPedId(), "cellphone@", "cellphone_text_read_base", 2.0, 1.0, -1, 49, 0, 0, 0, 0)
    TriggerEvent("attachItemPhone","phone01")
    local speed = math.random(60, 90)
    local fspeed = speed / 10
    local inter = math.random(380, 475)
    local latter = math.random(2, 3)
    local dropam = math.random(8, 14)
    local finished = exports['erp-thermite']:startGame(dropam, latter, fspeed, inter)
    
    if finished then
        TriggerEvent('erp-robberies:client:closedoors', sentInfo['doorId'], getEntity())
        TriggerServerEvent('erp-doors:alterlockstate', sentInfo['doorId'])
    else
        if math.random(3) > 1 then
            local coords = GetEntityCoords(PlayerPedId())
            exports['erp-thermite']:startFireAtLocation(coords.x, coords.y, coords.z, math.random(5000, 10000))
        end
    end
    
    ClearPedTasks(PlayerPedId())
    TriggerEvent("destroyPropPhone")
    PaletoInfo[sentId]['status'] = 0 TriggerServerEvent('erp-robberies:server:paletobank', PaletoInfo)   
end)

function getEntity()
    local playerped = PlayerPedId()
    local coordA = GetEntityCoords(playerped, 1)
    local coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 100.0, 0.0)
    local targetVehicle = getVehicleInDirection(coordA, coordB)

    return targetVehicle
end

AddEventHandler('erp-robberies:client:closedoors', function(sentId, sentEntity)
    if sentId then
        CreateThread(function()
            Wait(240000)
            local doorInfo = exports['erp-doors']:GetDoorInfo(sentId)
            if doorInfo and doorInfo['lock'] == 0 then
                TriggerServerEvent('erp-doors:alterlockstate', sentId)
                if sentEntity and DoesEntityExist(sentEntity) then
                    if sentId == 210 then
                        SetEntityHeading(sentEntity, 47.32)
                    elseif sentId == 211 then
                        SetEntityHeading(sentEntity, 315.00)
                    end
                end
            end
        end)
    end
end)

AddEventHandler('erp-robberies:client:paletobank', function()
    for i=1, #PaletoInfo do
        if PaletoInfo[i]['type'] == 'door' and PaletoInfo[i]['status'] == 0 then
            local doorInfo = exports['erp-doors']:GetDoorInfo(PaletoInfo[i]['doorId'])
            if doorInfo then
                local coords = GetEntityCoords(PlayerPedId())
                if #(coords - doorInfo['coords']) < 1.5 then
                    TriggerServerEvent('erp-robberies:server:paletobank', PaletoInfo, i)
                    return
                end
            end
        elseif PaletoInfo[i]['type'] == 'loot' and PaletoInfo[i]['status'] == 0 then
            local coords = GetEntityCoords(PlayerPedId())
            if #(coords - PaletoInfo[i]['coords'].xyz) < 1 then
                TriggerServerEvent('erp-robberies:server:attemptloot', i-2, exports['erp-inventory']:hasEnoughOfItem('laptop_h', 1, false))
                return
            end
        end 
    end 
    
end)

RegisterNetEvent('erp-robberies:client:attemptloot')
AddEventHandler('erp-robberies:client:attemptloot', function(data)
    TaskPlayAnim(PlayerPedId(), "cellphone@", "cellphone_text_read_base", 2.0, 1.0, -1, 49, 0, 0, 0, 0)
    TriggerEvent("attachItemPhone","phone01")
    
    TriggerEvent("mhacking:show")

    TriggerEvent("mhacking:start",math.random(3,6),math.random(10,15), function(success, reason)
        TriggerEvent('mhacking:hide')
        if success then
            if exports['erp-inventory']:hasEnoughOfItem('laptop_h', 1, false) then
                TriggerServerEvent('erp-robberies:server:getloot', data)
            end
        else
            TriggerEvent('inventory:removeItem', 'laptop_h', 1)
            TriggerServerEvent('erp-robberies:server:failedloot', data)
        end
    end)

    ClearPedTasks(PlayerPedId())
    TriggerEvent("destroyPropPhone")
end)

RegisterNetEvent('erp-robberies:client:paletobank:adjustValue')
AddEventHandler('erp-robberies:client:paletobank:adjustValue', function(data, sentNum, sentId)
    PaletoInfo = data
    if sentId == GetPlayerServerId(PlayerId()) then TriggerEvent('erp-robberies:client:tryrob', PaletoInfo[sentNum], sentNum) end
end)