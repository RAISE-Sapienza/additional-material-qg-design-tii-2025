within SMC_02.Functions;

function periodicInterp
  input Real t "time input";
  input Real[:] points_t "point times, re-based to start at 0";
  input Real[:] points_v "point values";
  output Real y;
protected
  Real pt[size(points_t,1)];
  Real period, t_mod;
algorithm
  pt     := points_t-points_t[1]*ones(size(points_t,1));
  period := pt[end];
  t_mod  := mod(t,period);
  y      := Modelica.Math.Vectors.interpolate(pt,points_v,t_mod);
end periodicInterp;