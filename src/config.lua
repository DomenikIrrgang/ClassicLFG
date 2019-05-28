ClassicLFG.Config = {
    Font = "Fonts\\FRIZQT__.ttf",
    Network = {
        Prefix = "CLFG",
        Channel = {
            Name = "ClassicLFGNetwork",
            Id = 1
        },
        Prefixes = {
            SendData = "CLFG_Response",
            RequestData = "CLFG_Request",
            PostGroup = "CLFG_PostGroup",
            DequeueGroup = "CLFG_DQGroup",
            ApplyForGroup = "CLFG_Apply",
            Event = "CFGL_Event"
        }
    },
    Events = {
        -- Args(applicant)
        ApplicantInvited = "CLASSICLFG_APPLICANT_INVITED",
        -- Args(applicant)
        ApplicantInviteAccepted = "CLASSICLFG_APPLICANT_INVITE_ACCEPTED",
        -- Args(applicant)
        ApplicantInviteDeclined = "CLASSICLFG_APPLICANT_INVITE_DECLINED",
        -- Args(applicant)
        ApplicantDeclined = "CLASSICLFG_APPLICANT_DECLINED",
        -- Args(applicant)
        ApplicantReceived = "CLASSICLFG_APPLICANT_RECEIVED"
    }
}