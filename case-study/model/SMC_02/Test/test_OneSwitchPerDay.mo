within SMC_02.Test;

model test_OneSwitchPerDay
  Components.OneSwitchperDay oneSwitchperDay annotation(
    Placement(visible = true, transformation(origin = {-38, 28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  annotation(
    experiment(StartTime = 0, StopTime = 400000, Tolerance = 1e-06, Interval = 1),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian",
    __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl", variableFilter = ".*"));
end test_OneSwitchPerDay;