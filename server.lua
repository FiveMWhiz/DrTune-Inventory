CreateThread(function()
    Wait(5000)
    exports.oxmysql:executeSync("DELETE FROM user_inventory2 WHERE name like '%Drop%' OR name like '%trash%'")
end)

local Weapon = {
    ['knife'] = '2578778090',
    ['nightstick'] = '1737195953',
    ['hammer'] = '1317494643',
    ['bat'] = '2508868239',
    ['golfclub'] = '1141786504',
    ['pistol'] = '453432689',
    ['combatpistol'] = '1593441988',
    ['microsmg'] = '324215364',
    ['smg'] = '2024373456',
    ['assaultsmg'] = '-270015777"',
    ['assaultrifle'] = '-1074790547',
    ['carbinerifle'] = '-2084633992',
    ['pumpshotgun'] = '1432025498',
    ['stungun'] = '911657153',
    ['molotov'] = '615608432',
    ['heavypistol'] = '-771403250',
    ['combatpdw'] = '171789620',
    ['machete'] = '3713923289',
    ['machinepistol'] = '-619010992',
    ['switchblade'] = '-538741184',
    ['compactrifle'] = '1649403952',
    ['minismg'] = '-1121678507',
    ['flashlight'] = '2343591895',
    ['fireextinguisher'] = '101631238',
    ['smg_mk2'] = tostring(`WEAPON_SMGMK2`)
}

local ItemInfo = {}

RegisterNetEvent('echorp:playerSpawned')
AddEventHandler('echorp:playerSpawned', function(sentData) TriggerEvent('sendingItemstoClient', sentData.cid, sentData.source) end)

function DoesItemExist(item)    
    local Info = json.decode(ItemInfo)
    local Found = false
    for k,v in pairs(Info) do
        if k == item then
            Found = true
            break
        end
    end
    return Found
end

RegisterCommand("evidence", function(source, args, rawCommand)
    local src = source
    local job = exports['echorp']:GetOnePlayerInfo(src, 'job')

    if (job.isPolice) and job.duty == 1 then
        local evidenceId, wantedId = tonumber(args[1]), 99
        if job.name == 'pa' then wantedId = 0 end
        if evidenceId and evidenceId > wantedId then
            
            local coords = GetEntityCoords(GetPlayerPed(src))
            local missionrow = vector3(472.71, -992.73, 26.26)
            local dist = #(coords - missionrow)
            
            if dist < 20 then
                TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'inform', text = 'Opening Evidence Locker '..evidenceId, length = 2500 })
                Wait(1500)
                TriggerClientEvent("server-inventory-open", src, "1", "evidence-" .. tostring(evidenceId))
            elseif #(coords - vector3(1846.62, 3680.29, 34.27)) < 20 then
                TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'inform', text = 'Opening Evidence Locker '..evidenceId, length = 2500 })
                Wait(1500)
                TriggerClientEvent("server-inventory-open", src, "1", "evidence-" .. tostring(evidenceId))
            else
                TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'inform', text = 'Move a little closer to the evidence room at MRPD/BCSO.', length = 5000 })
            end
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'inform', text = 'Provide a evidence ID above 100.', length = 5000 })
        end
    end
end, false)

RegisterCommand("emslocker", function(source, args, rawCommand)
    local src = source
    local player = exports['echorp']:GetPlayerFromId(src)
    local cid = tonumber(player.cid)

    if player.job.name == "ambulance" or ((player.job.isPolice) and player.job.duty == 1) then

        if args[1] then
            if ((player.job.isPolice) and player.job.duty == 1) or (player.job.name == "ambulance" and (player.job.grade == 7 or player.job.grade == 8 or player.job.grade == 15 or player.job.grade == 16)) then
                TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'success', text = 'Authorized!', length = 2500 })
                cid = tonumber(args[1])
            else
                TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'error', text = 'You are not authorized to do that!!', length = 2500 })
            end
        end

        if cid and cid > 0 then
            
            local coords = GetEntityCoords(GetPlayerPed(src))
            local mz = vector3(-443.74, -310.34, 34.91)
            local dist = #(coords - mz)
            
            if dist < 8 then
                TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'inform', text = 'Opening EMS Locker '..cid, length = 2500 })
                Wait(1500)
                TriggerClientEvent("server-inventory-open", src, "1", "emslocker-" .. tostring(cid))
            else
                TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'inform', text = 'Move a little closer to the lockers at Mount Zonah.', length = 5000 })
            end
        end
    end
end, false)

RegisterCommand("pharmacy", function(source, args, rawCommand)
    local src = source
    local player = exports['echorp']:GetPlayerFromId(src)
    local cid = tonumber(player.cid)
    local allowed = false

    if player.job.name == "ambulance" or ((player.job.isPolice) and player.job.duty == 1) then

        if (player.job.name == "ambulance" and (player.job.grade == 5 or player.job.grade == 6 or player.job.grade == 7 or player.job.grade == 8 or player.job.grade == 14 or player.job.grade == 15 or player.job.grade == 16 or player.job.grade == 20 or player.job.grade == 21 or player.job.grade == 22)) then
            TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'success', text = 'Authorized!', length = 2500 })
            allowed = true
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'error', text = 'You are not authorized to do that!!', length = 2500 })
        end


        if cid and cid > 0 and allowed then
            
            local coords = GetEntityCoords(GetPlayerPed(src))
            local mz = vector3(-443.74, -310.34, 34.91)
            local dist = #(coords - mz)
            
            if dist < 8 then
                
                TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'inform', text = 'Opening Pharmacy', length = 2500 })
                Wait(1500)
                TriggerClientEvent("server-inventory-open", src, "1", "pharmacy")
            else
                TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'inform', text = 'Move a little closer to the lockers at Mount Zonah.', length = 5000 })
            end
        end
    end
end, false)

RegisterCommand("giveitem", function(source, args, rawCommand)
    local src = source
    local console = false

    if src == 0 then console = true end
    
    if not console then
        if not IsPlayerAceAllowed(src, 'echorp.seniormod') then
            TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'inform', text = 'Invalid permissions.', length = 5000 }) return
        end
    end

    local target = tonumber(args[1])

    if target ~= nil and target > 0 and GetPlayerPing(target) > 0 then
        local item = args[2]
        local count = tonumber(args[3]) or 1
        
        if count then

            if item ~= nil and type(item) == 'string' then
                if string.match(item, "weapon_") then 
                    item = GetHashKey(item)
                end

                if not DoesItemExist(item) and Weapon[item] then
                    item = Weapon[item]
                end
            end

            if item ~= nil and type(item) == 'string' and DoesItemExist(item) then
                if console then
                    print("Item Given.")    
                else 
                    local msg = 'A command was used to give an item to a player.\n\nType: **Give Command**\n From: **'..GetPlayerName(src)..'\n**To: **'..GetPlayerName(args[1])..'**\nItem: **'..item..'**\nCount: **'..count..'**'
                    TriggerEvent('erp_adminmenu:discord', 'Inventory Logging', msg, '16711680', "https://discordapp.com/api/webhooks/731752246395535450/MXLUjYat7v13kVpcRbONiKBLGOWj_EEeQPP5YvOY62eIcc1xo1yiJ9GHsVJrYB53uUqH")
                    TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'inform', text = 'Item Given.', length = 5000 })
                end

                if string.match(item, "weapon_") then item = GetHashKey(item) end
                TriggerClientEvent('player:receiveItem', target, item, count)
            else
                if console then
                    print("Invalid Item.")
                else
                    TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'inform', text = 'Invalid item.', length = 5000 })
                end
            end
        else
            if console then
                print("Invalid Count.")
            else
                TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'inform', text = 'Invalid Count.', length = 5000 })
            end
        end
    else
        if console then
            print("Target Offline.")
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'inform', text = 'Target Offline.', length = 5000 })
        end
    end
end, false)

-- cash:remove
RegisterNetEvent('cash:remove')
AddEventHandler('cash:remove', function(source,cash)
    if cash ~= nil then
        if cash > 0 then
            local cid = exports['echorp']:GetOnePlayerInfo(source, 'cid')
            if cid then
                TriggerEvent('RemoveCash', cid, cash, true, true)
            end
        end
    end
end)

RegisterNetEvent('sendListToLua')
AddEventHandler('sendListToLua', function(data)
    ItemInfo = json.encode(data)
end)

--[[ Migration ]]

RegisterCommand("heal", function(source, args, rawCommand)
	local src = source
	local console, allowed = false, false

	if src == 0 then
		console = true
		allowed = true
	else
		if IsPlayerAceAllowed(src, 'echorp.mod') then
			allowed = true
		end
	end

	if not allowed then
		TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'inform', text = 'Tut tut, you are not allowed to do this!', length = 5000})
		return
	end

	if args[1] then
		local playerId = tonumber(args[1])
		if playerId and GetPlayerPing(playerId) > 0 then
			TriggerClientEvent('esx_basicneeds:healPlayer', playerId)

			if not console then
				TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'inform', text = 'Target Revived.', length = 5000})
			else
				print("[EchoRP] Player Revived.")
			end
		else
			if not console then
				TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'inform', text = 'Player not online.', length = 5000})
			else
				print("[EchoRP] Player Not Online.")
			end		
		end
	else
		if not console then
			TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'inform', text = 'You provided no target, I\'ll simply heal you.', length = 5000})
			TriggerClientEvent('esx_basicneeds:healPlayer', src)
		else
			print("[EchoRP] No Target Provided")
		end
	end
end, false) -- set this to false to allow anyone.

-- Paleto

local PaletoLoot = {
    [1] = { type = 'loot', coords = vector4(-103.35, 6475.89, 31.64, 221.1), status = 0, time = 0},
    [2] = { type = 'loot', coords = vector4(-103.78, 6477.8, 31.62, 317.48), status = 0, time = 0},
    [3] = { type = 'loot', coords = vector4(-105.6, 6478.07, 31.62, 36.85), status = 0, time = 0},
}

RegisterNetEvent('erp-robberies:server:paletobank')
AddEventHandler('erp-robberies:server:paletobank', function(data, sentNum)
    if data and sentNum then
        if GlobalState.numberOfPolice >= 0 then
            TriggerClientEvent('erp-dispatch:paleto:bankrobbery', source)
            data[sentNum]['status'] = 1
            TriggerClientEvent('erp-robberies:client:paletobank:adjustValue', -1, data, sentNum, source)
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'No money in the bank', length = 4000 })
        end
    end
end)

RegisterNetEvent('erp-robberies:server:attemptloot')
AddEventHandler('erp-robberies:server:attemptloot', function(data, hasEnough)
    if data <= 3 then
        if hasEnough then
            if PaletoLoot[data]['status'] == 0 then
                if PaletoLoot[data]['time'] == 0 or (PaletoLoot[data]['time'] - os.time() < 1) then
                    PaletoLoot[data]['status'] = 1
                    TriggerClientEvent('erp-robberies:client:attemptloot', source, data)
                end
            end 
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Missing Required Item', length = 3000 })
        end
    end
end)

RegisterNetEvent('erp-robberies:server:getloot')
AddEventHandler('erp-robberies:server:getloot', function(lootId)
    if lootId then
        PaletoLoot[lootId]['status'] = 0
        PaletoLoot[lootId]['time'] = os.time() + 3600
        TriggerClientEvent('player:receiveItem', source, 'band', math.random(1, 2))
        TriggerClientEvent('player:receiveItem', source, 'markedbills', math.random(1, 2))
        if math.random(1, 100) >= 85 then
            TriggerClientEvent('player:receiveItem', source, 'blackoutkey', 1)
        end
    end 
end)

RegisterNetEvent('erp-robberies:server:failedloot')
AddEventHandler('erp-robberies:server:failedloot', function(lootId)
    if lootId then
        PaletoLoot[lootId]['status'] = 0
    end 
end)


-- EVIDENCE 



RegisterNetEvent('erp-inventory:runEvidence')
AddEventHandler('erp-inventory:runEvidence', function(sentInformation)
    local source = source
    if sentInformation then
        local cid = string.sub(sentInformation['Identifier'], 13)
        local evidenceid = sentInformation['Identifier']:sub(1, 11)
        local evidenceType = sentInformation['type']

        if evidenceType == 'Blood' then
            exports.oxmysql:fetch('SELECT dna_collected, firstname, lastname FROM users WHERE id=:id LIMIT 1', {id = cid}, function(result)
                if result[1] then
                    if not result[1]['dna_collected'] then
                        TriggerClientEvent('chat:addMessage', source, {
                            template = '<div class="chat-message-system">Evidence ID: {0}<br>Citizen ID: {1}<br>Type: {2}<br>Other Info: {3}</div>',
                            args = { evidenceid, 'No Matching Evidence', sentInformation['type'], sentInformation['other']}
                        })
                    else
                        local name = result[1]['firstname']..' '..result[1]['lastname']
                        TriggerClientEvent('chat:addMessage', source, {
                            template = '<div class="chat-message-system">Evidence ID: {0}<br>Citizen ID: {1}<br>Name: {4}<br>Type: {2}<br>Other Info: {3}</div>',
                            args = { evidenceid, cid, sentInformation['type'], sentInformation['other'], name}
                        })
                    end 
                end
            end)
        else
            TriggerClientEvent('chat:addMessage', source, {
                template = '<div class="chat-message-system">Evidence ID: {0}<br>Type: {1}<br>Other Info: {2}</div>',
                args = { evidenceid, sentInformation['type'], sentInformation['other']}
            })
        end
    end 
end)

RegisterNetEvent('erp-inventory:runCottonSwab')
AddEventHandler('erp-inventory:runCottonSwab', function(dbId, sentTargetId)
    local source = source
    if sentTargetId and dbId then
        local targetCid = exports['echorp']:GetOnePlayerInfo(sentTargetId, 'cid')
        if targetCid then
            local Information = { ['CID'] = targetCid }
            exports.oxmysql:execute("UPDATE user_inventory2 SET information=:information WHERE id=:id", { information = json.encode(Information), id = dbId }, function(result)
                if result then
                    TriggerEvent('server-request-update-src', 'ply-'..''..exports['echorp']:GetOnePlayerInfo(source, 'cid'), source)
                    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Cotton swab now has DNA on it, go ahead and scan it!', length = 5000 })
                end
            end)
        end 
    end
end)

RegisterNetEvent('erp-inventory:finishCottonSwab')
AddEventHandler('erp-inventory:finishCottonSwab', function(dbId, sentInformation)
    local source = source
    exports.oxmysql:execute("DELETE FROM user_inventory2 WHERE id=:id", { id = dbId }, function(result)
        if result then
            TriggerEvent('server-request-update-src', 'ply-'..''..exports['echorp']:GetOnePlayerInfo(source, 'cid'), source)
        end
    end)
    exports.oxmysql:execute("UPDATE users SET dna_collected=:dna_collected WHERE id=:id", { dna_collected = '1', id = sentInformation['CID'] }, function(result)
        if result then
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'DNA Obtained and returns to Citizen ID: '..sentInformation['CID'], length = 5000 })
        end
    end)
end)

RegisterNetEvent('policescanner')
AddEventHandler('policescanner', function()
    TriggerClientEvent('erp:walkcommand', source, '69 + '..GlobalState.numberOfPolice)
end)

local NumberCharset = {}
local Charset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end

for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

local function GetRandomNumber(length)
	if length > 0 then return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
    else return '' end
end

local function GetRandomLetter(length)
	if length > 0 then return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
    else return '' end
end

local function isPlateTaken(plate, cb)
    cb(exports.oxmysql:fetchSync('SELECT 1 FROM owned_vehicles WHERE plate = :plate', { plate = string.upper(plate)}))
end

local function GeneratePlate(cb)
    local plate = ""
    if math.random(1, 2) == math.random(1, 2) then plate = tostring(GetRandomLetter(1)) 
    else plate = GetRandomNumber(1) end
    local finished = false
    while true do
        Wait(0)
        plate = ""
        if finished then break end;
        for i=1, 8 do
            if math.random(1, 2) == math.random(1, 2) then plate = plate..GetRandomLetter(1)
            else plate = plate..GetRandomNumber(1) end
        end
        isPlateTaken(plate, function(res) finished = not res end)
        if finished then break end
	end
    cb(string.upper(plate))
end

RegisterNetEvent('fakeplate')
AddEventHandler('fakeplate', function(veh)
    local vehicle = NetworkGetEntityFromNetworkId(veh)
    if DoesEntityExist(vehicle) then
        GeneratePlate(function(plate)
            SetVehicleNumberPlateText(vehicle, plate)
        end)   
    end
end)

RegisterNetEvent('driftmode')
AddEventHandler('driftmode', function(veh)
    local vehicle = NetworkGetEntityFromNetworkId(veh)
    if DoesEntityExist(vehicle) then
        local new = false
        
        if Entity(vehicle).state.drift == nil then
            new = true
        elseif Entity(vehicle).state.drift == false then
            new = true
        end
        Entity(vehicle).state:set('drift', new, true)
    end
end)

-- Vape

RegisterNetEvent("eff_smokes")
AddEventHandler("eff_smokes", function(entity)
	TriggerClientEvent("c_eff_smokes", -1, entity)
end)

RegisterNetEvent('erp-inventory:payBusiness')
AddEventHandler('erp-inventory:payBusiness', function(business, amount, cost)
    exports['erp_phone']:AddMoney((amount * cost),business)
end)
