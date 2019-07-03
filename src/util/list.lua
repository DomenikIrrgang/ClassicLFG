ClassicLFGLinkedList = {}
ClassicLFGLinkedList.__index = ClassicLFGLinkedList

setmetatable(ClassicLFGLinkedList, {
    __call = function (cls, ...)
        return cls.new(...)
    end,
})

function ClassicLFGLinkedList.new(text, parent)
    local self = setmetatable({}, ClassicLFGLinkedList)
    self.Items = {}
    self.Items.Head = { IsHead = true, Next = nil }
    self.Size = 0
    return self
end

function ClassicLFGLinkedList:First()
    return self.Items.Head.Next
end

function ClassicLFGLinkedList:Last()
    return self:GetItem(self.Size)
end

function ClassicLFGLinkedList:SetItem(index, item)
    local currentItem = self.Items.Head.Next
    for i=0, index do
        if (i == index) then
            currentItem.Value = item
            break
        else
            currentItem = currentItem.Next
        end
    end
end

function ClassicLFGLinkedList:GetItem(index)
    local currentItem = self.Items.Head.Next
    if (index == -1) then
        return self.Items.Head
    end
    if (self.Size > 0 and index < self.Size) then
        if (index == 0) then
            return currentItem.Value
        end
        for i=0, index do
            if (i == index) then
                return currentItem.Value
            else
                currentItem = currentItem.Next
            end
        end
    end
    return nil
end


function ClassicLFGLinkedList:GetItemNode(index)
    local currentItem = self.Items.Head.Next
    if (index == -1) then
        return self.Items.Head
    end
    if (self.Size > 0) then
        if (index == 0) then
            return currentItem
        end
        for i=0, index do
            if (i == index) then
                return currentItem
            else
                currentItem = currentItem.Next
            end
        end
    end
    return nil
end

function ClassicLFGLinkedList:AddItem(newItem)
    local tmp = { Next = nil, Value = newItem }
    tmp.Next = self.Items.Head.Next
    self.Items.Head.Next = tmp
    self.Size = self.Size + 1
end

function ClassicLFGLinkedList:RemoveItem(index)
    local currentItem = self.Items.Head
    if (index >= 0) then
        for i = 0, index - 1 do
            if (currentItem == nil) then
                break
            end
            currentItem = currentItem.Next
        end
        if (currentItem ~= nil) then
            currentItem.Next = currentItem.Next.Next
            self.Size = self.Size - 1
        end
    end

end

-- Note: Item needs to implements the Function "Equals" on itself and needs to return a boolean value.
function ClassicLFGLinkedList:RemoveItemByComparison(item)
    local currentItem = self.Items.Head.Next
    local index = 0
    while (currentItem ~= nil) do
        if (item:Equals(currentItem.Value) == true) then
            self:RemoveItem(index)
            break
        else
            currentItem = currentItem.Next
            index = index + 1
        end
    end
end

function ClassicLFGLinkedList:Clear(item)
    self.Items.Head.Next = nil
    self.Size = 0
end

-- Note: Item needs to implements the Function "Equals" on itself and needs to return a boolean value.
function ClassicLFGLinkedList:Contains(item)
    local currentItem = self.Items.Head.Next
    local index = 0
    while (currentItem ~= nil) do
        if (item == currentItem.Value or (item.Equals and item:Equals(currentItem.Value) == true)) then
            return index
        else
            currentItem = currentItem.Next
            index = index + 1
        end
    end
    return nil
end

-- Note: Item needs to implements the Function "Equals" on itself and needs to return a boolean value.
function ClassicLFGLinkedList:ContainsWithEqualsFunction(item, equals)
    local currentItem = self.Items.Head.Next
    local index = 0
    while (currentItem ~= nil) do
        if (equals(currentItem.Value, item) == true) then
            return index
        else
            currentItem = currentItem.Next
            index = index + 1
        end
    end
    return nil
end

function ClassicLFGLinkedList:RemoveItemEqualsFunction(equals)
    local currentItem = self.Items.Head.Next
    local index = 0
    while (currentItem ~= nil) do
        if (equals(currentItem.Value) == true) then
            self:RemoveItem(index)
            break
        else
            currentItem = currentItem.Next
            index = index + 1
        end
    end
end

function ClassicLFGLinkedList:Print()
    local currentItem = self.Items.Head
    while (currentItem ~= nil) do
        ClassicLFG:DebugPrint(currentItem.Value)
        currentItem = currentItem.Next
    end
end

function ClassicLFGLinkedList:ToArray()
    local currentItem = self.Items.Head.Next
    local tmp = {}
    while (currentItem ~= nil) do
        table.insert(tmp, currentItem.Value)
        currentItem = currentItem.Next
    end
    return tmp
end