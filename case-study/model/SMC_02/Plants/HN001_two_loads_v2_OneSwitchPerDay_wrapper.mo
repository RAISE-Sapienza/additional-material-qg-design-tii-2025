within SMC_02.Plants;

model HN001_two_loads_v2_OneSwitchPerDay_wrapper
  /* Variabili di decisione */
  parameter SI.Temperature spTo1 = 320; // 310
  parameter SI.Temperature spTo2 = 350;
  parameter SI.PressureDifference spDpHC1 = 1.5e5; // 1e5
  parameter SI.PressureDifference spDpHC2 = 2e5;
  parameter Real hod_12 = 6; // 8
  // 6-9
  parameter Real hod_21 = 19; // 18
  // 16-20
  /* /Variabili di decisione */
  parameter SI.Temperature TSHret_min = 273.15 + 30;
  parameter Real Pload_std_multiplier = 1 "load power std multiplier";
  parameter Real wload_std_multiplier = 1 "load flowrate std multiplier";
  Real E_cons_kWh, Tout_load1, Tout_load2, THSout, THSret, wHSout;
  Boolean monitor_TSHret_min_violated(start = false);
  HN001_two_loads_v2_OneSwitchPerDay HN(hod_12 = hod_12, hod_21 = hod_21, spDpHC1 = spDpHC1, spDpHC2 = spDpHC2, spTo1 = spTo1, spTo2 = spTo2) annotation(
    Placement(visible = true, transformation(origin = {-44, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
/* aggingere vincoli (bound come parametri) e relativi monitor booleani di violazione */
  E_cons_kWh = HN.HS.Etotal/3600000 "total energy consumption, kWh";
  Tout_load1 = HN.load1.tube_load.fluidStream.T[HN.load1.tube_load.n] "primary outlet T at load 1, K";
  Tout_load2 = HN.load2.tube_load.fluidStream.T[HN.load2.tube_load.n] "primary outlet T at load 2, K";
  THSout = HN.HS.sTo.oT "heating station outlet T, K";
  THSret = HN.HS.sTr.oT "heating station return T, K";
  wHSout = HN.HS.sw.ow "heating station outlet flowrate, kg/s";
algorithm
  when THSret < TSHret_min then
    monitor_TSHret_min_violated := true;
  end when;
  annotation(
    experiment(StartTime = 0, StopTime = 172800, Tolerance = 1e-06, Interval = 3600),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian -d=stateselection",
    __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl", variableFilter = ".*", noEquidistantTimeGrid = "()"));
end HN001_two_loads_v2_OneSwitchPerDay_wrapper;