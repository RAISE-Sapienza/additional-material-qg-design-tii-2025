within SMC_02.Plants;

model HN001_two_loads_v2

  parameter SI.Temperature spTho_hourly_values[24] = {300,300,300,300,300,300,
                                                      300,300,350,350,350,350,
                                                      350,350,320,320,320,320,
                                                      320,300,300,300,300,300};
                                                      
  parameter SI.PressureDifference spDPHC_hourly_values[24] = 1e5*{1,1,1,1,1,1,
                                                                  1,1,2,2,2,2,
                                                                  2,2,2,2,2,2,
                                                                  2,1,1,1,1,1};

  parameter SI.Temperature Tstart_all = 300;
  
  parameter SI.Power HS_Pmax = 1e6;
  parameter SI.Power load1_Pmax = 5e5;
  parameter SI.MassFlowRate load1_wmax=5;
  parameter SI.Power load2_Pmax = 3e5;
  parameter SI.MassFlowRate load2_wmax=5;
  
  parameter Real Pload_std_multiplier=1 "load power std multiplier";
  parameter Real wload_std_multiplier=1 "load flowrate std multiplier";  

  inner AES.ProcessComponents.Thermal.System_settings.System_liquid system annotation(
    Placement(visible = true, transformation(origin = {-100, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanExpression hON(y = true) annotation(
    Placement(visible = true, transformation(origin = {-100, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanExpression pON(y = true) annotation(
    Placement(visible = true, transformation(origin = {-100, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  inner AES.ProcessComponents.Thermal.System_settings.System_terrain terrain annotation(
    Placement(visible = true, transformation(origin = {-70, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  AES.ProcessComponents.Thermal.DistrictHeating.TwinPipe line_1(Di = 0.05, L = 200, Tstart(displayUnit = "K") = Tstart_all, dz(displayUnit = "km"), hasInertia = false, kloss = 10, wnom = 10) annotation(
    Placement(visible = true, transformation(origin = {-8, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  AES.ProcessComponents.Thermal.DistrictHeating.TwinPipe line_2(Di = 0.05, L = 200, Tstart(displayUnit = "K") = Tstart_all, hasInertia = false, kloss = 10, wnom = 10) annotation(
    Placement(visible = true, transformation(origin = {70, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  AES.ProcessComponents.Thermal.DistrictHeating.TwinPipeClosure clo(Di = 0.05, L = 200, Tstart(displayUnit = "K") = Tstart_all, hasInertia = false, kdp = 250, kloss = 10, wnom = 10) annotation(
    Placement(visible = true, transformation(origin = {140, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SMC_02.Components.Tload_flow_power load1(Ptaken_cmd1 = load1_Pmax, Tstart(displayUnit = "K") = Tstart_all, w_cmd1 = load1_wmax)  annotation(
    Placement(visible = true, transformation(origin = {30, 24}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SMC_02.Components.Tload_flow_power load2(Ptaken_cmd1 = load2_Pmax,Tstart(displayUnit = "K") = Tstart_all, w_cmd1 = load2_wmax)  annotation(
    Placement(visible = true, transformation(origin = {110, 24}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SMC_02.Components.Hstation_with_controls HS(Phmax = HS_Pmax,Tstart(displayUnit = "K") = Tstart_all, dpP00 = 5500000, dpPn0 = 200000, noPReverse = false, wPctrlTC = 30, wPn0 = 50)  annotation(
    Placement(visible = true, transformation(origin = {-50, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SMC_02.Components.rgen rgenPload1(values_std_mult = Pload_std_multiplier)  annotation(
    Placement(visible = true, transformation(origin = {-10, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SMC_02.Components.rgen rgenPload2(values_std_mult = Pload_std_multiplier)  annotation(
    Placement(visible = true, transformation(origin = {70, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SMC_02.Components.pgen pgenTsp(TC = 60, values = spTho_hourly_values)  annotation(
    Placement(visible = true, transformation(origin = {-100, 22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SMC_02.Components.pgen pgendpsp(TC = 60, values = spDPHC_hourly_values) annotation(
    Placement(visible = true, transformation(origin = {-100, -18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SMC_02.Components.rgen rgenwload1(values_avg = {0.3, 0.4, 0.5, 0.6, 0.5, 0.4, 0.3}, values_std_mult = wload_std_multiplier)  annotation(
    Placement(visible = true, transformation(origin = {-10, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SMC_02.Components.rgen rgenwload2(values_avg = {0.3, 0.4, 0.5, 0.6, 0.5, 0.4, 0.3}, values_std_mult = wload_std_multiplier) annotation(
    Placement(visible = true, transformation(origin = {70, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(line_2.tpwh_a, load1.tpwh_b) annotation(
    Line(points = {{58, -10}, {36, -10}, {36, 12}}));
  connect(hON.y, HS.heaterON) annotation(
    Line(points = {{-89, 44}, {-69, 44}, {-69, -2}, {-62, -2}}, color = {255, 0, 255}));
  connect(pON.y, HS.pumpON) annotation(
    Line(points = {{-89, 2}, {-78, 2}, {-78, -14}, {-63, -14}}, color = {255, 0, 255}));
  connect(HS.tpwh_a, line_1.tpwh_a) annotation(
    Line(points = {{-38, -10}, {-20, -10}}));
  connect(rgenPload1.y, load1.Ptaken_cmd01) annotation(
    Line(points = {{2, 50}, {10, 50}, {10, 28}, {18, 28}}, color = {0, 0, 127}));
  connect(rgenPload2.y, load2.Ptaken_cmd01) annotation(
    Line(points = {{82, 50}, {90, 50}, {90, 28}, {98, 28}}, color = {0, 0, 127}));
  connect(pgenTsp.y, HS.spTho) annotation(
    Line(points = {{-88, 22}, {-73, 22}, {-73, -6}, {-62, -6}}, color = {0, 0, 127}));
  connect(pgendpsp.y, HS.spDpHC) annotation(
    Line(points = {{-88, -18}, {-62, -18}}, color = {0, 0, 127}));
  connect(rgenwload2.y, load2.w_cmd01) annotation(
    Line(points = {{82, 20}, {98, 20}}, color = {0, 0, 127}));
  connect(rgenwload1.y, load1.w_cmd01) annotation(
    Line(points = {{2, 20}, {18, 20}}, color = {0, 0, 127}));
  connect(line_1.tpwh_b, load1.tpwh_a) annotation(
    Line(points = {{4, -10}, {24, -10}, {24, 12}}));
  connect(line_2.tpwh_b, load2.tpwh_a) annotation(
    Line(points = {{82, -10}, {104, -10}, {104, 12}}));
  connect(clo.tpwh_a, load2.tpwh_b) annotation(
    Line(points = {{128, -10}, {116, -10}, {116, 12}}));
  annotation(
    Diagram(coordinateSystem(extent = {{-200, -100}, {200, 100}})),
    experiment(StartTime = 0, StopTime = 400000, Tolerance = 1e-06, Interval = 10),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian",
    __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl", variableFilter = ".*"));
end HN001_two_loads_v2;