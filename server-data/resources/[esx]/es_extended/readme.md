# es_extended

es_extended is an RPG framework for FiveM, equipped with many extra resources to suit RPG servers.

# Link Utili 
- [BPT-DEVELOPMENT](bitpredator.github.io/bptdevelopment/)

# Features

- Weight based inventory system
- Weapon support, including support for accessories and tints
- It supports different money accounts
- It supports most languages

# Requirements

- [oxmysql](https://github.com/overextended/oxmysql/releases)
- [spawnmanager]

# Installation

- Import `es_extended.sql` in your database
- Configure your `server.cfg`

```
add_ace group.admin command allow # allow all commands
add_ace group.admin command.quit deny # but don't allow quit
add_ace resource.es_extended command.add_ace allow
add_ace resource.es_extended command.add_principal allow
add_ace resource.es_extended command.remove_principal allow
add_ace resource.es_extended command.stop allow
```

# Legal

es_extended - ESX framework for FiveM

Copyright (C) 2015-2023 Jérémie N'gadi - Rework by bitpredator