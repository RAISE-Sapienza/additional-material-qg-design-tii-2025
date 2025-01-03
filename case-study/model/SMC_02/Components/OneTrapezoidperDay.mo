within SMC_02.Components;

model OneTrapezoidperDay
  parameter Real value1 =  2;
  parameter Real value2 =  4;
  parameter Real hod_12_start =  7 "hour of day 1 to 2 ramp start, assuming time=0 is midnight";
  parameter Real hod_12_end   =  8 "hour of day 1 to 2 ramp end, assuming time=0 is midnight";
  parameter Real hod_21_start = 18 "hour of day 2 to 1 ramp start, assuming time=0 is midnight";
  parameter Real hod_21_end   = 19 "hour of day 2 to 1 ramp end, assuming time=0 is midnight";
  parameter Real TC=10;
  
  Modelica.Blocks.Interfaces.RealOutput y annotation(
    Placement(visible = true, transformation(origin = {114, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  
  Real yy(start=value1,fixed=true),yyy(start=value1,fixed=true);
  Modelica.Blocks.Sources.Trapezoid trapezoid(amplitude = value2 - value1, falling = 3600*(hod_21_end - hod_21_start), offset = value1, period = 86400, rising = 3600*(hod_12_end - hod_12_start), startTime = 3600*hod_12_start, width = 3600*(hod_21_start - hod_12_end))  annotation(
    Placement(visible = true, transformation(origin = {-12, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  yy+TC*der(yy)   = trapezoid.y;
  yyy+TC*der(yyy) = yy;
  y               = yyy;
 
end OneTrapezoidperDay;