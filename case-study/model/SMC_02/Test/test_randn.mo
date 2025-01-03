within SMC_02.Test;

model test_randn
  parameter Real mu=1;
  parameter Real sigma=0.5;
  discrete Real y;
algorithm
  when sample(0, 0.001) then
    y := Functions.randn(mu,sigma);
  end when;
  annotation(
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.002),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian",
    __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl", variableFilter = ".*"));
end test_randn;