# VORP Inventory in Lua
Preview
<img width="1915" height="1070" alt="vorp_inventory" src="https://github.com/user-attachments/assets/e0939389-d7b9-4592-93fd-d25540573680" />
<img width="911" height="1079" alt="vorpinventory" src="https://github.com/user-attachments/assets/f244c1e1-03c8-44f9-8035-1bb80eb55c9a" />

## Requirements
- [VORP Core LUA](https://github.com/VORPCORE/vorp_core-lua)

## How to install
- Download the lastest version of `vorp_inventory`
- Copy and paste `vorp_inventory` folder to `resources/[VORP]essentials/vorp_inventory`
- Add `ensure vorp_inventory` to your `resource.cfg` file
- To change the language go to `languages/language.lua` and change the default language in config

## Extensive API
- Exports
- Events

## Features
- Weight inventory based `(with limit for items)`
- Unique weapons equip/unequip
- Weapons with serial numbers
- Weapons custom labels serial numbers and descriptions
- Weight for weapons and items
- Give ammo from your belt
- Drop/Give/Pick Up functions
    - Props can be spawned for dropped items(Real weapon models are used for weapons)
- Usable items double click or right click
- KLS.
- Metadata for items
    - Changing item label, weight, description and image with metadata
- Storage/Stashes API
- On respawn clear weapons items money ammo
- Jobs can hold more weapons
- Items and weapons with groups
- Item give on first connection and weapons
- Degration System (Items in the Custom inventory do not lose degradation level(Only when dropped in the main inventory or on the ground))
    - Each item can optionally have an expiration date
    - Expired items cannot be used
    - Expired items are displayed in inventory with low opacity and much more
Preview
## Extra Features
- Description of all items in DB
- Gold item like Dollars (You can give and drop item)
- Option to use Gold like Dollars, configurable in `config.lua` and `config.js`
- Added descriptions of each item in inventory, for items (desc is in DB), for weapons (desc is in `shared/weapons.lua`)

## Custom Enhancements (this fork)
- Redesigned UI — modern dark glass + gold-accent theme, replacing the old panel artwork
- Item favoriting/pinning — right-click a satchel item, or drag it onto the hotbar, to pin it
- Quick-use hotbar
    - A standalone bar (separate from the satchel window) shown at the bottom of the screen, usable whether the satchel is open or not
    - Keys `1`-`5` use/equip the pinned item in that slot; pressing an already-equipped weapon's slot holsters it, and switching weapons auto-holsters the previous one
    - Drag items in/out of hotbar slots, reorder by dragging between slots, or left-click a filled slot to unpin
    - Draggable position (grab the small handle on the bar) with the position remembered per player
    - On/off toggle button inside the satchel UI; disabling it fully hides the bar and stops intercepting the number keys
    - Correctly reapplies gunsmith weapon customization (`vorp_weaponsv2` components) when a customized weapon is equipped from the hotbar, matching the normal inventory equip flow
- Animated weight/capacity bar next to the weight readout, with a red warning glow near full capacity
- Assorted stability fixes: tooltip position clamping, native weapon-wheel key conflicts, and race conditions around inventory reload

## DOCUMENTATION
Inventory API [Documentation](https://docs.vorp-core.com/api-reference/inventory)

## Credits
- To [Val3ro](https://github.com/Val3ro) for the initial work.
- To [Emolitt](https://github.com/RomainJolidon) for the conversion.

## Support
[Discord](https://discord.gg/VJEBa4hPwR)
