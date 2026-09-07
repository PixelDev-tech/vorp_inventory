let isOpen = false;
let type = "normal";
let disabled = false;
let disabledFunction = null;
let ready4Action = true;
let checkxy;
let infoxy;
let Weight = null;
let customId = 0;
let houseId = 0;
let hideoutid = 0;
let clanid = 0;
let stealid = 0;
let Containerid = 0;
let horseid = 0;
let wagonid = 0;
let bankId = 0;
let playerId = 0;
let allplayerammo = [];
let ammolabels = [];
let isValidating = false; // Block other validation event when a validation prompt is already processing
// Safe fallback so a render that happens to race the "initiate" NUI message
// (which normally fills this in with the real translations) doesn't throw
// and abort the whole item list.
let LANGUAGE = {
    labels: {
        weight: "Weight: ",
        decay: "Decay: ",
        limit: "Limit: ",
        ammo: "Ammo: ",
        serial: "Serial: ",
    },
};
let objToGive = {};
let geninfo;
let StoreId;
let LuaConfig = {};
// Define the ID object
