-- vorp_keychain item entry
-- Run this in your server database to create/update the keychain item.

-- ITALIAN

INSERT INTO `items` (`item`, `label`, `limit`, `can_remove`, `type`, `usable`, `desc`)
VALUES ('keychain', 'Portachiavi', 1, 1, 'item_standard', 1, 'Contiene solo chiavi, ma puoi farti una chiavata.')
ON DUPLICATE KEY UPDATE
    `label` = VALUES(`label`),
    `limit` = VALUES(`limit`),
    `can_remove` = VALUES(`can_remove`),
    `type` = VALUES(`type`),
    `usable` = VALUES(`usable`),
    `desc` = VALUES(`desc`);

-- ENGLISH

-- INSERT INTO `items` (`item`, `label`, `limit`, `can_remove`, `type`, `usable`, `desc`)
-- VALUES ('keychain', 'Keychain', 1, 1, 'item_standard', 1, 'Contains only keys.')
-- ON DUPLICATE KEY UPDATE
--     `label` = VALUES(`label`),
--     `limit` = VALUES(`limit`),
--     `can_remove` = VALUES(`can_remove`),
--     `type` = VALUES(`type`),
--     `usable` = VALUES(`usable`),
--     `desc` = VALUES(`desc`);

----------------------------------------------------------------------------------------------------------------------

-- If your items table uses `can_use` instead of `usable`, use this instead:
-- INSERT INTO `items` (`item`, `label`, `limit`, `can_remove`, `type`, `can_use`, `desc`)
-- VALUES ('keychain', 'Keychain', 1, 1, 'item_standard', 1, 'Contains only keys.')
-- ON DUPLICATE KEY UPDATE
--     `label` = VALUES(`label`),
--     `limit` = VALUES(`limit`),
--     `can_remove` = VALUES(`can_remove`),
--     `type` = VALUES(`type`),
--     `can_use` = VALUES(`can_use`),
--     `desc` = VALUES(`desc`);
