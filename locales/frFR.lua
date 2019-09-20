local L = LibStub("AceLocale-3.0"):NewLocale("ClassicLFG", "frFR")

if (L) then
    L["Select Dungeon"] = "Selectionnez un donjon"
    L["Title"] = "Titre"
    L["Dungeon"] = "Donjon"
    L["Description"] = "Description"
    L["List Group"] = "Inscrire le groupe"
    L["Delist Group"] = "Désinscrire le groupe"
    L["Update Data"] = "Mettre à jour les informations"
    L["Select Broadcastchannel"] = "Sélectionner le canal d'annonce"
    L["Broadcastchannel"] = "Canal d'annonce"
    L["Broadcastinterval"] = "Intervalle d'annonce"
    L["Invitemessage"] = "Message d'invitation"
    L["Decline"] = "Refuser"
    L["Invite"] = "Inviter"
    L["Queue"] = "S'inscrire"
    L["Whisper"] = "Chuchoter"
    L["Search Group"] = "Chercher un groupe"
    L["Create Group"] = "Créer un groupe"
    L["Settings"] = "Configuration"
    L["Always show all dungeons"] = "Toujours afficher tous les donjons"
    L["Leftclick: Open LFG Browser"] = "Click gauche: Ouvrir l'explorateur LFG"
    L["Select all"] = "Tout sélectionner"
    L["Deselect all"] = "Tout désélectionner"
    L["Queue Dungeon"] = "Inscription à un donjon"
    L["Note"] = "Note"
    L["Autoaccept invites of parties you applied to"] =
        "Accepter automatiquement les invitations aux groupes auxquels vous avez postulé"
    L["New Applicant: "] = "Nouveau candidat: "
    L[" - Level "] = " - Niveau "
    L["Invite Keyword"] = "Mot-clé d'invitation"
    L["Autoinvite"] = "Inviter automatiquement"

    -- Classes
    L["Warlock"] = "Démoniste"
    L["Priest"] = "Prêtre"
    L["Mage"] = "Mage"
    L["Druid"] = "Druide"
    L["Rogue"] = "Voleur"
    L["Hunter"] = "Chasseur"
    L["Shaman"] = "Chaman"
    L["Warrior"] = "Guerrier"
    L["Paladin"] = "Paladin"
    L["Affliction"] = "Affliction"
    L["Demonology"] = "Démonologie"
    L["Destruction"] = "Destruction"
    L["Discipline"] = "Discipline"
    L["Holy"] = "Sacré"
    L["Shadow"] = "Ombre"
    L["Arcane"] = "Arcane"
    L["Fire"] = "Feu"
    L["Frost"] = "Givre"
    L["Balance"] = "Equilibre"
    L["Feral"] = "Combat farouche"
    L["Restoration"] = "Restauration"
    L["Assasination"] = "Assassinat"
    L["Combat"] = "Combat"
    L["Subtlety"] = "Finesse"
    L["Beastmastery"] = "Maîtrise des bêtes"
    L["Marksmanship"] = "Précision"
    L["Survival"] = "Survie"
    L["Elemental"] = "Elémentaire"
    L["Enhancement"] = "Amélioration"
    L["Restoration"] = "Restauration"
    L["Arms"] = "Arme"
    L["Fury"] = "Fureur"
    L["Protection"] = "Protection"
    L["Holy"] = "Sacré"
    L["Protection"] = "Protection"
    L["Retribution"] = "Vindicte"

    -- Dungeons
    L["Ragefire Chasm"] = {
        Name = "Gouffre de Ragefeu",
        AliasTags = {}
    }
    L["Wailing Caverns"] = {
        Name = "Cavernes des Lamentations",
        AliasTags = {}
    }
    L["The Deadmines"] = {
        Name = "Les Mortemines",
        AliasTags = {}
    }
    L["Shadowfang Keep"] = {
        Name = "Donjon d'Ombrecroc",
        AliasTags = {}
    }
    L["Blackfathom Deeps"] = {
        Name = "Profondeurs de Brassenoire",
        AliasTags = {}
    }
    L["The Stockades"] = {
        Name = "La Prison",
        AliasTags = {}
    }
    L["Gnomeregan"] = {
        Name = "Gnomeregan",
        AliasTags = {}
    }
    L["Razorfen Kraul"] = {
        Name = "Kraal de Tranchebauge",
        AliasTags = {}
    }
    L["The Scarlet Monastery: Graveyard"] = {
        Name = "Le Monastère Écarlate: Cimetière",
        AliasTags = {}
    }
    L["The Scarlet Monastery: Library"] = {
        Name = "Le Monastère Écarlate: Bibliothèque",
        AliasTags = {}
    }
    L["The Scarlet Monastery: Armory"] = {
        Name = "Le Monastère Écarlate: Armurerie",
        AliasTags = {}
    }
    L["The Scarlet Monastery: Cathedral"] = {
        Name = "Le Monastère Écarlate: Cathédrale",
        AliasTags = {}
    }
    L["Razorfen Downs"] = {
        Name = "Souilles de Tranchebauge",
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
        Name = "Temple d'Atal'Hakkar",
        AliasTags = {}
    }
    L["Blackrock Depths"] = {
        Name = "Profondeurs de Rochenoire",
        AliasTags = {}
    }
    L["Lower Blackrock Spire"] = {
        Name = "Pic Rochenoire inférieur",
        AliasTags = {}
    }
    L["Upper Blackrock Spire"] = {
        Name = "Pic Rochenoire supérieur",
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
        Name = "Cœur du Magma",
        AliasTags = {}
    }
    L["Onyxia's Lair"] = {
        Name = "Repaire d'Onyxia",
        AliasTags = {}
    }
    L["Custom"] = {
        Name = "Personnalisé",
        AliasTags = {}
    }

    -- SYSTEM MESSAGES (NEED TO BE ACCURATE!!)
    L[" declines your group invitation."] = " refuse votre invitation à rejoindre le groupe."
    L[" joins the party."] = " rejoint le groupe."
    L[" leaves the party."] = " a quitté le groupe."
    L["Your group has been disbanded."] = "Votre groupe a été dissout."
    L["You leave the group."] = "Vous quittez le groupe."
    L["You have been removed from the group."] = "Vous avez été renvoyé du groupe."
    L[" has invited you to join a group."] = " vous a invité à rejoindre un groupe."
    L[" to join your group."] = " à rejoindre votre groupe."
    L["You have invited "] = "Vous avez invité "
    L[" is already in a group."] = " est déjà dans un groupe."
end
