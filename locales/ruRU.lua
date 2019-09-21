local L = LibStub("AceLocale-3.0"):NewLocale("ClassicLFG", "ruRU")

if (L) then
    L["Select Dungeon"] = "Выберите подземелье"
    L["Title"] = "Название"
    L["Dungeon"] = "Подземелье"
    L["Description"] = "Описание"
    L["List Group"] = "Начать поиск"
    L["Delist Group"] = "Остановить поиск"
    L["Update Data"] = "Обновить"
    L["Select Broadcastchannel"] = "Выбрать канал"
    L["Broadcastchannel"] = "Канал"
    L["Broadcastinterval"] = "Интервал сообщения"
    L["Invitemessage"] = "Сообщение о наборе"
    L["Decline"] = "Отклонить"
    L["Invite"] = "Пригласить"
    L["Queue"] = "Очередь"
    L["Whisper"] = "Шепот"
    L["Search Group"] = "Найти группу"
    L["Create Group"] = "Создать группу"
    L["Settings"] = "Настройки"
    L["Always show all dungeons"] = "Всегда показывать все подземелья"
    L["Leftclick: Open LFG Browser"] = "Левый клик: Открыть окно поиска"
    L["Select all"] = "Выбрать все"
    L["Deselect all"] = "Отменить выбор"
    L["Queue Dungeon"] = "Встать в очередь"
    L["Note"] = "Заметка"
    L["Autoaccept invites of parties you applied to"] = "Автоматически принимать приглашение"
    L["New Applicant: "] = "Новая заявка: "
    L[" - Level "] = " - Уровень "
    L["Invite Keyword"] = "Кодовое слово для приглашения"
    L["Autoinvite"] = "Автоприглашение"
    L["RolesArray"] = {
        "танк",
        "дд",
        "рдд",
        "хил",
        "дпс",
        "рдпс"
    }

    -- LFM tags
    L["LFMTags"] = {
        "лфм",
        "нид",
        "нужен",
        "нужно",
        "нужны"
    }
    -- LFG tags
    L["LFGTags"] = {
        "лфг",
        "ищy",
        "сходит",
        "ищют"
    }

    -- Classes
    L["Warlock"] = "Чернокнижник"
    L["Priest"] = "Жрец"
    L["Mage"] = "Маг"
    L["Druid"] = "Друид"
    L["Rogue"] = "Разбойник"
    L["Hunter"] = "Охотник"
    L["Shaman"] = "Шаман"
    L["Warrior"] = "Воин"
    L["Paladin"] = "Паладин"
    L["Affliction"] = "Колдовство"
    L["Demonology"] = "Демонология"
    L["Destruction"] = "Разрушение"
    L["Discipline"] = "Послушание"
    L["Holy"] = "Свет"
    L["Shadow"] = "Тьма"
    L["Arcane"] = "Тайная магия"
    L["Fire"] = "Огонь"
    L["Frost"] = "Лед"
    L["Balance"] = "Баланс"
    L["Feral"] = "Сила зверя"
    L["Restoration"] = "Восстановление"
    L["Assasination"] = "Ликвидация"
    L["Combat"] = "Бой"
    L["Subtlety"] = "Скрытность"
    L["Beastmastery"] = "Мастер зверей"
    L["Marksmanship"] = "Стрельба"
    L["Survival"] = "Выживание"
    L["Elemental"] = "Стихии"
    L["Enhancement"] = "Совершенствование"
    L["Restoration"] = "Исцеление"
    L["Arms"] = "Оружие"
    L["Fury"] = "Неистовство"
    L["Protection"] = "Защита"
    L["Holy"] = "Свет"
    L["Protection"] = "Защита"
    L["Retribution"] = "Воздаяние"

    -- Dungeons
    L["Ragefire Chasm"] = {
        Name = "Огненная пропасть",
        AliasTags = {
            "оп"
        }
    }
    L["Wailing Caverns"] = {
        Name = "Пещеры Стенаний",
        AliasTags = {
            "пс"
        }
    }
    L["The Deadmines"] = {
        Name = "Мертвые копи",
        AliasTags = {
            "копи",
            "мк",
            "дм"
        }
    }
    L["Shadowfang Keep"] = {
        Name = "Крепость темного клыка",
        AliasTags = {
            "ктк"
        }
    }
    L["Blackfathom Deeps"] = {
        Name = "Непроглядная пучина",
        AliasTags = {
            "нп"
        }
    }
    L["The Stockades"] = {
        Name = "Тюрьма Штормграда",
        AliasTags = {
            "тш",
            "тюрьма",
            "тюрьму"
        }
    }
    L["Gnomeregan"] = {
        Name = "Гномерган",
        AliasTags = {
            "гномер",
            "гном"
        }
    }
    L["Razorfen Kraul"] = {
        Name = "Лабиринты иглошкурых",
        AliasTags = {
            "ли",
            "лабиринты",
            "лобиринты"
        }
    }
    L["The Scarlet Monastery: Graveyard"] = {
        Name = "Монастырь Алого Ордена: Кладбище",
        AliasTags = {
            "мао",
            "кладбон",
            "скарлет",
            "монастырь",
            "кладбище"
        }
    }
    L["The Scarlet Monastery: Library"] = {
        Name = "Монастырь Алого Ордена: Библиотека",
        AliasTags = {
            "мао",
            "скарлет",
            "монастырь",
            "библиотека"
        }
    }
    L["The Scarlet Monastery: Armory"] = {
        Name = "Монастырь Алого Ордена: Оружейная",
        AliasTags = {
            "мао",
            "скарлет",
            "монастырь",
            "оружейная",
            "оружейка",
            "армори"
        }
    }
    L["The Scarlet Monastery: Cathedral"] = {
        Name = "Монастырь Алого Ордена: Собор",
        AliasTags = {
            "мао",
            "скарлет",
            "монастырь",
            "собор"
        }
    }
    L["Razorfen Downs"] = {
        Name = "Курганы иглошкурых",
        AliasTags = {
            "ки",
            "курганы"
        }
    }
    L["Uldaman"] = {
        Name = "Ульдаман",
        AliasTags = {
            "ульдa",
            "ульду",
            "ульдуман"
        }
    }
    L["Zul'Farak"] = {
        Name = "Зуль'Фарак",
        AliasTags = {
            "зф",
            "фарак",
            "зул",
            "зулфарак",
            "зульфарак"
        }
    }
    L["Maraudon"] = {
        Name = "Мараудон",
        AliasTags = {
            "марадон",
            "мара",
            "мородон",
            "мародон"
        }
    }
    L["Temple of Atal'Hakkar"] = {
        Name = "Храм Атал'Хаккара",
        AliasTags = {
            "ха",
            "хах",
            "атал",
            "аталхаккара",
            "аталхакара",
            "хаккара"
        }
    }
    L["Blackrock Depths"] = {
        Name = "Глубины Черной Горы",
        AliasTags = {
            "брд",
            "глубины",
            "арены"
        }
    }
    L["Lower Blackrock Spire"] = {
        Name = "Пик Черной Горы",
        AliasTags = {
            "пик",
            "лбрс"
        }
    }
    L["Upper Blackrock Spire"] = {
        Name = "Верхняя часть Пика Черной Горы",
        AliasTags = {
            "верх",
            "верхняя",
            "убрс"
        }
    }
    L["Stratholme"] = {
        Name = "Стратхольм",
        AliasTags = {
            "страт"
        }
    }
    L["Scholomance"] = {
        Name = "Некроситет",
        AliasTags = {
            "шоло",
            "некроситет",
            "некраситет"
        }
    }
    L["Molten Core"] = {
        Name = "Огненные недра",
        AliasTags = {
            "недры",
            "он"
        }
    }
    L["Onyxia's Lair"] = {
        Name = "Логово Ониксии",
        AliasTags = {
            "оникс",
            "ониксия",
            "ониксию"
        }
    }
    L["Custom"] = {
        Name = "разное",
        AliasTags = {}
    }

    -- SYSTEM MESSAGES (NEED TO BE ACCURATE!!)
    L[" declines your group invitation."] = " отклоняет приглашение в группу."
    L[" joins the party."] = " присоединяется к группе."
    L[" leaves the party."] = " покидает группу."
    L["Your group has been disbanded."] = "Ваша группа расформирована."
    L["You leave the group."] = "Вы покинули группу."
    L["You have been removed from the group."] = "Вы покинули группу или были исключены из нее."
    L[" has invited you to join a group."] = " предлагает вам присоединиться к группе."
    L[" to join your group."] = " приглашается в вашу группу."
    L["You have invited "] = "Вы пригласили "
    L[" is already in a group."] = " уже состоит в группе."
end
