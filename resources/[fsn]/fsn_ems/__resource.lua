--client_script 'debug_kng.lua'

client_script 'client.lua'
client_script 'cl_advanceddamage.lua'
client_script 'beds/client.lua'

server_script 'server.lua'
server_script 'beds/server.lua'

exports({
  'fsn_IsDead',
  'fsn_EMSDuty',
  'fsn_getEMSLevel',
  'fsn_Airlift',
})