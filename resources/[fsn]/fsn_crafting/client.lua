local crafting_stations = {
  ------------ WEED
  {
	--[[
    blip = {
      title = 'Weed Farming',
      id = 496
    },
	]]
    loc = {x = 2219.7758789063, y = 5577.4584960938, z = 53.845291137695},
    cost = 5,
    required = {
      item = 'none',
      itemtitle = 'none',
      amount = 0
    },
    gives = {
      item = '2g_weed',
      itemtitle = '2G Weed',
      amount = 2
    }
  },
  {
	--[[
    blip = {
      title = 'Weed Crafting',
      id = 496
    },
	]]
    loc = {x = 1273.991, y = -1711.7100, z = 54.771},
    cost = 175,
    required = {
      item = '2g_weed',
      itemtitle = '2G Weed',
      amount = 1
    },
    gives = {
      item = 'joint',
      itemtitle = 'Joint',
      amount = 3
    }
  },

  ------------ METH
  {
	--[[
    blip = {
      title = 'Meth Farming',
      id = 403
    },
	]]
    loc = {x = 3623.6965332031, y = 3738.8859863281, z = 28.690086364746},
    cost = 15,
    required = {
      item = 'none',
      itemtitle = 'none',
      amount = 0
    },
    gives = {
      item = 'acetone',
      itemtitle = 'Acetone',
      amount = 2
    }
  },
  {	
	--[[
    blip = {
      title = 'Meth Crafting',
      id = 403
    },
	]]
    loc = {x = -586.707, y = -1601.208, z = 27.010},
    cost = 50,
    required = {
      item = 'acetone',
      itemtitle = 'Acetone',
      amount = 1
    },
    gives = {
      item = 'phosphorus',
      itemtitle = 'Phosphorus',
      amount = 1
    }
  },
  {
	--[[
    blip = {
      title = 'Meth Cooking',
      id = 403
    },
	]]
    loc = {x = 2431.5795898438, y = 4963.7548828125, z = 42.347560882568},
    cost = 150,
    required = {
      item = 'phosphorus',
      itemtitle = 'Phosphorus',
      amount = 1
    },
    gives = {
      item = 'meth_rocks',
      itemtitle = 'Meth Rocks',
      amount = 4
    }
  },
  ------------ Burgers
  {
	--[[
    blip = {
      title = 'Burger Manufacturing',
      id = 273
    },
	]]
    loc = {x = 974.915, y = -2120.97, z = 31.3902},
    cost = 0,
    required = {
      item = 'uncooked_meat',
      itemtitle = 'Raw Meat',
      amount = 3
    },
    gives = {
      item = 'minced_meat',
      itemtitle = 'Minced Meat',
      amount = 1
    }
  },
  {
	--[[
    blip = {
      title = 'Burger Stand',
      id = 467
    },
	]]
    loc = {x = -1856.4829101563, y = -1224.6036376953, z = 13.017220497131},
    cost = 100,
    required = {
      item = 'minced_meat',
      itemtitle = 'Minced Meat',
      amount = 1
    },
    gives = {
      item = 'burger',
      itemtitle = 'Supreme Burger',
      amount = 1
    }
  },
 }

Citizen.CreateThread(function()
  for k, v in pairs(crafting_stations) do
	if v.blip then
		local bleep = AddBlipForCoord(v.loc.x, v.loc.y, v.loc.z)
		SetBlipSprite(bleep, v.blip.id)
		SetBlipDisplay(bleep, 4)
		SetBlipScale(bleep, 1.0)
		SetBlipColour(bleep, 4)
		SetBlipAsShortRange(bleep, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(v.blip.title)
		EndTextCommandSetBlipName(bleep)
	end
  end
  while true do
    Citizen.Wait(0)
    for k, v in pairs(crafting_stations) do
      if GetDistanceBetweenCoords(v.loc.x,v.loc.y,v.loc.z,GetEntityCoords(GetPlayerPed(-1)), true) < 10 then
        DrawMarker(1,v.loc.x,v.loc.y,v.loc.z-1,0,0,0,0,0,0,5.001,5.0001,0.4001,0,155,255,175,0,0,0,0)
        if GetDistanceBetweenCoords(v.loc.x,v.loc.y,v.loc.z,GetEntityCoords(GetPlayerPed(-1)), true) < 5 then
          SetTextComponentFormat("STRING")
          AddTextComponentString("Press ~INPUT_PICKUP~ to get ~g~"..v.gives.itemtitle)
          DisplayHelpTextFromStringLabel(0, 0, 1, -1)
          if IsControlJustPressed(0,38) then
            if exports.fsn_main:fsn_GetWallet() >= v.cost then
              if exports.fsn_inventory:fsn_GetItemAmount(v.required.item) >= v.required.amount then
                local waittime = math.random(3000,6000)
                TriggerEvent('fsn_notify:displayNotification', 'Gathering ['..v.gives.amount..'X] '..v.gives.itemtitle, 'centerLeft', waittime, 'info')
                Citizen.Wait(waittime)
                if v.required.item ~= 'none' then
                  TriggerEvent('fsn_inventory:item:take', v.required.item, v.required.amount)
                end
                TriggerEvent('fsn_notify:displayNotification', 'Gathered ['..v.gives.amount..'X] '..v.gives.itemtitle, 'centerRight', 3500, 'success')
                if v.cost > 0 then
                  TriggerEvent('fsn_bank:change:walletMinus', v.cost)
                end
                TriggerEvent('fsn_inventory:item:add', v.gives.item, v.gives.amount)
              else
                TriggerEvent('fsn_notify:displayNotification', 'You don\'t have any '..v.required.itemtitle, 'centerRight', 3500, 'error')
              end
            else
              TriggerEvent('fsn_notify:displayNotification', 'You don\'t have $'..v.cost..'!!!', 'centerRight', 3500, 'error')
            end
          end
        end
      end
    end
  end
end)
