within SMC_02.Components;

model OneSwitchperDay
  parameter Real value1 =  2;
  parameter Real value2 =  4;
  parameter Real hod_12 =  8 "hour of day 1 to 2, assuming time=0 is midnoght";
  parameter Real hod_21 = 18 "hour of day 2 to 1, assuming time=0 is midnoght";
  parameter Real TC=10;
  
  Modelica.Blocks.Interfaces.RealOutput y annotation(
    Placement(visible = true, transformation(origin = {114, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  
  Real hod,yy(start=value1,fixed=true),yyy(start=value1,fixed=true);

equation
  y               = yyy;
  hod             = rem(time,86400)/3600;
  yy+TC*der(yy)   = if noEvent(hod<hod_12 or hod>hod_21) then value1 else value2;
  yyy+TC*der(yyy) = yy;
 
end OneSwitchperDay;