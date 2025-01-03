within SMC_02.Functions;

function randn01
 output Real y;
 external "C" y = randn01() annotation(
      LibraryDirectory="modelica://SMC_02/Resources/",
      Library="randn",
      IncludeDirectory="modelica://SMC_02/Resources/",
      Include="#include \"randn.h\"");      
end randn01;