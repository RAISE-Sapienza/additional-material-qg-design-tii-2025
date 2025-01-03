within SMC_02;

package models4nomad

/*

Variabili di decisione in ingresso reali
  SP temperatura mandata "giorno"  [90°C,120°C] quantizzazione 2°C
  SP temperatura mandata "notte"   [60°C,80°C]  quantizzazione 2°C
  ora transizione "notte->giorno"  [6,8]        quantizzazione 10'  dato in ore con decimali
  ora transizione "giorno->notte"  [17,20]      quantizzazione 10'  dato in ore con decimali

Variabili in uscita reali
  energia totale consumata                                 (f. obiettivo 1)
  integrale violazione vincolo Tmandata>soglia_attenzione  (f. obiettivo 2)
  integrale violazione vincolo Tritorno<soglia_attenzione  (f. obiettivo 3)
  
Variabili in uscita booleane
  vincolo Tmandata>soglia_allarme violato
  vincolo Tritorno<soglia_allarme violato
  
*/

Plants.HN001_two_loads_v2 HN;

algorithm
  when terminal() then
    Modelica.Utilities.Streams.print("total_energy_consumption=" + String(HS.Etotal));
  end when;
  
end models4nomad;