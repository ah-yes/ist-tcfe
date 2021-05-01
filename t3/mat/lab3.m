%AC/DC Lab


%simulating envelope detector
%'regular' behaviour for t < tof & capacitor discharge for tof < t < ton
t=linspace(0, 20e-3, 1000);
%sinusoidal signal + stuff
A = 230;
f=50;
w=2*pi*f;
R=1e3
C=1e-6
vs = A*cos(w*t);


%Computing ton and toff
toff = atan(1/(w*R*C))/w
ton = fsolve(@(x) cos(w*x) - cos(w*toff)*exp((toff - x)/(R*C)), 15e-3)
v1O = zeros(1, length(t)); 

%Discharge solution 
Vof = A*cos(w*toff)*exp((toff - t)/(R*C));
%ton = 0.8

%plotting solution 
for i=1:length(t)
  if t(i) < toff
    v1O(i) = vs(i);
  elseif  t(i) < ton
    v1O(i) = Vof(i);
  elseif t(i) > ton
    v1O(i) = vs(i);
  endif
endfor

plot(t*1000, v1O);
title("Envelope circuit output - one oscilation");
xlabel("t(ms)");
ylabel("Output voltage (V)");
%print ("venvlope.png", "-depsc"); ADD PLOT OUTPUT

%The output is still oscilating with frequency f, hence we have a ripple every 1/f seconds 


%Simulating Voltage Regulator


