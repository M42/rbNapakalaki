#!/usr/bin/env ruby
#encoding: utf-8
require_relative 'player.rb'

module Game

    class CultistPlayer < Player
        @@totalCultistPlayers = 0

        def initialize(player, cultist)
            copy(player)
            @myCultistCard = cultist
            @@totalCultistPlayers += 1
        end

        def getCombatLevel
            super + @myCultistCard.getSpecialValue
        end

        def getOponentLevel(monster)
            monster.getSpecialValue
        end

        def self.getTotalCultistPlayers
            @@totalCultistPlayers
        end

        def computeGoldCoinsValue(treasure)
            value = 0
            treasure.each {|t| value += 2*t.getGoldCoins}
            value/1000
        end

        def shouldConvert
            false
        end

        def to_s
            super + " [Sectario] "
        end
    end

end
