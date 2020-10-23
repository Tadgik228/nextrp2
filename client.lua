--
--                                          by 0xWraith(Dmitry Dzhuha)
--


local sWidth, sHeight = guiGetScreenSize()
showChat(false)
showCursor(true)

local dataToEdit

local win = Window(0, 0, sWidth, sHeight, 'CRUD')
win:align('center')

local tp = TabPanel(0, 0, sWidth, sHeight-30.0)
tp:setParent(win)
local tab1 = tp:addTab('CREATE')
local tab2 = tp:addTab('READ')
local tab3 = tp:addTab('UPDATE')
local tab4 = tp:addTab('DELETE')

-- 
-- CREATE
-- 

local labelCreate = Label(sWidth/2.0-140, sHeight/4, 350, 400, 'CREATE NEW USER', 2.5)
labelCreate:setParent(tab1)

local createInputName = Input(sWidth/2.0-150.0, sHeight/2.0-115.0, 300.0, 45.0, "Enter username")
createInputName:setParent(tab1)

local createInputSurName = Input(sWidth/2.0-150.0, sHeight/2.0-50.0, 300.0, 45.0, "Enter surname")
createInputSurName:setParent(tab1)

local createInputAddress = Input(sWidth/2.0-150.0, sHeight/2.0+15.0, 300.0, 45.0, "Enter address")
createInputAddress:setParent(tab1)

local createButton = Button(sWidth/2.0-150.0, sHeight/2.0+150.0, 300, 45, 'CREATE')
createButton:setParent(tab1)
createButton:on('mouseup', function() 
	
	-- Regex for username and surname
	-- ^([a-z ,.'-]{1,20})$
	-- 

	if createInputName.value == "Enter username" or pregFind(createInputName.value, '^([a-z ,.\'-]{1,20})$', 'i') == false then
		return Alert('Username value is not entered correctly or length more 20 or less than 3 symbols!')
	end

	if createInputSurName.value == "Enter surname" or pregFind(createInputSurName.value, '^([a-z ,.\'-]{1,20})$', 'i') == false then
		return Alert('Surname value is not entered correctly or length more 20 or less than 3 symbols!')
	end

	if createInputAddress.value == "Enter address" or pregFind(createInputAddress.value, '^([a-z ,.\'-]{1,30})$', 'i') == false then
		return Alert('Address value is not entered correctly or length more 30 or less than 3 symbols!')
	end

	Alert('User successful created! Check READ or DELETE TABS')
	triggerServerEvent("createUser", getLocalPlayer(), createInputName.value, createInputSurName.value, createInputAddress.value) 

	createInputName.value 		= 'Enter username'
	createInputSurName.value 	= 'Enter surname'
	createInputAddress.value 	= 'Enter address'

end)

-- 
-- 
-- 

-- 
-- EDIT
-- 
local editList = Gridlist(0.0, 0.0, sWidth, sHeight-110.0-5.0)
editList:align('center')
editList:setParent(tab3)

editList:addColumn('UserID')
editList:setColumnWidth(1, sWidth/4.0)

editList:addColumn('Name')
editList:setColumnWidth(2, sWidth/4.0)

editList:addColumn('Surname')
editList:setColumnWidth(3, sWidth/4.0)

editList:addColumn('Address')
editList:setColumnWidth(4, sWidth/4.0)

editList:setItemHeight(37.2)

local editBTN1 = Button(sWidth/2.0-150.0-0.5, sHeight-110.0, 150.0, 50.0, 'UPDATE LIST')
editBTN1:align('center')
editBTN1:setParent(tab3)

local editBTN2 = Button(sWidth/2.0+0.5, sHeight-110.0, 150.0, 50.0, 'UPDATE SELECTED')
editBTN2:align('center')
editBTN2:setParent(tab3)

editBTN1:on('mouseup', function()
	updateAllTabsList()
end)

local editWindow = Window(sWidth/2-175, sHeight/2-200, 350, 400, 'UPDATE')
editWindow:align('center')
editWindow:setParent(tab3)
editWindow:hide()


local editBTN3 = Button(350/2-75, 400/2+100, 150.0, 50.0, 'UPDATE')
editBTN3:align('center')
editBTN3:setParent(editWindow)

local labelName = Label(350/2-150, 30, 350, 400, 'Edit name:')
labelName:setParent(editWindow)

local editName = Input(350/2-150, 400/2.0-150.0, 300.0, 45.0, '-')
editName:setParent(editWindow)

local labelSurName = Label(350/2-150, 105, 350, 400, 'Edit surname:')
labelSurName:setParent(editWindow)

local editSurName = Input(350/2-150, 400/2.0-75.0, 300.0, 45.0, '-')
editSurName:setParent(editWindow)

local labelAddress = Label(350/2-150, 180, 350, 400, 'Edit address:')
labelAddress:setParent(editWindow)

local editAddress = Input(350/2-150, 400/2.0, 300.0, 45.0, '-')
editAddress:setParent(editWindow)

editBTN2:on('mouseup', function()
	local index = editList:getSelectedItem()

	if index then

		for k, v in pairs(editList:getItemsValues()) do

			if index == k then
				
				showEditWindow(v)
				break
			end
		end
		
	end
end)

editBTN3:on('mouseup', function()

	if dataToEdit then
		if pregFind(editName.value, '^([a-z ,.\'-]{1,20})$', 'i') == false then
			return Alert('Username value is not entered correctly or length more 20 or less than 3 symbols!')
		end
	
		if pregFind(editSurName.value, '^([a-z ,.\'-]{1,20})$', 'i') == false then
			return Alert('Surname value is not entered correctly or length more 20 or less than 3 symbols!')
		end
	
		if pregFind(editAddress.value, '^([a-z ,.\'-]{1,30})$', 'i') == false then
			return Alert('Address value is not entered correctly or length more 30 or less than 3 symbols!')
		end
	
		Alert('User successful updated!')

		dataToEdit[2] = editName.value
		dataToEdit[3] = editSurName.value
		dataToEdit[4] = editAddress.value

		triggerServerEvent("updateUserData", getLocalPlayer(), dataToEdit)

	end
end)

-- 
-- 
-- 

-- 
-- READ
-- 

local list = Gridlist(0.0, 0.0, sWidth, sHeight-110.0-5.0)
list:align('center')
list:setParent(tab2)

list:addColumn('UserID')
list:setColumnWidth(1, sWidth/4.0)
list:addColumn('Name')
list:setColumnWidth(2, sWidth/4.0)
list:addColumn('Surname')
list:setColumnWidth(3, sWidth/4.0)
list:addColumn('Address')
list:setColumnWidth(4, sWidth/4.0)

list:setItemHeight(37.2)

local readBTN1 = Button(sWidth/2.0-75.0, sHeight-110.0, 150.0, 50.0, 'UPDATE LIST')
readBTN1:align('center')
readBTN1:setParent(tab2)


readBTN1:on('mouseup', function()
	updateAllTabsList()
end)


-- 
-- 
-- 

-- 
-- DELETE
-- 

local DELETElist = Gridlist(0.0, 0.0, sWidth, sHeight-110.0-5.0)
DELETElist:align('center')
DELETElist:setParent(tab4)

DELETElist:addColumn('UserID')
DELETElist:setColumnWidth(1, sWidth/4.0)
DELETElist:addColumn('Name')
DELETElist:setColumnWidth(2, sWidth/4.0)
DELETElist:addColumn('Surname')
DELETElist:setColumnWidth(3, sWidth/4.0)
DELETElist:addColumn('Address')
DELETElist:setColumnWidth(4, sWidth/4.0)

DELETElist:setItemHeight(37.2)

local DELETEBTN1 = Button(sWidth/2.0-150.0-0.5, sHeight-110.0, 150.0, 50.0, 'UPDATE LIST')
DELETEBTN1:align('center')
DELETEBTN1:setParent(tab4)

local DELETEBTN2 = Button(sWidth/2.0+0.5, sHeight-110.0, 150.0, 50.0, 'DELETE SELECTED')
DELETEBTN2:align('center')
DELETEBTN2:setParent(tab4)



DELETEBTN1:on('mouseup', function()
	updateAllTabsList()
end)

DELETEBTN2:on('mouseup', function()
	local index = DELETElist:getSelectedItem()
	if index then
		
		Alert('Are you shure you want to delete current user?', function()

			for k, v in pairs(DELETElist:getItemsValues()) do

				if index == k then
					if tonumber(v[1]) ~= nil then 
						list:clear()
						DELETElist:removeItem(index)
						triggerServerEvent("deleteUserFromTable", getLocalPlayer(), v[1])
					else 
						Alert('This item is not user data!')
					end	
					break
				end
			end
		end)
	end
end)

-- 
-- 
-- 

function showEditWindow(table)
	editWindow:show()
	editWindow:focus()

	editName:setValue(table[2])
	editSurName:setValue(table[3])
	editAddress:setValue(table[4])

	dataToEdit = table

end

function updateAllTabsList()
	DELETElist:clear()
	editList:clear()
	list:clear()

	triggerServerEvent("loadUsersInTable", getLocalPlayer()) 
end
addEvent("updateAllTabsList", true)
addEventHandler( "updateAllTabsList", localPlayer, updateAllTabsList)

function recieveDataForAllList(result)


	if next(result) == nil then
		DELETElist:addItem({"There is no data in DB!", "-", "-", "-"})
		editList:addItem({"There is no data in DB!", "-", "-", "-"})
		list:addItem({"There is no data in DB!", "-", "-", "-"})
	else
		for idx, user in ipairs (result) do
			DELETElist:addItem({user.uID, user.uName, user.uSurName, user.uAddress})
			editList:addItem({user.uID, user.uName, user.uSurName, user.uAddress})
			list:addItem({user.uID, user.uName, user.uSurName, user.uAddress})
		end
	end		
end
addEvent("recieveDataForAllList", true)
addEventHandler( "recieveDataForAllList", localPlayer, recieveDataForAllList)

updateAllTabsList()


--           _
--       .__(.)< (MEOW)
--        \___)   
-- ~~~~~~~~~~~~~~~~~~