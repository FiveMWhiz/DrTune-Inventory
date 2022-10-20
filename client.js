let usedSlots = [];
let boundItems = {}
let ammoTable = {}
let boundItemsAmmo = {}
let canOpen = true;
let dropName = "none";
let DroppedInventories = [];
let NearInventories = [];
let DrawInventories = [];
let MyInventory = [];
let MyItemCount = 0;
let cash = 0;
let weaponsLicence = false
let openedInv = false;
let cid = 0;
let personalWeight = 0;
let hadBrought = [];

let PlayerData = {}
//0x49 = i 
let objectDumps = [
	{ objectID: 666561306, Description: "Blue Dumpster" },
	{ objectID: 218085040, Description: "Light Blue Dumpster" },
	{ objectID: -58485588, Description: "Gray Dumpster" },
	{ objectID: 682791951, Description: "Big Blue Dumpster" },
	{ objectID: -206690185, Description: "Big Green Dumpster" },
	{ objectID: 364445978, Description: "Big Green Skip Bin" },
	{ objectID: 143369, Description: "Small Bin" },
	
];

let objectPermDumps = [
	{ objectID: 344662182, Description: "Jail Yellow Bin" },
	{ objectID: 1923262137, Description: "Jail Electrical Box" },
	{ objectID: -686494084, Description: "Jail Electrical Box 2" },
	{ objectID: 1419852836, Description: "Jail Electrical Box 3" },
	{ objectID: -1149940374, Description: "Small Bin Food Room" },
	{ objectID: -41273338, Description: "Small Bin Food Room" },
	{ objectID: -686494084, Description: "Small Bin Food Room" },

];

function ScanContainers() {

	let player = PlayerPedId();
	let startPosition = GetOffsetFromEntityInWorldCoords(player, 0, 0.1, 0);
	let endPosition = GetOffsetFromEntityInWorldCoords(player, 0, 1.8, -0.4);

	let rayhandle = StartShapeTestRay(startPosition[0],startPosition[1],startPosition[2], endPosition[0],endPosition[1],endPosition[2], 16, player, 0)

	let vehicleInfo = GetShapeTestResult(rayhandle)

	let hitData = vehicleInfo[4]

	let model = 0;
	let entity = 0;
	if (hitData) {
		model = GetEntityModel(hitData);
	}
	if (model !== 0) {
		for (let x in objectDumps) {
			if (x) {
				if (objectDumps[x].objectID == model) {
					return GetEntityCoords(hitData);
				}
			}
		}
	}
}

function ScanJailContainers() {

	let player = PlayerPedId();
	let startPosition = GetOffsetFromEntityInWorldCoords(player, 0, 0.1, 0);
	let endPosition = GetOffsetFromEntityInWorldCoords(player, 0, 1.8, -0.4);

	let rayhandle = StartShapeTestRay(startPosition[0],startPosition[1],startPosition[2], endPosition[0],endPosition[1],endPosition[2], 16, player, 0)

	let vehicleInfo = GetShapeTestResult(rayhandle)

	let hitData = vehicleInfo[4]

	let model = 0;
	let entity = 0;
	if (hitData) {
		model = GetEntityModel(hitData);
	}
	if (model !== 0) {
		for (let x in objectPermDumps) {
			if (x) {
				if (objectPermDumps[x].objectID == model) {
					return GetEntityCoords(hitData);
				}
			}
		}
	}
}

on("onResourceStart", async (resource) => {
	if (resource == GetCurrentResourceName()){
		cid = 'ply-' + exports.isPed.isPed("cid").toString();
		if (cid != null) {
			setTimeout(()=>{
				emitNet("server-request-update",cid)
				SendNuiMessage(JSON.stringify({ response: "SendItemList", list: itemList}))
			}, 1000)
		}
	}
});

RegisterNetEvent('echorp:playerSpawned')
on('echorp:playerSpawned', (playerData) => {
	let cid = playerData.cid
	cid = 'ply-' + cid.toString();
	setTimeout(()=>{
		emitNet("server-request-update",cid)
		SendNuiMessage(JSON.stringify({ response: "SendItemList", list: itemList}))
	}, 1000)
})


RegisterNuiCallbackType("Weight");
on("__cfx_nui:Weight", (data, cb) => {
	personalWeight = data.weight
	emit("weight:sendWeight", data.weight)
})

RegisterNuiCallbackType("Close");
on("__cfx_nui:Close", (data, cb) => {
  CloseGui(data.isItemUsed)
})

RegisterNuiCallbackType("GiveItem");
on("__cfx_nui:GiveItem", (data, cb) => {
	if (!data[3]) {
		return
	}

	let id = data[0]
	let amount = data[1]
	let generateInformation = data[2]
	let nonStacking = data[4]
	let itemdata = data[5]

	emit("hud-display-item",id,"Received",amount)
	GiveItem(id, amount, generateInformation,nonStacking, itemdata)	
})

RegisterNetEvent('player:receiveItem')
on('player:receiveItem', (id, amount,generateInformation, itemdata) => {
	if (personalWeight > 250) {
		emit("DoLongHudText","Failed to give " + id + " because you were overweight!",2)
		return
	}
	SendNuiMessage(JSON.stringify({ response: "GiveItemChecks", id: id, amount: amount, generateInformation: generateInformation, data: Object.assign({}, itemdata) }))
})



RegisterNetEvent('hud-display-item')
on('hud-display-item', (itemid,text,amount) => {
	if (openedInv) { return };
	SendNuiMessage(JSON.stringify({ response: "UseBar", itemid: itemid, text: text, amount: amount }))
})

RegisterNetEvent('inventory-bar')
on('inventory-bar', (toggle) => {
	
	SendNuiMessage(JSON.stringify({ response: "DisplayBar", toggle: toggle, boundItems: boundItems, boundItemsAmmo: boundItemsAmmo }))
})

RegisterNetEvent('inventory:removeItem')
on('inventory:removeItem', (id, amount) => {
	RemoveItem(id,amount)
	emit("hud-display-item",id,"Removed", amount)
})

function RemoveItem(id,amount) {
	cid = 'ply-' + exports.isPed.isPed("cid").toString();
	pId = GetPlayerServerId(PlayerId());

	emitNet("server-remove-item",cid,id, amount, openedInv,pId)
}

function UpdateItem(id, slot, data) {
	cid = 'ply-' + exports.isPed.isPed("cid").toString();
	emitNet("server-update-item",cid, id, slot, data,)
}

RegisterNetEvent('inventory:updateItem')
on('inventory:updateItem', (id, slot, data) => {
	UpdateItem(id, slot, data)
})

// this is used for giving a dropped item, not put into inventory
RegisterNetEvent('CreateCraftOption')
on('CreateCraftOption', (id, add, craft) => {
	CreateCraftOption(id, add,craft)
})

function CreateCraftOption(id, add, craft) {
	if(exports.isPed.isPed("dead")){return;}
	if(exports["erp-police"].isCuffed()){return;}
	//if(exports["erp-inventory"].canOpenInventory() == false){return;}
	let itemArray = [
		{ itemid: id, amount: add }
	];
	if (craft === true) {
		emitNet("server-inventory-open", GetEntityCoords(PlayerPedId()), cid, "7", "Craft", JSON.stringify(itemArray));
	} else {
		emitNet("server-inventory-open", GetEntityCoords(PlayerPedId()), cid, "7", "Shop", JSON.stringify(itemArray));
	}
}

let slotsAvailable = [...Array(41).keys()].slice(1)

function ResetCache(fullReset) {
	CacheBinds(JSON.parse(MyInventory))
	slotsAvailable = [...Array(41).keys()].slice(1)
	if (fullReset) {
		usedSlots = []
	}
}

let hasIncorrectItems = false

RegisterNuiCallbackType('dropIncorrectItems');
on('__cfx_nui:dropIncorrectItems', (data, cb) => {
	hasIncorrectItems = true
	if (!canOpen) { return; }
	canOpen = false;
	emitNet("server-inventory-open", GetEntityCoords(PlayerPedId()), cid, "13", "Drop", data.slots);
	setTimeout(()=>{canOpen = true},2000)
});


let recentused = [];
RegisterNuiCallbackType('SlotJustUsed');
on('__cfx_nui:SlotJustUsed', (data, cb) => {
	let target = data.targetslot
	if (target < 5 && data.MyInvMove) {
	ResetCache(true)
		Rebind(target,data.itemid)
	}
	if (data.move) {
		boundItems[data.origin] = undefined
	}
	recentused.push(data.origin)
	recentused.push(data.targetslot)
	usedSlots = []
});

function doubleCheck(slotcheck) {
	let foundshit = recentused.find(x => x == slotcheck)
	if (foundshit) {
		return false
	} else {
		return true
	}
}

function findSlot(ItemIdToCheck,amount, nonStacking) {

	let sqlInventory = JSON.parse(MyInventory);

	let itemCount = parseInt(MyItemCount);
	let foundslot = 0;

	for (let i = 0; i < itemCount; i++) { 
		if ( (sqlInventory[i].item_id == ItemIdToCheck ) && nonStacking == false) {
			if (doubleCheck(sqlInventory[i].slot)) {
				foundslot = sqlInventory[i].slot
			}
		}
	} 

	if (usedSlots[ItemIdToCheck] && nonStacking == false) {
		foundslot = usedSlots[ItemIdToCheck];
		slotsAvailable = slotsAvailable.filter(x => x != foundslot)
	}

	for (let i = 0; i < itemCount; i++) { 
		slotsAvailable = slotsAvailable.filter(x => x != sqlInventory[i].slot)
	} 

	if (foundslot == 0 && slotsAvailable[0] != undefined && slotsAvailable.length > 0) {
		foundslot = slotsAvailable[0];
		usedSlots[ItemIdToCheck] = foundslot;
		slotsAvailable = slotsAvailable.filter(x => x != foundslot);
	}

	if (foundslot == 0) {
		emit("DoLongHudText","Failed to give " + ItemIdToCheck + " because you were full!",2)
	}

	return foundslot;
}

RegisterNetEvent('loopUpdateItems')
on('loopUpdateItems', () => {

	cid = 'ply-' + exports.isPed.isPed("cid").toString();
	if (openedInv) {
	}else{
	emitNet("sendingItemstoClient",cid);
	
	SendNuiMessage(JSON.stringify({ response: "SendItemList", list: itemList}))
	ResetCache(true)
}
})

let HousingObjects = [
	90805875, -301668442, 1725227610, 914205402, -457079481, 1601487018, 309266674, -1251197000, 603696143, 306579620, 1089807209, -2008585441, 
	1797500920, -586091884, -335877674, -1003293747, -1538231930, -1221122355, -1280437652, -599924401, 863314394, -1464134536, 1892623307, 658311972, -1600421347,
	580175976, -2094907124, 250681399, -994868291, -2008585441
]

RegisterNetEvent('inventory-open-request')
on('inventory-open-request', () => {
	
	SendNuiMessage(JSON.stringify({ response: "SendItemList", list: itemList}))

	let player = PlayerPedId();
	let startPosition = GetOffsetFromEntityInWorldCoords(player, 0, 0.5, 0);
	let endPosition = GetOffsetFromEntityInWorldCoords(player, 0, 2.0, -0.4);

	let BinFound = ScanContainers();
	let JailBinFound = ScanJailContainers();

	cid = 'ply-' + exports.isPed.isPed("cid").toString();

	if (openedInv) { CloseGui() }
	if(exports.isPed.isPed("dead")){return;}
	if(exports["erp-police"].isCuffed()){return;}
	//if(exports["erp-inventory"].canOpenInventory() == false){return;}

	emit("randPickupAnim")

	OpenGui()

	let rayhandle = StartShapeTestRay(startPosition[0],startPosition[1],startPosition[2], endPosition[0],endPosition[1],endPosition[2], 10, player, 0)
	let vehicleInfo = GetShapeTestResult(rayhandle)
	let vehicleFound = vehicleInfo[4]

	let objectHandle = StartShapeTestRay(startPosition[0],startPosition[1],startPosition[2], endPosition[0],endPosition[1],endPosition[2], 16, player, 0)
	let objectInfo = GetShapeTestResult(objectHandle)
	let objectFound = objectInfo[4]
	let actualObject = GetEntityModel(objectFound)

	//console.log(actualObject)
	
	if (exports['erp-housing'].inHouse()) {
		if (objectFound != 0) {
			//console.log(actualObject)
			if (HousingObjects.indexOf(actualObject) > -1) {
				let objCoords = GetEntityCoords(objectFound)
				let x = parseInt(objCoords[0]);
				let y = parseInt(objCoords[1]);
				let container = actualObject + "|" + x + "|" + y;
				emitNet("server-inventory-open", startPosition, cid, "1", container);
				return
			}
		} else {
			let endPosition = GetOffsetFromEntityInWorldCoords(player, 0.0, 2.0, 0.0);
			let startPosition = GetEntityCoords(player);
			let objectHandle = StartShapeTestRay(startPosition[0],startPosition[1],startPosition[2], endPosition[0],endPosition[1],endPosition[2], -1, player, 5000)
			let objectInfo = GetShapeTestResult(objectHandle)
			let objectFound = objectInfo[4]
			let actualObject = GetEntityModel(objectFound)
			//console.log(actualObject)
			if (objectFound != 0) {
				if (HousingObjects.indexOf(actualObject) > -1) {
					let objCoords = GetEntityCoords(objectFound)
					let x = parseInt(objCoords[0]);
					let y = parseInt(objCoords[1]);
					let container = actualObject + "|" + x + "|" + y;
					emitNet("server-inventory-open", startPosition, cid, "1", container);
					return
				}
			}
		}
	}
	

	if (actualObject == -654402915) {
		TriggerEvent("server-inventory-open", "-654402915", "Shop"); // Food
	} else if (actualObject == -1317235795 || actualObject == 1114264700 || actualObject == 992069095) {
		TriggerEvent("server-inventory-open", "-1317235795", "Shop"); // Drinks
	} else if (IsPedInAnyVehicle(player, false)) {
		vehicleFound = GetVehiclePedIsIn(player,false)
		const licensePlate = GetVehicleNumberPlateText(vehicleFound)
		const vehicleClass = GetVehicleClass(vehicleFound)
		if (vehicleClass != 8 && vehicleClass != 13) {
			emitNet("server-inventory-open", startPosition, cid, "1", "Glovebox-" + licensePlate);
		} else {
			GroundInventoryScan()
		}
	} else if (JailBinFound && GetDistanceBetweenCoords(startPosition[0],startPosition[1],startPosition[2],1700.2,2536.8,45.5) < 80.0) {
		let x = parseInt(JailBinFound[0]);
		let y = parseInt(JailBinFound[1]);
		let container = "jail-container|" + x + "|" + y;
		// emit("inventory-jail", startPosition, cid, container);
		if (exports['erp-inventory'].hasEnoughOfItem('okaylockpick', 1, false)) {
			emitNet("server-inventory-open", startPosition, cid, "1", container);
		}
	} else if (BinFound) {
		let x = parseInt(BinFound[0]);
		let y = parseInt(BinFound[1]);
		let container = "hidden-container|" + x + "|" + y;
		emitNet("server-inventory-open", startPosition, cid, "1", container);
	} else if (vehicleFound != 0 && GetVehicleDoorsLockedForPlayer(vehicleFound) != 1) {
		let cock = GetEntityModel(vehicleFound)
		let coords = GetModelDimensions(cock);

		let back = GetOffsetFromEntityInWorldCoords(vehicleFound,0.0, coords[0][1] - 0.5, 0.0);
		let distanceRear = GetDistanceBetweenCoords(startPosition[0],startPosition[1],startPosition[2], back[0], back[1], back[2]);

		if (GetVehicleDoorLockStatus(vehicleFound) == 2 && distanceRear < 1.5) {
			CloseGui()
		}	else {
			if (distanceRear > 2.2) {
				GroundInventoryScan()
			} else {

				let licensePlate = GetVehicleNumberPlateText(vehicleFound);
				if(licensePlate != null){
					SetVehicleDoorOpen(vehicleFound, 5, 0, 0)
					TaskTurnPedToFaceEntity(player, vehicleFound, 1.0)
					emit("toggle-animation", true);

					let foodtruck = false
					if (exports.isPed.isPed("myjob") == "taco") {
						foodtruck = true
					}

					if (cock == GetHashKey('taco') && foodtruck) {
						TriggerEvent("server-inventory-open", "18", "Shop");
					} else {

						let vehicleClass = GetVehicleClass(vehicleFound)
						if (vehicleClass != 8 && vehicleClass != 13) {
							const vehicleModel = GetEntityModel(vehicleFound)
							//console.log("Vehicle Model:", vehicleModel)
							emitNet("server-inventory-open", startPosition, cid, "1", "Trunk-" + licensePlate, "", "", { model: vehicleModel, class: vehicleClass});
						} else {
							GroundInventoryScan()
						}
					}
				} else {
					GroundInventoryScan()
				}
			}
		}
	} else {
		GroundInventoryScan()
	}
});

function GroundInventoryScan() {
	if (exports["erp-motels"].inApartment()) {
		emitNet("server-inventory-open", GetEntityCoords(PlayerPedId()), cid, "3", "create");
		exports["mythic_notify"].SendAlert('inform', 'Any dropped items in the free apartment will be lost.', 5000)
	}
	let row = DroppedInventories.find(ScanClose);
	if (row) {
		emitNet("server-inventory-open", GetEntityCoords(PlayerPedId()), cid, "1", row.name);
	} else {
		emitNet("server-inventory-open", GetEntityCoords(PlayerPedId()), cid, "3", "create");
	}
}

function ScanClose(row) {
	let playerPos = GetEntityCoords(PlayerPedId());
	let targetPos = row.position
	let distancec = GetDistanceBetweenCoords(playerPos[0], playerPos[1], playerPos[2], targetPos.x, targetPos.y, targetPos.z);
	return distancec < 1.5;
}

let debug = true;

function ClearCache(sentIndexName) {
	let foundIndex = -1;
	let i = 0;
	for (let Row in DroppedInventories) {
		if (DroppedInventories[Row].name == sentIndexName) {
			foundIndex = i;
			break;
		}
		i++
	}
	if (foundIndex > -1) {
		DroppedInventories.splice(foundIndex, 1);
	}

	foundIndex = -1;
	i = 0;
	for (let Row in DrawInventories) {
		if (DrawInventories[Row].name == sentIndexName) {
			foundIndex = i;
			break;
		}
		i++
	}
	if (foundIndex > -1) {
		DrawInventories.splice(foundIndex, 1);
	}

	foundIndex = -1;
	i = 0;
	for (let Row in NearInventories) {
		if (NearInventories[Row].name == sentIndexName) {
			foundIndex = i;
			break;
		}
		i++
	}

	if (foundIndex > -1) {
		NearInventories.splice(foundIndex, 1);
	}
}

function drawMarkersUI() {
	for (let Row in DrawInventories) {		
		DrawMarker(20,DrawInventories[Row].position.x, DrawInventories[Row].position.y, DrawInventories[Row].position.z-0.8,0,0,0,0,0,0,0.35,0.5,0.15,252,255,255,91,0,0,0,0)
	}	
}

setTick(drawMarkersUI);

function CacheInventories() {
	DrawInventories = NearInventories.filter(DrawMarkers);
}

setInterval(CacheInventories, 1000);

function GetCloseInventories() {
	NearInventories = DroppedInventories.filter(Scan);
}
setInterval(GetCloseInventories, 15000);

function DrawMarkers(row) {
	let plyPed = PlayerPedId()
	let playerPos = GetEntityCoords(plyPed);
	let targetPos = row.position;
	let distanceb = GetDistanceBetweenCoords(playerPos[0], playerPos[1], playerPos[2], targetPos.x, targetPos.y, targetPos.z);
	let checkDistance = 12
	if (IsPedInAnyVehicle(plyPed, false)) {
		checkDistance = 25;
	}

	return distanceb < checkDistance;
}

function Scan(row) {
	let plyPed = PlayerPedId()
	let playerPos = GetEntityCoords(plyPed);
	let targetPos = row.position;
	let distancea = GetDistanceBetweenCoords(playerPos[0], playerPos[1], playerPos[2], targetPos.x, targetPos.y, targetPos.z);

	let checkDistance = 300;
	if (IsPedInAnyVehicle(plyPed, false)) {
		checkDistance = 700;
	}

	return distancea < checkDistance;
}

function CacheBinds(sqlInventory) {

	boundItems = {}
	let Ped = PlayerPedId()
	for (let i = 0; i < itemCount; i++) {
		let slot = sqlInventory[i].slot
		if ( slot < 5) {
			//boundItems[slot] = sqlInventory[i].item_id
			boundItems[slot] = [sqlInventory[i].item_id, sqlInventory[i].creationDate];

			if (!isNaN(boundItems[slot])) {

				let ammoType = Citizen.invokeNative("0x7FEAD38B326B9F74", Ped, parseInt(boundItems[slot]), Citizen.returnResultAnyway(), Citizen.resultAsInteger())

				if (ammoTable[""+ammoType+""]) {
					boundItemsAmmo[slot] = ammoTable[""+ammoType+""].ammo
				} else {
					boundItemsAmmo[slot] = 0
				}
			} else {
				boundItemsAmmo[slot] = undefined
			}
		}
	}
}

function Rebind(slot,itemid) {
	
	let Ped = PlayerPedId()
	boundItems[slot] = itemid

	if (!isNaN(boundItems[slot])) {

		let ammoType = Citizen.invokeNative("0x7FEAD38B326B9F74", Ped, parseInt(boundItems[slot]), Citizen.returnResultAnyway(), Citizen.resultAsInteger())

		if (ammoTable[""+ammoType+""]) {
			boundItemsAmmo[slot] = ammoTable[""+ammoType+""].ammo
		} else {
			boundItemsAmmo[slot] = 0
		}

	} else {

		boundItemsAmmo[slot] = undefined
	}

}


RegisterNetEvent('nui-toggle')
on('nui-toggle', (toggle) => {
	SetNuiFocus(toggle,toggle)
});

RegisterNetEvent('inventory-bind')
on('inventory-bind', (slot) => {
	if(exports.isPed.isPed("dead")){return;}
	let cid = 'ply-' + exports.isPed.isPed("cid").toString();
	let inventoryUsedName = cid
	let itemid = boundItems[slot]
	let isWeapon = true
	if (isNaN(itemid[0])) { isWeapon = false }
	emit("RunUseItem", itemid[0], slot, inventoryUsedName, isWeapon, ConvertQuality(itemid[0], itemid[1]));
});

RegisterNetEvent('inventory-bind-CLIENT')
on('inventory-bind-CLIENT', (itemid, slot, inventoryUsedName, isWeapon, creationDate) => {
	let dura = ConvertQuality(itemid, creationDate)
	emit("RunUseItem", itemid, slot, inventoryUsedName, isWeapon, dura);
});

RegisterNetEvent('OpenInv')
on('OpenInv', () => {
	if(exports.isPed.isPed("dead")){return;}
	if(exports["erp-police"].isCuffed()){return;}
	//if(exports["erp-inventory"].canOpenInventory() == false){return;}
	emit('inventory-open-request')
});



RegisterNetEvent('inventory:qualityUpdate')
on('inventory:qualityUpdate', (originSlot,originInventory,creationDate) => {

	SendNuiMessage(JSON.stringify({ response: "updateQuality", slot: originSlot, inventory: originInventory, creationDate: creationDate }))
});


RegisterNetEvent('closeInventoryGui')
on('closeInventoryGui', () => {
	CloseGui()
	//closegui
});



RegisterNuiCallbackType("ServerCloseInventory");

on("__cfx_nui:ServerCloseInventory", (data, cb) => {

	let cid = 'ply-' + exports.isPed.isPed("cid").toString();
	if (data.name != "none") {
		emitNet("server-inventory-close", cid, data.name)

		let player = PlayerPedId();
		let startPosition = GetOffsetFromEntityInWorldCoords(player, 0, 0.5, 0);
		let endPosition = GetOffsetFromEntityInWorldCoords(player, 0, 2.0, -0.4);

		let rayhandle = StartShapeTestRay(startPosition[0],startPosition[1],startPosition[2], endPosition[0],endPosition[1],endPosition[2], 10, player, 0)
		let vehicleInfo = GetShapeTestResult(rayhandle)
		let vehicleFound = vehicleInfo[4]


		let isInVehicle = IsPedInAnyVehicle(player, false);
		if (!isInVehicle) {
			SetVehicleDoorShut(vehicleFound, 5, true)
			SetVehicleDoorShut(vehicleFound, 6, true)
		}
	}
})

RegisterNetEvent('sendListAtOnce')
on('sendListAtOnce', () => {
	
	ResetCache(true)
	SendNuiMessage(JSON.stringify({ response: "SendItemList", list: itemList}))
})

RegisterNuiCallbackType("updateMyQuality");
on("__cfx_nui:updateMyQuality", (data, cb) => {
	let cid = 'ply-' + exports.isPed.isPed("cid").toString();

	emitNet("server-item-quality-update", cid, data, GetEntityCoords(PlayerPedId()))
})

RegisterNuiCallbackType('removeCraftItems');
on("__cfx_nui:removeCraftItems", (data,cb) => {

	let requirements = data[0];
	let amountCrafted = data[1]

	for (let xx = 0; xx < requirements.length; xx++) {
		RemoveItem(requirements[xx].itemid,Math.ceil(requirements[xx].amount*amountCrafted))
	}
	//emitNet("server-inventory-removeCraftItems", cid, data, GetEntityCoords(PlayerPedId()),openedInv)
})

RegisterNuiCallbackType('stack');
on("__cfx_nui:stack", (data,cb) => {
	emitNet("server-inventory-stack", cid, data, GetEntityCoords(PlayerPedId()))
})

RegisterNuiCallbackType('move');
on("__cfx_nui:move", (data,cb) => {
	let plyPed = PlayerPedId()
	emitNet("server-inventory-move", cid, data, GetEntityCoords(plyPed))
	if (data[9] && data[3].replace(/"/g, "") != data[2].replace(/"/g, "")) {
		emit("actionbar:setEmptyHanded")
	}
})

RegisterNuiCallbackType('swap');
on("__cfx_nui:swap", (data,cb) => {	
	let plyPed = PlayerPedId()
	emitNet("server-inventory-swap", cid, data, GetEntityCoords(plyPed))
	if (data[9] && data[3].replace(/"/g, "") != data[2].replace(/"/g, "")) {
		emit("actionbar:setEmptyHanded")
	}
})

RegisterNetEvent('server-inventory-open')
on('server-inventory-open', (target, name, type) => {
	cid = 'ply-' + exports.isPed.isPed("cid").toString();
	if(exports.isPed.isPed("dead")){return;}
	if(exports["erp-police"].isCuffed()){return;}
	//if(exports["erp-inventory"].canOpenInventory() == false){return;}
	emitNet("server-inventory-open", GetEntityCoords(PlayerPedId()), cid, target, name, 'unknown', 'unknown', type)
});

RegisterNetEvent('client-inventory-remove-any')
on('client-inventory-remove-any', (itemidsent, amount) => {
	emitNet("server-inventory-remove-any", itemidsent, amount)
});

RegisterNetEvent('client-inventory-remove-slot')
on('client-inventory-remove-slot', (itemidsent, amount, slot) => {
	emitNet("server-inventory-remove-slot", itemidsent, amount, slot)
});

RegisterNetEvent('Inventory-Dropped-Remove')
on('Inventory-Dropped-Remove', (sentIndexName) => {
	ClearCache(sentIndexName);
});

RegisterNetEvent('Inventory-Dropped-Addition')
on('Inventory-Dropped-Addition', (object) => {
	DroppedInventories.push(object)
	NearInventories.push(object)
	DrawInventories.push(object)
});

RegisterNetEvent('requested-dropped-items')
on('requested-dropped-items', (object) => {
	DroppedInventories = []
	object2 = JSON.parse(object)
   for (let key in object2)   {
		DroppedInventories.push(object2[key])
   }
});

RegisterNetEvent('inventory-update-player')
on('inventory-update-player', (information) => {

	let returnInv = BuildInventory(information[0])
	let playerinventory = returnInv[0]
	let itemCount = returnInv[1]

	let invName = information[2]

	MyInventory = playerinventory;
	MyItemCount = itemCount;

	ResetCache(true)
	PopulateGuiSingle(playerinventory,itemCount,invName);
	if (openedInv) {
		SendNuiMessage(JSON.stringify({ response: "EnableMouse" }))
	} 
	emit('current-items', information[0])
});

RegisterNetEvent('inventory-open-target')
on('inventory-open-target', (information) => {


	let returnInv = BuildInventory(information[0])

	let playerinventory = returnInv[0]

	let invName = information[2]
	let targetinventory
	let targetitemCount

	let itemCount2 = 0;

	if (information[7] == true) {
		let returnInv2 = BuildInventory(information[3])
		targetinventory = returnInv2[0]
		targetitemCount = information[3].length
	} else {
		targetinventory = information[3]
		targetitemCount = information[4]
	}
	let targetinvName = information[5]
	if(exports.isPed.isPed("dead")){return;}
	if(exports["erp-police"].isCuffed()){return;}
	//if(exports["erp-inventory"].canOpenInventory() == false){return;}

	if (canOpen === true) {
		MyInventory = playerinventory;
		MyItemCount = information[0].length;
		OpenGui()
		PopulateGui(playerinventory,information[0].length,invName,targetinventory,targetitemCount,targetinvName,cash,information[8]);
		SendNuiMessage(JSON.stringify({ response: "EnableMouse" }))
		ResetCache(true)
	}
	emit('current-items', information[0])
});

RegisterNetEvent('inventory-open-target1')
on('inventory-open-target1', (information) => {
	let returnInv = BuildInventory(information[0])

	let playerinventory = returnInv[0]

	let invName = information[2]
	let targetinventory
	let targetitemCount

	let itemCount2 = 0;

	if (information[7] == true) {
		let returnInv2 = BuildInventory(information[3])
		targetinventory = returnInv2[0]
		targetitemCount = information[3].length
	} else {
		targetinventory = information[3]
		targetitemCount = information[4]
	}
	let targetinvName = information[5]
	if(exports.isPed.isPed("dead")){return;}
	if(exports["erp-police"].isCuffed()){return;}
	//if(exports["erp-inventory"].canOpenInventory() == false){return;}

	if (canOpen === true) {
		MyInventory = playerinventory;
		MyItemCount = information[0].length;
		PopulateGui(playerinventory,information[0].length,invName,targetinventory,targetitemCount,targetinvName,cash);
		SendNuiMessage(JSON.stringify({ response: "EnableMouse" }))
		ResetCache(true)
	}
});

function spam() {
	if (hasIncorrectItems) {
		return
	}

	emit("player:receiveItem","electronics",12)

	emit("player:receiveItem","clutch",12)

	emit("player:receiveItem","screen",5)


}

function spam2() {

	RemoveItem("weedoz",5)

	RemoveItem("weedq",5)	
	setTimeout(spam,3000)
}

let timer = 0;
let timeFunction = false;




function GiveItem(itemid,amount, generateInformation, nonStacking, itemdata) {
	let slot = findSlot(itemid,amount, nonStacking)
	if (!isNaN(itemid)) {
		generateInformation = true;
	}
	if (slot != 0) {
		cid = 'ply-' + exports.isPed.isPed("cid").toString();
		emitNet("server-inventory-give",cid,itemid,slot,amount, generateInformation, Object.assign({}, itemdata), openedInv)
		SendNuiMessage(JSON.stringify({ response: "DisableMouse" }))
	}
}

function CloseGui(pIsItemUsed = false) {
	if(!pIsItemUsed) {
		emit("randPickupAnim")
	}
	TriggerScreenblurFadeOut(250)
	SendNuiMessage( JSON.stringify({ response: "closeGui" }))
	SetNuiFocus(false,false)
	openedInv = false
	recentused = [];
};

function OpenGui() {
	if ( openedInv === true ) {
		return;
	}
	if(exports.isPed.isPed("dead")){return;}
	if(exports["erp-police"].isCuffed()){return;}
	//if(exports["erp-inventory"].canOpenInventory() == false){return;}
	openedInv = true
	SendNuiMessage( JSON.stringify({ response: "openGui" })) 
	SetNuiFocus(true,true)
	TriggerScreenblurFadeIn(250)
	cash = exports.echorp.mycash()
	weaponsLicence = false
	const job = exports.isPed.isPed("myjob")
	let brought = hadBrought[cid]
	let cop = job.isPolice
	setTimeout(()=>{
		SendNuiMessage( JSON.stringify({ response: "cashUpdate", amount: cash, weaponlicence: weaponsLicence,brought: brought,cop: cop}))
	},250)
};

function PopulateGuiSingle(playerinventory,itemCount,invName) {
	let ServerId = PlayerPedId();
  SendNuiMessage(JSON.stringify({ response: "PopulateSingle", playerinventory: playerinventory, itemCount: itemCount, invName: invName,serverId: ServerId  })) 
};

let TrapOwner = false
function PopulateGui(playerinventory,itemCount,invName,targetinventory,targetitemCount,targetinvName,cash,housingShell) {
	let cid = 'ply-' + exports.isPed.isPed("cid").toString();
	let StoreOwner = false
	let ServerId = PlayerPedId();
	if (targetinvName.indexOf("PlayerStore") > -1) {

		if (targetinvName.indexOf("TrapHouse") > -1) {
			SendNuiMessage(JSON.stringify({ response: "Populate", playerinventory: playerinventory, itemCount: itemCount, invName: invName,targetinventory: targetinventory,targetitemCount: targetitemCount, targetinvName: targetinvName, cash: cash, StoreOwner: TrapOwner, serverId: ServerId }))
		} else {
			let targetCid = targetinvName.split('|')
			targetCid = targetCid[0].split('-')

			if (targetCid[1] == cid) {
				StoreOwner = true
			}
			setTimeout(()=>{
				SendNuiMessage(JSON.stringify({ response: "Populate", playerinventory: playerinventory, itemCount: itemCount, invName: invName,targetinventory: targetinventory,targetitemCount: targetitemCount, targetinvName: targetinvName, cash: cash, StoreOwner: StoreOwner, serverId: ServerId }))
			},250)
		}
	} else {
		SendNuiMessage(JSON.stringify({ response: "Populate", playerinventory: playerinventory, itemCount: itemCount, invName: invName,targetinventory: targetinventory,targetitemCount: targetitemCount, targetinvName: targetinvName, cash: cash, StoreOwner: StoreOwner, serverId: ServerId, Shell: housingShell }))
	}
};

RegisterNetEvent('inventory-open-trap')
on('inventory-open-trap', (Owner) => {
	TrapOwner = Owner
});

RegisterNetEvent('inventory-open-target-NoInject')
on('inventory-open-target-NoInject', (playerinventory, itemCount, invName) => {
	if(exports.isPed.isPed("dead")){return;}
	if(exports["erp-police"].isCuffed()){return;}
	//if(exports["erp-inventory"].canOpenInventory() == false){return;}

	if (canOpen === true) {


		let returnInv = BuildInventory(information[0])
		playerinventory = returnInv[0]
		itemCount = returnInv[1]


		MyInventory = playerinventory;
		MyItemCount = itemCount;
		emitNet("server-inventory-close",cid, invName)
	}
});

RegisterNetEvent('inventory-util-canOpen')
on('inventory-util-canOpen', (openStatus) => {
	canOpen = openStatus;
});

function BuildInventory(Inventory) {
	let buildInv = Inventory
	let invArray = {};
	itemCount = 0;
	for (let i = 0; i < buildInv.length; i++) { 
		let quality = ConvertQuality(buildInv[i].item_id,buildInv[i].creationDate)
		invArray[itemCount] = { quality: quality, creationDate: buildInv[i].creationDate, amount: buildInv[i].amount, item_id: buildInv[i].item_id, id: buildInv[i].id,  name: buildInv[i].name, information: buildInv[i].information,  slot: buildInv[i].slot };
		itemCount = itemCount + 1
	}
	return [JSON.stringify(invArray),itemCount]
}

const TimeAllowed = 1000 * 60 * 40320; // 28 days, 
function ConvertQuality(itemID,creationDate) {

    let StartDate = new Date(creationDate).getTime()
    let DecayRate = itemList[itemID].decayrate
    let TimeExtra = (TimeAllowed * DecayRate)
    let percentDone = 100 - Math.ceil((((Date.now() - StartDate) / TimeExtra) * 100))

    if (DecayRate == 0.0) { percentDone = 100 }
    if (percentDone < 0) { percentDone = 0 }
    return percentDone
}


RegisterNuiCallbackType('invuse')
on('__cfx_nui:invuse', (data) => {
	let inventoryUsedName = data[0] 
	let itemid = data[1]
	let slotusing = data[2] 
	let isWeapon = data[3]
	let durability = data[4]	
	emit("RunUseItem",itemid, slotusing, inventoryUsedName, isWeapon, durability);
});

RegisterNetEvent('toggle-animation')
on('toggle-animation', (toggleAnimation) => {
	let lPed = PlayerPedId()
	if(toggleAnimation) {
		TriggerEvent("animation:load")
		if(!IsEntityPlayingAnim(lPed, "mini@repair", "fixing_a_player", 3))
			TaskPlayAnim(lPed, "mini@repair", "fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)
	} else {
		StopAnimTask(lPed, "mini@repair", "fixing_a_player", -4.0);
	}
});
