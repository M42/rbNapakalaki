#!/usr/bin/env ruby
#encoding: utf-8
require_relative 'monster.rb'
require_relative 'player.rb'
require_relative 'combatResult.rb'
require_relative 'cardDealer.rb'
require 'singleton'

module Game

    class Napakalaki
        include Singleton

        # Inicializador
        def initialize
            @players = []
            @currentPlayer = nil
            @currentPlayerIndex = nil
            @currentMonster = nil
        end


        # Métodos privados
        private

        def initPlayers(names)
            @players = names.collect{|name| Player.new(name)}
            
            # Toma el índice del primer jugador como -1. El nextTurn en initGames hará que el primer jugador sea el correto. 
            @currentPlayerIndex = -1
            @currentPlayer = @players[0]
        end

        def nextPlayer
            # Toma el siguiente jugador, calculando previamente su índice. 
            @currentPlayerIndex = (@currentPlayerIndex+1) % @players.size
            @currentPlayer = @players[@currentPlayerIndex]
        end


        # Métodos públicos
        public

        # Llama al método combat del jugador actual. Pasa como parámetro el monstruo al que combatir. 
        def combat
            result = @currentPlayer.combat(@currentMonster)
            CardDealer.instance.giveMonsterBack(@currentMonster)
            result
        end

        def discardVisibleTreasure(treasure)
            @currentPlayer.discardVisibleTreasure(treasure)
        end

        def discardHiddenTreasure(treasure)
            @currentPlayer.discardHiddenTreasure(treasure)
        end
        
        def makeTreasureVisible(treasure) 
            @currentPlayer.makeTreasureVisible(treasure)
        end

        def buyLevels(visible, hidden)
            @currentPlayer.buyLevels(visible, hidden)
        end

        # Revisar. El nextTurn al final puede hacer que el primer jugador no sea el primero, pues ya se inicia en initPlayers
        # Puede no, hace. Avisar al profesor. --Óscar
        def initGame(names)
            CardDealer.instance.initCards
            initPlayers(names)
            nextTurn
        end

        def getCurrentPlayer
            @currentPlayer
        end

        def getCurrentMonster
            @currentMonster
        end
        
        def canMakeTreasureVisible(treasure)
            @currentPlayer.canMakeTreasureVisible(treasure)
        end

        def getVisibleTreasures
            @currentPlayer.getVisibleTreasures
        end

        def getHiddenTreasures
            @currentPlayer.getHiddenTreasures
        end

        # Pasa de turno si se puede. 
        def nextTurn
            stateOK = nextTurnAllowed
            if stateOK
                @currentMonster = CardDealer.instance.nextMonster
                @currentPlayer = nextPlayer
                if (@currentPlayer.isDead)
                    @currentPlayer.initTreasures
                end
            end
            stateOK
        end

        # Comprueba si estamos listos para pasar de turno. 
        def nextTurnAllowed
            @currentPlayer.validState
        end

        def endOfGame(result)
            result == WINANDWINGAME
        end

    end

end
