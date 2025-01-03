within SMC_02.Components;

model Tload_flow_power_00
  parameter SI.MassFlowRate w_cmd1=1 "mass flowrate ad cmd=1";
  parameter SI.Power Ptaken_cmd1=20e3 "thermal power taken at cmd=1";
  parameter SI.Temperature Tstart=293.15 "initial T, all tube lumps";

  AES.ProcessComponents.Thermal.Liquid.Tube tube_load(Di = 0.01, Tstart = Tstart, hasInertia = false) annotation(
    Placement(visible = true, transformation(origin = {30, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  AES.ProcessComponents.Thermal.Liquid.Pump_volumetric pump(w0 = w_cmd1)  annotation(
    Placement(visible = true, transformation(origin = {-10, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  AES.ProcessComponents.Thermal.Liquid.surfQcond_prescribed Qload annotation(
    Placement(visible = true, transformation(origin = {30, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gPmax(k = -Ptaken_cmd1)  annotation(
    Placement(visible = true, transformation(origin = {-28, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput w_cmd01 annotation(
    Placement(visible = true, transformation(origin = {-80, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Ptaken_cmd01 annotation(
    Placement(visible = true, transformation(origin = {-80, 50}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  AES.ProcessComponents.Thermal.Interfaces.pwhTwinPort tpwh_a annotation(
    Placement(visible = true, transformation(origin = {-90, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-60, -116}, extent = {{-16, -20}, {16, 20}}, rotation = 90)));
  AES.ProcessComponents.Thermal.Interfaces.pwhTwinPort tpwh_b annotation(
    Placement(visible = true, transformation(origin = {110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {60, -116}, extent = {{-16, -20}, {16, 20}}, rotation = 90)));
  AES.ProcessComponents.Thermal.Interfaces.pwhPortSplitter split_a annotation(
    Placement(visible = true, transformation(origin = {-52, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  AES.ProcessComponents.Thermal.Interfaces.pwhPortSplitter join_b annotation(
    Placement(visible = true, transformation(origin = {70, -30}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
equation
  connect(pump.pwh_b, tube_load.pwh_a) annotation(
    Line(points = {{2, -10}, {18, -10}}, color = {46, 52, 54}));
  connect(Qload.surf, tube_load.surf) annotation(
    Line(points = {{30, 41}, {30, -5}}, color = {144, 5, 5}));
  connect(gPmax.y, Qload.Q) annotation(
    Line(points = {{-17, 50}, {22, 50}}, color = {0, 0, 127}));
  connect(pump.cmd, w_cmd01) annotation(
    Line(points = {{-10, -2}, {-10, 20}, {-80, 20}}, color = {0, 0, 127}));
  connect(gPmax.u, Ptaken_cmd01) annotation(
    Line(points = {{-40, 50}, {-80, 50}}, color = {0, 0, 127}));
  connect(tpwh_a, split_a.pwhTwin_HC) annotation(
    Line(points = {{-90, -30}, {-64, -30}}));
  connect(split_a.pwh_H, join_b.pwh_H) annotation(
    Line(points = {{-40, -24}, {58, -24}}, color = {46, 52, 54}));
  connect(split_a.pwh_C, join_b.pwh_C) annotation(
    Line(points = {{-40, -36}, {58, -36}}, color = {46, 52, 54}));
  connect(tube_load.pwh_b, join_b.pwh_C) annotation(
    Line(points = {{42, -10}, {50, -10}, {50, -36}, {58, -36}}, color = {46, 52, 54}));
  connect(join_b.pwhTwin_HC, tpwh_b) annotation(
    Line(points = {{81.6, -30}, {110, -30}}));
  connect(split_a.pwh_H, pump.pwh_a) annotation(
    Line(points = {{-40, -24}, {-30, -24}, {-30, -10}, {-22, -10}}, color = {46, 52, 54}));
  annotation(
    Diagram(coordinateSystem(extent = {{-200, -100}, {200, 100}})),
    experiment(StartTime = 0, StopTime = 10000, Tolerance = 1e-6, Interval = 20),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian",
    __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl", variableFilter = ".*"));
end Tload_flow_power_00;