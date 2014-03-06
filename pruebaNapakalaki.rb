#!/usr/bin/env ruby
#encoding: utf-8
require_relative 'Monster.rb'
module Napakalaki
  class PruebaNapakalaki
    if __FILE__ == $0
      #Declaración de los monstruos. 
      #Declaración de los monstruos. 
      @monsters = Array.new()

      #Monstruos añadidos por orden de aparición en el guión. 

      #3 Byakhees de bonanza.
      bad = BadConsequence.new_det_tr("Pierdes tu armadura visible y otra oculta.", 0, [ARMOR], [ARMOR])
      monsters.add(Monster.new("2 Byakhees de bonanza", 8, bad, Prize.new(2,1)))

      #Chibithulhu
      bad = BadConsequence.new_det_tr("Embobados con el lindo primigenio te descartas de tu casco visible.", 0, [HELMET], [])
      monsters.add(Monster.new("Chibithulhu", 2, bad4, Prize.new(1,1))) 

      #El sopor de Dunwich
      bad = BadConsequence.new_det_tr("El primordial bostezo contagioso. Pierdes el calzado visible.", 0, [SHOE], [])
      monsters.add(Monster.new("El sopor de Dunwich", 2, bad, Prize.new(1,1)))

      #Ángeles de la noche ibicenca
      bad = BadConsequence.new_det_tr("Te atrapan para llevarte de fiesta y te dejan caer en mitad del vuelo. Descarta 1 mano visible y 1 mano oculta.", 0, [ONEHAND], [ONEHAND])
      monsters.add(Monster.new("Ángeles de la noche ibicenca", 14, bad, Prize.new(4,1)))

      #El gorrón en el umbral???
      bad = BadConsequence.new_det_tr("Pierdes todos tus tesoros visibles.", 0, [ARMOR, BOTHHANDs, ONEHAND, ONEHAND, SHOE, SHOE, HELMET, NECKLACE], [])
      monsters.add(Monster.new("El gorrón en el umbral", 10, bad, Prize.new(3,1))) 

      #H.P. Munchcraft
      bad = BadConsequence.new_det_tr("Pierdes la armadura visible.", 0, [ARMOR], [])
      monsters.add(Monster.new("H.P. Munchcraft", 6, bad, Prize.new(2,1)))

      #Bichgooth
      bad = BadConsequence.new_det_tr("Sientes bichos bajo la ropa. Descarta la armadura visible.", 0, [ARMOR], []) 
      monsters.add(Monster.new("Bichgooth", 2, bad, Prize.new(1,1)))

      #El rey de rosa
      @bad = BadConsequence.new_indet_tr("Pierdes 5 niveles y 3 tesoros visibles.", 5, 3, 0)
      monsters.add(Monster.new("El rey de rosa", 13, bad, Price.new(4,2)))

      #La que redacta en las sombras. 
      bad = BadConsequence.new_indet_tr("Toses los pulmones y pierdes 2 niveles.", 2, 0, 0)
      monsters.add(Monster.new("La que redacta en las sombras", 3, bad, Price.new(1,1)))

      # Los hondos verdes
      bad = BadConsequence.new_death("Estos monstruos resultan bastante superficiales y te aburren mortalmente. Estás muerto.")
      monsters.add(Monster.new("Los hondos verdes", 7, bad, Prize.new(2,1)))

      # Semillas Cthulhu
      bad = BadConsequence.new_indet_tr("Pierdes 2 niveles y 2 tesoros ocultos.", 2, 0, 2)
      monsters.add(Monster.new("Semillas Cthulhu", 4, bad, Prize.new(2,1)))

      # Dameargo
      bad = BadConsequence.new_det_tr("Te intentas escapar. Pierdes una mano visible.", 0, [ONEHAND], [])
      monsters.add(Monster.new("Dameargo", 1, bad, Prize.new(2,1))) 

      # Pollipólipo volante
      bad = BadConsequence.new_indet_tr("Da mucho asquito. Pierdes 3 niveles.", 3, 0, 0)
      monsters.add(Monster.new("Pollipólipo volante", 3, bad, Prize.new(1,1))) 

      # Yskhtihyssg-Goth
      bad = BadConsequence.new_death("No le hace gracia que pronuncien mal su nombre. Estás muerto.")
      monsters.add(Monster.new("Yskhtihyssg-Goth", 12, bad, Prize.new(3,1))) 

      # Familia feliz.
      bad = BadConsequence.new_death("La familia te atrapa. Estás muerto.")
      monsters.add(Monster.new("Familia feliz", 1, bad, Prize.new(4,1))) 

      # Roboggoth
      bad = BadConsequence.new_det_tr("La quinta directiva primaria te obliga a perder 2 niveles y un tesoro 2 manos visible.", 2, [BOTHHANDS], [])
      monsters.add(Monster.new("Roboggoth", 8, bad, Prize.new(2,1))) 

      # El espía ciego. 

      tvp.clear() 
      tvp.add(TreasureKind.HELMET) 
      BadConsequence bad17 = BadConsequence.new_de("Te asusta en la noche. "
      + "Pierdes un casco visible.", 0, tvp, thp) 
      Prize price17 = new Prize(1,1) 
      monsters.add(Monster.new("El espía ciego", 4, bad17, price17)) 

      # El Lenguas

      BadConsequence bad18 = BadConsequence.new_de("Menudo susto te llevas. Pierdes "
      + "2 niveles y 5 tesoros visibles.", 2, 5, 0) 
      Prize price18 = new Prize(1,1) 
      monsters.add(Monster.new("El Lenguas", 20, bad18, price18)) 

      # Bicéfalo

      tvp.clear() 
      tvp.add(TreasureKind.BOTHHANDS) 
      BadConsequence bad19 = BadConsequence.new_de("Te faltan manos para tanta cabeza."
      + " Pierdes 3 niveles y tus tesoros visibles de las manos.", 3, tvp, thp)
      Prize price19 = new Prize(1,1) 
      monsters.add(Monster.new("Bicéfalo", 20, bad19, price19)) 
   
    end
  end
end