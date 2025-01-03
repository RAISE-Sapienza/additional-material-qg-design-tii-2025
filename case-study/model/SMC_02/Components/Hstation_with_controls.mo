within SMC_02.Components;

model Hstation_with_controls
  parameter SI.Power Phmax=2e5 "maximum heater power";
  parameter SI.Volume Vheater = 1 "heater volume";
  parameter SI.Pressure pvessel = 1e5 "vessel nominal pressure";
  
  parameter Real cmdPnom = 0.75 "pump nominal cmd [0,1]";
  parameter SI.PressureDifference dpPn0=4e5 "pump dp at cmd=cmdPnom, w=wpnom";
  parameter SI.MassFlowRate wPn0=10 "pump w at cmd=cmdnom, dp=dpPnom";
  parameter SI.PressureDifference dpP00=4.5e5 "pump dp at cmd=cmdPnom, w=0";
  parameter Real etaHPopt=0.8 "pump optimal hydraulic efficiency, at cmd=cmdHopt";
  parameter Real cmdHPopt=0.8 "pump optimal efficiency cmd";
  parameter Real etaHP0=0.3 "pump hydraulic efficiency near cmd=0";
  parameter Boolean noPReverse=true "strictly prohibit reverse flow in pump";
  
  parameter SI.Time wPctrlTC=2 "pump flow control time constant";
  parameter SI.PressureDifference dpHCnom = 3e5 "nominal H-C dp";
  parameter SI.MassFlowRate wrnom = 25 "recycle flowrate at dpHCnom with valve fully open";
  parameter SI.Temperature Tstart = 293.15 "initial T, all items";
  parameter Real KTho = 0.5 "heater T control gain";
  parameter SI.Time TiTho=500 "heater T control integral time";
  parameter Real KwP = 1 "pump flow control gain";
  parameter SI.Time TiwP=2 "pump flow control integral time";
  parameter Real KdpHC = 0.5 "H-C dp control gain";
  parameter SI.Time TidpHC=500 "H-C dp flow control integral time";
  
  SI.Power Pheater,Ppump;
  SI.Energy Eheater(start=0),Epump(start=0),Etotal;
  
  AES.ProcessComponents.Thermal.Liquid.DiffPressureSensor sdp annotation(
    Placement(visible = true, transformation(origin = {32, -46}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  AES.ProcessComponents.Thermal.Liquid.Header heater(Tstart = Tstart, V = Vheater) annotation(
    Placement(visible = true, transformation(origin = {-70, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow Ph annotation(
    Placement(visible = true, transformation(origin = {-70, 10}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  AES.ProcessComponents.Thermal.Liquid.MassFlowrateSensor sw annotation(
    Placement(visible = true, transformation(origin = {-32, -70}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  AES.ProcessComponents.Thermal.Liquid.Pressuriser EV(p = pvessel) annotation(
    Placement(visible = true, transformation(origin = {-90, -64}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  AES.ProcessComponents.Thermal.Liquid.Tsensor sTo annotation(
    Placement(visible = true, transformation(origin = {-12, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder FlowCtrl(T = wPctrlTC, initType = Modelica.Blocks.Types.Init.InitialOutput, y_start = 1e-6) annotation(
    Placement(visible = true, transformation(origin = {-10, 34}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  AES.ControlBlocks.AnalogueControllers.PI_awfb_full PI_dpHC(CSmin = 0, K = KdpHC, Ti = TidpHC, hasTracking = true) annotation(
    Placement(visible = true, transformation(origin = {30, 20}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  AES.ControlBlocks.AnalogueControllers.PI_awfb_full PI_To( CSmin = 0, K = KTho, Ti = TiTho, hasTracking = true) annotation(
    Placement(visible = true, transformation(origin = {-110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  AES.ProcessComponents.Thermal.Liquid.Pump_centrifugal P(cmdHopt = cmdHPopt, cmdnom = cmdPnom, dp00 = dpP00, dpn0 = dpPn0, etaH0 = etaHP0, etaHopt = etaHPopt, noReverse = noPReverse, wn0 = wPn0)  annotation(
    Placement(visible = true, transformation(origin = {-32, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput spDpHC annotation(
    Placement(visible = true, transformation(origin = {130, 34}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Logical.Not notp annotation(
    Placement(visible = true, transformation(origin = {94, 18}, extent = {{6, -6}, {-6, 6}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput pumpON annotation(
    Placement(visible = true, transformation(origin = {130, 18}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-120, -40}, extent = {{20, -20}, {-20, 20}}, rotation = 180)));
  Modelica.Blocks.Interfaces.BooleanInput heaterON annotation(
    Placement(visible = true, transformation(origin = {-170, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-120, 80}, extent = {{20, -20}, {-20, 20}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput spTho annotation(
    Placement(visible = true, transformation(origin = {-170, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-120, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Logical.Not notH annotation(
    Placement(visible = true, transformation(origin = {-146, 16}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression zH annotation(
    Placement(visible = true, transformation(origin = {-160, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression zP annotation(
    Placement(visible = true, transformation(origin = {120, -2}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gPh(k = Phmax)  annotation(
    Placement(visible = true, transformation(origin = {-84, 34}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  AES.ProcessComponents.Thermal.Interfaces.pwhTwinPort tpwh_a annotation(
    Placement(visible = true, transformation(origin = {130, -64}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {116, 0}, extent = {{16, -20}, {-16, 20}}, rotation = 0)));
  AES.ProcessComponents.Thermal.Interfaces.pwhPortSplitter pwh annotation(
    Placement(visible = true, transformation(origin = {92, -64}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  AES.ProcessComponents.Thermal.Liquid.Tsensor sTr annotation(
    Placement(visible = true, transformation(origin = {52, -56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  Ppump = P.Pabs;
  Pheater = gPh.y;
  der(Epump) = Ppump;
  der(Eheater) = Pheater;
  Etotal = Epump + Eheater;
  connect(sTo.oT, PI_To.PV) annotation(
    Line(points = {{-10, -40}, {-130, -40}, {-130, 30}, {-120, 30}}, color = {0, 0, 127}));
  connect(EV.pwh_b, sw.pwh_b) annotation(
    Line(points = {{-78, -70}, {-44, -70}}, color = {46, 52, 54}));
  connect(heater.pwh_b, P.pwh_a) annotation(
    Line(points = {{-58, -20}, {-44, -20}}, color = {46, 52, 54}));
  connect(heater.pwh_a, EV.pwh_a) annotation(
    Line(points = {{-82, -20}, {-112, -20}, {-112, -70}, {-102, -70}}, color = {46, 52, 54}));
  connect(PI_dpHC.PV, sdp.oDp) annotation(
    Line(points = {{40, 30}, {50.2, 30}, {50.2, -46}, {30, -46}}, color = {0, 0, 127}));
  connect(Ph.port, heater.heatPort) annotation(
    Line(points = {{-70, 0}, {-70, -10}}, color = {191, 0, 0}));
  connect(PI_dpHC.SP, spDpHC) annotation(
    Line(points = {{40, 34}, {130.2, 34}}, color = {0, 0, 127}));
  connect(PI_dpHC.TS, notp.y) annotation(
    Line(points = {{40, 26}, {73.7, 26}, {73.7, 18}, {87, 18}}, color = {255, 0, 255}));
  connect(notp.u, pumpON) annotation(
    Line(points = {{101.2, 18}, {130.2, 18}}, color = {255, 0, 255}));
  connect(spTho, PI_To.SP) annotation(
    Line(points = {{-170, 34}, {-120, 34}}, color = {0, 0, 127}));
  connect(PI_To.TS, notH.y) annotation(
    Line(points = {{-120.2, 26}, {-134.2, 26}, {-134.2, 16}, {-139.2, 16}}, color = {255, 0, 255}));
  connect(heaterON, notH.u) annotation(
    Line(points = {{-170, 16}, {-153, 16}}, color = {255, 0, 255}));
  connect(PI_To.TR, zH.y) annotation(
    Line(points = {{-120.2, 22.2}, {-126.2, 22.2}, {-126.2, -4}, {-149, -4}}, color = {0, 0, 127}));
  connect(PI_dpHC.TR, zP.y) annotation(
    Line(points = {{40, 22}, {70.2, 22}, {70.2, -2}, {109, -2}}, color = {0, 0, 127}));
  connect(PI_To.CS, gPh.u) annotation(
    Line(points = {{-100, 34}, {-91, 34}}, color = {0, 0, 127}));
  connect(gPh.y, Ph.Q_flow) annotation(
    Line(points = {{-77.4, 34}, {-70.4, 34}, {-70.4, 20}}, color = {0, 0, 127}));
  connect(pwh.pwhTwin_HC, tpwh_a) annotation(
    Line(points = {{104, -64}, {130, -64}}));
  connect(sw.pwh_a, pwh.pwh_C) annotation(
    Line(points = {{-20, -70}, {80, -70}}, color = {46, 52, 54}));
  connect(FlowCtrl.y, P.cmd) annotation(
    Line(points = {{-21, 34}, {-32, 34}, {-32, -12}}, color = {0, 0, 127}));
  connect(sTr.pwh_a, pwh.pwh_C) annotation(
    Line(points = {{64, -56}, {71, -56}, {71, -70}, {80, -70}}, color = {46, 52, 54}));
  connect(P.pwh_b, sdp.pwh_hi) annotation(
    Line(points = {{-20, -20}, {20, -20}, {20, -40}}, color = {46, 52, 54}));
  connect(P.pwh_b, pwh.pwh_H) annotation(
    Line(points = {{-20, -20}, {80, -20}, {80, -58}}, color = {46, 52, 54}));
  connect(PI_dpHC.CS, FlowCtrl.u) annotation(
    Line(points = {{20, 34}, {2, 34}}, color = {0, 0, 127}));
  connect(sw.pwh_a, sdp.pwh_lo) annotation(
    Line(points = {{-20, -70}, {20, -70}, {20, -52}}, color = {46, 52, 54}));
  connect(sTo.pwh_a, sdp.pwh_hi) annotation(
    Line(points = {{0, -40}, {20, -40}}, color = {46, 52, 54}));
  annotation(
    Diagram(coordinateSystem(extent = {{-200, -100}, {200, 100}})),
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}})),
  experiment(StartTime = 0, StopTime = 10000, Tolerance = 1e-6, Interval = 2),
  __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian",
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl", variableFilter = ".*"));
end Hstation_with_controls;