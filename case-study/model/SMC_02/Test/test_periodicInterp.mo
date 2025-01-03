within SMC_02.Test;

model test_periodicInterp
  Real pt[:] = {1,2,3,6,8,9};
  Real pv[:] = {1,2,2,3,3,1};
  Real y;
equation
  y = Functions.periodicInterp(time,pt,pv);
annotation(
    experiment(StartTime = 0, StopTime = 30, Tolerance = 1e-6, Interval = 0.06),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian",
    __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl", variableFilter = ".*"));
end test_periodicInterp;