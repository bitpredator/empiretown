Citizen.CreateThread(function()
    local function loadDefaults(list)
        for _, obj in ipairs(list) do
            if type(obj) == "table" and obj.condition then
                if obj.condition() then
                    obj.ref.LoadDefault()
                end
            elseif type(obj) == "table" and obj.enable ~= nil then
                obj.ref.Enable(obj.enable)
            else
                obj.LoadDefault()
            end
        end
    end

    -- Single Player
    loadDefaults({
        Michael,
        Franklin,
        FranklinAunt,
        Simeon,
        Floyd,
        TrevorsTrailer,
        Ammunations,
        LesterFactory,
        StripClub,
        ZancudoGates,
        { ref = BahamaMamas, enable = true },
        { ref = PillboxHospital, enable = true },
        { ref = Graffitis, enable = true },
        { ref = UFO.Hippie, enable = false },
        { ref = UFO.Chiliad, enable = false },
        { ref = UFO.Zancudo, enable = false },
        { ref = RedCarpet, enable = false },
        { ref = NorthYankton, enable = false },
    })

    -- GTA Online
    loadDefaults({
        GTAOApartmentHi1,
        GTAOApartmentHi2,
        GTAOHouseHi1,
        GTAOHouseHi2,
        GTAOHouseHi3,
        GTAOHouseHi4,
        GTAOHouseHi5,
        GTAOHouseHi6,
        GTAOHouseHi7,
        GTAOHouseHi8,
        GTAOHouseMid1,
        GTAOHouseLow1,
    })

    -- High Life
    loadDefaults({
        HLApartment1,
        HLApartment2,
        HLApartment3,
        HLApartment4,
        HLApartment5,
        HLApartment6,
    })

    -- Heists
    loadDefaults({
        { ref = HeistCarrier, enable = true },
        HeistYacht,
    })

    -- Executives & Other Criminals
    loadDefaults({ ExecApartment1, ExecApartment2, ExecApartment3 })

    -- Finance & Felony
    loadDefaults({ FinanceOffice1, FinanceOffice2, FinanceOffice3, FinanceOffice4 })

    -- Bikers
    loadDefaults({
        BikerCocaine,
        BikerCounterfeit,
        BikerDocumentForgery,
        BikerMethLab,
        BikerWeedFarm,
        BikerClubhouse1,
        BikerClubhouse2,
    })

    -- Import/Export
    loadDefaults({
        ImportCEOGarage1,
        ImportCEOGarage2,
        ImportCEOGarage3,
        ImportCEOGarage4,
        ImportVehicleWarehouse,
    })

    -- Gunrunning
    loadDefaults({ GunrunningBunker, GunrunningYacht })

    -- Smuggler’s Run
    loadDefaults({ SmugglerHangar })

    -- Doomsday Heist
    loadDefaults({ DoomsdayFacility })

    -- After Hours
    loadDefaults({ AfterHoursNightclubs })

    -- Diamond Casino & Resort
    loadDefaults({
        {
            ref = DiamondCasino,
            condition = function()
                return GetGameBuildNumber() >= 2060
            end,
        },
        {
            ref = DiamondPenthouse,
            condition = function()
                return GetGameBuildNumber() >= 2060
            end,
        },
    })

    -- Los Santos Tuners
    loadDefaults({
        {
            ref = TunerGarage,
            condition = function()
                return GetGameBuildNumber() >= 2372
            end,
        },
        {
            ref = TunerMethLab,
            condition = function()
                return GetGameBuildNumber() >= 2372
            end,
        },
        {
            ref = TunerMeetup,
            condition = function()
                return GetGameBuildNumber() >= 2372
            end,
        },
    })

    -- The Contract
    loadDefaults({
        {
            ref = MpSecurityGarage,
            condition = function()
                return GetGameBuildNumber() >= 2545
            end,
        },
        {
            ref = MpSecurityMusicRoofTop,
            condition = function()
                return GetGameBuildNumber() >= 2545
            end,
        },
        {
            ref = MpSecurityStudio,
            condition = function()
                return GetGameBuildNumber() >= 2545
            end,
        },
        {
            ref = MpSecurityBillboards,
            condition = function()
                return GetGameBuildNumber() >= 2545
            end,
        },
        {
            ref = MpSecurityOffice1,
            condition = function()
                return GetGameBuildNumber() >= 2545
            end,
        },
        {
            ref = MpSecurityOffice2,
            condition = function()
                return GetGameBuildNumber() >= 2545
            end,
        },
        {
            ref = MpSecurityOffice3,
            condition = function()
                return GetGameBuildNumber() >= 2545
            end,
        },
        {
            ref = MpSecurityOffice4,
            condition = function()
                return GetGameBuildNumber() >= 2545
            end,
        },
    })

    -- Criminal Enterprises
    loadDefaults({
        {
            ref = CriminalEnterpriseSmeonFix,
            condition = function()
                return GetGameBuildNumber() >= 2699
            end,
        },
        {
            ref = CriminalEnterpriseVehicleWarehouse,
            condition = function()
                return GetGameBuildNumber() >= 2699
            end,
        },
        {
            ref = CriminalEnterpriseWarehouse,
            condition = function()
                return GetGameBuildNumber() >= 2699
            end,
        },
    })
end)
