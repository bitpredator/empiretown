# SQZ_CARKEYS SCRIPT

Modern, simple, clear script for locking player vehicles. Optimized server + client side, possibility to give keys to another players, supports society owned vehicles, Locksmith for resetting vehicle keys and much more! All is working with OneSync Infinity/Legacy, as much as possible is handled server, all events are protected againts hackers.

# Features
- Lock personaly/society owned vehicles
- Give vehicle keys to other players
- Reset vehicle keys at Locksmith (place on the map)
- Give temporarily keys of vehicle
- Optimized client & server side

# Controls
- /givekeys - Give keys to a player
- /lockvehicle or F10 - Lock closest vehicle

# Exports
- Server side
- - `resetPlate(plate)` - Resets a vehicle plate's cache
- - `giveTempKeys(plate, identifier, timeout)` - Adds temporarily keys to a player (until the server), timeout is an optional param, time in ms until the key is reset

# Instalation
- Drop the script into your resources folder and start it in your `server.cfg`
- Run the sql.sql file
- For optional modifications & exports check docs

