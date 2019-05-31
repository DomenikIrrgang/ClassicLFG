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
    Events = {
        RequestData = "CLASSICLFG_DATA_REQUEST",
        SendData = "CLASSICLFG_DATA_RESPONSE",
        ApplyForGroup = "CLASSICLFG_GROUP_APPLY",
        -- Args(applicant)
        ApplicantInvited = "CLASSICLFG_APPLICANT_INVITED",
        -- Args(applicant)
        ApplicantInviteAccepted = "CLASSICLFG_APPLICANT_INVITE_ACCEPTED",
        -- Args(applicant)
        ApplicantInviteDeclined = "CLASSICLFG_APPLICANT_INVITE_DECLINED",
        -- Args(applicant)
        ApplicantDeclined = "CLASSICLFG_APPLICANT_DECLINED",
        -- Args(applicant)
        ApplicantReceived = "CLASSICLFG_APPLICANT_RECEIVED",
        -- Args(dungeonGroup)
        GroupListed = "CLASSICLFG_GROUP_LISTED",
        -- Args(dungeonGroup)
        GroupDelisted = "CLASSICLFG_GROUP_DELISTED",
        -- Args(dungeonGroup)
        GroupUpdated = "CLASSICLFG_GROUP_UPDATED",
        -- Args(dungeonGroup)
        DungeonGroupJoined = "CLASSICLFG_GROUP_JOINED",
        -- Args()
        DungeonGroupSyncRequest = "CLASSICLFG_GROUP_SYNC_REQUEST",
        -- Args(dungeonGroup)
        DungeonGroupSyncResponse = "CLASSICLFG_GROUP_SYNC_RESPONSE",
    }
}