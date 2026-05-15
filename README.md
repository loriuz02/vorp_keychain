# vorp_keychain

Keychain resource for VORP inventory. Your players have too many keys in their pocket? Collect them inside a keychain! 

## Features

- Uses a normal inventory item as the keychain opener (`Config.KeychainItem`)
- Every keychain gets a unique metadata id (`keychainid`)
- Opens a dedicated custom inventory for each keychain
- Restricts allowed items via VORP `whitelistItems`
- Adds runtime fallback guard for non-key item moves

## Requirements

- `vorp_core`
- `vorp_inventory`

## Installation

1. Place this folder in your server resources.
2. Run the SQL file [install/keychain_item.sql](install/keychain_item.sql) in your database to add the keychain item. (Optional if you create the item manually)
3. Ensure your key items exist in the items table (`house_key`, `wagon_key`, `business_key` by default).
4. Edit `config.lua` for your server item names and limits.
5. Add to your server config:

```cfg
ensure vorp_keychain
```

## Configuration

Main settings are in `config.lua`:

- `Config.KeychainItem`: item name used to open the keychain
- `Config.KeychainName`: title of the opened custom inventory
- `Config.KeychainSlots`: inventory slot limit
- `Config.InventoryIdPrefix`: internal custom inventory id prefix
- `Config.AllowedKeyItems`: only these items can be stored in keychains

Example:

```lua
Config.AllowedKeyItems = {
	house_key = 25,
	wagon_key = 25,
	business_key = 25,
}
```

If a value is `true`, `Config.DefaultKeyLimit` is used.

## Notes

- This version does not attach any backpack model to the player.
- No SQL table is required for keychain storage ids. If you don't know how to add items to the database you can use the created sql.
- Keychain ids are stored directly on the keychain item metadata.

