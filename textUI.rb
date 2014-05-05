#!/usr/bin/env ruby
#encoding: utf-8
require 'curses'
require_relative 'napakalaki.rb'


module UserInterface

    class TextUI
        include Singleton
        NP = Game::Napakalaki.instance

        def initialize
            @turn = 0
        end

        def clearScreen
            system "clear"
            printHeader
            puts "Turno: #{@turn}\n"
            printCurrentPlayerStatus
            printCurrentMonsterStatus
        end

        def printHeader
            puts "-"*30
            puts "\tNapakalaki"
            puts "-"*30
        end

        def readPlayers
            puts "Introduzca el nombre de los jugadores:"
            line = gets.chomp
            players = line.split
            return players
        end

        def printCurrentPlayerStatus
            puts "\nJugador actual: #{NP.getCurrentPlayer}\n"
            printCurrentPlayerCombatStatus
        end

        def printCurrentPlayerCombatStatus
            puts "Nivel de combate: #{NP.getCurrentPlayer.getCombatLevel}\n"
        end

        def printCurrentMonsterStatus
            puts "\nMonstruo actual: #{NP.getCurrentMonster}\n"
        end

        def printCombatResult(result)
            puts "Combate contra #{NP.getCurrentMonster.getName}:"
            
            # Faltan otros casos del combate
            case result
            when WIN
                puts "Victoria"
            when LOSE
                puts "Derrota"
            else
                puts "No sabemos qué ha pasado"
            end
        end

        def menu(msg, *options)
            puts msg
            
            index = 1
            for o in options
                puts "[#{index}]: #{o}"
                index = index + 1
            end
        end

        def selectionMenu
            menu("Elegir acción:\n",
                 "Comprar niveles",
                 "Equipar",
                 "Combatir",
                 )
            
            respuesta = "0"

            # Controla opciones del menú
            case respuesta = gets.strip
            when "1"
                clearScreen
                buyLevels
            when "2"
                clearScreen
                equip
            when "3"
                clearScreen
            else
                clearScreen
                selectionMenu
            end
        end

        def yesNoQuestion(message)
            puts "#{message} (y/n)"
            c = gets.chomp

            while c != 'y' and c != 'n'
                c = gets.chomp
            end

            return c == 'y'
        end

        def buyLevels
            # Imprime información relevante a la compra de niveles
            menu("Elegir acción:\n",
                 "Ver tesoros visibles",
                 "Ver tesoros invisibles",
                 "Vender tesoros")
            
            case gets.strip
            when "1"
                printVisibleTreasures
            when "2"
                printHiddenTreasures
            when "3"
                # La idea que he tenido es: que te digan una serie de número de 0 a 9, de 0 a 5 serían los visibles (nil's incluidos) y el resto ocultos
                # He copiado esto de arriba.
                line = gets.chomp 
                respuesta = line.split
                visibles, ocultos = respuesta.select{|item| item < 6}, respuesta.select{|item| item >= 6}.collect{|item| item % 6}

                if(!NP.buyLevels(visibles, ocultos))
                    if (yesNoQuestion("No puedes venderlos, ¿quieres tiralos?")) # Es realmente necesario?
                        NP.discardVisibleTreasures(visibles)
                        NP.discardVisibleTreasures(ocultos)
                    end
                else 
                    puts "Compra realizada. Ahora tu nivel de combate es #{NP.getCurrentPlayer.getCombatLevel}\n"
                end 
            else
                clearScreen
                selectionMenu
            end
        end
        
        def printVisibleTreasures
            puts "Tesoros visibles:\n" #{NP.getCurrentPlayer.getVisibleTreasures.resize(6)}\n"
            
            index = 0
            for treasure in NP.getVisibleTreasures do
                puts "(#{index}): #{printTreasure}"
            end
        end

        def printHiddenTreasures
            puts "\nTesoros ocultos:\n#{NP.getCurrentPlayer.getHiddenTreasures.resize(4)}\n"
        end

        def printTreasure(treasure)
            puts "#{treasure.getName}"
        end

        def equip
            # Escribe información relevante a la equipación de objetos
            puts "Equipación de objetos."
            printVisibleTreasures
            
            # La idea que he tenido es: que te digan una serie de número de 0 a 3 que serían los ocultos (nil's incluidos)
            line = gets.chomp
            ocultos = line.split
            ocultos.each do |treasure|
                if(!NP.canMakeTreasureVisible(treasure))
                    if (yesNoQuestion("No puedes equiparte #{treasure} ¿quieres vender algunos objetos?")) # Nuevamente: Es necesario? 
                        buyLevels
                    end
                else
                    NP.makeTreasureVisible(treasure)
                end
            end
        end

        def main
            # Presentación del juego
            system "clear"
            printHeader

            # Lee los jugadores
            players = readPlayers
            NP.initGame players

            # Bucle principal del juego
            begin
                # Anuncia el nuevo turno
                clearScreen
                
                # El jugador elige acción
                selectionMenu

                # Combate
                result = NP.combat
                
                # Pasa al siguiente turno
                NP.nextTurn
                @turn = @turn+1
            end while not NP.endOfGame(result)
        end
    end

    if __FILE__ == $0
        TextUI.instance.main
    end

end


