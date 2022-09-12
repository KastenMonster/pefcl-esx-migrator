

Citizen.CreateThread(function()
    print('^2Start Migrating Users from ESX...')
    local users = MySQL.query.await('SELECT identifier, accounts, firstname, lastname FROM users', {})
    for i=1,#users do
        if users[i] then
            if users[i].identifier and users[i].firstname and users[i].lastname and users[i].accounts then
                exports.pefcl:createUniqueAccount(-1, {
                    identifier = users[i].identifier, 
                    name = users[i].firstname..' '..users[i].lastname,
                    type = 'personal'
                })
            end
            Wait(100)
        end
    end
    Wait(5000)
    print('^2Start Updating Balance for pefcl_accounts...')
    for i=1,#users do
        if users[i] then
            if users[i].identifier and users[i].firstname and users[i].lastname then
                MySQL.update.await('UPDATE pefcl_accounts SET balance = ? WHERE ownerIdentifier = ?', {json.decode(users[i].accounts).bank, users[i].identifier})
            end
            Wait(100)
        end
    end
    print('^2Finsihed migrating users from ESX...')
end)