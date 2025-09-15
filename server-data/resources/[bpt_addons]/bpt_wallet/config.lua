Config = {}

Config.WalletItem = "wallet" -- Item name of wallet
Config.WalletStorage = {
    slots = 8, -- Slots of wallet storage
    weight = 1000, -- Total weight for wallet
}

-- Whitelist di item ammessi nel portafogli (case-insensitive)
Config.WalletWhitelist = {
    "money",
    "black_money",
    "idcard",
    "jobcard",
    "dmvcard",
    "licensecard",
}
