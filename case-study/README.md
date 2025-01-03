# Case Study (Modelica code)

In the following, we provide the Modelica code of the case study with which the approach proposed in "Simulation-Based Design of Industry-Size Control Systems with Formal Quality Guarantees" has been evaluated.

## Requirements

The Modelica code of the case study depends on the following software requirements: 

* OpenModelica 1.21.0
* Modelica Standard Library v4.0.0


## Build the random generator (optional)

You can optionally compile the C++ code of the random generator. To do that, you can run the instructions within the file `model/SMC_02/Resources/INSTALL.txt`



## Load model using OMEdit

To inspect and simulate the system, you can follow the next steps:

1. Open OMEdit (OpenModelica Connection Editor).

2. Load the AES (Automation of Energy System) library. Through the option `Open Model/Library File(s)` of the OMEdit GUI, you can load the library by opening the file `library/Automation_of_Energy_Systems/Modelica/AES/package.mo`

3. Load the case study model. Through the option `Open Model/Library File(s)` of the OMEdit GUI, you can load the case study model by opening the file `model/SMC_02/package.mo`


You can use the OMEdit editor to inspect and simulate the system.


## Simulate the model

Through the OMEdit GUI, open the file `HN001_two_loads_v2_OneTrapezoidPerDay_wrapper` within the `Plants` module and simulate the model.