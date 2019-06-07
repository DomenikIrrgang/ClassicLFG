ClassicLFG.Config = {
    Debug = true,
    Font = "Fonts\\FRIZQT__.ttf",
    Network = {
        Prefix = "CLFG_Network",
        Channel = {
            Name = "ClassicLFGNetwork",
            Id = 1
        }
    },
    BroadcastInterval = 30,
    CheckGroupExpiredInterval = 5,
    GroupTimeToLive = 5 * 60,
    BroadcastDungeonGroupChannel = "ClassicLFGNetwork",
    BroadcastDungeonGroupInterval = 60,
    InviteMessage = "invite please",
    Events = {
        RequestData = "CLASSICLFG_DATA_REQUEST",
        SendData = "CLASSICLFG_DATA_RESPONSE",
        ApplyForGroup = "CLASSICLFG_GROUP_APPLY",
        -- Args(dungeonGroup)
        AppliedForGroup = "CLASSICLFG_GROUP_APPLIED",
        -- Args(applicant, dungeonGroup)
        ApplicantInvited = "CLASSICLFG_APPLICANT_INVITED",
        -- Args(applicant)
        ApplicantInviteAccepted = "CLASSICLFG_APPLICANT_INVITE_ACCEPTED",
        -- Args(applicant)
        ApplicantInviteDeclined = "CLASSICLFG_APPLICANT_INVITE_DECLINED",
        -- Args(applicant)
        ApplicantDeclined = "CLASSICLFG_APPLICANT_DECLINED",
        -- Args(applicant)
        ApplicantReceived = "CLASSICLFG_APPLICANT_RECEIVED",
        -- Args(applicant)
        DungeonGroupWithdrawApplication = "CLASSICLFG_APPLICANT_WITHDRAW",
        -- Args(dungeonGroup)
        GroupListed = "CLASSICLFG_GROUP_LISTED",
        -- Args(dungeonGroup)
        GroupDelisted = "CLASSICLFG_GROUP_DELISTED",
        -- Args(dungeonGroup)
        DungeonGroupJoined = "CLASSICLFG_GROUP_JOINED",
        -- Args(dungeonGroup)
        DungeonGroupLeft = "CLASSICLFG_GROUP_LEFT",
        -- Args(dungeonGroup)
        DungeonGroupUpdated = "CLASSICLFG_GROUP_UPDATED",
        -- Args(player)
        DungeonGroupMemberLeft = "CLASSICLFG_DUNGEON_GROUP_MEMBER_LEFT",
        -- Args(dungeonGroup)
        DeclineApplicant = "CLASSICLFG_APPLICANT_DECLINE",
        -- Args()
        DungeonGroupSyncRequest = "CLASSICLFG_GROUP_SYNC_REQUEST",
        -- Args(dungeonGroup)
        DungeonGroupSyncResponse = "CLASSICLFG_GROUP_SYNC_RESPONSE",
        -- Args()
        DungeonGroupRequestTalents = "CLASSICLFG_GROUP_TALENTS_REQUEST",
        -- Args(talents)
        DungeonGroupRequestTalents = "CLASSICLFG_GROUP_TALENTS_RESPONSE",
        -- Args(dungeonGroup)
        ChatDungeonGroupFound = "CLASSICLFG_CHAT_DUNGEONGROUP_FOUND",
        -- Args(dungeonGroup)
        DungeonGroupBroadcasterCanceled = "CLASSICLFG_DUNGEONGROUP_BROADCASTER_CANCELED",
    }
}