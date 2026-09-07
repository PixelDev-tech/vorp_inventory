HotbarService = {}

local HotbarFavorites = { "", "", "", "", "" }
local UiBusy = false
local HotbarEnabled = true

local hotbarControls = {
	{ controls = { 0xE6F612E4 }, slot = 1 },
	{ controls = { 0x1CE6D9EB }, slot = 2 },
	{ controls = { 0x4F49CC4C, 0xAE69478F }, slot = 3 },
	{ controls = { 0x8F9F9E58 }, slot = 4 },
	{ controls = { 0xAB62E997 }, slot = 5 },
}

local function isControlJustPressed(controls)
	for _, control in ipairs(controls) do
		for _, padIndex in ipairs({ 0, 2 }) do
			if IsDisabledControlJustPressed(padIndex, control) or IsControlJustPressed(padIndex, control) then
				return true
			end
		end
	end
	return false
end

--- Receives the pinned hotbar entries from the NUI (JS keeps the pin list in
--- localStorage; this keeps a client-side mirror so key presses work without
--- depending on the NUI having keyboard focus).
---@param data table array of 5 { name, id } entries (name="" / id=0 = empty slot).
--- `id` matters for weapons specifically: gunsmith customization (loadout.comps)
--- is saved per weapon id, not per name, so two guns with the same name can
--- have different components. Matching by name alone risked equipping the
--- wrong physical weapon's customization.
function HotbarService.NUISetHotbar(data)
	HotbarFavorites = data or {}
end

--- Lets the NUI tell us when a blocking UI surface is open (quantity/prompt
--- dialogs, character selection, transaction loader, or a focused input),
--- so hotbar key presses don't hijack whatever the player is doing there.
---@param data boolean
function HotbarService.NUISetUiBusy(data)
	UiBusy = data == true
end

--- Lets the player turn the hotbar's key detection fully on/off from the NUI
--- toggle button. When off, the native weapon-wheel keys aren't disabled
--- either, so they behave exactly as vanilla RDR2 again.
---@param data boolean
function HotbarService.NUISetHotbarEnabled(data)
	HotbarEnabled = data == true
end

local function useHotbarSlot(slotIndex)
	local entry = HotbarFavorites[slotIndex]
	if not entry or not entry.name or entry.name == "" then return end

	local name = entry.name
	local pinnedId = tonumber(entry.id)

	for _, item in pairs(UserInventory) do
		if item:getName() == name then
			NUIService.NUIUseItem({
				item = name,
				type = "item_standard",
				id = item:getId(),
				amount = item:getCount(),
			})
			return
		end
	end

	-- Prefer the exact pinned weapon instance (customization lives on
	-- loadout.id, not the weapon name) and only fall back to a name search
	-- if that specific one is no longer owned (sold/dropped).
	local weapon = (pinnedId and pinnedId > 0) and UserWeapons[pinnedId] or nil
	if weapon and weapon:getName() ~= name then
		weapon = nil -- pinned id got reused for a different weapon somehow
	end
	local weaponId = weapon and pinnedId or nil

	if not weapon then
		for id, w in pairs(UserWeapons) do
			if w:getName() == name then
				weapon = w
				weaponId = id
				break
			end
		end
	end

	if not weapon then return end

	if weapon:getUsed() or weapon:getUsed2() then
		-- already equipped: pressing its slot again holsters it
		NUIService.NUIUnequipWeapon({ id = weaponId })
		return
	end

	CreateThread(function()
		-- Holster whatever other weapon is currently equipped first, and give
		-- the game engine a moment to actually process it.
		local hadOther = false
		for otherId, otherWeapon in pairs(UserWeapons) do
			if otherId ~= weaponId and (otherWeapon:getUsed() or otherWeapon:getUsed2()) then
				NUIService.NUIUnequipWeapon({ id = otherWeapon:getId() })
				hadOther = true
			end
		end
		if hadOther then
			Wait(200)
		end

		-- Equip the weapon directly instead of going through useWeapon(),
		-- which bails out of its own equip step when the ped still reads as
		-- "armed" (a one-handed-gun-swap guard meant for the normal
		-- double-click flow).
		local w = UserWeapons[weaponId]
		if not w then return end

		w:equipwep()
		w:setUsed(true)

		-- vorp_inventory's own Weapon:loadComponents() (GiveWeaponComponentToPed)
		-- isn't actually what renders gunsmith customization -- that's done by
		-- vorp_weaponsv2, which fetches the live components from loadout.comps
		-- server-side and applies them with GiveWeaponComponentToEntity once it
		-- gets this event back. This is the exact same event useWeapon()'s
		-- normal equip path fires, so mirroring it here is what makes hotbar
		-- equips look identical to equipping from the inventory.
		TriggerServerEvent("syn_weapons:weaponused", {
			id = weaponId,
			hash = joaat(w:getName()),
		})

		TriggerServerEvent("vorpinventory:setUsedWeapon", weaponId, w:getUsed(), w:getUsed2())
		NUIService.LoadInv()
	end)
end

CreateThread(function()
	while true do
		if HotbarEnabled then
			for _, hotkey in ipairs(hotbarControls) do
				for _, control in ipairs(hotkey.controls) do
					DisableControlAction(0, control, true)
					DisableControlAction(2, control, true)
				end
				if not UiBusy and isControlJustPressed(hotkey.controls) then
					useHotbarSlot(hotkey.slot)
				end
			end
		end
		Wait(0)
	end
end)
