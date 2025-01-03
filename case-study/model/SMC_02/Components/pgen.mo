within SMC_02.Components;

model pgen
  parameter Real values[:] = {300,300,300,300,300,300,
                              300,300,350,350,350,350,
                              350,350,320,320,320,320,
                              320,300,300,300,300,300} "values ";
  parameter Real period     = 3600 "update period";
  parameter Real TC=10;
  
  Modelica.Blocks.Interfaces.RealOutput y annotation(
    Placement(visible = true, transformation(origin = {114, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  
protected
  final parameter Integer n_values=size(values,1) annotation(Evaluate = true);
  discrete Integer dex;
  Real yy(start=values[1],fixed=true);

equation
  y = yy;
  yy+TC*der(yy) = values[dex];
  
algorithm
  when sample(period,period) then
       dex  := dex+1;
       if dex>n_values then dex := 1; end if;
  end when;

initial algorithm
  dex := 1;
end pgen;