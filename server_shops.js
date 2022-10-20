function CourtHouse() {
    var shopItems = [
        { item_id: "idcard", id: 0, name: "Shop", information: "{}", slot: 1, amount: 1, price: 25 },
    ];
    return JSON.stringify(shopItems);
}

function PoliceArmory() {
    var shopItems = [
        { item_id: "pistolammo", id: 0, name: "Shop", information: "{}", slot: 1, amount: 10, price: 9 },
        { item_id: "shotgunammo", id: 0, name: "Shop", information: "{}", slot: 2, amount: 10, price: 14 },
        { item_id: "rifleammo", id: 0, name: "Shop", information: "{}", slot: 3, amount: 10, price: 14 },
        { item_id: "911657153", id: 0, name: "Shop", information: "{}", slot: 4, amount: 10, price: 110 }, // Stun Gun
        { item_id: "-1075685676", id: 0, name: "Shop", information: "{}", slot: 5, amount: 10, price: 155 }, // 9MM
        { item_id: "-86904375", id: 0, name: "Shop", information: "{}", slot: 6, amount: 10, price: 315 }, // 762
        { item_id: "-2084633992", id: 0, name: "Shop", information: "{}", slot: 7, amount: 10, price: 270 }, // 556
        { item_id: "1432025498", id: 0, name: "Shop", information: "{}", slot: 8, amount: 10, price: 315 }, // PD Shotgun
        { item_id: "1737195953", id: 0, name: "Shop", information: "{}", slot: 9, amount: 10, price: 90 }, // Nightstick
        { item_id: "2343591895", id: 0, name: "Shop", information: "{}", slot: 10, amount: 10, price: 63 }, // Flashlight
        { item_id: "101631238", id: 0, name: "Shop", information: "{}", slot: 11, amount: 10, price: 126 }, // Fire Ext
        { item_id: "HeavyArmor", id: 0, name: "Shop", information: "{}", slot: 12, amount: 10, price: 63 },
        { item_id: "IFAK", id: 0, name: "Shop", information: "{}", slot: 13, amount: 10, price: 14 },
        { item_id: "radio", id: 0, name: "Shop", information: "{}", slot: 14, amount: 10, price: 45 },
        { item_id: "gpstransponder", id: 0, name: "Shop", information: "{}", slot: 15, amount: 1, price: 50 },
        { item_id: "binoculars", id: 0, name: "Shop", information: "{}", slot: 16, amount: 10, price: 90 },
        { item_id: "cottonswab", id: 0, name: "Shop", information: "{}", slot: 17, amount: 50, price: 0 },
        { item_id: "policebadge", id: 0, name: "Shop", information: "{}", slot: 18, amount: 1, price: 25 },
        { item_id: "spikes", id: 0, name: "Shop", information: "{}", slot: 19, amount: 10, price: 50 },
        { item_id: "mzinsurance_diamond_week", id: 0, name: "Shop", information: "MZ Insurance - Diamond Level</br>100% OFF Medical</br>1 Week", slot: 20, amount: 1, price: 450 },
        { item_id: "mzinsurance_diamond_month", id: 0, name: "Shop", information: "MZ Insurance - Diamond Level</br>100% OFF Medical</br>1 Month", slot: 21, amount: 1, price: 1500 },
        { item_id: "-37975472", id: 0, name: "Shop", information: "{}", slot: 22, amount: 10, price: 20 }, // 9MM
    ];
    return JSON.stringify(shopItems);
}


function MedicArmory() {
    var shopItems = [
        { item_id: "bandage", id: 0, name: "Shop", information: "{}", slot: 1, amount: 50, price: 2 },
        { item_id: "101631238", id: 0, name: "Shop", information: "{}", slot: 2, amount: 1, price: 75 },
        { item_id: "binoculars", id: 0, name: "Shop", information: "{}", slot: 3, amount: 1, price: 90 },
        { item_id: "2343591895", id: 0, name: "Shop", information: "{}", slot: 4, amount: 1, price: 60 },
        { item_id: "911657153", id: 0, name: "Shop", information: "{}", slot: 5, amount: 1, price: 110 },
        { item_id: "radio", id: 0, name: "Shop", information: "{}", slot: 6, amount: 1, price: 45 },
        { item_id: "gpstransponder", id: 0, name: "Shop", information: "{}", slot: 7, amount: 1, price: 50 },
        { item_id: "emsbadge", id: 0, name: "Shop", information: "{}", slot: 8, amount: 1, price: 25 },
        { item_id: "cottonswab", id: 0, name: "Shop", information: "{}", slot: 9, amount: 1, price: 0 },        
        { item_id: "medbag", id: 0, name: "Shop", information: "{}", slot: 10, amount: 50, price: 50 },
        { item_id: "firstaidkit", id: 0, name: "Shop", information: "{}", slot: 11, amount: 50, price: 30 },
        { item_id: "ibuprofen", id: 0, name: "Shop", information: "{}", slot: 12, amount: 50, price: 10 },
        { item_id: "cleanwipes", id: 0, name: "Shop", information: "{}", slot: 13, amount: 50, price: 1 },
        { item_id: "wheelchair", id: 0, name: "Shop", information: "{}", slot: 14, amount: 1, price: 50 },        
        { item_id: "mzinsurance_diamond_week", id: 0, name: "Shop", information: "MZ Insurance - Diamond Level</br>100% OFF Medical</br>1 Week", slot: 15, amount: 1, price: 300 },
        { item_id: "mzinsurance_diamond_month", id: 0, name: "Shop", information: "MZ Insurance - Diamond Level</br>100% OFF Medical</br>1 Month", slot: 16, amount: 1, price: 1000 },
    ];
    return JSON.stringify(shopItems);
}

function JailFood() {
    var shopItems = [
        { item_id: "jailfood", id: 0, name: "Shop", information: "{}", slot: 1, amount: 1, price: 1 },
    ];
    return JSON.stringify(shopItems);
}

function emspublic() {
    var shopItems = [
        { item_id: "mzinsurance_bronze_week", id: 0, name: "Shop", information: "MZ Insurance - Bronze Level</br>25% OFF Medical</br>1 Week", slot: 1, amount: 1, price: 250 },
        { item_id: "mzinsurance_bronze_month", id: 0, name: "Shop", information: "MZ Insurance - Bronze Level</br>25% OFF Medical</br>1 Month", slot: 2, amount: 1, price: 900 },
        { item_id: "mzinsurance_silver_week", id: 0, name: "Shop", information: "MZ Insurance - Silver Level</br>50% OFF Medical</br>1 Week", slot: 3, amount: 1, price: 450 },
        { item_id: "mzinsurance_silver_month", id: 0, name: "Shop", information: "MZ Insurance - Silver Level</br>50% OFF Medical</br>1 Month", slot: 4, amount: 1, price: 1500 },
        { item_id: "mzinsurance_gold_week", id: 0, name: "Shop", information: "MZ Insurance - Gold Level</br>75% OFF Medical</br>1 Week", slot: 5, amount: 1, price: 650 },
        { item_id: "mzinsurance_gold_month", id: 0, name: "Shop", information: "MZ Insurance - Gold Level</br>75% OFF Medical</br>1 Month", slot: 6, amount: 1, price: 2250 },
        { item_id: "mzinsurance_diamond_week", id: 0, name: "Shop", information: "MZ Insurance - Diamond Level</br>100% OFF Medical</br>1 Week", slot: 7, amount: 1, price: 900 },
        { item_id: "mzinsurance_diamond_month", id: 0, name: "Shop", information: "MZ Insurance - Diamond Level</br>100% OFF Medical</br>1 Month", slot: 8, amount: 1, price: 3000 },
    ];
    return JSON.stringify(shopItems);
}

function JailSlushy() {
    var shopItems = [
        { item_id: "slushy", id: 0, name: "Shop", information: "{}", slot: 1, amount: 1, price: 1 },
    ];
    return JSON.stringify(shopItems);
}

// stores
function ConvenienceStore() {
    var shopItems = [
        { item_id: "water", id: 0, name: "Shop", information: "{}", slot: 1, amount: 10, price: 4 }, // 1
        { item_id: "cocacola", id: 0, name: "Shop", information: "{}", slot: 2, amount: 10, price: 4 }, // 2
        { item_id: "bread", id: 0, name: "Shop", information: "{}", slot: 3, amount: 10, price: 4 }, // 3
        { item_id: "hamburger", id: 0, name: "Shop", information: "{}", slot: 4, amount: 10, price: 4 }, // 4
        { item_id: "sandwich", id: 0, name: "Shop", information: "{}", slot: 5, amount: 10, price: 4 }, // 5
        { item_id: "donut", id: 0, name: "Shop", information: "{}", slot: 6, amount: 6, price: 5 }, // 6
        { item_id: "chips", id: 0, name: "Shop", information: "{}", slot: 7, amount: 10, price: 4 }, // 7
        { item_id: "chocolate", id: 0, name: "Shop", information: "{}", slot: 8, amount: 10, price: 7 }, // 8
        { item_id: "bandage", id: 0, name: "Shop", information: "{}", slot: 9, amount: 10, price: 7 }, // 9                
        { item_id: "cleanwipes", id: 0, name: "Shop", information: "{}", slot: 10, amount: 50, price: 5 },
        { item_id: "notepad", id: 0, name: "Shop", information: "{}", slot: 11, amount: 10, price: 5 }, // 12
        { item_id: "rollingpaper", id: 0, name: "Shop", information: "{}", slot: 12, amount: 10, price: 5 }, // 13
        { item_id: "cigarette", id: 0, name: "Shop", information: "{}", slot: 13, amount: 10, price: 1 }, // 14
        { item_id: "lighter", id: 0, name: "Shop", information: "{}", slot: 14, amount: 10, price: 5 }, // 15
        { item_id: "treat", id: 0, name: "Shop", information: "{}", slot: 15, amount: 10, price: 5 }, // 16
        { item_id: "gummybears", id: 0, name: "Shop", information: "{}", slot: 16, amount: 10, price: 6 }, // 17
        { item_id: "beer", id: 0, name: "Shop", information: "{}", slot: 17, amount: 50, price: 6 },
        { item_id: "vodka", id: 0, name: "Shop", information: "{}", slot: 18, amount: 50, price: 14 },
        { item_id: "mtnshlew", id: 0, name: "Shop", information: "{}", slot: 19, amount: 10, price: 5 },
        // Scratch cards
        { item_id: "commonsc", id: 0, name: "Shop", information: "{}", slot: 20, amount: 10, price: 25 },
        { item_id: "raresc", id: 0, name: "Shop", information: "{}", slot: 21, amount: 10, price: 50 },
        { item_id: "epicsc", id: 0, name: "Shop", information: "{}", slot: 22, amount: 10, price: 75 },
        { item_id: "legendarysc", id: 0, name: "Shop", information: "{}", slot: 23, amount: 10, price: 100 },
    ];
    return JSON.stringify(shopItems);
}

function HardwareStore1() {
    var shopItems = [
        { item_id: "oxygentank", id: 0, name: "Shop", information: "{}", slot: 1, amount: 10, price: 225 },
        { item_id: "fishingrod", id: 0, name: "Shop", information: "{}", slot: 2, amount: 10, price: 20 },
        { item_id: "notepad", id: 0, name: "Shop", information: "{}", slot: 3, amount: 10, price: 3 },
        { item_id: "fishbait", id: 0, name: "Shop", information: "{}", slot: 4, amount: 50, price: 1 },
        { item_id: "binoculars", id: 0, name: "Shop", information: "{}", slot: 5, amount: 10, price: 200 },
        { item_id: "Suitcase", id: 0, name: "Shop", information: "{}", slot: 6, amount: 10, price: 75 },
        { item_id: "Box", id: 0, name: "Shop", information: "{}", slot: 7, amount: 10, price: 10 },
        { item_id: "DuffelBag", id: 0, name: "Shop", information: "{}", slot: 8, amount: 10, price: 50 },
        { item_id: "shovel", id: 0, name: "Shop", information: "{}", slot: 9, amount: 10, price: 150 },
        { item_id: "nitrogensulfate", id: 0, name: "Shop", information: "{}", slot: 10, amount: 50, price: 5 },
        { item_id: "883325847", id: 0, name: "Shop", information: "{}", slot: 11, amount: 5, price: 35 },
        { item_id: "SmallArmor", id: 0, name: "Shop", information: "{}", slot: 12, amount: 5, price: 300 },
        { item_id: "-72657034", id: 0, name: "Shop", information: "{}", slot: 13, amount: 5, price: 750 },
    ];
    return JSON.stringify(shopItems);
}

function HardwareStore2() {
    var shopItems = [
        { item_id: "oxygentank", id: 0, name: "Shop", information: "{}", slot: 1, amount: 10, price: 225 },
        { item_id: "fishingrod", id: 0, name: "Shop", information: "{}", slot: 2, amount: 10, price: 20 },
        { item_id: "notepad", id: 0, name: "Shop", information: "{}", slot: 3, amount: 10, price: 3 },
        { item_id: "fishbait", id: 0, name: "Shop", information: "{}", slot: 4, amount: 50, price: 1 },
        { item_id: "binoculars", id: 0, name: "Shop", information: "{}", slot: 5, amount: 10, price: 200 },
        { item_id: "Suitcase", id: 0, name: "Shop", information: "{}", slot: 6, amount: 10, price: 75 },
        { item_id: "Box", id: 0, name: "Shop", information: "{}", slot: 7, amount: 10, price: 10 },
        { item_id: "DuffelBag", id: 0, name: "Shop", information: "{}", slot: 8, amount: 10, price: 50 },
        { item_id: "blowtorch", id: 0, name: "Shop", information: "{}", slot: 9, amount: 10, price: 350 },
        { item_id: "phosphorussulfate", id: 0, name: "Shop", information: "{}", slot: 10, amount: 50, price: 3 },
    ];
    return JSON.stringify(shopItems);
}

function HardwareStore3() {
    var shopItems = [
        { item_id: "oxygentank", id: 0, name: "Shop", information: "{}", slot: 1, amount: 10, price: 225 },
        { item_id: "fishingrod", id: 0, name: "Shop", information: "{}", slot: 2, amount: 10, price: 20 },
        { item_id: "notepad", id: 0, name: "Shop", information: "{}", slot: 3, amount: 10, price: 3 },
        { item_id: "fishbait", id: 0, name: "Shop", information: "{}", slot: 4, amount: 50, price: 1 },
        { item_id: "binoculars", id: 0, name: "Shop", information: "{}", slot: 5, amount: 10, price: 200 },
        { item_id: "Suitcase", id: 0, name: "Shop", information: "{}", slot: 6, amount: 10, price: 75 },
        { item_id: "Box", id: 0, name: "Shop", information: "{}", slot: 7, amount: 10, price: 10 },
        { item_id: "DuffelBag", id: 0, name: "Shop", information: "{}", slot: 8, amount: 10, price: 50 },
        { item_id: "2227010557", id: 0, name: "Shop", information: "{}", slot: 9, amount: 10, price: 250 },
        { item_id: "gunpowder", id: 0, name: "Shop", information: "{}", slot: 10, amount: 50, price: 400 },
    ];
    return JSON.stringify(shopItems);
}

function HardwareStore4() {
    var shopItems = [
        { item_id: "oxygentank", id: 0, name: "Shop", information: "{}", slot: 1, amount: 10, price: 225 },
        { item_id: "fishingrod", id: 0, name: "Shop", information: "{}", slot: 2, amount: 10, price: 20 },
        { item_id: "notepad", id: 0, name: "Shop", information: "{}", slot: 3, amount: 10, price: 3 },
        { item_id: "fishbait", id: 0, name: "Shop", information: "{}", slot: 4, amount: 50, price: 1 },
        { item_id: "binoculars", id: 0, name: "Shop", information: "{}", slot: 5, amount: 10, price: 200 },
        { item_id: "Suitcase", id: 0, name: "Shop", information: "{}", slot: 6, amount: 10, price: 75 },
        { item_id: "Box", id: 0, name: "Shop", information: "{}", slot: 7, amount: 10, price: 10 },
        { item_id: "DuffelBag", id: 0, name: "Shop", information: "{}", slot: 8, amount: 10, price: 50 },
        { item_id: "drill", id: 0, name: "Shop", information: "{}", slot: 9, amount: 10, price: 475 },
        { item_id: "bucket", id: 0, name: "Shop", information: "{}", slot: 10, amount: 50, price: 30 },
    ];
    return JSON.stringify(shopItems);
}

function HardwareStore5() {
    var shopItems = [
        { item_id: "oxygentank", id: 0, name: "Shop", information: "{}", slot: 1, amount: 10, price: 225 },
        { item_id: "fishingrod", id: 0, name: "Shop", information: "{}", slot: 2, amount: 10, price: 20 },
        { item_id: "notepad", id: 0, name: "Shop", information: "{}", slot: 3, amount: 10, price: 3 },
        { item_id: "fishbait", id: 0, name: "Shop", information: "{}", slot: 4, amount: 50, price: 1 },
        { item_id: "binoculars", id: 0, name: "Shop", information: "{}", slot: 5, amount: 10, price: 200 },
        { item_id: "Suitcase", id: 0, name: "Shop", information: "{}", slot: 6, amount: 10, price: 75 },
        { item_id: "Box", id: 0, name: "Shop", information: "{}", slot: 7, amount: 10, price: 10 },
        { item_id: "DuffelBag", id: 0, name: "Shop", information: "{}", slot: 8, amount: 10, price: 50 },
        { item_id: "anglegrinder", id: 0, name: "Shop", information: "{}", slot: 9, amount: 10, price: 475 },
        { item_id: "potassiumsulfate", id: 0, name: "Shop", information: "{}", slot: 10, amount: 50, price: 3 },
    ];
    return JSON.stringify(shopItems);
}

function HardwareStore6() {
    var shopItems = [
        { item_id: "oxygentank", id: 0, name: "Shop", information: "{}", slot: 1, amount: 10, price: 225 },
        { item_id: "fishingrod", id: 0, name: "Shop", information: "{}", slot: 2, amount: 10, price: 20 },
        { item_id: "notepad", id: 0, name: "Shop", information: "{}", slot: 3, amount: 10, price: 3 },
        { item_id: "fishbait", id: 0, name: "Shop", information: "{}", slot: 4, amount: 50, price: 1 },
        { item_id: "binoculars", id: 0, name: "Shop", information: "{}", slot: 5, amount: 10, price: 200 },
        { item_id: "Suitcase", id: 0, name: "Shop", information: "{}", slot: 6, amount: 10, price: 75 },
        { item_id: "Box", id: 0, name: "Shop", information: "{}", slot: 7, amount: 10, price: 10 },
        { item_id: "DuffelBag", id: 0, name: "Shop", information: "{}", slot: 8, amount: 10, price: 50 },
        { item_id: "grease", id: 0, name: "Shop", information: "{}", slot: 9, amount: 50, price: 20 },
        { item_id: "paintthinner", id: 0, name: "Shop", information: "{}", slot: 10, amount: 50, price: 20 },
    ];
    return JSON.stringify(shopItems);
}

function ElectronicStore() {
    var shopItems = [
        { item_id: "applephone", id: 0, name: "Shop", information: "{}", slot: 1, amount: 10, price: 420 },
        { item_id: "samsungphone", id: 0, name: "Shop", information: "{}", slot: 2, amount: 10, price: 300 },
        { item_id: "radio", id: 0, name: "Shop", information: "{}", slot: 3, amount: 10, price: 150 },
        { item_id: "qualityscales", id: 0, name: "Shop", information: "{}", slot: 4, amount: 10, price: 400 },
        { item_id: "camera", id: 0, name: "Shop", information: "{}", slot: 5, amount: 10, price: 300 },
        { item_id: "headphones", id: 0, name: "Shop", information: "{}", slot: 6, amount: 10, price: 250 },
        { item_id: "airpods", id: 0, name: "Shop", information: "{}", slot: 7, amount: 10, price: 225 },
    ];
    return JSON.stringify(shopItems);
}

function SexStore() { // For horny Rico.
    var shopItems = [
        { item_id: "lotion", id: 0, name: "Shop", information: "{}", slot: 1, amount: 10, price: 15 },
        { item_id: "xscondom", id: 0, name: "Shop", information: "{}", slot: 2, amount: 10, price: 5 },
        { item_id: "handcuffs", id: 0, name: "Shop", information: "{}", slot: 3, amount: 10, price: 50 },
        { item_id: "rnovel", id: 0, name: "Shop", information: "{}", slot: 4, amount: 10, price: 30 },

    ];
    return JSON.stringify(shopItems);
}

function TacoTruck() { // For both taco shop & truck
    var shopItems = [
        { item_id: "burrito", id: 0, name: "Shop", information: "{}", slot: 1, amount: 50, price: 2 },
        { item_id: "fishtaco", id: 0, name: "Shop", information: "{}", slot: 2, amount: 50, price: 2 },
        { item_id: "vegantaco", id: 0, name: "Shop", information: "{}", slot: 3, amount: 50, price: 2 },
        { item_id: "taco", id: 0, name: "Shop", information: "{}", slot: 4, amount: 50, price: 2 },
        { item_id: "churro", id: 0, name: "Shop", information: "{}", slot: 5, amount: 50, price: 1 },
        { item_id: "slushy", id: 0, name: "Shop", information: "{}", slot: 6, amount: 50, price: 1 },
        { item_id: "water", id: 0, name: "Shop", information: "{}", slot: 7, amount: 50, price: 1 },
        { item_id: "cocacola", id: 0, name: "Shop", information: "{}", slot: 8, amount: 50, price: 1 },
        { item_id: "icecream", id: 0, name: "Shop", information: "{}", slot: 9, amount: 50, price: 1 },
        { item_id: "donut", id: 0, name: "Shop", information: "{}", slot: 10, amount: 50, price: 1 },
        { item_id: "beer", id: 0, name: "Shop", information: "{}", slot: 11, amount: 50, price: 1 },
        { item_id: "coffee", id: 0, name: "Shop", information: "{}", slot: 12, amount: 50, price: 1 },
        { item_id: "hotchoccy", id: 0, name: "Shop", information: "{}", slot: 13, amount: 50, price: 1 },
        { item_id: "icetea", id: 0, name: "Shop", information: "{}", slot: 14, amount: 50, price: 1 },
        { item_id: "mtnshlew", id: 0, name: "Shop", information: "{}", slot: 15, amount: 50, price: 1 }
    ];
    return JSON.stringify(shopItems);
}

function VendingMachine1() {
    var shopItems = [
          { item_id: "chips", id: 0, name: "Shop", information: "{}", slot: 1, amount: 1, price: 7 },
          { item_id: "chocolate", id: 0, name: "Shop", information: "{}", slot: 2, amount: 1, price: 9 },
    ];
    return JSON.stringify(shopItems);
}

function VendingMachine2() {
    var shopItems = [
          { item_id: "beer", id: 0, name: "Shop", information: "{}", slot: 1, amount: 1, price: 5 },
          { item_id: "cocacola", id: 0, name: "Shop", information: "{}", slot: 2, amount: 1, price: 8 },
          { item_id: "icetea", id: 0, name: "Shop", information: "{}", slot: 3, amount: 1, price: 9 },
          { item_id: "water", id: 0, name: "Shop", information: "{}", slot: 4, amount: 1, price: 7 },
          { item_id: "mtnshlew", id: 0, name: "Shop", information: "{}", slot: 5, amount: 1, price: 8 },
    ];
    return JSON.stringify(shopItems);
}

function Weed() {
    var shopItems = [
        { item_id: "joint", id: 0, name: "craft", information: "{}", slot: 1, amount: 10, price: 4 },
        { item_id: "weed_pooch", id: 0, name: "craft", information: "{}", slot: 2, amount: 10, price: 4 },
    ];
    return JSON.stringify(shopItems);
}

function Fertilizer() {
    var shopItems = [
        { item_id: "plant_fertilizer", id: 0, name: "craft", information: "{}", slot: 1, amount: 10, price: 4 },
    ];
    return JSON.stringify(shopItems);
}

function UnstableMeth() {
    var shopItems = [
        { item_id: "unstablemeth", id: 0, name: "craft", information: "{}", slot: 1, amount: 10, price: 4 },
    ];
    return JSON.stringify(shopItems);
}

function LaptopCrafting() {
    var shopItems = [
        { item_id: "laptop", id: 0, name: "craft", information: "{}", slot: 1, amount: 10, price: 4 },
    ];
    return JSON.stringify(shopItems);
}

function FakePlateCrafting() {
    var shopItems = [
        { item_id: "fakeplate", id: 0, name: "craft", information: "{}", slot: 1, amount: 10, price: 4 },
    ];
    return JSON.stringify(shopItems);
}

function rawmethpile() {
    var shopItems = [
        { item_id: "rawmethpile", id: 0, name: "craft", information: "{}", slot: 1, amount: 10, price: 4 },
    ];
    return JSON.stringify(shopItems);
}

function baggedpuremeth() {
    var shopItems = [
        { item_id: "baggedpuremeth", id: 0, name: "craft", information: "{}", slot: 1, amount: 10, price: 4 },
    ];
    return JSON.stringify(shopItems);
}

function coldmedicine() {
    var shopItems = [
        { item_id: "coldmedicine", id: 0, name: "Shop", information: "{}", slot: 1, amount: 10, price: 10 },
    ];
    return JSON.stringify(shopItems);
}

function PotatoShit() {
    var shopItems = [
        { item_id: "cleanedpotato", id: 0, name: "craft", information: "{}", slot: 1, amount: 10, price: 4 },
        { item_id: "potatoshake", id: 0, name: "craft", information: "{}", slot: 2, amount: 10, price: 4 },
        { item_id: "potatojuice", id: 0, name: "craft", information: "{}", slot: 3, amount: 10, price: 4 },
        { item_id: "fishchips", id: 0, name: "craft", information: "{}", slot: 4, amount: 10, price: 4 },
        { item_id: "hashbrown", id: 0, name: "craft", information: "{}", slot: 5, amount: 10, price: 4 },
        { item_id: "breakfastburrito", id: 0, name: "craft", information: "{}", slot: 6, amount: 10, price: 4 },
        { item_id: "bakedpotato", id: 0, name: "craft", information: "{}", slot: 7, amount: 10, price: 4 },
        { item_id: "potatovodka", id: 0, name: "craft", information: "{}", slot: 8, amount: 10, price: 4 },
    ];
    return JSON.stringify(shopItems);
}

function polscanner() {
    var shopItems = [
        { item_id: "policescanner", id: 0, name: "craft", information: "{}", slot: 1, amount: 1, price: 4 },
    ];
    return JSON.stringify(shopItems);
}

function weazelnews() {
    var shopItems = [
        { item_id: "weazelmicrophone", id: 0, name: "shop", information: "{}", slot: 1, amount: 1, price: 35 },
        { item_id: "weazelcamera", id: 0, name: "shop", information: "{}", slot: 2, amount: 1, price: 150 },
        { item_id: "weazelboommic", id: 0, name: "shop", information: "{}", slot: 3, amount: 1, price: 50 },
        { item_id: "weazel_mediabadge", id: 0, name: "shop", information: "{}", slot: 4, amount: 1, price: 25 },
    ];
    return JSON.stringify(shopItems);
}

function BuyPotatoShit() {
    var shopItems = [
        { item_id: "potato_seed", id: 0, name: "shop", information: "{}", slot: 1, amount: 10, price: 2 },
        { item_id: "plant_food", id: 0, name: "shop", information: "{}", slot: 2, amount: 10, price: 1 },
    ];
    return JSON.stringify(shopItems);
}

function HQWeed() {
    var shopItems = [
        { item_id: "blunt", id: 0, name: "craft", information: "{}", slot: 1, amount: 10, price: 4 },
        { item_id: "packaged_pineapple", id: 0, name: "craft", information: "{}", slot: 2, amount: 10, price: 4 },

    ];
    return JSON.stringify(shopItems);
}

// Thorhall's Holistic Center
function THCWeed() {
    var shopItems = [
        { item_id: "phoenix_joint", id: 0, name: "craft", information: "{}", slot: 1, amount: 10, price: 4 },
    ];
    return JSON.stringify(shopItems);
}

function Plastic() {
    var shopItems = [
        { item_id: "ziplock_bag", id: 0, name: "craft", information: "{}", slot: 1, amount: 10, price: 4 },
    ];
    return JSON.stringify(shopItems);
}

function thermalcharge() {
    var shopItems = [
        { item_id: "thermal_charge", id: 0, name: "craft", information: "{}", slot: 1, amount: 10, price: 4 },
    ];
    return JSON.stringify(shopItems);
}

function Mechanic() {
    var shopItems = [
        { item_id: "lockpick", id: 0, name: "craft", information: "{}", slot: 1, amount: 10, price: 100 },
        { item_id: "advlockpick", id: 0, name: "craft", information: "{}", slot: 2, amount: 10, price: 300 },
        { item_id: "repairkit", id: 0, name: "craft", information: "{}", slot: 3, amount: 10, price: 300 },
        { item_id: "weakrepairkit", id: 0, name: "craft", information: "{}", slot: 4, amount: 10, price: 300 },
        { item_id: "washkit", id: 0, name: "craft", information: "{}", slot: 5, amount: 10, price: 300 },
    ];
    return JSON.stringify(shopItems);
}

function UndergroudShop() {
    var shopItems = [
        { item_id: "nitrous", id: 0, name: "Shop", information: "{}", slot: 1, amount: 10, price: 500 },
    ];
    return JSON.stringify(shopItems);
}

function HarnessShop() {
    var shopItems = [
        { item_id: "harness", id: 0, name: "Shop", information: "{}", slot: 2, amount: 10, price: 250 },
    ];
    return JSON.stringify(shopItems);
}

function DriftItemShop() {
    var shopItems = [
        { item_id: "drift", id: 0, name: "craft", information: "{}", slot: 1, amount: 10, price: 250 },
    ];
    return JSON.stringify(shopItems);
}

function CoffeeShop() {
    var shopItems = [
        { item_id: "coffee", id: 0, name: "Shop", information: "{}", slot: 1, amount: 50, price: 5 },
        { item_id: "turtlecheesecake", id: 0, name: "Shop", information: "{}", slot: 2, amount: 50, price: 5 },
        { item_id: "chips", id: 0, name: "Shop", information: "{}", slot: 3, amount: 50, price: 4 },
        { item_id: "chocolate", id: 0, name: "Shop", information: "{}", slot: 4, amount: 50, price: 6 },
        { item_id: "donut", id: 0, name: "Shop", information: "{}", slot: 5, amount: 50, price: 6 },
        { item_id: "water", id: 0, name: "Shop", information: "{}", slot: 6, amount: 50, price: 4 },
        { item_id: "eggsbacon", id: 0, name: "Shop", information: "{}", slot: 7, amount: 50, price: 5 },
        { item_id: "cookie", id: 0, name: "Shop", information: "{}", slot: 8, amount: 50, price: 4 },
        { item_id: "icecream", id: 0, name: "Shop", information: "{}", slot: 9, amount: 50, price: 4 },
        { item_id: "frappuccino", id: 0, name: "Shop", information: "{}", slot: 10, amount: 50, price: 5 },
        { item_id: "hotchoccy", id: 0, name: "Shop", information: "{}", slot: 11, amount: 50, price: 5 },
    ];
    return JSON.stringify(shopItems);
}

function VanillaUnicorn() {
    var shopItems = [
        { item_id: "beer", id: 0, name: "Shop", information: "{}", slot: 1, amount: 50, price: 2 },
        { item_id: "champagne", id: 0, name: "Shop", information: "{}", slot: 2, amount: 50, price: 2 },
        { item_id: "vodka", id: 0, name: "Shop", information: "{}", slot: 3, amount: 50, price: 2 },
        { item_id: "whiskey", id: 0, name: "Shop", information: "{}", slot: 4, amount: 50, price: 2 },
    ];
    return JSON.stringify(shopItems);
}

function Mortuary() {
    var shopItems = [
        { item_id: "rose", id: 0, name: "Shop", information: "{}", slot: 1, amount: 50, price: 2 },
        { item_id: "urn", id: 0, name: "Shop", information: "{}", slot: 2, amount: 50, price: 5 },
        { item_id: "bouquet", id: 0, name: "Shop", information: "{}", slot: 3, amount: 50, price: 2 },
        { item_id: "daisy", id: 0, name: "Shop", information: "{}", slot: 4, amount: 50, price: 1 },
        { item_id: "lily", id: 0, name: "Shop", information: "{}", slot: 5, amount: 50, price: 1 },
        { item_id: "sunflower", id: 0, name: "Shop", information: "{}", slot: 6, amount: 50, price: 1 },
    ];
    return JSON.stringify(shopItems);
}

function CarParts1() {
    var shopItems = [
        { item_id: "aluminium", id: 0, name: "Shop", information: "{}", slot: 1, amount: 50, price: 8 },
        { item_id: "grease", id: 0, name: "Shop", information: "{}", slot: 2, amount: 50, price: 8 },
        { item_id: "laminatedplastic", id: 0, name: "Shop", information: "{}", slot: 3, amount: 50, price: 20 },
        { item_id: "copperwires", id: 0, name: "Shop", information: "{}", slot: 4, amount: 50, price: 3 },
        { item_id: "lead", id: 0, name: "Shop", information: "{}", slot: 5, amount: 50, price: 38 },
        { item_id: "stainlesssteel", id: 0, name: "Shop", information: "{}", slot: 6, amount: 50, price: 6 },
        { item_id: "plastic", id: 0, name: "Shop", information: "{}", slot: 7, amount: 50, price: 3 },
        { item_id: "rubber", id: 0, name: "Shop", information: "{}", slot: 8, amount: 50, price: 4 },
        { item_id: "scrapmetal", id: 0, name: "Shop", information: "{}", slot: 9, amount: 50, price: 8 },
    ];
    return JSON.stringify(shopItems);
}

function CarParts2() {
    var shopItems = [
        { item_id: "iron", id: 0, name: "Shop", information: "{}", slot: 1, amount: 50, price: 13 },
        { item_id: "graphite", id: 0, name: "Shop", information: "{}", slot: 2, amount: 50, price: 38 },
        { item_id: "carbon", id: 0, name: "Shop", information: "{}", slot: 3, amount: 50, price: 6 },
        { item_id: "electronics", id: 0, name: "Shop", information: "{}", slot: 4, amount: 50, price: 10 },
    ];
    return JSON.stringify(shopItems);
}

function CarParts3() {
    var shopItems = [
        { item_id: "copper", id: 0, name: "Shop", information: "{}", slot: 1, amount: 50, price: 2 },
        { item_id: "carbondisk", id: 0, name: "Shop", information: "{}", slot: 2, amount: 50, price: 375 },
        { item_id: "coilspring", id: 0, name: "Shop", information: "{}", slot: 3, amount: 50, price: 7 },
    ];
    return JSON.stringify(shopItems);
}

function CarParts4() {
    var shopItems = [
        { item_id: "lead", id: 0, name: "Shop", information: "{}", slot: 1, amount: 50, price: 8 },
        { item_id: "timingbelt", id: 0, name: "Shop", information: "{}", slot: 2, amount: 50, price: 11 },
    ];
    return JSON.stringify(shopItems);
}

function CarParts5() {
    var shopItems = [
        { item_id: "steel", id: 0, name: "Shop", information: "{}", slot: 1, amount: 50, price: 8 },
        { item_id: "clutchfluid", id: 0, name: "Shop", information: "{}", slot: 2, amount: 50, price: 15 },
        { item_id: "electronics", id: 0, name: "Shop", information: "{}", slot: 3, amount: 50, price: 10 },
    ];
    return JSON.stringify(shopItems);
}

function LegacyFoodShop() {
    var shopItems = [
        { item_id: "shrimptaco", id: 0, name: "Shop", information: "{}", slot: 1, amount: 50, price: 1 },
        { item_id: "caesarsalad", id: 0, name: "Shop", information: "{}", slot: 2, amount: 50, price: 1 },
        { item_id: "lobstersliders", id: 0, name: "Shop", information: "{}", slot: 3, amount: 50, price: 1 },
        { item_id: "pretzels", id: 0, name: "Shop", information: "{}", slot: 4, amount: 50, price: 1 },
        { item_id: "onionrings", id: 0, name: "Shop", information: "{}", slot: 5, amount: 50, price: 1 },
        { item_id: "deepfriedpickles", id: 0, name: "Shop", information: "{}", slot: 6, amount: 50, price: 1 },
        { item_id: "jelloshot", id: 0, name: "Shop", information: "{}", slot: 7, amount: 50, price: 2 },
        { item_id: "baconbloodymary", id: 0, name: "Shop", information: "{}", slot: 8, amount: 50, price: 2 },
        { item_id: "tequilasprite", id: 0, name: "Shop", information: "{}", slot: 9, amount: 50, price: 2 },
        { item_id: "rumpunch", id: 0, name: "Shop", information: "{}", slot: 10, amount: 50, price: 2 },
        { item_id: "gintonic", id: 0, name: "Shop", information: "{}", slot: 11, amount: 50, price: 2 },
        { item_id: "redsangria", id: 0, name: "Shop", information: "{}", slot: 12, amount: 50, price: 2 },
        { item_id: "milkdudsliders", id: 0, name: "Shop", information: "{}", slot: 13, amount: 50, price: 2 },
        { item_id: "badbitchmartini", id: 0, name: "Shop", information: "{}", slot: 14, amount: 50, price: 2 },
        { item_id: "valkkiss", id: 0, name: "Shop", information: "{}", slot: 15, amount: 50, price: 2 },
        { item_id: "water", id: 0, name: "Shop", information: "{}", slot: 16, amount: 50, price: 1 },
        { item_id: "cocacola", id: 0, name: "Shop", information: "{}", slot: 17, amount: 50, price: 1 },
    ];
    return JSON.stringify(shopItems);
}

function GunStore() {
    var shopItems = [
        { item_id: "pistolammo", id: 0, name: "Shop", information: "{}", slot: 1, amount: 5, price: 100 },
        { item_id: "shotgunammo", id: 0, name: "Shop", information: "{}", slot: 2, amount: 5, price: 125 },
        { item_id: "2508868239", id: 0, name: "Shop", information: "{}", slot: 3, amount: 5, price: 575 },
        { item_id: "2343591895", id: 0, name: "Shop", information: "{}", slot: 4, amount: 5, price: 225 },
        { item_id: "2578778090", id: 0, name: "Shop", information: "{}", slot: 5, amount: 5, price: 150 },
        { item_id: "MedArmor", id: 0, name: "Shop", information: "{}", slot: 6, amount: 5, price: 350 },
        { item_id: "SmallArmor", id: 0, name: "Shop", information: "{}", slot: 7, amount: 5, price: 250 },
        { item_id: "3218215474", id: 0, name: "Shop", information: "{}", slot: 8, amount: 5, price: 475 },
        { item_id: "453432689", id: 0, name: "Shop", information: "{}", slot: 9, amount: 5, price: 1000 },
    ];
    return JSON.stringify(shopItems);
};

function secretguns() {
    var shopItems = [
        { item_id: "rifleammo", id: 0, name: "Shop", information: "{}", slot: 1, amount: 10, price: 125 },
        { item_id: "-1074790547", id: 0, name: "Shop", information: "{}", slot: 2, amount: 10, price: 15000 },
        { item_id: "1649403952", id: 0, name: "Shop", information: "{}", slot: 3, amount: 10, price: 10000 },
        { item_id: "-619010992", id: 0, name: "Shop", information: "{}", slot: 4, amount: 10, price: 5000 },
        { item_id: "-1121678507", id: 0, name: "Shop", information: "{}", slot: 5, amount: 10, price: 5000 },
        { item_id: "-771403250", id: 0, name: "Shop", information: "{}", slot: 6, amount: 10, price: 5000 },
        { item_id: "324215364", id: 0, name: "Shop", information: "{}", slot: 7, amount: 10, price: 5000 },
        { item_id: "584646201", id: 0, name: "Shop", information: "{}", slot: 8, amount: 10, price: 5000 },
        { item_id: "2017895192", id: 0, name: "Shop", information: "{}", slot: 9, amount: 10, price: 6000 },
        { item_id: "137902532", id: 0, name: "Shop", information: "{}", slot: 10, amount: 10, price: 2500 },
        { item_id: "2024373456", id: 0, name: "Shop", information: "{}", slot: 11, amount: 10, price: 9000 },
        { item_id: "shotgunammo", id: 0, name: "Shop", information: "{}", slot: 12, amount: 5, price: 100 },
        { item_id: "silencer_l", id: 0, name: "Shop", information: "{}", slot: 13, amount: 5, price: 4000 },
        { item_id: "silencer_l2", id: 0, name: "Shop", information: "{}", slot: 14, amount: 5, price: 4000 },
        { item_id: "silencer_s", id: 0, name: "Shop", information: "{}", slot: 15, amount: 5, price: 4000 },
        { item_id: "silencer_s2", id: 0, name: "Shop", information: "{}", slot: 16, amount: 5, price: 4000 },
        { item_id: "extended_ap", id: 0, name: "Shop", information: "{}", slot: 17, amount: 5, price: 1500 },
        { item_id: "extended_micro", id: 0, name: "Shop", information: "{}", slot: 18, amount: 5, price: 1500 },
        { item_id: "extended_sns", id: 0, name: "Shop", information: "{}", slot: 19, amount: 5, price: 1500 },
        { item_id: "extended_tec9", id: 0, name: "Shop", information: "{}", slot: 20, amount: 5, price: 1500 },
        { item_id: "subammo", id: 0, name: "Shop", information: "{}", slot: 21, amount: 5, price: 50 },
        { item_id: "171789620", id: 0, name: "Shop", information: "{}", slot: 22, amount: 5, price: 8000 },
        { item_id: "2578377531", id: 0, name: "Shop", information: "{}", slot: 23, amount: 5, price: 6500 },
    ];
    return JSON.stringify(shopItems);
};