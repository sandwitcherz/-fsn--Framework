-- GLOBAL UTILS
client_script '@fsn_main/cl_utils.lua'
server_script '@fsn_main/sv_utils.lua'

resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

ui_page "gui/ui.html"

files {
	"gui/ui.html",
	"gui/ui.js",
	"gui/ui.css"
}


client_script 'client.lua'
server_script '@mysql-async/lib/MySQL.lua'
server_script 'server.lua'

-- exports
exports {
	"inInstance",
	"isNearStorage"
}