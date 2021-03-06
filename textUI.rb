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

        # Hace una pregunta de sí/no y devuelve la respuesta en un valor booleano. 
        def yesNoQuestion(message)
            puts "#{message} (y/n)"

            begin 
                c = STDIN.getch
            end while c != 'y' and c != 'n'

            return c == 'y'
        end

        # Refresca la pantalla. 
        def clearScreen
            system "clear"
            printHeader
            puts "Turno: #{@turn}\n"
            puts Game::CardDealer.instance
            puts "Sectarios en juego: #{Game::CultistPlayer.getTotalCultistPlayers}\n"
            printCurrentPlayerStatus
            printCurrentMonsterStatus
        end

# SECCIÓN PRINT'S:

        # Imprime la cabecera del juego. 
        def printHeader
            puts "-"*30
            puts "\t Napakalaki"
            puts "\tVersión Ruby"
            puts "-"*30
        end

        # Imprime el estado del jugador actual.
        def printCurrentPlayerStatus
            puts "\nJugador actual: #{NP.getCurrentPlayer}\n"
            printVisibleTreasures
            printHiddenTreasures
            printCurrentPlayerCombatStatus
        end

        # Imprime el nivel de combate del jugador actual. 
        def printCurrentPlayerCombatStatus
            puts "Nivel de combate: #{NP.getCurrentPlayer.getCombatLevel}\n"
        end
        
        # Imprime los tesoros que se le pasan como parámetro. 
        def printTreasures(treasures)
            treasures.each_with_index do |treasure, index|
                puts "\t(#{index}): #{treasure}"
            end
        end

        # Imprime los tesoros visibles del jugador actual. 
        def printVisibleTreasures
            puts "Tesoros visibles:\n"
            printTreasures(NP.getVisibleTreasures)
        end

        # Imprime los tesoros ocultos del jugador actual. 
        def printHiddenTreasures
            puts "Tesoros ocultos:\n"
            printTreasures(NP.getHiddenTreasures)
        end

        # Imprime el monstruo actual
        def printCurrentMonsterStatus
            puts "\nMonstruo actual: #{NP.getCurrentMonster}\n"
        end

        # Imprime el resultado de un combate. 
        def printCombatResult(result)
            clearScreen
            puts "Combate contra #{NP.getCurrentMonster.getName}:"
            
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
            when Game::LOSEANDCONVERT
                puts "Has sido derrotado. ¡Ahora eres sectario!"
            else
                puts "Error en el combate."
            end
        end


#SECCIÓN MENÚ'S:
        # Imprime por pantalla un menu con sus opciones. 
        def menu(msg, *options)
            puts msg
            
            index = 1
            for o in options
                puts "[#{index}]: #{o}"
                index = index + 1
            end
        end

        # Menú antes de combatir. 
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

        # Menú después de combatir.
        def selectionMenu2
            menu("Elegir acción:\n", 
                 "Equipar tesoros", 
                 "Pasar de turno",
                 )

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
        
# SECCIÓN DE MANEJO DE TESOROS
        def buyLevels
            # Compra de niveles.
            # Listas de tesoros ocultos y visibles a vender.
            svisibles = []
            shidden = []
            # Listas con los índices de posibles tesoros a vender.
            index_visibles = (0..NP.getVisibleTreasures.size-1).to_a
            index_hidden = (0..NP.getHiddenTreasures.size-1).to_a
            
            # Venta de tesoros visibles
            begin
                puts "Vendiendo tesoros visibles:"
                print "Tesoros visibles que se venderán:\n"
                printTreasures(svisibles)
                printVisibleTreasures
                puts "\t(x): Salir"

                index = STDIN.getch
                if (index != 'x')
                    index = index.to_i
                    if (index_visibles.member? index)
                        svisibles.push(NP.getVisibleTreasures.at(index))
                        index_visibles.delete index
                    end
                end 

                clearScreen
            end while (index != 'x')
            
            # Venta de tesoros ocultos
            begin
                puts "Vendiendo tesoros ocultos:"
                print "Tesoros ocultos que se venderán:\n"
                printTreasures(shidden)
                printHiddenTreasures
                puts "\t(x): Salir"

                index = STDIN.getch
                if (index != 'x')
                    index = index.to_i
                    if (index_hidden.member? index)
                        shidden.push(NP.getHiddenTreasures.at(index))
                        index_hidden.delete index
                    end
                end
                
                clearScreen
            end while (index != 'x')


            # Comprobante de venta
            puts "Se venderán los siguientes tesoros:"
            puts "Tesoros visibles:"
            printTreasures svisibles
            sumavisibles = 0
            svisibles.each {|t| sumavisibles += t.getGoldCoins}
            puts "\tSuma total: #{sumavisibles}"
            puts "Tesoros ocultos:"
            printTreasures shidden
            sumahidden = 0
            shidden.each {|t| sumahidden += t.getGoldCoins}
            puts "\tSuma total: #{sumahidden}"
            # Distinguimos si el jugador es sectario o no. 
            if (NP.getCurrentPlayer.instance_of?(Game::Player))
                puts "Aumentarías #{sumavisibles/1000 + sumahidden/1000} niveles"
            else 
                puts "Aumentarías #{ 2*sumavisibles/1000 + 2*sumahidden/1000} niveles"
            end

            if (yesNoQuestion "¿Realizar la compra?")
                # Tras realizar la compra, limpia la pantalla y muestra el resultado.
                if(!NP.buyLevels(svisibles, shidden))
                    clearScreen
                    puts "No puedes vender los tesoros.\n"
                else
                    clearScreen
                    puts "Compra realizada.\n"
                end 
            else
                clearScreen
                puts "Compra anulada.\n"
            end
            
        end

        # Método para equipar tesoros. 
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

        # Método para eliminar tesoros visibles. 
        def discardVisibleTreasures
            begin
                puts "Descarta tesoros visibles:\n"
                printVisibleTreasures
                puts "Dime el índice del tesoro visible a descartar (x para terminar): "
                index = STDIN.getch
                if (index != 'x') 
                    index = index.to_i
                    if (index >= 0 and index < NP.getVisibleTreasures.size)
                        NP.discardVisibleTreasure(NP.getVisibleTreasures.at(index))
                        clearScreen 
                        puts "Tesoro eliminado.\n"
                    else
                        clearScreen
                    end
                else
                    clearScreen
                end
            end while (index != 'x')
        end 

        # Método para eliminar tesoros ocultos.
        def discardHiddenTreasures
            begin
                puts "Descarta tesoros ocultos:\n"
                printHiddenTreasures
                puts "Dime el índice del tesoro oculto a descartar (x para terminar): "
                index = STDIN.getch
                if (index != 'x') 
                    index = index.to_i
                    if (index >= 0 and index < NP.getHiddenTreasures.size)
                        NP.discardHiddenTreasure(NP.getHiddenTreasures.at(index))
                        clearScreen 
                        puts "Tesoro eliminado.\n"
                    else
                        clearScreen
                    end
                else
                    clearScreen
                end
            end while (index != 'x')
        end

        # Método para ajustar el mal rollo. 
        def adjust
            begin 
                discardVisibleTreasures
                discardHiddenTreasures
            end while !NP.nextTurnAllowed
        end

        def readPlayers
            puts "Introduzca el nombre de los jugadores:"
            line = gets.chomp
            players = line.split
            return players
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

                if result != Game::WINANDWINGAME
                    # Aplica mal rollo si pierde, o bien ofrece la posibilidad de eliminar tesoros.    
                    adjust 
                    begin
                        selectionMenu2
                        # Pasa al siguiente turno
                    end while not yesNoQuestion("¿Pasar al siguiente turno?")
                    NP.nextTurn
                    @turn = @turn+1
                else
                    # Fin del juego.
                    puts "¡El juego ha terminado! Ganador: #{NP.getCurrentPlayer}"
                end
            end while not NP.endOfGame(result)
        end
    end

    if __FILE__ == $0
        TextUI.instance.main
    end

end


