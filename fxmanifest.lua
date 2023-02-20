fx_version 'adamant'
game 'gta5'
description 'DrTune | Inventory Script'
version '1.0.5'

ui_page 'nui/ui.html'

files {
	'nui/ui.html',
	'nui/pricedown.ttf',
	'nui/default.png',
	'nui/styles.css',
	'nui/scripts.js',
	'nui/debounce.min.js',
	'nui/icons/*',
}


shared_script 'shared_list.js'
client_script 'client.js'
client_script 'functions.lua'
client_script 'client.lua'
server_script 'server_shops.js'
server_script 'server.js'
server_script 'server.lua'


exports{
	'getCash',
	'hasEnoughOfItem',
	'getQuantity',
	'GetCurrentWeapons',
	'GetItemInfo',
	'CreateCraftOption'
}
