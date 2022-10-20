let DroppedInventories = [];
let InUseInventories = [];
let DataEntries = 0;
let hasBrought = [];
let CheckedDeginv = [];
const DROPPED_ITEM_KEEP_ALIVE = 1000 * 60 * 15;

function clean() {
    for (let Row in DroppedInventories) {
        if (new Date(DroppedInventories[Row].lastUpdated + DROPPED_ITEM_KEEP_ALIVE).getTime() < Date.now() && DroppedInventories[Row].used && !InUseInventories[DroppedInventories[Row].name]) {
            emitNet("Inventory-Dropped-Remove", -1, [DroppedInventories[Row].name])
            delete DroppedInventories[Row];
        }
    }
}

setInterval(clean, 20000)

RegisterNetEvent("server-remove-item")
onNet("server-remove-item", async (player, itemidsent, amount, openedInv, pId) => {
    functionRemoveAny(player, itemidsent, amount, openedInv, pId)
});

RegisterNetEvent("server-update-item")
onNet("server-update-item", async (player, itemidsent, slot, data) => {
    let src = source
    let playerinvname = player
    exports["oxmysql"].execute("UPDATE user_inventory SET information=:information WHERE item_id=:item_id AND name=:name AND slot=:slot", {
        information: data,
        item_id: itemidsent,
        name: playerinvname,
        slot: slot
    }, function () {
        emit("server-request-update-src", player, src)
    });
});

function functionRemoveAny(player, itemidsent, amount, openedInv, pId) {
    let src = pId
    let playerinvname = player
    if (amount) {
        exports["oxmysql"].execute("DELETE FROM user_inventory2 WHERE name=:name AND item_id=:item_id LIMIT :limit", {
            name: playerinvname,
            item_id: itemidsent,
            limit: amount
        }, function () {
            emit("server-request-update-src", player, src)
            emit('sendingItemstoClient', player, src)
        });
    }
}

RegisterNetEvent("request-dropped-items")
onNet("request-dropped-items", async (player) => {
    let src = source;
    emitNet("requested-dropped-items", src, JSON.stringify(Object.assign({}, DroppedInventories)));
});

RegisterNetEvent("server-request-update")
onNet("server-request-update", async (player) => {
    let src = source
    let playerinvname = player
    exports["oxmysql"].fetch("SELECT count(item_id) as amount, id, item_id, name, information, slot, dropped, creationDate FROM user_inventory2 WHERE name=:name GROUP BY item_id, slot", {
        name: player
    }, function (inventory) {
        emitNet("inventory-update-player", src, [inventory, 0, playerinvname]);
    });
});

RegisterNetEvent("server-request-update-src")
onNet("server-request-update-src", async (player, src) => {
    exports["oxmysql"].fetch("SELECT count(item_id) as amount, id, item_id, name, information, slot, dropped, creationDate FROM user_inventory2 WHERE name=:name GROUP BY item_id, slot", {
        name: player
    }, function (inventory) {
        if (!inventory) { } else {
            var invArray = inventory;
            var i;
            var arrayCount = 0;
            var playerinvname = player
            // DataEntries = DataEntries + 1
            emitNet("inventory-update-player", src, [invArray, arrayCount, playerinvname]);
            //emitNet('current-items', src, invArray)
        }
    })
});

function makeid(length) {
    var result = '';
    var characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghikjlmnopqrstuvwxyz'; //abcdef
    var charactersLength = characters.length;
    for (var i = 0; i < length; i++) {
        result += characters.charAt(Math.floor(Math.random() * charactersLength));
    }
    return result;
}

function GenerateInformation(player, itemid, itemdata) {
    let data = Object.assign({}, itemdata);
    let returnInfo = "{}"

    return new Promise((resolve, reject) => {
        if (itemid == "") return resolve(returnInfo);

        if (itemid == "policebadge") {
            exports["erp-police"].CreateBadge(player.substring(4), function (BadgeInfo) {
                returnInfo = JSON.stringify({
                    callsign: BadgeInfo['callsign'],
                    firstname: BadgeInfo['firstname'],
                    lastname: BadgeInfo['lastname'],
                    job: BadgeInfo['job'],
                    rank: BadgeInfo['rank'],
                    picture: BadgeInfo['picture']
                })
                timeout = 1
                clearTimeout(timeout)
                return resolve(returnInfo);
            })
        }

        if (itemid == "emsbadge") {
            exports["erp-scripts"].CreateBadge(player.substring(4), function (SentInfo) {
                returnInfo = JSON.stringify({
                    firstname: SentInfo['firstname'],
                    lastname: SentInfo['lastname'],
                    job: SentInfo['job'],
                    rank: SentInfo['rank'],
                    expirydate: SentInfo['expirydate'],
                    picture: SentInfo['picture']
                })
                timeout = 1
                clearTimeout(timeout)
                return resolve(returnInfo);
            })
        }

        if (itemid == "weazel_mediabadge") {
            exports["erp-scripts"].CreateBadge(player.substring(4), function (SentInfo) {
                returnInfo = JSON.stringify({
                    firstname: SentInfo['firstname'],
                    lastname: SentInfo['lastname'],
                    job: SentInfo['job'],
                    rank: SentInfo['rank'],
                    expirydate: SentInfo['expirydate'],
                    picture: SentInfo['picture']
                })
                timeout = 1
                clearTimeout(timeout)
                return resolve(returnInfo);
            })
        }

        if (itemid.includes("mzinsurance_")) {
            exports["erp-scripts"].CreateInsurance(player.substring(4), function (SentInfo) {
                returnInfo = JSON.stringify({
                    cid: SentInfo['cid'],
                    name: SentInfo['fullname'],
                })
                timeout = 1
                clearTimeout(timeout)
                return resolve(returnInfo);
            })
        }

        if (itemid == "policebadge") {
        } else if (Object.prototype.toString.call(itemid) === '[object String]') {
            switch (itemid.toLowerCase()) {
                case "idcard":
                    returnInfo = JSON.stringify({ 
                        citizenid: itemdata.citizenid, 
                        firstname: itemdata.firstname, 
                        lastname: itemdata.lastname,
                        dateofbirth: itemdata.dateofbirth,
                        issuedate: itemdata.issuedate,
                        expirydate: itemdata.expirydate,
                        gender: itemdata.gender,
                        hair: itemdata.hair,
                        eye: itemdata.eye,
                        classes: itemdata.classes,
                        permits: itemdata.permits,
                        mugshot: itemdata.mugshot,
                    })
                    timeout = 1;
                    clearTimeout(timeout)
                    return resolve(returnInfo);
                case "policebadge":
                    exports["erp-police"].CreateBadge(player.substring(4), function (BadgeInfo) {
                        returnInfo = JSON.stringify({
                            callsign: BadgeInfo['callsign'],
                            firstname: BadgeInfo['firstname'],
                            lastname: BadgeInfo['lastname'],
                            job: BadgeInfo['job'],
                            rank: BadgeInfo['rank'],
                            picture: BadgeInfo['picture']
                        })
                        timeout = 1
                        clearTimeout(timeout)
                        return resolve(returnInfo);
                    })
                    return
                case "emsbadge":
                    exports["erp-scripts"].CreateBadge(player.substring(4), function (SentInfo) {
                        returnInfo = JSON.stringify({
                            firstname: SentInfo['firstname'],
                            lastname: SentInfo['lastname'],
                            job: SentInfo['job'],
                            rank: SentInfo['rank'],
                            expirydate: SentInfo['expirydate'],
                            picture: SentInfo['picture']
                        })
                        timeout = 1
                        clearTimeout(timeout)
                        return resolve(returnInfo);
                    })
                    return
                case "weazel_mediabadge":
                    exports["erp-scripts"].CreateBadge(player.substring(4), function (SentInfo) {
                        returnInfo = JSON.stringify({
                            firstname: SentInfo['firstname'],
                            lastname: SentInfo['lastname'],
                            job: SentInfo['job'],
                            rank: SentInfo['rank'],
                            expirydate: SentInfo['expirydate'],
                            picture: SentInfo['picture']
                        })
                        timeout = 1
                        clearTimeout(timeout)
                        return resolve(returnInfo);
                    })
                    return                 
                case "casing":
                    returnInfo = JSON.stringify({ Identifier: itemdata.identifier, type: itemdata.eType, other: itemdata.other })
                    timeout = 1
                    clearTimeout(timeout)
                    return resolve(returnInfo);
                case "evidence":
                    returnInfo = JSON.stringify({ Identifier: itemdata.identifier, type: itemdata.eType, other: itemdata.other })
                    timeout = 1;
                    clearTimeout(timeout)
                    return resolve(returnInfo);
                case "casinogold":
                    returnInfo = JSON.stringify({ Cid: itemdata.cid })
                    timeout = 1;
                    clearTimeout(timeout)
                    return resolve(returnInfo);
                case "casinoplat":
                    returnInfo = JSON.stringify({ Cid: itemdata.cid })
                    timeout = 1;
                    clearTimeout(timeout)
                    return resolve(returnInfo);
                case "casinodiamond":
                    returnInfo = JSON.stringify({ Cid: itemdata.cid })
                    timeout = 1;
                    clearTimeout(timeout)
                    return resolve(returnInfo);
                case "legacyvipcard_gold":
                    returnInfo = JSON.stringify({ Cid: itemdata.cid })
                    timeout = 1;
                    clearTimeout(timeout)
                    return resolve(returnInfo);
                case "legacyvipcard_diamond":
                    returnInfo = JSON.stringify({ Cid: itemdata.cid })
                    timeout = 1;
                    clearTimeout(timeout)
                    return resolve(returnInfo);
                case "legacyvipcard_platinum":
                    returnInfo = JSON.stringify({ Cid: itemdata.cid })
                    timeout = 1;
                    clearTimeout(timeout)
                    return resolve(returnInfo);
                case "legacyvipcard_legendary":
                    returnInfo = JSON.stringify({ Cid: itemdata.cid })
                    timeout = 1;
                    clearTimeout(timeout)
                    return resolve(returnInfo);
                case "cncmembership_bronze":
                    returnInfo = JSON.stringify({ Cid: itemdata.cid })
                    timeout = 1;
                    clearTimeout(timeout)
                    return resolve(returnInfo);
                case "cncmembership_silver":
                    returnInfo = JSON.stringify({ Cid: itemdata.cid })
                    timeout = 1;
                    clearTimeout(timeout)
                    return resolve(returnInfo);
                case "cncmembership_gold":
                    returnInfo = JSON.stringify({ Cid: itemdata.cid })
                    timeout = 1;
                    clearTimeout(timeout)
                    return resolve(returnInfo);
                case "cncmembership_diamond":
                    returnInfo = JSON.stringify({ Cid: itemdata.cid })
                    timeout = 1;
                    clearTimeout(timeout)
                    return resolve(returnInfo);
                case "cncmembership_sapphire":
                    returnInfo = JSON.stringify({ Cid: itemdata.cid })
                    timeout = 1;
                    clearTimeout(timeout)
                    return resolve(returnInfo);
                case "mzinsurance_bronze":
                    returnInfo = JSON.stringify({ Cid: itemdata.cid })
                    timeout = 1;
                    clearTimeout(timeout)
                    return resolve(returnInfo);
                case "mzinsurance_silver":
                    returnInfo = JSON.stringify({ Cid: itemdata.cid })
                    timeout = 1;
                    clearTimeout(timeout)
                    return resolve(returnInfo);
                case "mzinsurance_gold":
                    returnInfo = JSON.stringify({ Cid: itemdata.cid })
                    timeout = 1;
                    clearTimeout(timeout)
                    return resolve(returnInfo);
                case "mzinsurance_diamond":
                    returnInfo = JSON.stringify({ Cid: itemdata.cid })
                    timeout = 1;
                    clearTimeout(timeout)
                    return resolve(returnInfo);                
                case "prescription_standard":
                    returnInfo = JSON.stringify({ Cid: itemdata.cid, Drug: itemdata.drug, Symptoms: itemdata.level})
                    timeout = 1;
                    clearTimeout(timeout)
                    return resolve(returnInfo);
                case "prescription_extended":
                    returnInfo = JSON.stringify({ Cid: itemdata.cid, Drug: itemdata.drug, Symptoms: itemdata.level})
                    timeout = 1;
                    clearTimeout(timeout)
                    return resolve(returnInfo);
                case "weedplant":
                    returnInfo = JSON.stringify({ Identifier: itemdata.identifier })
                    timeout = 1;
                    clearTimeout(timeout)
                    return resolve(returnInfo);
                case 'fakeid':
                    returnInfo = JSON.stringify({
                        firstname: itemdata.firstname,
                        lastname: itemdata.lastname,
                        job: itemdata.job,
                        dob: itemdata.dob,
                        sex: itemdata.sex
                    })
                    timeout = 1
                    clearTimeout(timeout)
                    return resolve(returnInfo);
                default:
                    timeout = 1
                    clearTimeout(timeout)
                    return resolve(returnInfo);
            }
        } else {
            return resolve(returnInfo);
        }

        setTimeout(() => {
            if (timeout == 0) {
                return resolve(returnInfo);
            }
        }, 500)

    });
}

RegisterNetEvent("server-inventory-give")
onNet("server-inventory-give", async (player, itemid, slot, amount, generateInformation, itemdata, openedInv) => {
    let src = source
    let playerinvname = player
    let information = "{}"
    let creationDate = Date.now()    
    information = await GenerateInformation(player, itemid, itemdata)
    for (let i=1; i <= amount; i++) { // this might be broken, should come back to double check.
        exports["oxmysql"].executeSync("INSERT INTO user_inventory2 (name, item_id, information, slot, creationDate) VALUES (:name, :item_id, :information, :slot, :creationDate)", {
            name: playerinvname,
            item_id: itemid,
            information: information,
            slot: slot,
            creationDate: creationDate
        });
    }
    emit("server-request-update-src", player, src)
});


RegisterNetEvent("sendingItemstoClient")
onNet("sendingItemstoClient", async (player, sauce) => {
    let src = source
    if (!src) { src = sauce }
    exports["oxmysql"].fetch("SELECT count(item_id) as amount, id, name, item_id, information, slot, dropped, creationDate FROM user_inventory2 WHERE name=:name GROUP BY slot", {
        name: player
    }, function (inventory) {
        if (!inventory) { } else {
            var invArray = inventory;
            var arrayCount = 0;
            var playerinvname = player
            emitNet("inventory-update-player", src, [invArray, arrayCount, playerinvname]);
        }
    })
})

RegisterNetEvent("server-inventory-open")
onNet("server-inventory-open", async (coords, player, secondInventory, targetName, itemToDropArray, sauce, housingShell) => {

    let src = source

    if (!src) {
        src = sauce
    }

    let playerinvname = player

    if (InUseInventories[targetName] || InUseInventories[playerinvname]) {

        if (InUseInventories[playerinvname]) {
            if ((InUseInventories[playerinvname] != player)) {
                return
            } else {

            }
        }
        if (InUseInventories[targetName]) {
            if (InUseInventories[targetName] == player) {

            } else {
                secondInventory = "69"
            }
        }
    }

    exports["oxmysql"].fetch("SELECT count(item_id) as amount, id, name, item_id, information, slot, dropped, creationDate FROM user_inventory2 WHERE name=:name GROUP BY slot", {
        name: player
    }, function (inventory) {
        
        var invArray = inventory;
        var i;
        var arrayCount = 0;

        InUseInventories[playerinvname] = player;

        //emitNet('current-items', src, invArray)

        if (secondInventory == "1") {

            var targetinvname = targetName
            exports["oxmysql"].fetch("SELECT count(item_id) as amount, id, name, item_id, information, slot, dropped, creationDate FROM user_inventory2 WHERE name=:name GROUP BY slot", {
                name: targetinvname
            }, function (inventory2) {
                emitNet("inventory-open-target", src, [invArray, arrayCount, playerinvname, inventory2, 0, targetinvname, 500, true, housingShell]);
                InUseInventories[targetinvname] = player
            });
        }

        else if (secondInventory == "3") {

            let Key = "" + DataEntries + "";
            let NewDroppedName = 'Drop-' + Key;

            DataEntries = DataEntries + 1
            var invArrayTarget = [];
            DroppedInventories[NewDroppedName] = { position: { x: coords[0], y: coords[1], z: coords[2] }, name: NewDroppedName, used: false, lastUpdated: Date.now() }


            InUseInventories[NewDroppedName] = player;

            invArrayTarget = JSON.stringify(invArrayTarget)
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerinvname, invArrayTarget, 0, NewDroppedName, 500, false]);

        }
        else if (secondInventory == "13") {

            let Key = "" + DataEntries + "";
            let NewDroppedName = 'Drop-' + Key;
            DataEntries = DataEntries + 1
            for (let Key in itemToDropArray) {
                for (let i = 0; i < itemToDropArray[Key].length; i++) {
                    let objectToDrop = itemToDropArray[Key][i];
                    exports["oxmysql"].executeSync("UPDATE user_inventory2 SET slot=:slot, name=:name, dropped='1' WHERE name=:key and slot=:slot and item_id=:item_id", {
                        slot: i + 1,
                        name: NewDroppedName,
                        key: Key,
                        slot: objectToDrop.faultySlot,
                        item_id: objectToDrop.faultyItem
                    });
                    emit('sendingItemstoClient', player, src)
                }
            }
            DroppedInventories[NewDroppedName] = { position: { x: coords[0], y: coords[1], z: coords[2] }, name: NewDroppedName, used: false, lastUpdated: Date.now() }
            emitNet("Inventory-Dropped-Addition", -1, DroppedInventories[NewDroppedName])
        } else if (secondInventory == "2") {

            var targetinvname = targetName;
            var shopArray = ConvenienceStore();
            var shopAmount = 16;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerinvname, shopArray, shopAmount, targetinvname, 500, false]);

        }
        else if (secondInventory == "4") {
            var targetinvname = targetName;
            var shopArray = HardwareStore1();
            var shopAmount = 8;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerinvname, shopArray, shopAmount, targetinvname, 500, false]);
        }
        else if (secondInventory == "8") {
            var targetinvname = targetName;
            var shopArray = HardwareStore2();
            var shopAmount = 8;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerinvname, shopArray, shopAmount, targetinvname, 500, false]);
        }
        else if (secondInventory == "9") {
            var targetinvname = targetName;
            var shopArray = HardwareStore3();
            var shopAmount = 8;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerinvname, shopArray, shopAmount, targetinvname, 500, false]);
        }
        else if (secondInventory == "UnstableMeth") {
            var targetinvname = targetName;
            var shopArray = UnstableMeth();
            var shopAmount = 1;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerinvname, shopArray, shopAmount, targetinvname, 500, false]);
        }
        else if (secondInventory == "LaptopCrafting") {
            var targetinvname = targetName;
            var shopArray = LaptopCrafting();
            var shopAmount = 1;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerinvname, shopArray, shopAmount, targetinvname, 500, false]);
        }
        else if (secondInventory == "FakePlateCrafting") {
            var targetinvname = targetName;
            var shopArray = FakePlateCrafting();
            var shopAmount = 1;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerinvname, shopArray, shopAmount, targetinvname, 500, false]);
        }
        else if (secondInventory == "rawmethpile") {
            var targetinvname = targetName;
            var shopArray = rawmethpile();
            var shopAmount = 1;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerinvname, shopArray, shopAmount, targetinvname, 500, false]);
        }
        else if (secondInventory == "coldmedicine") {
            var targetinvname = targetName;
            var shopArray = coldmedicine();
            var shopAmount = 1;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerinvname, shopArray, shopAmount, targetinvname, 500, false]);
        }
        else if (secondInventory == "726") {
            var targetinvname = targetName;
            var shopArray = UndergroudShop();
            var shopAmount = 2;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerinvname, shopArray, shopAmount, targetinvname, 500, false]);
        }
        else if (secondInventory == "harness") {
            var targetinvname = targetName;
            var shopArray = HarnessShop();
            var shopAmount = 2;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerinvname, shopArray, shopAmount, targetinvname, 500, false]);
        }
        else if (secondInventory == "drift-bennys") {
            var targetinvname = targetName;
            var shopArray = DriftItemShop();
            var shopAmount = 1;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerinvname, shopArray, shopAmount, targetinvname, 500, false]);
        }
        else if (secondInventory == "699") {
            var targetinvname = targetName;
            var shopArray = CoffeeShop();
            var shopAmount = 1;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerinvname, shopArray, shopAmount, targetinvname, 500, false]);
        }
        else if (secondInventory == "VU") {
            var targetinvname = targetName;
            var shopArray = VanillaUnicorn();
            var shopAmount = 4;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerinvname, shopArray, shopAmount, targetinvname, 500, false]);
        }
        else if (secondInventory == "Mort") {
            var targetinvname = targetName;
            var shopArray = Mortuary();
            var shopAmount = 6;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerinvname, shopArray, shopAmount, targetinvname, 500, false]);
        }
        else if (secondInventory == "5") {
            var targetinvname = targetName;
            var shopArray = GunStore();
            var shopAmount = 9;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerinvname, shopArray, shopAmount, targetinvname, 500, false]);
        }
        else if (secondInventory == "6") {
            var targetinvname = targetName;
            var shopArray = HoboJims();
            var shopAmount = 5;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerinvname, shopArray, shopAmount, targetinvname, 500, false]);
        }

        else if (secondInventory == "30") {
            var targetinvname = targetName;
            var shopArray = FatMikesBar();
            var shopAmount = 8;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerinvname, shopArray, shopAmount, targetinvname, 500, false]);
        }
        else if (secondInventory == "609") {
            var targetinvname = targetName;
            var shopArray = Water();
            var shopAmount = 1;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerinvname, shopArray, shopAmount, targetinvname, 500, false]);
        }
        else if (secondInventory == "10") {
            var targetinvname = targetName;
            var shopArray = PoliceArmory();
            var shopAmount = 12;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerinvname, shopArray, shopAmount, targetinvname, 500, false]);
        }
        else if (secondInventory == "12") {
            var targetinvname = targetName;
            var shopArray = BurgieStore();
            var shopAmount = 2;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerinvname, shopArray, shopAmount, targetinvname, 500, false]);
        }
        else if (secondInventory == "11") {
            emitNet("inventory-open-target-NoInject", src, [invArray.arrayCount, playerinvname]);
        } else if (secondInventory == "14") {
            var targetinvname = targetName;
            var shopArray = CourtHouse();
            var shopAmount = 1;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerinvname, shopArray, shopAmount, targetinvname, 500, false]);
        } else if (secondInventory == "thermalcharge") {
            var targetinvname = targetName;
            var shopArray = thermalcharge();
            var shopAmount = 1;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerinvname, shopArray, shopAmount, targetinvname, 500, false]);
        }
        else if (secondInventory == "15") {
            var targetinvname = targetName;
            var shopArray = MedicArmory();
            var shopAmount = 2;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerinvname, shopArray, shopAmount, targetinvname, 500, false]);
        }
        else if (secondInventory == "16") {
            var targetinvname = targetName;
            var shopArray = HardwareStore4();
            var shopAmount = 2;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerinvname, shopArray, shopAmount, targetinvname, 500, false]);
        }
        else if (secondInventory == "17") {
            var targetinvname = targetName;
            var shopArray = HardwareStore5();
            var shopAmount = 2;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerinvname, shopArray, shopAmount, targetinvname, 500, false]);
        }
        else if (secondInventory == "18") {
            var targetinvname = targetName;
            var shopArray = TacoTruck();
            var shopAmount = 15;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerinvname, shopArray, shopAmount, targetinvname, 500, false]);
        }
        else if (secondInventory == "19") {
            var targetinvname = targetName;
            var shopArray = HardwareStore6();
            var shopAmount = 9;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerinvname, shopArray, shopAmount, targetinvname, 500, false]);
        }
        else if (secondInventory == "20") {
            var targetinvname = targetName;
            var shopArray = ElectronicStore();
            var shopAmount = 7;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerinvname, shopArray, shopAmount, targetinvname, 500, false]);
        }
        else if (secondInventory == "21") {
            var targetinvname = targetName;
            var shopArray = SexStore();
            var shopAmount = 4;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerinvname, shopArray, shopAmount, targetinvname, 500, false]);
        }
        else if (secondInventory == "-654402915") {
            var targetinvname = targetName;
            var shopArray = VendingMachine1();
            var shopAmount = 2;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerinvname, shopArray, shopAmount, targetinvname, 500, false]);
        }
        else if (secondInventory == "-1317235795") {
            var targetinvname = targetName;
            var shopArray = VendingMachine2();
            var shopAmount = 2;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerinvname, shopArray, shopAmount, targetinvname, 500, false]);
        }
        else if (secondInventory == "22") {
            var targetinvname = targetName;
            var shopArray = JailFood();
            var shopAmount = 1;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerinvname, shopArray, shopAmount, targetinvname, 500, false]);
        }
        else if (secondInventory == "23") {
            var targetinvname = targetName;
            var shopArray = CarParts1();
            var shopAmount = 5;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerinvname, shopArray, shopAmount, targetinvname, 500, false]);
        }
        else if (secondInventory == "24") {
            var targetinvname = targetName;
            var shopArray = CarParts2();
            var shopAmount = 5;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerinvname, shopArray, shopAmount, targetinvname, 500, false]);
        }
        else if (secondInventory == "25") {
            var targetinvname = targetName;
            var shopArray = CarParts3();
            var shopAmount = 5;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerinvname, shopArray, shopAmount, targetinvname, 500, false]);
        }
        else if (secondInventory == "26") {
            var targetinvname = targetName;
            var shopArray = CarParts4();
            var shopAmount = 5;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerinvname, shopArray, shopAmount, targetinvname, 500, false]);
        }
        else if (secondInventory == "27") {
            var targetinvname = targetName;
            var shopArray = CarParts5();
            var shopAmount = 5;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerinvname, shopArray, shopAmount, targetinvname, 500, false]);
        }
        else if (secondInventory == "32") {
            var targetinvname = targetName;
            var shopArray = TacoTruck();
            var shopAmount = 15;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerinvname, shopArray, shopAmount, targetinvname, 500, false]);
        }
        else if (secondInventory == "554") {
            var targetinvname = targetName;
            var shopArray = Weed();
            var shopAmount = 2;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerinvname, shopArray, shopAmount, targetinvname, 500, false]);
        }
        else if (secondInventory == "203") {
            var targetinvname = targetName;
            var shopArray = Fertilizer();
            var shopAmount = 1;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerinvname, shopArray, shopAmount, targetinvname, 500, false]);
        }
        else if (secondInventory == "1011") {
            var targetinvname = targetName;
            var shopArray = PotatoShit();
            var shopAmount = 9;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerinvname, shopArray, shopAmount, targetinvname, 500, false]);
        }
        else if (secondInventory == "polscanner") {
            var targetinvname = targetName;
            var shopArray = polscanner();
            var shopAmount = 9;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerinvname, shopArray, shopAmount, targetinvname, 500, false]);
        }
        else if (secondInventory == "weazelnews") {
            var targetinvname = targetName;
            var shopArray = weazelnews();
            var shopAmount = 9;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerinvname, shopArray, shopAmount, targetinvname, 500, false]);
        }
        else if (secondInventory == "emspublic") {
            var targetinvname = targetName;
            var shopArray = emspublic();
            var shopAmount = 9;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerinvname, shopArray, shopAmount, targetinvname, 500, false]);
        }
        else if (secondInventory == "213") {
            var targetinvname = targetName;
            var shopArray = BuyPotatoShit();
            var shopAmount = 1;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerinvname, shopArray, shopAmount, targetinvname, 500, false]);
        }
        else if (secondInventory == "553") {
            var targetinvname = targetName;
            var shopArray = HQWeed();
            var shopAmount = 2;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerinvname, shopArray, shopAmount, targetinvname, 500, false]);
        }
        else if (secondInventory == "555") {
            var targetinvname = targetName;
            var shopArray = Plastic();
            var shopAmount = 1;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerinvname, shopArray, shopAmount, targetinvname, 500, false]);
        }
        else if (secondInventory == "556") {
            var targetinvname = targetName;
            var shopArray = THCWeed();
            var shopAmount = 1;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerinvname, shopArray, shopAmount, targetinvname, 500, false]);
        }        
        else if (secondInventory == "55") {
            var targetinvname = targetName;
            var shopArray = Mechanic();
            var shopAmount = 3;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerinvname, shopArray, shopAmount, targetinvname, 500, false]);
        }

        else if (secondInventory == "77") {
            var targetinvname = targetName;
            var shopArray = JT();
            var shopAmount = 5;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerinvname, shopArray, shopAmount, targetinvname, 500, false]);
        }

        else if (secondInventory == "gatsnstraps") {
            var targetinvname = targetName;
            var shopArray = BusinessGunStore();
            var shopAmount = 10;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerinvname, shopArray, shopAmount, targetinvname, 500, false]);
        }

        else if (secondInventory == "secretguns") {
            var targetinvname = targetName;
            var shopArray = secretguns();
            var shopAmount = 10;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerinvname, shopArray, shopAmount, targetinvname, 500, false]);
        }

        else if (secondInventory == "legacyshop") {
            var targetinvname = targetName;
            var shopArray = LegacyFoodShop();
            var shopAmount = 17;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerinvname, shopArray, shopAmount, targetinvname, 500, false]);
        }

        else if (secondInventory == "7") {
            var targetinvname = targetName;
            var shopArray = DroppedItem(itemToDropArray);

            itemToDropArray = JSON.parse(itemToDropArray)
            var shopAmount = itemToDropArray.length;

            emitNet("inventory-open-target", src, [invArray, arrayCount, playerinvname, shopArray, shopAmount, targetinvname, 500, false]);
        }
        else {
            emitNet("inventory-update-player", src, [invArray, arrayCount, playerinvname]);
        }
    });
});



RegisterNetEvent("server-inventory-close")
onNet("server-inventory-close", async (player, targetInventoryName) => {
    let src = source

    if (targetInventoryName.startsWith("Trunk"))
        emitNet("toggle-animation", src, false);
    InUseInventories = InUseInventories.filter(item => item != player);
    if (targetInventoryName.indexOf("Drop") > -1 && DroppedInventories[targetInventoryName]) {
        if (DroppedInventories[targetInventoryName].used === false) {
            delete DroppedInventories[targetInventoryName];
        } else {
            exports["oxmysql"].fetch("SELECT count(item_id) as amount, item_id, name, information, slot, dropped FROM user_inventory2 WHERE name=:name GROUP BY item_id, slot", {
                name: targetInventoryName
            }, function (result) {
                if (result.length == 0 && DroppedInventories[targetInventoryName]) {
                    delete DroppedInventories[targetInventoryName];
                    emitNet("Inventory-Dropped-Remove", -1, [targetInventoryName])
                }
            });
        }
    }
    emit("server-request-update-src", player, source)
});


RegisterNetEvent("server-request.removeCraftItems")
onNet("server-inventory.removeCraftItems", async (player, data, coords, openedInv) => {

});

let IllegalSearchString = `'weedoz', 'weed5oz', 'coke50g', 'thermite', 'weedq', 'weed12oz', 'oxy', '1gcrack', '1gcocaine', 'joint'`

// checked below

RegisterNetEvent("sniffAccepted")
onNet("sniffAccepted", async (t) => {
    let src = source
    emitNet('sniffAccepted', t, src)
});

RegisterNetEvent("server-inventory-remove-slot")
onNet("server-inventory-remove-slot", async (player, itemidsent, amount, slot) => {
    var playerinvname = player
    if (amount) {
        exports["oxmysql"].executeSync("DELETE FROM user_inventory2 WHERE name=:name and item_id=:item_id and slot=:slot LIMIT :amount", {
            name: playerinvname,
            item_id: itemidsent,
            slot: slot,
            amount: amount
        });
    }
});

RegisterNetEvent("server-ragdoll-items")
onNet("server-ragdoll-items", async (player) => {
    let currInventoryName = `${player}`
    let newInventoryName = `wait-${player}`

    exports["oxmysql"].executeSync("UPDATE user_inventory2 SET name=:name WHERE name=:nametwo AND dropped=0 AND (item_id=:item_id OR item_id=:item_idtwo)", {
        name: newInventoryName,
        nametwo: currInventoryName,
        item_id: "mobilephone",
        item_idtwo: "idcard"
    });

    await exports["oxmysql"].executeSync("DELETE FROM user_inventory WHERE name=:name", { name: currInventoryName });

    exports["oxmysql"].executeSync("UPDATE user_inventory2 SET name=:name WHERE name=:nametwo AND dropped=0", {
        name: currInventoryName,
        nametwo: newInventoryName,
    });

});


RegisterNetEvent('server-jail-item')
onNet("server-jail-item", async (player, target, isSentToJail) => {
    let currInventoryName = `${player}`
    let newInventoryName = `${player}`

    if (!isSentToJail) {
        currInventoryName = `${player}`
        newInventoryName = `jail-${target}`
    } else {
        currInventoryName = `jail-${target}`
        newInventoryName = `${player}`
    }

    exports["oxmysql"].executeSync("UPDATE user_inventory2 SET name=:name WHERE name=:nametwo AND dropped=:dropped", {
        name: currInventoryName,
        nametwo: newInventoryName,
        dropped: "0"
    });

});

function removecash(src, amount) {
    emit('cash:remove', src, amount)
}

function idk() { emit('sendListToLua', itemList) }
setTimeout(idk, 30)

setTimeout(CleanDroppedInventory, 5)


function DroppedItem(itemArray) {
    itemArray = JSON.parse(itemArray)
    var shopItems = [];

    shopItems[0] = { item_id: itemArray[0].itemid, id: 0, name: "shop", information: "{}", slot: 1, amount: itemArray[0].amount };

    return JSON.stringify(shopItems);
}
function BuildInventory(Inventory) {
    let buildInv = Inventory
    let invArray = {};
    itemCount = 0;
    for (let i = 0; i < buildInv.length; i++) {
        invArray[itemCount] = { item_id: buildInv[i].item_id, id: buildInv[i].id, name: buildInv[i].name, information: buildInv[i], slot: buildInv[i].slot };
        itemCount = itemCount + 1
    }
    return [JSON.stringify(invArray), itemCount]
}

function mathrandom(min, max) {
    return Math.floor(Math.random() * (max + 1 - min)) + min;
}


const DEGREDATION_INVENTORY_CHECK = 1000 * 60 * 60;
const DEGREDATION_TIME_BROKEN = 1000 * 60 * 40320;
const DEGREDATION_TIME_WORN = 1000 * 60 * 201000;

RegisterNetEvent("inventory:degItem")
onNet("inventory:degItem", async (itemID, amount) => {
    exports["oxmysql"].executeSync("UPDATE user_inventory2 SET creationDate = creationDate - :amount WHERE id=:id", {
        amount: amount,
        id: itemID,
    });
});

RegisterNetEvent("server-inventory-move")
onNet("server-inventory-move", async (player, data, coords) => {
    let src = source
    let targetslot = data[0]
    let startslot = data[1]
    let targetname = data[2].replace(/"/g, "");
    let startname = data[3].replace(/"/g, "");
    let purchase = data[4]
    let itemCosts = data[5]
    let itemidsent = data[6]
    let amount = data[7]
    let crafting = data[8]
    let isWeapon = data[9]
    let PlayerStore = data[10]
    let creationDate = Date.now()

    if ((targetname.indexOf("Drop") > -1 || targetname.indexOf("hidden") > -1) && DroppedInventories[targetname]) {

        if (DroppedInventories[targetname].used === false) {

            DroppedInventories[targetname] = { position: { x: coords[0], y: coords[1], z: coords[2] }, name: targetname, used: true, lastUpdated: Date.now() }
            emitNet("Inventory-Dropped-Addition", -1, DroppedInventories[targetname])
        }
    }

    let info = "{}"

    if (purchase) {
        if (isWeapon) {
        }

        info = await GenerateInformation(player, itemidsent)
        removecash(src, itemCosts)

        if (!PlayerStore) {
            for (let i = 0; i < parseInt(amount); i++) {
                exports["oxmysql"].executeSync("INSERT INTO user_inventory2 (item_id, name, information, slot, creationDate) VALUES (:item_id, :name, :information, :slot, :creationDate)", {
                    item_id: itemidsent,
                    name: targetname,
                    information: info,
                    slot: targetslot,
                    creationDate: creationDate
                });
            }
        } else if (crafting) {

            info - await GenerateInformation(player, itemidsent)
            for (let i = 0; i < parseInt(amount); i++) {
                exports["oxmysql"].executeSync("INSERT INTO user_inventory2 (item_id, name, information, slot, creationDate) VALUES (:item_id, :name, :information, :slot, :creationDate)", {
                    item_id: itemidsent,
                    name: targetname,
                    information: info,
                    slot: targetslot,
                    creationDate: creationDate
                });
            }
        } else {
            if (targetname.indexOf("Drop") > -1 || targetname.indexOf("hidden") > -1) {
                exports["oxmysql"].executeSync("INSERT INTO user_inventory2 SET slot=:slot, name=:name, dropped='1' WHERE slot=:startslot AND name=:startname", {
                    slot: targetslot,
                    name: targetname,
                    startslo: startslot,
                    startname: startname
                });
            } else {
                exports["oxmysql"].executeSync("UPDATE user_inventory2 SET slot=:slot, name=:name, dropped='0' WHERE slot=:startslot and name=:startname", {
                    slot: targetslot,
                    name: targetname,
                    startslot: startslot,
                    startname: startname
                });
            }
        }
    } else {

        if (crafting == true) {

            info - await GenerateInformation(player, itemidsent)
            for (let i = 0; i < parseInt(amount); i++) {
                exports["oxmysql"].executeSync("INSERT INTO user_inventory2 (item_id, name, information, slot, creationDate) VALUES (:item_id, :name, :information, :slot, :creationDate)", {
                    item_id: itemidsent,
                    name: targetname,
                    information: info,
                    slot: targetslot,
                    creationDate: creationDate
                });
            }
        }

        exports["oxmysql"].executeSync("UPDATE user_inventory2 SET slot=:slot, name=:name, dropped='0' WHERE slot=:startslot AND name=:startname", {
            slot: targetslot,
            name: targetname,
            startslot: startslot,
            startname: startname
        });
    }
});

function CleanDroppedInventory() {
    onNet("server-ragdoll-items", async (player) => {
        let currInventoryName = `${player}`
        let newInventoryName = `wait-${player}`
        exports["oxmysql"].executeSync("UPDATE user_inventory2 SET name=:name WHERE name=:newInventoryName AND dropped='0'", {
            name: currInventoryName,
            newInventoryName: newInventoryName
        });
    })
};

RegisterNetEvent("server-inventory-stack")
onNet("server-inventory-stack", async (player, data, coords) => {

    let targetslot = data[0]
    let moveAmount = data[1]
    let targetName = data[2].replace(/"/g, "");
    let src = source
    let originSlot = data[3]

    let originInventory = data[4].replace(/"/g, "");

    let purchase = data[5]
    let itemCosts = data[6]
    let itemidsent = data[7]
    let amount = data[8]
    let crafting = data[9]
    let isWeapon = data[10]
    let PlayerStore = data[11]
    let creationDate = Date.now()

    if ((targetName.indexOf("Drop") > -1 || targetName.indexOf("hidden") > -1) && DroppedInventories[targetName]) {

        if (DroppedInventories[targetName].used === false) {
            DroppedInventories[targetName] = { position: { x: coords[0], y: coords[1], z: coords[2] }, name: targetName, used: true, lastUpdated: Date.now() }
            emitNet("Inventory-Dropped-Addition", -1, DroppedInventories[targetName])
        }
    }

    let info = "{}"

    if (purchase) {
        info = await GenerateInformation(player, itemidsent)
        removecash(src, itemCosts)

        if (!PlayerStore) {
            for (let i = 0; i < parseInt(amount); i++) {
                exports["oxmysql"].executeSync("INSERT INTO user_inventory2 (item_id, name, information, slot, creationDate) VALUES (:item_id, :name, :information, :slot, :creationDate)", {
                    item_id: itemidsent,
                    name: targetName,
                    information: info,
                    slot: targetslot,
                    creationDate: creationDate
                });
            }
        }


        if (PlayerStore) {
            exports["oxmysql"].executeSync("UPDATE user_inventory2 SET slot=:slot, name=:name, dropped='0' WHERE slot=:startslot and name=:startname", {
                slot: targetslot,
                name: targetName,
                startslot: startslot,
                startname: startname
            });
        }


    } else if (crafting) {

        info = await GenerateInformation(player, itemidsent)

        for (let i = 0; i < parseInt(amount); i++) {
            exports["oxmysql"].executeSync("INSERT INTO user_inventory2 (item_id, name, information, slot, creationDate) VALUES (:item_id, :name, :information, :slot, :creationDate)", {
                item_id: itemidsent,
                name: targetName,
                information: info,
                slot: targetslot,
                creationDate: creationDate
            });
        }
    } else {
        exports["oxmysql"].fetch("SELECT item_id, id FROM user_inventory2 WHERE slot=:slot AND name=:name LIMIT :limit", {
            slot: originSlot,
            name: originInventory,
            limit: moveAmount
        }, function (result) {
            let dropped = '0'
            if (targetName.indexOf("Drop") > -1 || targetName.indexOf("hidden") > -1) {
                dropped = '1'
            }
            for (let i = 0; i < result.length; i++) {
                exports["oxmysql"].executeSync("UPDATE user_inventory2 SET slot=:slot, name=:name, dropped=:dropped WHERE id=:id", {
                    slot: targetslot,
                    name: targetName,
                    id: result[i]['id'],
                    dropped: dropped
                });
            }
        });
    }
});

function db(string) { exports.oxmysql.execute(string,{}, function(result) { }); }

RegisterNetEvent("server-inventory-swap")
onNet("server-inventory-swap", (player, data, coords) => {
    let targetslot = data[0]
    let targetname = data[1].replace(/"/g, "");
    let startslot = data[2]
    let startname = data[3].replace(/"/g, "");
        
    exports.oxmysql.fetch("SELECT id FROM user_inventory2 WHERE slot=:targetslot AND name=:targetname",{
        targetslot: targetslot,
        targetname: targetname
    }, function(startid) {
       var itemids = "0"
       for (let i = 0; i < startid.length; i++) { itemids = itemids + "," + startid[i].id }
       let dropped = "0"
       if (targetname.indexOf("Drop") > -1 || targetname.indexOf("hidden") > -1) { dropped = "1" }
       exports.oxmysql.execute("UPDATE user_inventory2 SET slot=:slot, name=:name, dropped=:dropped WHERE slot=:startslot AND name=:startname",{
            slot: targetslot,
            name: targetname,
            dropped: dropped,
            startslot: startslot,
            startname: startname
       }, function(inventory) {
           if (startname.indexOf("Drop") > -1 || startname.indexOf("hidden") > -1) {
               db(`UPDATE user_inventory2 SET slot='${startslot}', name='${startname}', dropped='1' WHERE id IN (${itemids})`);
           } else {
               db(`UPDATE user_inventory2 SET slot='${startslot}', name='${startname}', dropped='0' WHERE id IN (${itemids})`);
           }
       });
    });
});

function deleteHidden() {
    exports["oxmysql"].executeSync("DELETE FROM user_inventory2 WHERE name like '%Hidden%' OR name like '%trash%", {});
}

function deleteHiddenHandler() {
    setTimeout(250000, deleteHidden())
}

/**RegisterNetEvent("server-frisk-player-inventory")
onNet("server-frisk-player-inventory", (searcher, cash, inventoryName) => {
    let weapons = 0
    let string = `SELECT count(item_id) as amount, id, item_id, id, name, information, slot, dropped FROM user_inventory2 WHERE name = '${inventoryName}' group by item_id, slot`;

    exports["oxmysql"].fetch(string, {}, function (inventory) {
        for (let i = 0; i < inventory.length; i++) {
            var t = parseInt(inventory[i].item_id, 10)
            if (!isNaN(t)) {
                weapons++;
            }
        }


        if (cash >= 20000 || weapons >= 1) {
            emitNet("notification", searcher, "Frisk: Person Seems to have large bulge.", 1)
        } else {
            emitNet("notification", searcher, "Frisk: Huh, this person is quite flat...", 1)
        }
    });
});
*/