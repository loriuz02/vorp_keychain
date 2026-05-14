fx_version 'cerulean'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
game 'rdr3'

description 'vorp keychain system'
version '1.0.0'
author 'loriuz02'

server_scripts {
    'server/server.lua'
}

shared_scripts {
    'config.lua',
    'shared/locale.lua',
    'languages/*.lua',
}

dependencies {
    'vorp_core',
    'vorp_inventory',
}

lua54 'yes'
