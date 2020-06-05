# Cordic hyperbolic tangent
This is an implementation and simulation of hyperbolic tangent function using
 Cordic algorithm. The .m files are merely for simulation, verification and test
 generation but the verilog scripts can be used directly as modules in a project.
 
## Algorithm
There are two main approaches for calculating hyperbolic tangent function using cordic algorithm.
The first approach is to directly calculate it using rotaion mode, and the secod approach is to
calculate sinh and cosh using vectoring mode and then divide them by another linear cordic algorithm.
In this repository the latest is implemented.
## Matlab files
All the matlab functions are implemented using **fixed point computation**
### cordic.m
A function that implements cordic tanh algorithm using ROM_lookup.m and cordic_Div.m. This funstion
calcuates tanh and output the result. the fixed point attributes are passed to the function using
input arguments.
### ROM_lookup.m
This function returns the tanh inverse number. this part will be a look up table in the HDL implementation.
### cordic_Div.m
This function implements cordic division algorithm which is used to divide sinh and cosh in the  cordic.m.
### cordic_test_generator.m
This file produces verilog test cases to be fed to the DUT testbench
### cordic_test_check.m
This files checks the result of the test bench and visualizes all the results to be compared
## Verilog files
The verilog code is written in a modular fasion
### cordic.v
is the core HDL script which implements the whole process of cordic tanh. note that this module is mainly
broken down to two module which are sinh&cosh and division. Each pf these sub modules are pipelined
and consist of #Fraction_Length stages so the totall system consists of twice the #Fraction_Length.
For example if you choose to work with 8 bits of word length and 6 bits of fraction length, The output should
be ready after 12 clock cycles.
### cordic_tb.v
This file reads the test.txt files and fed thme to DUT as inputs. Then stores the results to the test_result.txt
file.
## Text files
### test.txt
output of the cordic_test_generator.m and input to the cordic_tb.v
### test.txt
output of the cordic_tb.v and input to the cordic_test_check.m
## Rsults
<img src="https://github.com/alireza-shirzad/Cordic_tanh/blob/master/Result.png" height="48" width="48" >
