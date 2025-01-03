within SMC_02.Functions;

function randn
  input Real mu;
  input Real sigma;
  output Real y;
algorithm
  y := mu+sigma*randn01();
end randn;