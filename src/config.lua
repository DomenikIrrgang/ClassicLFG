ClassicLFG.Config = {
    Debug = false,
    Version = "0.4.7",
    Font = "Fonts\\FRIZQT__.ttf",
    Network = {
        Prefix = "CLFG_Network",
        Channel = {
            Name = "ClassicLFG",
            Id = 1
        }
    },
    BroadcastInterval = 15,
    CheckGroupExpiredInterval = 5,
    GroupTimeToLive = 5 * 60,
    PrimaryColor = { Red = 0.5, Blue = 0.5, Green = 0.5, Alpha = 1 },
    SecondaryColor = { Red = 0.7, Blue = 0.7, Green = 0.7, Alpha = 1 },
    BackgroundColor = { Red = 0.2, Blue = 0.2, Green = 0.2, Alpha = 1 },
    ActiveColor = { Red = 0.8, Blue = 0.8, Green = 0.8, Alpha = 1 },
    DialogColor = { Red = 0.3, Blue = 0.3, Green = 0.3, Alpha = 1 },
    DisabledColor = { Red = 0.15, Blue = 0.15, Green = 0.15, Alpha = 0.4 },
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
        DungeonGroupJoined = "CLASSICLFG_DUNGEONGROUP_JOINED",
        -- Args(dungeonGroup)
        DungeonGroupLeft = "CLASSICLFG_DUNGEONGROUP_LEFT",
        -- Args(dungeonGroup)
        DungeonGroupUpdated = "CLASSICLFG_GROUP_UPDATED",
        -- Args(player)
        DungeonGroupMemberLeft = "CLASSICLFG_DUNGEON_GROUP_MEMBER_LEFT",
        -- Args(dungeonGroup)
        DeclineApplicant = "CLASSICLFG_APPLICANT_DECLINE",
        -- Args(applicantList)
        SyncApplicantList = "CLASSICLFG_SYNC_APPLICANT_LIST",
        -- Args()
        DungeonGroupTalentsRequest = "CLASSICLFG_GROUP_TALENTS_REQUEST",
        -- Args(talents)
        DungeonGroupTalentsResponse = "CLASSICLFG_GROUP_TALENTS_RESPONSE",
        -- Args(dungeonGroup)
        ChatDungeonGroupFound = "CLASSICLFG_CHAT_DUNGEONGROUP_FOUND",
        -- Args(dungeonGroup)
        DungeonGroupBroadcasterCanceled = "CLASSICLFG_DUNGEONGROUP_BROADCASTER_CANCELED",
        -- Args(channels)
        ChannelListChanged = "CLASSICLFG_CHANNEL_LIST_CHANGED",
        -- Args(playerName)
        GroupInviteDecline = "CLASSICLFG_GROUP_INVITE_DECLINE",
        -- Args(playerName)
        GroupInviteDeclined = "CLASSICLFG_GROUP_INVITE_DECLINED",
        -- Args(playername)
        GroupInviteReceived = "CLASSICLFG_GROUP_INVITE_RECEIVED",
        -- Args(playername)
        GroupJoined = "CLASSICLFG_GROUP_JOINED",
        -- Args(playername)
        GroupLeft = "CLASSICLFG_GROUP_LEFT",
        -- Args(playername)
        GroupMemberJoined = "CLASSICLFG_GROUP_MEMBER_JOINED",
        -- Args(playername)
        GroupMemberLeft = "CLASSICLFG_GROUP_MEMBER_LEFT",
        -- Args(playerName)
        GroupInviteSend = "CLASSICLFG_GROUP_INVITE_SEND",
        -- Args(playerName)
        GroupInviteAccepted = "CLASSICLFG_GROUP_INVITE_ACCEPTED",
        -- Args()
        GroupDisbanded = "CLASSICLFG_GROUP_DISBANDED",
        -- Args()
        GroupKicked = "CLASSICLFG_GROUP_KICKED",
        -- Args(version)
        VersionCheck = "CLASSICLFG_VERSION_CHECK",
        -- Args(version)
        NewVersionAvailable = "CLASSICLFG_NEW_VERSION_AVAILABLE",
        -- Args(player)
        InviteWhisperReceived = "CLASSICLFG_INVITE_WHISPER_RECEIVED",
        -- Args(player)
        GroupInviteAlreadyInGroup = "CLASSICLFG_GROUP_INVITE_ALREADY_IN_GROUP",
         -- Args({ player, talents })
        PlayerTalents = "CLASSICLFG_TALENT_SYNC",
    }
}