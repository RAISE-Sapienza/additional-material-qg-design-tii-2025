within SMC_02.Plants;

model HN001_two_loads_v2_wrapper
  parameter SI.Temperature spTho_hourly_values[24] = {310, 300, 300, 300, 300, 300,
                                                      300, 300, 350, 350, 350, 350,
                                                      350, 350, 320, 320, 320, 320,
                                                      320, 300, 300, 300, 300, 300} "K";
                                                      
  parameter SI.PressureDifference spDPHC_hourly_values[24] = 1e5*{1, 1, 1, 1, 1, 1,
                                                                  1, 1, 2, 2, 2, 2,
                                                                  2, 2, 2, 2, 2, 2,
                                                                  2, 1, 1, 1, 1, 1}*0.5 "Pa";


  parameter SI.Temperature TSHret_min = 273.15+30;

  parameter Real Pload_std_multiplier=1 "load power std multiplier";
  parameter Real wload_std_multiplier=1 "load flowrate std multiplier"; 
  
  HN001_two_loads_v2 HN(spTho_hourly_values = spTho_hourly_values,
                        spDPHC_hourly_values = spDPHC_hourly_values,
                        Pload_std_multiplier = Pload_std_multiplier,
                        wload_std_multiplier = wload_std_multiplier);

  Real E_cons_kWh, Tout_load1, Tout_load2, THSout, THSret, wHSout;
  Boolean monitor_TSHret_min_violated(start=false);

equation


  /* aggingere vincoli (bound come parametri) e relativi monitor booleani di violazione */

  E_cons_kWh = HN.HS.Etotal/3600000 "total energy consumption, kWh";
  Tout_load1 = HN.load1.tube_load.fluidStream.T[HN.load1.tube_load.n] "primary outlet T at load 1, K";
  Tout_load2 = HN.load2.tube_load.fluidStream.T[HN.load2.tube_load.n] "primary outlet T at load 2, K";
  THSout     = HN.HS.sTo.oT "heating station outlet T, K";
  THSret     = HN.HS.sTr.oT "heating station return T, K";
  wHSout     = HN.HS.sw.ow "heating station outlet flowrate, kg/s";
  
algorithm
  when THSret<TSHret_min then
    monitor_TSHret_min_violated := true;
  end when;
  
  annotation(
    experiment(StartTime = 0, StopTime = 172800, Tolerance = 1e-6, Interval = 60),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian -d=stateselection",
    __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl", variableFilter = ".*", noEquidistantTimeGrid = "()"));
end HN001_two_loads_v2_wrapper;