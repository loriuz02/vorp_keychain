local VORPcore = exports.vorp_core:GetCore()

local KnownKeychains = {}

local function debugPrint(message)
    if Config.Debug then
        print(('[%s] %s'):format(GetCurrentResourceName(), message))
    end
end

local function getInventoryId(keychainId)
    return tostring(Config.InventoryIdPrefix or 'keychain:') .. tostring(keychainId)
end

local function isKeychainInventory(invId)
    if type(invId) ~= 'string' then
        return false
    end

    local prefix = tostring(Config.InventoryIdPrefix or 'keychain:')
    return invId:sub(1, #prefix) == prefix
end

local function getAllowedItemLimit(itemName)
    local allowed = Config.AllowedKeyItems or {}
    local value = allowed[itemName]

    if type(value) == 'number' then
        return value
    end

    if value == true then
        return Config.DefaultKeyLimit or 1
    end

    return nil
end

local function isAllowedKeyItem(itemName)
    return getAllowedItemLimit(itemName) ~= nil
end

local function buildKeychainId(source, itemId)
    local randomPart = math.random(100000, 999999)
    return ('%s-%s-%s-%s'):format(os.time(), source, itemId or '0', randomPart)
end

local function ensureKeychainInventoryRegistered(invId)
    if exports.vorp_inventory:isCustomInventoryRegistered(invId) then
        return true
    end

    exports.vorp_inventory:registerInventory({
        id = invId,
        name = Config.KeychainName,
        limit = Config.KeychainSlots,
        acceptWeapons = false,
        shared = true,
        ignoreItemStackLimit = true,
        whitelistItems = true,
        whitelistWeapons = false,
        UsePermissions = false,
        UseBlackList = false,
    })

    local hasAnyAllowed = false
    for itemName, _ in pairs(Config.AllowedKeyItems or {}) do
        local limit = getAllowedItemLimit(itemName)
        if limit and limit > 0 then
            hasAnyAllowed = true
            exports.vorp_inventory:setCustomInventoryItemLimit(invId, itemName, limit)
        end
    end

    if not hasAnyAllowed then
        debugPrint('No allowed key items configured; keychain will not accept any item.')
    end

    return true
end

local function assignKeychainMetadata(source, data)
    local metadata = data.metadata or {}
    if metadata.keychainid and tostring(metadata.keychainid) ~= '' then
        return tostring(metadata.keychainid), metadata
    end

    local keychainId = buildKeychainId(source, data.id)
    metadata.keychainid = keychainId
    metadata.description = _U('KeychainID') .. keychainId

    if data.id then
        local stackAmount = data.count or 1
        exports.vorp_inventory:setItemMetadata(source, data.id, metadata, stackAmount)
    else
        VORPcore.NotifyRightTip(source, _U('MissingItemIdMetadata'), 4000)
        debugPrint('Cannot set metadata on keychain item because data.id is missing.')
    end

    return keychainId, metadata
end

exports.vorp_inventory:registerUsableItem(Config.KeychainItem, function(data)
    local source = data.source
    local keychainId = nil

    if not next(Config.AllowedKeyItems or {}) then
        VORPcore.NotifyRightTip(source, _U('NoAllowedKeysConfigured'), 4000)
        return
    end

    keychainId = data.metadata and data.metadata.keychainid
    if not keychainId or tostring(keychainId) == '' then
        keychainId = select(1, assignKeychainMetadata(source, data))
    end

    local invId = getInventoryId(keychainId)
    KnownKeychains[invId] = true

    ensureKeychainInventoryRegistered(invId)
    exports.vorp_inventory:openInventory(source, invId)
end, GetCurrentResourceName())

AddEventHandler('vorp_inventory:Server:OnItemMovedToCustomInventory', function(item, invId, source)
    if not item or not invId then
        return
    end

    if not isKeychainInventory(invId) and not KnownKeychains[tostring(invId)] then
        return
    end

    local itemName = item.name
    if isAllowedKeyItem(itemName) then
        return
    end

    local amount = item.amount or item.count or 1
    local removed = false

    local okById, removedById = pcall(function()
        return exports.vorp_inventory:removeItemFromCustomInventory(invId, itemName, amount, item.id)
    end)

    if okById and removedById ~= false then
        removed = true
    else
        local okByName, removedByName = pcall(function()
            return exports.vorp_inventory:removeItemFromCustomInventory(invId, itemName, amount)
        end)
        if okByName and removedByName ~= false then
            removed = true
        end
    end

    if removed then
        exports.vorp_inventory:addItem(source, itemName, amount, item.metadata)
    end

    VORPcore.NotifyRightTip(source, _U('OnlyKeysAllowed'), 3000)
    debugPrint(('Blocked non-key item in keychain. item=%s inv=%s removed=%s'):format(tostring(itemName), tostring(invId), tostring(removed)))
end)
