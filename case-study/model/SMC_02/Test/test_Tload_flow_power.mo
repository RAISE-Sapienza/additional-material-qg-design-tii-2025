within SMC_02.Test;

model test_Tload_flow_power
  SMC_02.Components.Tload_flow_power Tload(Ptaken_cmd1 = 4186, w_cmd1 = 1)  annotation(
    Placement(visible = true, transformation(origin = {10, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  AES.ProcessComponents.Thermal.Liquid.Node_pT_fixed src annotation(
    Placement(visible = true, transformation(origin = {-70, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  AES.ProcessComponents.Thermal.Liquid.Node_pT_fixed snk annotation(
    Placement(visible = true, transformation(origin = {50, -10}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression cmd_P(y = 0.2)  annotation(
    Placement(visible = true, transformation(origin = {-70, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression cmd_w(y = 0.05)  annotation(
    Placement(visible = true, transformation(origin = {-70, 26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  inner AES.ProcessComponents.Thermal.System_settings.System_liquid system annotation(
    Placement(visible = true, transformation(origin = {-70, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  AES.ProcessComponents.Thermal.Liquid.dp_linear dp annotation(
    Placement(visible = true, transformation(origin = {-30, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(Tload.Cout, snk.pwh_a) annotation(
    Line(points = {{14, 18}, {14, -10}, {38, -10}}, color = {46, 52, 54}));
  connect(cmd_P.y, Tload.Ptaken_cmd01) annotation(
    Line(points = {{-59, 50}, {-34, 50}, {-34, 34}, {-2, 34}}, color = {0, 0, 127}));
  connect(cmd_w.y, Tload.w_cmd01) annotation(
    Line(points = {{-59, 26}, {-2, 26}}, color = {0, 0, 127}));
  connect(src.pwh_a, dp.pwh_a) annotation(
    Line(points = {{-58, -10}, {-42, -10}}, color = {46, 52, 54}));
  connect(dp.pwh_b, Tload.Hin) annotation(
    Line(points = {{-18, -10}, {6, -10}, {6, 18}}, color = {46, 52, 54}));

annotation(
    experiment(StartTime = 0, StopTime = 10000, Tolerance = 1e-6, Interval = 20),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian",
    __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl", variableFilter = ".*"));
end test_Tload_flow_power;