#!/usr/bin/env ruby
#encoding: utf-8
require 'io/console'
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
            printVisibleTreasures
            printHiddenTreasures
            printCurrentPlayerCombatStatus
        end

        def printCurrentPlayerCombatStatus
            puts "Nivel de combate: #{NP.getCurrentPlayer.getCombatLevel}\n"
        end

        def printCurrentMonsterStatus
            puts "\nMonstruo actual: #{NP.getCurrentMonster}\n"
        end

        def printCombatResult(result)
            clearScreen
            puts "Combate contra #{NP.getCurrentMonster.getName}:"
            
            # Faltan otros casos del combate
            case result
            when Game::WIN
                puts "Has derrotado al monstruo."
            when Game::WINANDWINGAME
                puts "Has ganado el combate y el juego. ¡Enhorabuena!"
            when Game::LOSEANDESCAPE
                puts "Has logrado escapar del combate a salvo."
            when Game::LOSE
                puts "Has sido derrotado. Ahora se te aplicará el mal rollo del monstruo."
            when Game::LOSEANDDIE
                puts "Has sido derrotado y has muerto."
            else
                puts "Error en el combate."
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
                 "Combatir",
                 "Cerrar juego"
                 )

            # Controla opciones del menú
            case respuesta = STDIN.getch
            when "1"
                clearScreen
                buyLevels
                selectionMenu
            when "2"
                clearScreen
            when "3"
                exit
            else
                clearScreen
                selectionMenu
            end
        end

        def selectionMenu2
            menu("Elegir acción:\n", 
                 "Equipar tesoros", 
                 "Pasar de turno",
                 )
            respuesta = 0

            # Controla opciones
            case respuesta = STDIN.getch
            when "1"
                clearScreen 
                equip
                selectionMenu2
            when "2"
                clearScreen
            else 
                clearScreen
                selectionMenu2
            end
        end
        
        def yesNoQuestion(message)
            puts "#{message} (y/n)"

            begin 
                c = STDIN.getch
            end while c != 'y' and c != 'n'

            return c == 'y'
        end

        def buyLevels
            # Compra de niveles. 
            visibles = []
            ocultos = []
            puts "Dime los índices de los tesoros visibles que quieres vender (x para terminar):"
            begin
                index = STDIN.getch
                if (index != 'x')
                    index = index.to_i
                    visibles.push(NP.getVisibleTreasures.at(index))
                end 
            end while (index != 'x')
            puts "Dime los índices de los tesoros ocultos que quieres vender (x para terminar):"
            begin
                index = STDIN.getch
                if (index != 'x')
                    index = index.to_i
                    ocultos.push(NP.getHiddenTreasures.at(index))
                end 
            end while (index != 'x')
            
            if(!NP.buyLevels(visibles, ocultos))
                puts "No puedes vender los tesoros"
            else 
                clearScreen
                puts "Compra realizada.\n"
            end 
        end
        
        def printTreasures(treasures)
            treasures.each_with_index do |treasure, index|
                puts "\t(#{index}): #{treasure}"
            end
        end

        def printVisibleTreasures
            puts "Tesoros visibles:\n"
            printTreasures(NP.getVisibleTreasures)
        end

        def printHiddenTreasures
            puts "Tesoros ocultos:\n"
            printTreasures(NP.getHiddenTreasures)
        end

        def equip
            begin
                # Escribe información relevante a la equipación de objetos
                puts "Equipación de objetos.\n"
                printVisibleTreasures
                printHiddenTreasures
                puts "\t(x): Salir"
                puts "Dime que tesoro oculto te quieres equipar:"
                
                # Pasamos el índice del tesoro que queremos equipar. 
                index = STDIN.getch
                if (index != 'x')
                    index = index.to_i
                    clearScreen

                    # Comprueba que el índice sea válido.
                    puts "#{NP.getVisibleTreasures.size}"
                    if (index < NP.getHiddenTreasures.size and index >= 0)
                        if(NP.canMakeTreasureVisible(NP.getHiddenTreasures.at(index)))
                            puts "Tesoro #{NP.getHiddenTreasures.at(index).getName} equipado\n"
                            NP.makeTreasureVisible(NP.getHiddenTreasures.at(index))
                        else
                            puts "No puedes equiparte #{NP.getHiddenTreasures.at(index)}\n"
                        end
                    else
                        puts "Índice inválido.\n"
                    end
                end 
            end while (index != 'x')
            clearScreen
        end

        # Método para ajustar el mal rollo. 
        def adjust
            begin 
                discardVisibleTreasures
                discardHiddenTreasures
            end while !NP.nextTurnAllowed
        end

        def discardVisibleTreasures
            puts "Descarta tesoros visibles:\n"
            printVisibleTreasures
            puts "Dime el índice del tesoro visible a descartar (x para terminar): "
            begin
                index = STDIN.getch
                if (index != 'x') 
                    index = index.to_i
                    NP.discardVisibleTreasure(NP.getVisibleTreasures.at(index))
                    clearScreen 
                    puts "Tesoro eliminado.\n"
                else
                    clearScreen
                end
            end while (index != 'x')
        end 

        def discardHiddenTreasures
            puts "Descarta tesoros ocultos:\n"
            printHiddenTreasures
            puts "Dime el índice del tesoro oculto a descartar (x para terminar): "
            begin
                index = STDIN.getch
                if (index != 'x') 
                    index = index.to_i
                    NP.discardHiddenTreasure(NP.getHiddenTreasures.at(index))
                    clearScreen 
                    puts "Tesoro eliminado.\n"
                else
                    clearScreen
                end
            end while (index != 'x')
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
                printCombatResult result

                # Aplica mal rollo si pierde, o bien ofrece la posibilidad de eliminar tesoros.    
                adjust 
                selectionMenu2                

                # Pasa al siguiente turno
                while not yesNoQuestion("¿Pasar al siguiente turno?")
                end
                NP.nextTurn
                @turn = @turn+1
            end while not NP.endOfGame(result)
        end
    end

    if __FILE__ == $0
        TextUI.instance.main
    end

end


