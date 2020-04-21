local L = LibStub("AceLocale-3.0"):NewLocale("ClassicLFG", "deDE")

if (L) then
    L["Select Dungeon"] = "Wähle Dungeon aus"
    L["Title"] = "Titel"
    L["Dungeon"] = "Dungeon"
    L["Description"] = "Beschreibung"
    L["List Group"] = "Gruppe anmelden"
    L["Delist Group"] = "Gruppe abmelden"
    L["Update Data"] = "Daten aktualisieren"
    L["Select Broadcastchannel"] = "Übertragunskanal auswählen"
    L["Broadcastchannel"] = "Übertragungskanal"
    L["Broadcastinterval"] = "Übertragunsinterval"
    L["Invitemessage"] = "Anmeldenachricht"
    L["Decline"] = "Ablehnen"
    L["Invite"] = "Einladen"
    L["Queue"] = "Anmelden"
    L["Whisper"] = "Anflüstern"
    L["Search Group"] = "Gruppe suchen"
    L["Create Group"] = "Gruppe erstellen"
    L["Settings"] = "Einstellungen"
    L["Always show all dungeons"] = "Zeige immer alle Dungeons an"
    L["Leftclick: Open LFG Browser"] = "Linksclick: Öffne LFG Fenster."
    L["Select all"] = "Alle auswählen"
    L["Deselect all"] = "Alle abwählen"
    L["Queue Dungeon"] = "Dungeon anmelden"
    L["Note"] = "Notiz"
    L["Autoaccept invites of parties you applied to"] = "Einladungen automatisch annehmen"
    L["New Applicant: "] = "Neuer Spieler: "
    L[" - Level "] = " - Level "
    L["Invite Keyword"] = "Invite Stichwort"
    L["Autoinvite"] = "Autoinvite"
    L["Hide Minimap Icon"] = "Minimap Icon verstecken"
    L["RolesArray"] = {
        "tank",
        "dd",
        "dds",
        "heal",
        "healer",
        "heiler",
        "schadensverursacher",
        "damagedealer"
    }
    L["Looking"] = "suchen"
    L["group"] = "gruppe"

    -- Classes
    L["Warlock"] = "Hexenmeister"
    L["Priest"] = "Priester"
    L["Mage"] = "Magier"
    L["Druid"] = "Druide"
    L["Rogue"] = "Schurke"
    L["Hunter"] = "Jäger"
    L["Shaman"] = "Schamane"
    L["Warrior"] = "Krieger"
    L["Paladin"] = "Paladin"
    L["Affliction"] = "Gebrechen"
    L["Demonology"] = "Dämonologie"
    L["Destruction"] = "Zerstörung"
    L["Discipline"] = "Disziplin"
    L["Holy"] = "Heilig"
    L["Shadow"] = "Schatten"
    L["Arcane"] = "Arkan"
    L["Fire"] = "Feuer"
    L["Frost"] = "Frost"
    L["Balance"] = "Gleichgewicht"
    L["Feral"] = "Wildheit"
    L["Restoration"] = "Wiederherstellung"
    L["Assasination"] = "Meucheln"
    L["Combat"] = "Kampf"
    L["Subtlety"] = "Täuschung"
    L["Beastmastery"] = "Tierherschaft"
    L["Marksmanship"] = "Treffsicherheit"
    L["Survival"] = "Überleben"
    L["Elemental"] = "Elementar"
    L["Enhancement"] = "Verstärkung"
    L["Restoration"] = "Wiederherstellung"
    L["Arms"] = "Waffen"
    L["Fury"] = "Furor"
    L["Protection"] = "Schutz"
    L["Holy"] = "Heilig"
    L["Protection"] = "Schutz"
    L["Retribution"] = "Vergeltung"
    L["Advertise Group in Chat"] = "Gruppe im Chat posten"

    -- Dungeons
    L["Ragefire Chasm"] = {
        Name = "Der Flammenschlund",
        AliasTags = {}
    }
    L["Wailing Caverns"] = {
        Name = "Die Höhlen des Wehklagens",
        AliasTags = {}
    }
    L["The Deadmines"] = {
        Name = "Die Todesminen",
        AliasTags = {}
    }
    L["Shadowfang Keep"] = {
        Name = "Burg Schattenfang",
        AliasTags = {}
    }
    L["Blackfathom Deeps"] = {
        Name = "Tiefschwarze Grotte",
        AliasTags = {}
    }
    L["The Stockades"] = {
        Name = "Das Verlies",
        AliasTags = {}
    }
    L["Gnomeregan"] = {
        Name = "Gnomeregan",
        AliasTags = {}
    }
    L["Razorfen Kraul"] = {
        Name = "Kral der Klingenhauer",
        AliasTags = {}
    }
    L["The Scarlet Monastery: Graveyard"] = {
        Name = "Das schwarlachrote Kloster: Friedhof",
        AliasTags = {}
    }
    L["The Scarlet Monastery: Library"] = {
        Name = "Das schwarlachrote Kloster: Bibliothek",
        AliasTags = {}
    }
    L["The Scarlet Monastery: Armory"] = {
        Name = "Das schwarlachrote Kloster: Waffenkammer",
        AliasTags = {}
    }
    L["The Scarlet Monastery: Cathedral"] = {
        Name = "Das schwarlachrote Kloster: Kathedrale",
        AliasTags = {}
    }
    L["Razorfen Downs"] = {
        Name = "Hügel der Klingenhauer",
        AliasTags = {}
    }
    L["Uldaman"] = {
        Name = "Uldaman",
        AliasTags = {}
    }
    L["Zul'Farak"] = {
        Name = "Zul'Farak",
        AliasTags = {}
    }
    L["Maraudon"] = {
        Name = "Maraudon",
        AliasTags = {}
    }
    L["Temple of Atal'Hakkar"] = {
        Name = "Versunkener Tempel",
        AliasTags = {}
    }
    L["Blackrock Depths"] = {
        Name = "Schwarzfelstiefen",
        AliasTags = {}
    }
    L["Lower Blackrock Spire"] = {
        Name = "Obere Schwarzfelsspitze",
        AliasTags = {}
    }
    L["Upper Blackrock Spire"] = {
        Name = "Untere Schwarzfelsspitze",
        AliasTags = {}
    }
    L["Stratholme"] = {
        Name = "Stratholme",
        AliasTags = {}
    }
    L["Scholomance"] = {
        Name = "Scholomance",
        AliasTags = {}
    }
    L["Molten Core"] = {
        Name = "Geschmolzener Kern",
        AliasTags = {}
    }
    L["Onyxia's Lair"] = {
        Name = "Onyxias Hort",
        AliasTags = {}
    }
    L["Custom"] = {
        Name = "Benutzerdefiniert",
        AliasTags = {}
    }

    -- SYSTEM MESSAGES (NEED TO BE ACCURATE!!)
    L[" declines your group invitation."] = " lehnt Eure Einladung in die Gruppe ab."
    L[" joins the party."] = " schließt sich der Gruppe an."
    L[" leaves the party."] = " verlässt die Gruppe."
    L["Your group has been disbanded."] = "Eure Gruppe hat sich aufgelöst."
    L["You leave the group."] = "Ihr verlassst die Gruppe."
    L["You have been removed from the group."] = "Ihr wurdet aus der Gruppe entfernt."
    L[" has invited you to join a group."] = " hat Euch in eine Gruppe eingeladen."
    L[" is already in a group."] = " gehört bereits zu einer Gruppe."
end
