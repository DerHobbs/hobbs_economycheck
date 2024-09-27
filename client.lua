local Config = Config or {}

RegisterNetEvent('hobbs_server_economy:showRichestPlayers', function(playerData, totalAmount, totalCrypto)
    for i = 1, #playerData do
        playerData[i].total = playerData[i].cash + playerData[i].bank
    end

    SetNuiFocus(true, true)
    SendNUIMessage({
        type = 'show',
        players = playerData,
        totalAmount = totalAmount,
        totalCrypto = totalCrypto,
        texts = Config.Texts,
        webhookUrl = Config.WebhookUrl
    })
end)

RegisterNUICallback('close', function(data, cb)
    SetNuiFocus(false, false)
    SendNUIMessage({ type = 'hide' })
    cb('ok')
end)