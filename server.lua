local function extractPlayerInfo(charinfo, money)
    local charinfoData = json.decode(charinfo)
    local moneyData = json.decode(money)
    
    local firstname = charinfoData.firstname or "Unknown"
    local lastname = charinfoData.lastname or "Unknown"
    local cash = moneyData.cash or 0
    local bank = moneyData.bank or 0
    local crypto = moneyData.crypto or 0
    local total_money = cash + bank
    
    return firstname .. " " .. lastname, cash, bank, crypto, total_money
end

local function hasPermission(player)
    for _, group in ipairs(Config.AllowedGroups) do
        print("Checking permission for group:", group) 
        if exports.qbx_core:HasPermission(player, group) then
            print("Permission granted for group:", group) 
            return true
        end
    end
    return false
end

RegisterCommand("richestplayers", function(source, args, rawCommand)
    print("Executing richestplayers command") 

    if not hasPermission(source) then
        TriggerClientEvent('ox_lib:notify', source, {
            description = Config.Texts.noPermission,
            type = 'error'
        })
        return
    end

    local response = MySQL.query.await([[
        SELECT charinfo, money
        FROM players
    ]])

    if response then

        local totalCash = 0
        local totalBank = 0
        local totalCrypto = 0
        local playerData = {}

        for i = 1, #response do
            local playerName, cash, bank, crypto, total_money = extractPlayerInfo(response[i].charinfo, response[i].money)
            table.insert(playerData, {name = playerName, cash = cash, bank = bank, crypto = crypto, total = total_money})
            totalCash = totalCash + cash
            totalBank = totalBank + bank
            totalCrypto = totalCrypto + crypto
        end

        table.sort(playerData, function(a, b) return a.total > b.total end)

        local totalAmount = totalCash + totalBank
        TriggerClientEvent('hobbs_server_economy:showRichestPlayers', source, playerData, totalAmount, totalCrypto)
    else
        print("No data found") 
        TriggerClientEvent('ox_lib:notify', source, {
            description = Config.Texts.noDataFound,
            type = 'error'
        })
    end
end, false)