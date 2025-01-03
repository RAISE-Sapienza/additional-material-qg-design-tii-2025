within SMC_02.Plants;

model HN001_two_loads_v2_OneTrapezoidPerDay_wrapper
  /* Variabili di decisione */
  parameter SI.Temperature spTo1 = 310;
  parameter SI.Temperature spTo2 = 350;
  parameter SI.PressureDifference spDpHC1 = 1e5;
  parameter SI.PressureDifference spDpHC2 = 2e5;
  parameter Real hod_12_start =  7; // 5-9
  parameter Real hod_12_dur   =  1; // 0.5.4
  parameter Real hod_21_start = 16; // 15-20, must be > hod_12_start+hod_21_start
  parameter Real hod_21_dur   =  1; // 0.5-4
  
  /* Variabili di decisione */
  parameter SI.Temperature THSret_min = 273.15 + 30;
  parameter Real Pload_std_multiplier = 2 "load power std multiplier";
  parameter Real wload_std_multiplier = 2 "load flowrate std multiplier";
  Real E_cons_kWh, Tout_load1, Tout_load2, THSout, THSret, wHSout;
  Boolean monitor_THSret_min_violated(start = false);
  Real area_THSret_min_violated(start=0,fixed=true);
  
  
  /* Altri parametri*/
  
  parameter SI.CoefficientOfHeatTransfer gammaloss = 100 "heating tubes loss ccht, [5,100], nominal 10";
    
  HN001_two_loads_v2_OneTrapezoidPerDay HN(
    hod_12_start = hod_12_start,
    hod_12_end = hod_12_start+hod_12_dur,
    hod_21_start = hod_21_start,
    hod_21_end = hod_21_start+hod_21_dur,
    spDpHC1 = spDpHC1,
    spDpHC2 = spDpHC2,
    spTo1 = spTo1,
    spTo2 = spTo2,
    Pload_std_multiplier = Pload_std_multiplier,
    wload_std_multiplier = wload_std_multiplier,
    gammaloss = gammaloss) annotation(
    Placement(visible = true, transformation(origin = {-44, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    
  /* New KPIs */
  Real PCurr_t, avg_PCurr_t;
  Real THSret_min_violation(start=0), avg_THSret_min_violation(start=0);
  Real THSret_min_absolute_violation(start=0), avg_THSret_min_absolute_violation(start=0); 
  
  
equation
/* aggingere vincoli (bound come parametri) e relativi monitor booleani di violazione */
  E_cons_kWh = HN.HS.Etotal/3600000 "total energy consumption, kWh";
  Tout_load1 = HN.load1.tube_load.fluidStream.T[HN.load1.tube_load.n] "primary outlet T at load 1, K";
  Tout_load2 = HN.load2.tube_load.fluidStream.T[HN.load2.tube_load.n] "primary outlet T at load 2, K";
  THSout = HN.HS.sTo.oT "heating station outlet T, K";
  THSret = HN.HS.sTr.oT "heating station return T, K";
  wHSout = HN.HS.sw.ow "heating station outlet flowrate, kg/s";
  
  if noEvent(THSret < THSret_min) then
     der(area_THSret_min_violated) = (THSret_min - THSret)/THSret_min;
  else
     der(area_THSret_min_violated) = 0;
  end if;
  
  
  /* Equations for new KPIs */
  PCurr_t = HN.HS.Pheater + HN.HS.Ppump "Power at time t";
  der(avg_PCurr_t) = (PCurr_t - avg_PCurr_t) / (time + 1e-10) "Average power over time"; 
  
  if noEvent(THSret < THSret_min) then
     THSret_min_violation = (THSret_min - THSret)/THSret_min;
  else
     THSret_min_violation = 0;
  end if;
    
  der(avg_THSret_min_violation) = (THSret_min_violation - avg_THSret_min_violation) / (time + 1e-10) "Average THSret violation area over time";
  
  // New KPI with temperature absolute difference
  if noEvent(THSret < THSret_min) then
     THSret_min_absolute_violation = THSret_min - THSret;
  else
     THSret_min_absolute_violation = 0;
  end if;
  
  der(avg_THSret_min_absolute_violation) = (THSret_min_absolute_violation - avg_THSret_min_absolute_violation) / (time + 1e-10) "Average THSret temperature over time";
  
  
algorithm
  when THSret < THSret_min then
    monitor_THSret_min_violated := true;
  end when;
  annotation(
    experiment(StartTime = 0, StopTime = 259200, Tolerance = 1e-05, Interval = 3600),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian -d=stateselection",
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "dassl", variableFilter = ".*", noEquidistantTimeGrid = "()", noRestart = "()"));
end HN001_two_loads_v2_OneTrapezoidPerDay_wrapper;