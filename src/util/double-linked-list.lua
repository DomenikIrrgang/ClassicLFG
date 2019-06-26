ClassicLFGDoubleLinkedList = {}
ClassicLFGDoubleLinkedList.__index = ClassicLFGDoubleLinkedList

setmetatable(ClassicLFGDoubleLinkedList, {
    __call = function (cls, ...)
        return cls.new(...)
    end,
})

function ClassicLFGDoubleLinkedList.new(text, parent)
    local self = setmetatable({}, ClassicLFGDoubleLinkedList)
    self.Items = {}
    self.Items.Head = { IsHead = true, Previous = nil, Next = nil }
    self.Items.Tail = { IsTail = true, Previous = nil, Next = nil }
    self.Items.Head.Next = self.Items.Tail
    self.Items.Tail.Previous = self.Items.Head
    self.Size = 0
    return self
end

function ClassicLFGDoubleLinkedList:First()
    return self.Head.Next
end

function ClassicLFGDoubleLinkedList:Last()
    return self.Head.Previous
end

function ClassicLFGDoubleLinkedList:GetItem(index)
    local currentItem = self.Items.Head.Next
    if (index == 0 and not currentItem.IsTail) then
        return currentItem
    end
    for i=0, index do
        if (currentItem.IsTail) then
            return nil
        else
            if (i == index) then
                return currentItem
            else
                currentItem = currentItem.Next
            end
        end
    end
end

function ClassicLFGDoubleLinkedList:AddItem(newItem)
    local tmp = newItem
    tmp.Previous = self.Items.Tail.Previous
    tmp.Next = self.Items.Tail
    self.Items.Tail.Previous.Next = tmp
    self.Items.Tail.Previous = tmp
    self.Size = self.Size + 1
end

function ClassicLFGDoubleLinkedList:RemoveItem(item)
    item.Previous.Next = item.Next
    item.Next.Previous = item.Previous
    self.Size = self.Size - 1
end

function ClassicLFGDoubleLinkedList:RemoveItemByIndex(index)
    local currentItem = self.Items.Head.Next
    local i = 0
    while (currentItem ~= nil) do
        if (i == index) then
            self:RemoveItem(currentItem)
            break
        else
            currentItem = currentItem.Next
            i = i + 1
        end
    end
end

-- Note: Item needs to implements the Function "Equals" on itself and needs to return a boolean value.
function ClassicLFGDoubleLinkedList:RemoveItemByComparison(item)
    local currentItem = self.Items.Head.Next
    while (currentItem ~= nil) do
        if (item:Equals(currentItem) == true) then
            self:RemoveItem(currentItem)
            break
        else
            currentItem = currentItem.Next
        end
    end
end

function ClassicLFGDoubleLinkedList:RemoveItemEqualsFunction(equals)
    local currentItem = self.Items.Head.Next
    while (currentItem ~= nil) do
        if (equals(currentItem) == true) then
            self:RemoveItem(currentItem)
            break
        else
            currentItem = currentItem.Next
        end
    end
end

function ClassicLFGDoubleLinkedList:FindItem(item)
    local currentItem = self.Items.Head.Next
    while (currentItem ~= nil) do
        if (item:Equals(currentItem) == true) then
            return item
        else
            currentItem = currentItem.Next
        end
    end
    return nil
end

function ClassicLFGDoubleLinkedList:Print()
    local currentItem = self.Items.Head
    ClassicLFG:DebugPrint("FORWARDS")
    while (currentItem ~= nil) do
        ClassicLFG:DebugPrint(currentItem.Name)
        currentItem = currentItem.Next
    end
    ClassicLFG:DebugPrint("BACKWARDS")
    currentItem = self.Items.Tail
    while (currentItem ~= nil) do
        ClassicLFG:DebugPrint(currentItem.Name)
        currentItem = currentItem.Previous
    end
end