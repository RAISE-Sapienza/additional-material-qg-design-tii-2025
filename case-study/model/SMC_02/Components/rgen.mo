within SMC_02.Components;

model rgen
  parameter Real dtimes_avg[:]   = {6,1,5,4,4,1,3} "time intervals avg";
  parameter Real dtimes_std[:]   = {0.1,0.2,0.2,0.1,0.3,0.1,0,1} "time intervals std";
  parameter Real tscale          = 3600 "scale times, e.g., s to h";
  parameter Real values_avg[:]   = {0.1,0.1,0.5,0.5,0.15,0.12,0.1} "values avg";
  parameter Real values_std[:]   = {0.001,0.001,0.001,0.001,0.001,0.001,0.01} "values std";
  parameter Real dtimes_std_mult = 1 "time interval std multiplier";
  parameter Real values_std_mult = 1 "values std multiplier"; 
  parameter Real ymin            = 0 "min output";
  parameter Real ymax            = 1 "max output";
  parameter Real ystart          = 0.1 "initial output";
  parameter Real ynoise_std      = 0.005 "output noise std";
  parameter Real ynoise_Ts       = 600 "output noise gen timestep";
  parameter Real ynoise_TC       = 2000 "output noise 2nd order filter TC";
  
  Modelica.Blocks.Interfaces.RealOutput y annotation(
    Placement(visible = true, transformation(origin = {114, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  
protected
  final parameter Real pnoise=exp(-ynoise_Ts/ynoise_TC) annotation(Evaluate = true);
  discrete Integer dex(start=1,fixed=true);
  discrete Real t_pres,t_next;
  discrete Real y_pres,y_next;
  discrete Real ynoise_sample;
  Real ynf,ynoise(start=0,fixed=true),xynoise(start=0,fixed=true);

equation
  y                              = max(ymin,min(ymax,ynf+ynoise));
//(ynf-y_pres)/(y_next-y_pres)   = (time-t_pres)/(t_next-t_pres);
  (ynf-y_pres)*(t_next-t_pres)   = (time-t_pres)*(y_next-y_pres);
  xynoise+ynoise_TC*der(xynoise) = ynoise_sample;
  ynoise+ynoise_TC*der(ynoise)   = xynoise;
  
algorithm
  when sample(0,ynoise_Ts) then
       ynoise_sample := Functions.randn(0,ynoise_std);
  end when;
  when time>=t_next then
       t_pres := t_next;
       y_pres := y_next;
       dex    := dex+1;
       if dex>size(dtimes_avg,1) then dex := 1; end if;
       t_next := t_pres+Functions.randn(dtimes_avg[dex]*tscale,dtimes_std[dex]*tscale*dtimes_std_mult);
       y_next := Functions.randn(values_avg[dex],values_std[dex]*values_std_mult);
  end when;

initial equation
  t_pres = time;
  y_pres = ystart+Functions.randn(0,ynoise_std);
  t_next = t_pres+Functions.randn(dtimes_avg[dex]*tscale,dtimes_std[dex]*tscale*dtimes_std_mult);
  y_next = Functions.randn(values_avg[dex],values_std[dex]*values_std_mult);
end rgen;