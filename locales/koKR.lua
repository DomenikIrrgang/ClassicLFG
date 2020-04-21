local L = LibStub("AceLocale-3.0"):NewLocale("ClassicLFG", "koKR")

if (L) then
    L["Select Dungeon"] = "던전 선택"
    L["Title"] = "제목"
    L["Dungeon"] = "던전"
    L["Description"] = "설명"
    L["List Group"] = "파티 목록 불러오기"
    L["Delist Group"] = "파티 목록 삭제"
    L["Update Data"] = "업데이트"
    L["Select Broadcastchannel"] = "광고할 채널 선택"
    L["Broadcastchannel"] = "광고할 채널"
    L["Broadcastinterval"] = "광고 주기"
    L["Invitemessage"] = "초대 메시지"
    L["Decline"] = "거절"
    L["Invite"] = "초대"
    L["Queue"] = "대기열 등록"
    L["Whisper"] = "귓속말"
    L["Search Group"] = "파티 찾기"
    L["Create Group"] = "파티 생성하기"
    L["Settings"] = "설정"
    L["Always show all dungeons"] = "항상 모든 던전 표시"
    L["Leftclick: Open LFG Browser"] = "좌클릭: 파티찾기 브라우저 열기"
    L["Select all"] = "모두 선택"
    L["Deselect all"] = "모두 선택해제"
    L["Queue Dungeon"] = "던전 대기열 등록"
    L["Note"] = "참고"
    L["Autoaccept invites of parties you applied to"] = "지원한 파티의 초대 자동 수락"
    L["New Applicant: "] = "새 지원자: "
    L[" - Level "] = " - 레벨 "
    L["Invite Keyword"] = "초대 키워드"
    L["Autoinvite"] = "자동 초대"
    L["Hide Minimap Icon"] = "미니맵 아이콘 숨기기"
    L["RolesArray"] = {
            "탱커",
            "딜러",
            "힐",
            "힐러",
            "데미지 딜러"
    }
    L["looking"] = "찾기"
    L["group"] = "그룹"

    -- Classes
    L["Warlock"] = "흑마법사"
    L["Priest"] = "사제"
    L["Mage"] = "마법사"
    L["Druid"] = "드루이드"
    L["Rogue"] = "도적"
    L["Hunter"] = "사냥꾼"
    L["Shaman"] = "주술사"
    L["Warrior"] = "전사"
    L["Paladin"] = "성기사"
    L["Affliction"] = "고통"
    L["Demonology"] = "악마"
    L["Destruction"] = "파괴"
    L["Discipline"] = "수양"
    L["Holy"] = "신성"
    L["Shadow"] = "암흑"
    L["Arcane"] = "비전"
    L["Fire"] = "화염"
    L["Frost"] = "냉기"
    L["Balance"] = "조화"
    L["Feral"] = "야성"
    L["Restoration"] = "회복"
    L["Assasination"] = "암살"
    L["Combat"] = "전투"
    L["Subtlety"] = "잠행"
    L["Beastmastery"] = "야수"
    L["Marksmanship"] = "사격"
    L["Survival"] = "생존"
    L["Elemental"] = "정기"
    L["Enhancement"] = "고양"
    L["Restoration"] = "복원"
    L["Arms"] = "무기"
    L["Fury"] = "분노"
    L["Protection"] = "방어"
    L["Holy"] = "신성"
    L["Protection"] = "보호"
    L["Retribution"] = "징벌"

    -- Dungeons
    L["Ragefire Chasm"] = {
            Name = "성난불길 협곡",
            AliasTags = {}
    }
    L["Wailing Caverns"] = {
            Name = "통곡의 동굴",
            AliasTags = {}
    }
    L["The Deadmines"] = {
            Name = "죽음의 폐광",
            AliasTags = {}
    }
    L["Shadowfang Keep"] = {
            Name = "그림자송곳니 성채",
            AliasTags = {}
    }
    L["Blackfathom Deeps"] = {
            Name = "검은심연의 나락",
            AliasTags = {}
    }
    L["The Stockades"] = {
            Name = "스톰윈드 지하감옥",
            AliasTags = {}
    }
    L["Gnomeregan"] = {
            Name = "놈리건",
            AliasTags = {}
    }
    L["Razorfen Kraul"] = {
            Name = "가시덩굴 우리",
            AliasTags = {}
    }
    L["The Scarlet Monastery: Graveyard"] = {
            Name = "붉은십자군 수도원 - 4번방 묘지",
            AliasTags = {}
    }
    L["The Scarlet Monastery: Library"] = {
            Name = "붉은십자군 수도원 - 1번방 도서관",
            AliasTags = {}
    }
    L["The Scarlet Monastery: Armory"] = {
            Name = "붉은십자군 수도원 - 2번방 무기고",
            AliasTags = {}
    }
    L["The Scarlet Monastery: Cathedral"] = {
            Name = "붉은십자군 수도원 - 3번방 예배당",
            AliasTags = {}
    }
    L["Razorfen Downs"] = {
            Name = "가시덩굴 구릉",
            AliasTags = {}
    }
    L["Uldaman"] = {
            Name = "울다만",
            AliasTags = {}
    }
    L["Zul'Farak"] = {
            Name = "줄파락",
            AliasTags = {}
    }
    L["Maraudon"] = {
            Name = "마라우돈",
            AliasTags = {}
    }
    L["Temple of Atal'Hakkar"] = {
            Name = "아탈학카르 신전",
            AliasTags = {}
    }
    L["Blackrock Depths"] = {
            Name = "검은바위 나락",
            AliasTags = {}
    }
    L["Lower Blackrock Spire"] = {
            Name = "검은바위 첨탑 하층",
            AliasTags = {}
    }
    L["Upper Blackrock Spire"] = {
            Name = "검은바위 첨탑 상층",
            AliasTags = {}
    }
    L["Stratholme"] = {
            Name = "스트라솔름",
            AliasTags = {}
    }
    L["Scholomance"] = {
            Name = "스칼로맨스",
            AliasTags = {}
    }
    L["Molten Core"] = {
            Name = "화산 심장부",
            AliasTags = {}
    }
    L["Onyxia's Lair"] = {
            Name = "오닉시아의 둥지",
            AliasTags = {}
    }
    L["Custom"] = {
            Name = "임의 설정",
            AliasTags = {}
    }

    -- SYSTEM MESSAGES (NEED TO BE ACCURATE!!)
    L[" declines your group invitation."] = "님이 초대를 사양했습니다."
    L[" joins the party."] = "님이 파티에 합류했습니다."
    L[" leaves the party."] = "님이 파티를 떠났습니다."
    L["Your group has been disbanded."] = "파티가 해체되었습니다."
    L["You leave the group."] = "당신은 파티를 떠났습니다."
    L["You have been removed from the group."] = "당신은 파티에서 제외되었습니다."
    L[" has invited you to join a group."] = "님이 당신을 파티에 초대했습니다."
    L[" to join your group."] = "님을 파티에 초대했습니다."
    L["You have invited "] = ""
    L[" is already in a group."] = "님은 이미 파티에 속해 있습니다."
end
