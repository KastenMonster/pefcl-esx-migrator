
local Spam = false

Citizen.CreateThread(function()
    print('===================================')
    print('^2Starting Migration...')
    print('^5getting all Values from ^1users')
    local users = MySQL.query.await('SELECT identifier, accounts, firstname, lastname FROM users', {})
    print('^2creating pefcl accounts...')
    local deadaccounts = 0
    for i=1,#users do
        if users[i] then
            if users[i].identifier and users[i].firstname and users[i].lastname and users[i].accounts then
                exports.pefcl:createUniqueAccount(-1, {
                    identifier = users[i].identifier, 
                    name = users[i].firstname..' '..users[i].lastname,
                    type = 'personal'
                })
                Wait(100)
                if Spam then
                    print(string.format('^2 Created Account: Name %s %s, Identifier: %s',users[i].firstname,users[i].lastname,users[i].identifier))
                end
            else
                if Spam then
                    print(string.format('^1 Skiped User due to missing Value'))
                end
                deadaccounts = deadaccounts + 1
            end
        end
    end
    print(string.format('^2found ^1 %s ^2 dead Accounts (some Values where nil)',deadaccounts))
    Wait(5000)
    print('^2Start Updating Balance for pefcl_accounts...')
    for i=1,#users do
        if users[i] then
            if users[i].identifier and users[i].firstname and users[i].lastname then
                MySQL.update.await('UPDATE pefcl_accounts SET balance = ? WHERE ownerIdentifier = ?', {json.decode(users[i].accounts).bank, users[i].identifier})
                if Spam then
                    print(string.format('^2 Set User (%s) Balance: %s',users[i].identifier,json.decode(users[i].accounts).bank))
                end
            end
            Wait(100)
        end
    end
    print('^2Finsihed migrating users from ESX...')
    print('===================================')
end)
