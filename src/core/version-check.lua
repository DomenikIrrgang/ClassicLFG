ClassicLFGVersionCheck = {}
ClassicLFGVersionCheck.__index = ClassicLFGVersionCheck

setmetatable(ClassicLFGVersionCheck, {
    __call = function (cls, ...)
        return cls.new(...)
    end,
})

function ClassicLFGVersionCheck.new()
    local self = setmetatable({}, ClassicLFGVersionCheck)
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.VersionCheck, self, self.CheckVersion)
    self.UserNotified = false
    return self
end

function ClassicLFGVersionCheck:CheckVersion(version)
    if (self.UserNotified == false and self:CompareVersions(version, ClassicLFG.Config.Version) == 1) then 
        self.UserNotified = true
        ClassicLFG.EventBus:PublishEvent(ClassicLFG.Config.Events.NewVersionAvailable, version)
    end
end

function ClassicLFGVersionCheck:CompareVersions(version1, version2)
    if (version1 ~= version2) then
        version1 = version1:SplitString(".")
        version2 = version2:SplitString(".")
        if (tonumber(version1[1]) == tonumber(version2[1])) then
            if (tonumber(version1[2]) == tonumber(version2[2])) then
                if (tonumber(version1[3]) < tonumber(version2[3])) then
                    return -1
                end
                return 1
            elseif (tonumber(version1[2]) < tonumber(version2[2])) then
                return -1
            end
            return 1
        elseif (tonumber(version1[1]) < tonumber(version2[1])) then
            return -1
        end
        return 1
    end
    return 0
end

ClassicLFG.VersionCheck = ClassicLFGVersionCheck()