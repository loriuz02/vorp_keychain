Config = {}

Config.defaultlang = 'it'
Config.Debug = false

-- Item used to open a keychain inventory.
Config.KeychainItem = 'keychain'

-- Display name shown when the custom inventory opens.
Config.KeychainName = 'Portachiavi' -- 'Keychain' in Italian

-- Slot limit of each keychain custom inventory.
Config.KeychainSlots = 30

-- Prefix used to build custom inventory ids.
Config.InventoryIdPrefix = 'keychain:'

-- If an item is set to true in AllowedKeyItems, this default per-item limit is used.
Config.DefaultKeyLimit = 25

-- Only items listed here are allowed inside keychains.
-- Format:
--   item_name = number(limit)
--   item_name = true (uses Config.DefaultKeyLimit)
Config.AllowedKeyItems = {
    house_key = 25,
    wagon_key = 25,
    business_key = 25,
}
