local PlayerData = {}

RegisterNetEvent('echorp:playerSpawned') -- Use this to grab player info on spawn.
AddEventHandler('echorp:playerSpawned', function(sentData) PlayerData = sentData end)

RegisterNetEvent('echorp:updateinfo')
AddEventHandler('echorp:updateinfo', function(toChange, targetData) 
    PlayerData[toChange] = targetData
end)

RegisterNetEvent('echorp:doLogout') -- Use this to logout.
AddEventHandler('echorp:doLogout', function(sentData) 
    PlayerData = {} 
end)

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

RegisterNetEvent('erp-inventory:search')
AddEventHandler('erp-inventory:search', function(n, i, t)
    local me = PlayerPedId()

    if IsEntityPlayingAnim(me, 'random@mugging3', 'handsup_standing_base', 3) or IsEntityPlayingAnim(me, 'missarmenian2', 'drunk_loop', 3) or IsEntityPlayingAnim(me, 'mp_arrest_paired', 'crook_p2_back_right', 3) then
        exports['mythic_notify']:SendAlert('inform', 'But you\'re dead or putting your hands up?')
        return
    end
    
    local closestPlayer, closestDistance = GetClosestPlayer()
    if closestPlayer ~= -1 and closestDistance <= 3.0 then
        local searchPlayerPed = GetPlayerPed(closestPlayer)
        SpikeStrip()
        local x = exports["erp-progressbar"]:taskBar(3000,"Searching")
        if x == 100 then
            ClearPedTasks(PlayerPedId())
            TriggerEvent("server-inventory-open", n, i, t)
        end
    end
end)

RegisterNetEvent('erp-inventory:steal')
AddEventHandler('erp-inventory:steal', function(n, i, t, cash, targetcid)
    local closestPlayer, closestDistance =  GetClosestPlayer()
    if closestPlayer ~= -1 and closestDistance <= 3.0 then
        local searchPlayerPed = GetPlayerPed(closestPlayer)
        local me = PlayerPedId()

        -- Let's check if the source is dead first mofoka...

        if IsEntityPlayingAnim(me, 'random@mugging3', 'handsup_standing_base', 3) or IsEntityPlayingAnim(me, 'missarmenian2', 'drunk_loop', 3) or IsEntityPlayingAnim(me, 'mp_arrest_paired', 'crook_p2_back_right', 3) then
            exports['mythic_notify']:SendAlert('inform', 'But you\'re dead or putting your hands up?')
            return
        end

        if IsEntityPlayingAnim(searchPlayerPed, 'random@mugging3', 'handsup_standing_base', 3) or IsEntityPlayingAnim(searchPlayerPed, 'missarmenian2', 'drunk_loop', 3) or IsEntityPlayingAnim(searchPlayerPed, 'mp_arrest_paired', 'crook_p2_back_right', 3) then
            --[[[CreateThread(function()
                local target = closestPlayer
                local searchPlayerPed = GetPlayerPed(closestPlayer)
                while true do
                    Wait(500)
                    if #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(searchPlayerPed)) > 10 then
                        TriggerEvent('closeInventoryGui')
                        return
                    end
                end
            end)]]
            SpikeStrip()
            local y = exports["erp-progressbar"]:taskBar(5000,"Robbing")
            if y == 100 then
                ClearPedTasks(PlayerPedId())
                TriggerEvent("server-inventory-open", n, i, t)

                TriggerEvent('chat:addMessage', {
                    template = '<div class="chat-message-system"><b>Cash ({1}) :</b> ${0}</div>',
                    args = { cash, targetcid }
                })
            end
        end
    end
end)

function SpikeStrip()
	local ped = PlayerPedId()
    local testdic = "missexile3"
    local testanim = "ex03_dingy_search_case_a_michael"

    if IsPedArmed(ped, 7) then SetCurrentPedWeapon(ped, 0xA2719263, true) end

    RequestAnimDict(testdic)

    while not HasAnimDictLoaded(testdic) and not handCuffed do
    	Citizen.Wait(0)
    end

    if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
        ClearPedSecondaryTask(ped)
    else
        local animLength = GetAnimDuration(testdic, testanim)
        TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, -1, 48, -1, 0, 0, 0)
	end
end

RegisterNUICallback('StealAll', function(data, cb)
    TriggerServerEvent('erp-inventory:takeAll', data[1])
    cb('ok')
end)

-- Allowed Business Item Kickback

local businesssItemCheck = {
	['mzinsurance_bronze_week'] = 'ambulance',
	['mzinsurance_bronze_month'] = 'ambulance',
	['mzinsurance_silver_week'] = 'ambulance',
	['mzinsurance_silver_month'] = 'ambulance',
	['mzinsurance_gold_week'] = 'ambulance',
	['mzinsurance_gold_month'] = 'ambulance',
	['mzinsurance_diamond_week'] = 'ambulance',
	['mzinsurance_diamond_month'] = 'ambulance',
}

RegisterNUICallback('checkBusinessShop', function(data, cb)
	local item = data[1].itemid
	if businesssItemCheck[item] then
		local amount = data[1].amount
		local cost = data[1].fwewef
		TriggerServerEvent('erp-inventory:payBusiness', businesssItemCheck[item], amount, cost)
	end
    cb('ok')
end)


local mechanicJobs = {
  ['jt3nv7'] = true,
  ['pdm'] = true,
  ['bikesrus'] = true,
  ['lostmc'] = true,
  ['flywheels'] = true,
  ['bennys'] = true,
  ['f1'] = true
}

function IsMechanic()
	if (not PlayerData['job']) then return false end;
  return mechanicJobs[PlayerData['job']['name']] or false
end

exports('IsMechanic', IsMechanic)

CreateThread(function()
    while true do
        Wait(30000)
        if (not hasEnoughOfItem('radio',1,false)) then
            exports["erp-voice"]:setVoiceProperty("radioEnabled", false)
            exports["erp-voice"]:setRadioChannel(0)
        end
    end
end)

RegisterNetEvent('payanimation:giver')
AddEventHandler('payanimation:giver', function(targetPed)
    if IsPedInAnyVehicle(PlayerPedId()) then return end;
    local targetPed = NetworkGetEntityFromNetworkId(targetPed)
    TaskTurnPedToFaceEntity(PlayerPedId(), targetPed, 350)
    Wait(350)
    local cashPile = CreateObject(`prop_anim_cash_pile_02`, GetEntityCoords(PlayerPedId()), true, true, false)
    AttachEntityToEntity(cashPile, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
    RequestAnimDict('mp_common')
    while not HasAnimDictLoaded('mp_common') do Citizen.Wait(5) end
    TaskPlayAnim(PlayerPedId(), "mp_common", "givetake1_a", 8.0, -8, -1, 12, 1, 0, 0, 0)
    Wait(1000)
    SetEntityAsMissionEntity(cashPile, false, false)
    DeleteObject(cashPile)
    Wait(500)
	StopAnimTask(PlayerPedId(), "mp_common","givetake1_a", 1.0)
end)

RegisterNetEvent('payanimation:receiver')
AddEventHandler('payanimation:receiver', function(targetPed)
    if IsPedInAnyVehicle(PlayerPedId()) then return end;
    local targetPed = NetworkGetEntityFromNetworkId(targetPed)
    TaskTurnPedToFaceEntity(PlayerPedId(), targetPed, 50)
    Wait(50)
    RequestAnimDict('mp_common')
    while not HasAnimDictLoaded('mp_common') do Citizen.Wait(5) end
    TaskPlayAnim(PlayerPedId(), "mp_common", "givetake1_a", 8.0, -8, -1, 12, 1, 0, 0, 0)
    Wait(1500)
	StopAnimTask(PlayerPedId(), "mp_common","givetake1_a", 1.0)
end)

-- Vape

local isVaping, DisplayText, VapeMod = false, false, nil
local savedItemId = 0

local uses = math.random(4, 7)

local function PlayerIsEnteringVehicle()
	isVaping = false
	DisplayText = false
	local ped = PlayerPedId()
	local ad = "anim@heists@humane_labs@finale@keycards"
	DeleteObject(VapeMod)
	TaskPlayAnim(ped, ad, "exit", 8.00, -8.00, -1, (2 + 16 + 32), 0.00, 0, 0, 0)
end

local function HandleVape()
	if not isVaping then
		isVaping = true
		local ped = PlayerPedId()
		local ad = "anim@heists@humane_labs@finale@keycards"
		local anim = "ped_a_enter_loop"

		while (not HasAnimDictLoaded(ad)) do
			RequestAnimDict(ad)
			Wait(1)
		end
		TaskPlayAnim(ped, ad, anim, 8.00, -8.00, -1, (2 + 16 + 32), 0.00, 0, 0, 0)

		local x,y,z = table.unpack(GetEntityCoords(ped))
		local prop_name = "ba_prop_battle_vape_01"
		VapeMod = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)
		AttachEntityToEntity(VapeMod, ped, GetPedBoneIndex(ped, 18905), 0.08, -0.00, 0.03, -150.0, 90.0, -10.0, true, true, false, true, 1, true)
		TriggerEvent('erp-prompts:ShowUI', 'show', '[E] Take a hit<br>[G] Reset rest position')
	else
		TriggerEvent('erp-prompts:HideUI')
		DisplayText = false
		isVaping = false
		savedItemId = 0
		local ped = PlayerPedId()
		DeleteObject(VapeMod)
		ClearPedTasksImmediately(ped)
		ClearPedSecondaryTask(ped)
		exports['mythic_notify']:SendAlert('inform', 'Vape stopped')
	end
end

RegisterNetEvent("Vape:toggleVaping")
AddEventHandler("Vape:toggleVaping", function(itemId)
	print("Sent ID:", itemId)
	local ped = PlayerPedId()
	if DoesEntityExist(ped) and not IsEntityDead(ped) then
		if IsPedOnFoot(ped) then
			HandleVape()
			savedItemId = itemId
		end
	end
end)

RegisterNetEvent("Vape:VapeAnimFix")
AddEventHandler("Vape:VapeAnimFix", function(source)
	local ped = PlayerPedId()
	local ad = "anim@heists@humane_labs@finale@keycards"
	local anim = "ped_a_enter_loop"
	while (not HasAnimDictLoaded(ad)) do RequestAnimDict(ad) Wait(1) end
	TaskPlayAnim(ped, ad, anim, 8.00, -8.00, -1, (2 + 16 + 32), 0.00, 0, 0, 0)
end)

RegisterNetEvent("Vape:Drag")
AddEventHandler("Vape:Drag", function()
	if isVaping and savedItemId ~= 0 then
		local ped = PlayerPedId()
		local PedPos = GetEntityCoords(ped)
		local ad = "mp_player_inteat@burger"
		local anim = "mp_player_int_eat_burger"
		if (DoesEntityExist(ped) and not IsEntityDead(ped)) then
			while (not HasAnimDictLoaded(ad)) do RequestAnimDict(ad) Wait(1) end

			TaskPlayAnim(ped, ad, anim, 8.00, -8.00, -1, (2 + 16 + 32), 0.00, 0, 0, 0)
			PlaySoundFrontend(-1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1)
			Wait(950)
			TriggerServerEvent("eff_smokes", PedToNet(ped))

			CreateThread(function()
				if math.random(1, 4) == 1 then
					AnimpostfxStop('FocusOut')
					AnimpostfxPlay('FocusOut', 0, false)
					Wait(1000)
					AnimpostfxStop('FocusOut')
				end
			end)
			
			Wait(2000-1000)

			if math.random(1, 4) >= math.random(1, 4) then
				TriggerEvent("updatestress", -math.random(200, 300))
			end

			-- 1265016685
			TriggerServerEvent("inventory:degItem", savedItemId, math.random(302526778, 363032134))
			TriggerEvent("Vape:VapeAnimFix", 0)
			uses = uses - 1

			if uses == 0 then
				TriggerEvent('Vape:toggleVaping', 0)
				uses = math.random(4, 7) 
			end
		end
	end
end)

p_smoke_location = { 20279 }
p_smoke_particle = "exp_grd_bzgas_smoke"
p_smoke_particle_asset = "core" 

RegisterNetEvent("c_eff_smokes")
AddEventHandler("c_eff_smokes", function(c_ped)
	for _,bones in pairs(p_smoke_location) do
		if DoesEntityExist(NetToPed(c_ped)) and not IsEntityDead(NetToPed(c_ped)) then
			createdSmoke = UseParticleFxAssetNextCall(p_smoke_particle_asset)
			createdPart = StartParticleFxLoopedOnEntityBone(p_smoke_particle, NetToPed(c_ped), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, GetPedBoneIndex(NetToPed(c_ped), bones), 1.0, 0.0, 0.0, 0.0)
			Wait(2000)
			--Wait(250)
			StopParticleFxLooped(createdSmoke, 1)
			StopParticleFxLooped(createdPart, 1)
			StopParticleFxLooped(p_smoke_particle, 1)
			StopParticleFxLooped(p_smoke_particle_asset, 1)
			Wait(2000*3)
			RemoveParticleFxFromEntity(NetToPed(c_ped))
			break
		end
	end
end)

CreateThread(function()
	while true do
		local waitTimer = 1000
		if isVaping and savedItemId ~= 0 then
			waitTimer = 0
			local ped = PlayerPedId()
			if IsPedInAnyVehicle(ped, true) then PlayerIsEnteringVehicle() end
			if isVaping then
				if IsControlPressed(0, 51) then
					Wait(250)
					if IsControlPressed(0, 51) then
						TriggerEvent("Vape:Drag", 0)
					end
					Wait(4000)
				end
				if IsControlPressed(0, 58) then
					waitTimer = 250
					if IsControlPressed(0, 58) then
						TriggerEvent("Vape:VapeAnimFix", 0)
					end
					waitTimer = 1000
				end
			end
		end
		Wait(waitTimer)
	end
end)