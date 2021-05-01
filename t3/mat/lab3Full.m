%Envelope circuit with fullwave rectifier and full diode equation 
%Diode parameters (taken from l12.m script)
I_S = 1e-9
V_T=25e-3
%Diode Equation i = I_S*(exp(v/V_T/2) - 1);

%input signal +++ circuit components
A = 230;
f=50;
w=2*pi*f;
R=50e3
C=10e-6

tspan = [0 100e-3];
v0 = 230.5258;
options = odeset('RelTol',1e-7,'Stats','on','OutputFcn',@odeplot)
[t,v] = ode45(@(t,v) (I_S*(exp((abs(A*cos(w*t)) - v)/V_T/2) - 1) - v/R)/C, tspan, v0, options);
title("Envelope circuit with full bridge rectifier (Numerical solution to ODE)")
xlabel("t(s)");
ylabel("V(V)");
%[t,v] = ode45(@(t,v) (I_S*(exp(((A*cos(w*t) - v)/V_T/2) + exp((-A*cos(w*t)-v)/V_T/2) - 2) - v/R)/C, tspan, 
