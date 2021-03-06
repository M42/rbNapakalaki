#!/usr/bin/env ruby
#encoding: utf-8
require_relative 'treasureKind.rb'
require_relative 'treasure.rb'

module Game

    # Perjuicio al producirse la derrota.
    class BadConsequence
        
        # Inicializador
        def initialize (text, levels, nVisible, nHidden, visible, hidden, death)
            @text = text
            @levels = levels
            @nVisibleTreasures = nVisible
            @nHiddenTreasures = nHidden
            @specificVisibleTreasures = visible
            @specificHiddenTreasures = hidden
            @death = death
        end



        # Constructores
        def self.new_det_tr(text, levels, visible, hidden)
            newObj=allocate
            newObj.send(:initialize, text, levels, visible.size, hidden.size, visible, hidden, false)
            newObj
        end

        def self.new_indet_tr(text, levels, nVisible, nHidden)
            newObj=allocate
            newObj.send(:initialize, text, levels, nVisible, nHidden, [], [], false)
            newObj
        end

        def self.new_death(text)
            newObj=allocate
            newObj.send(:initialize, text, 0, 0, 0, [], [], true)
            newObj
        end



        # Métodos públicos        
        def isEmpty
            @death == false && @levels == 0 && @nVisibleTreasures == 0 && @nHiddenTreasures == 0
        end 

        def kills
            @death
        end

        def getText
            @text
        end

        def getLevels
            @levels
        end

        def getNVisibleTreasures
            @nVisibleTreasures
        end

        def getNHiddenTreasures
            @nHiddenTreasures
        end

        def getSpecificVisibleTreasures
            @specificVisibleTreasures
        end

        def getSpecificHiddenTreasures
            @specificHiddenTreasures
        end

	# En los siguientes dos métodos, hay que usar que hay dos posibles BadConsequence que trabajan con tesoros:
    # los que conocen los objetos que quitan y los que sólo conocen la cantidad.
    # Para saber si un tesoro está contenido, tenemos que ver si está en la lista de tesoros (conoce los tesoros) 
    # o está vacía pero la cantidad de tesoros que quita no es nula(no conoce los tesoros)

        def substractVisibleTreasure(treasure)
            if(@specificVisibleTreasures.include?(treasure.getType)) 
                @specificVisibleTreasures = @specificVisibleTreasures - [treasure.getType]
                @nVisibleTreasures = @nVisibleTreasures - 1
            elsif(@specificVisibleTreasures.empty? and @nVisibleTreasures > 0)
                @nVisibleTreasures = @nVisibleTreasures - 1
            end 
        end

        def substractHiddenTreasure(treasure)
            if(@specificHiddenTreasures.include?(treasure.getType))
                @specificHiddenTreasures = @specificHiddenTreasures - [treasure.getType]
                @nHiddenTreasures = @nHiddenTreasures - 1 
            elsif(@specificHiddenTreasures.empty? and @nHiddenTreasures > 0)
                @nHiddenTreasures = @nHiddenTreasures - 1 
            end
        end

        # En este método, se usan los dos BadConsequence posibles, teniendo en cuenta que ya se han restado los niveles.
        def adjustToFitTreasureLists(visible, hidden)  

            # Si no conoce los tesoros específicos, trabaja con las cantidades (no se pueden quitar más tesoros de los que se tiene)
            if (@specificVisibleTreasures.empty? and @specificHiddenTreasures.empty?)
                nVTreasures = [visible.size, @nVisibleTreasures].min
                nHTreasures = [hidden.size, @nHiddenTreasures].min

                return BadConsequence.new_indet_tr(@text, 0, nVTreasures, nHTreasures)

            # Si conoce los tesoros, trabaja con los TreasureKind (no se pueden quitar los tipos de tesoros que no tiene)
            else
                # Tomamos los tipos de tesoros (treasureKind)
                visibleKind = visible.collect{|t| t.getType}
                hiddenKind = hidden.collect{|t| t.getType}

                listVisibleTreasureKind = []
                listHiddenTreasureKind = []

                # Iteramos para cada treasureKind: buscamos el mínimo entre los que tiene el mal rollo y los que tiene el jugador, 
                # y añadimos dicho número de treasureKind de cada tipo a la lista de treasureKind ajustados. 
                [ONEHAND, BOTHHANDS, ARMOR, HELMET, SHOE, NECKLACE].each do |tKind|

                    listVisibleTreasureKind = listVisibleTreasureKind + 
                        [tKind]*[visibleKind.select{|t| t == tKind}.size, @specificVisibleTreasures.select{|t| t == tKind}.size].min

                    listHiddenTreasureKind = listHiddenTreasureKind + 
                        [tKind]*[hiddenKind.select{|t| t == tKind}.size, @specificHiddenTreasures.select{|t| t == tKind}.size].min
                end
                return BadConsequence.new_det_tr(@text, 0, listVisibleTreasureKind, listHiddenTreasureKind)
            end
        end 


        # Métodos auxiliares
        def to_s
            "#{@text} \n\t" # + (@death ? "DEATH." : 
            #   "#{@levels} levels, #{@nHidden} hidden treasures, #{@nVisible} visible treasures." 
            #   ) + "\n"
        end

    end


    # Deshabilitando el constructor por defecto
    BadConsequence.instance_eval { undef :new }

end
