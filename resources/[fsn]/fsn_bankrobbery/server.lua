local vault_doors = {
  [1] = {'closed'},
  [2] = {'closed'},
  [3] = {'closed'},
}

local banks_payout = {
  [1] = 1500000,
  [2] = 2000000,
  [3] = 800000
}

AddEventHandler('fsn_main:money:bank:Add', function(ply, amt)
	local randomizer = amt / math.random(1,5)
	banks_payout[1] = banks_payout[1] + randomizer
	banks_payout[2] = banks_payout[2] + randomizer
	banks_payout[3] = banks_payout[3] + randomizer
end)

AddEventHandler('fsn_main:money:bank:Minus', function(ply, amt)
	local randomizer = amt / math.random(1,5)
	banks_payout[1] = banks_payout[1] - randomizer
	banks_payout[2] = banks_payout[2] - randomizer
	banks_payout[3] = banks_payout[3] - randomizer
end)

RegisterServerEvent('fsn_bankrobbery:vault:open')
AddEventHandler('fsn_bankrobbery:vault:open', function(id)
  print('attempting to open door '..id)
  vault_doors[id][1] = 'open'
  TriggerClientEvent('fsn_bankrobbery:openDoor', -1, id)
end)

RegisterServerEvent('fsn_bankrobbery:vault:close')
AddEventHandler('fsn_bankrobbery:vault:close', function(id)
  print('attempting to close door '..id)
  vault_doors[id][1] = 'closed'
  TriggerClientEvent('fsn_bankrobbery:closeDoor', -1, id)
end)

RegisterServerEvent('fsn_bankrobbery:init')
AddEventHandler('fsn_bankrobbery:init', function()
  TriggerClientEvent('fsn_bankrobbery:init', source, vault_doors)
end)

RegisterServerEvent('fsn_bankrobbery:payout')
AddEventHandler('fsn_bankrobbery:payout', function(id)
  if banks_payout[id] > 0 then
    local amt = banks_payout[id] / 6
    amt = amt / math.random(1,8)
    amt = math.floor(amt)
    banks_payout[id] = banks_payout[id] - amt
    print(':fsn_bankrobbery: '..source..' robbed bank #'..id..' and took $'..amt..' leaving the bank with $'..banks_payout[id])
    TriggerClientEvent('fsn_inventory:item:add', source, 'dirty_money', amt)
    TriggerClientEvent('fsn_notify:displayNotification', source, 'You got $'..amt..'DM from the vault!!', 'centerRight', 8000, 'error')
  else
    TriggerClientEvent('fsn_notify:displayNotification', source, 'This bank has no money left!', 'centerRight', 8000, 'error')
  end
end)
