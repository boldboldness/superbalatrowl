-- Super Bowl LIX cards
SMODS.Atlas {
    key = "SuperBowlAtlas",
    path = "superbowl.png",
    px = 71,
    py = 95
}

-- Eagles
-- Xmult random between -X2 and X9
SMODS.Joker {
    key = 'eagles',

    cost = 5,
    rarity = 1,
    blueprint_compat = true,

    config = {
        extra = {
            xmult_range = 12,
            xmult_offset = 2,
            xmult_min = -2,
            xmult_max = 10,
        }
    },

    loc_txt = {
        name = "Eagles",
        text = {
            "Random XMult between {X:mult,C:white}x#1#{} and {X:mult,C:white}x#2#{}"
        }
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult_min, card.ability.extra.xmult_max } }
    end,

    atlas = "SuperBowlAtlas",
    pos = { x = 0, y = 0 },

    calculate = function(self, card, context)
        if context.joker_main then
            local Xmult = math.floor(
                pseudorandom('eagles') 
                * (card.ability.extra.xmult_range+1) 
                - (card.ability.extra.xmult_offset)
            )

            local result = { Xmult = Xmult }


            if Xmult == 0 then
                G.E_MANAGER:add_event(Event({ --Add bonus chips from this card
                    trigger = 'before',
                    delay = 0.63,
                    func = function()
                        attention_text({
                            text = 'x0',
                            scale = 0.7, 
                            hold = 0.63,
                            backdrop_colour = G.C.MULT,
                            align = 'bm',
                            major = card,
                            offset = {x = 0, y = 0.05*card.T.h}
                        })
                        play_sound('multhit2')
                        card:juice_up(0.6, 0.1)
                        G.ROOM.jiggle = G.ROOM.jiggle + 0.7
                        return true
                    end
                }))
            end
            return result
        end
    end
}

-- Chiefs
-- +4 mult, 1 in 50 chance for x50 Xmult
SMODS.Joker {
    key = 'chiefs',

    cost = 5,
    rarity = 1,
    blueprint_compat = true,

    config = {
        extra = {
            mult = 2,
            Xmult = 50,
            odds = 50
        }
    },

    loc_txt = {
        name = "Chiefs",
        text = {
            "Each played card gives {C:mult}+#1#{} Mult",
            "with a {C:green}#2# in #3#{} chance",
            "to give {X:mult,C:white}x#4#{} Xmult"
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = { 
                card.ability.extra.mult, 
                (G.GAME.probabilities.normal or 1), 
                card.ability.extra.odds,
                card.ability.extra.Xmult
            }
        }
    end,

    atlas = "SuperBowlAtlas",
    pos = { x = 1, y = 0 },

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            local result = { mult = card.ability.extra.mult }
            if pseudorandom("chiefs") < G.GAME.probabilities.normal / card.ability.extra.odds then
                sendInfoMessage('Returning Xmult')
                result.Xmult = card.ability.extra.Xmult
            end

            return result
        end
    end
}