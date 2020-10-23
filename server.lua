function CreateMySQLConnection()
    CRUDConnection = dbConnect( "mysql", "dbname=mC3OJWkbpG;host=remotemysql.com;charset=utf8", "mC3OJWkbpG", "iQ8Jq608cc")
   
    if not CRUDConnection then
        outputDebugString("Error while connecting to MySQL host!");
    else
        outputDebugString("Success: Connected to the MySQL server")
    end

end

addEventHandler("onResourceStart", resourceRoot, CreateMySQLConnection)

-- 
-- CREATE
-- 
function createUser(username, surname, address)
    local qh = dbQuery(CRUDConnection, "INSERT INTO `users` (`uName`, `uSurName`, `uAddress`) VALUES (?, ?, ?)", username, surname, address)
    dbFree(qh)

    triggerClientEvent(client, "updateAllTabsList", client, users)
end
addEvent("createUser", true)
addEventHandler("createUser", getRootElement(), createUser)
-- 
-- 
-- 

--
-- UPDATE
-- 
function updateUserData(data)
    local qh = dbQuery(CRUDConnection, "UPDATE `users` SET `uName` = ?, `uSurName` = ?, `uAddress` = ? WHERE `uID` = ?", data[2], data[3], data[4], data[1])
    dbFree(qh)

    triggerClientEvent(client, "updateAllTabsList", client, users)

end
addEvent("updateUserData", true)
addEventHandler("updateUserData", getRootElement(), updateUserData)

-- 
-- 
-- 

-- 
-- READ
-- 

function getAllUsersInTable()
    dbQuery(queryTABReadRespond, {client}, CRUDConnection, "SELECT * FROM `users`")
end
addEvent("loadUsersInTable", true)
addEventHandler("loadUsersInTable", getRootElement(), getAllUsersInTable)


function queryTABReadRespond(qh, client)
    local users = dbPoll(qh, 0)
    
    triggerClientEvent(client, "recieveDataForAllList", client, users)
end    

-- 
-- DELETE
-- 

function deleteUserFromTable(userID)
    local qh = dbQuery(CRUDConnection, "DELETE FROM `users` WHERE `uID` = ?", userID)
    dbFree(qh)

    triggerClientEvent(client, "updateAllTabsList", client, users)

end
addEvent("deleteUserFromTable", true)
addEventHandler("deleteUserFromTable", getRootElement(), deleteUserFromTable)
