--[[ ===================================================== ]]--
--[[         FiveM Real Parking Script by Akkariin         ]]--
--[[ ===================================================== ]]--

fx_version 'adamant'
game 'gta5'

client_scripts {
	'@es_extended/locale.lua',
	'config.lua',
	'locales/en.lua',
	'locales/zh.lua',
	'client/main.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'config.lua',
	'locales/en.lua',
	'locales/zh.lua',
	'server/main.lua',
}
