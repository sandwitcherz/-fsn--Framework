RegisterServerEvent('fsn_phone:purchased')
AddEventHandler('fsn_phone:purchased', function(charid)
  local src = source
  local numbers = {1,2,3,4,5,6,7,8,9}
  local tbl = {}
  for id = 1, 6 do
    table.insert(tbl,#tbl+1,numbers[math.random(1, #numbers)])
  end
  local number = table.concat( tbl, '', 1, #tbl )
  MySQL.Async.execute('UPDATE `fsn_characters` SET `char_phone` = @number WHERE `fsn_characters`.`char_id` = @charid;', {['@charid'] = charid, ['@number'] = number}, function(rowsChanged)
    TriggerClientEvent('fsn_notify:displayNotification', src, 'Your new number is: <b>'..number, 'centerLeft', 10000, 'info')
    TriggerClientEvent('fsn_phone:updateNumber', src, tonumber(number))
    TriggerClientEvent('fsn_phone:recieveMessage', src, {
      sender = 'Lifeinvader',
      from_number = 696969,
      to_number = number,
      message = 'Welcome to Lifeinvader! Your new mobile phone number is '..number..'. ~Lifeinvader Team'
    })
  end)
end)

RegisterServerEvent('fsn_phone:sendMessage')
AddEventHandler('fsn_phone:sendMessage', function(tonum, fromnum, msg)
  --local from = exports.fsn_main:fsn_GetPlayerFromPhoneNumber(tonumber(tonum))
  local client = exports.fsn_main:fsn_GetPlayerFromPhoneNumber(tonumber(tonum))
  --local fromid = from.char_id
  --local clientid = client.char_id
  if client ~= 0 then
    TriggerClientEvent('fsn_phone:recieveMessage', client, {
      sender = false,
      from_number = fromnum,
      to_number = tonum,
      message = msg
    })
    TriggerClientEvent('fsn_notify:displayNotification', source, 'Messaged delivered', 'centerRight', 8000, 'success')
    --MySQL.Async.execute('INSERT INTO `fsn_textmessages` (`txt_id`, `txt_sender`, `txt_reciever`, `txt_message`, `txt_date`) VALUES (NULL, @sender, @reciever, @message, CURRENT_TIMESTAMP)', {['@sender'] = fromid,['@reciever'] = clientid,['@message'] = msg,}, function(rowsChanged) end)
  else
    TriggerClientEvent('fsn_notify:displayNotification', source, 'No player found with number <b>'..tonumber(tonum), 'centerRight', 8000, 'error')
  end
end)

RegisterServerEvent('fsn_phone:chat')
AddEventHandler('fsn_phone:chat', function(str, players)
  for k, v in pairs(players) do
    TriggerClientEvent('chatMessage', v, '', {255,255,255}, str)
  end
end)
