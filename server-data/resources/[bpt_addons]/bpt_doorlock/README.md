# bpt_doorlock

Port management resource, currently only compatible with es_extended.
[latest release](https://github.com/bitpredator/bpt_doorlock/releases/latest/download/bpt_doorlock.zip)

## Dependencies

### [oxmysql](https://github.com/overextended/oxmysql)

The ports are stored in a database to facilitate the use of the resource

## Client API

```lua
exports.bpt_doorlock:useClosestDoor()
```

```lua
exports.bpt_doorlock:pickClosestDoor()
```

## Server API

```lua
local mrpd_locker_rooms = exports.bpt_doorlock:getDoor(1)
local mrpd_locker_rooms = exports.bpt_doorlock:getDoorFromName('mrpd locker rooms')
```

- Set door state (0: unlocked, 1: locked)

```lua
TriggerEvent('bpt_doorlock:setState', mrpd_locker_rooms.id, state)
```

- Listen for event when door is toggled

```lua
AddEventHandler('bpt_doorlock:stateChanged', function(source, doorId, state, usedItem)
    if usedItem == 'trainticket' then
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem(usedItem, 1)
    end
end)
```