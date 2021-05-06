%%LAB03 --- AC/DC Converter

close all
clear all

%Defining time scale
t=linspace(0, 20e-3, 1000);

%'Full' diode model
%i = I_S*(exp(v/V_T) - 1);
I_S = 1e-14;
V_T=25e-3;

%sinusoidal signal + stuff
A = 230*2766.4;
f=50;
w=2*pi*f;
R=10e3;
C=10e-6;
R2 = 19e3;
vS = A * cos(w*t);
vOhr = zeros(1, length(t));
vO = zeros(1, length(t));

%Envelope Circuit with full bridge rectifier
tOFF = 1/w * atan(1/w/R/C)

vOnexp = A*cos(w*tOFF)*exp(-(t-tOFF)/(R*C));
vTwoxp = A*cos(w*tOFF)*exp(-(t-(tOFF + 1/(2*f)))/(R*C));

for i=1:length(t)
  if t(i) < tOFF
    vO(i) = abs(vS(i));
  elseif vOnexp(i) > abs(vS(i)) && t(i) < tOFF + 1/(2*f)
    vO(i) = vOnexp(i);
  elseif t(i) < tOFF + 1/(2*f)
    vO(i) = abs(vS(i));
  elseif vTwoxp(i) > abs(vS(i))
    vO(i) = vTwoxp(i);
  else vO(i) = abs(vS(i));
  endif
endfor


hf = figure()
plot(t*1000, vO)
title("Envelope circuit output with full bridge rectifier ");
xlabel("t(ms)");
grid on
ylabel("Output voltage (V)");
print (hf, "venvlope.png");

hf = figure()
plot(t*1000, vO)
hold on
plot(t*1000, abs(vS))
title("Envelope circuit output with full bridge rectifier ");
xlabel("t(ms)");
grid on
ylabel("Output voltage (V)");
legend("Envelope", "Rectified")
print (hf, "VEnvRec.png");

%Regulator circuit

%Computing incremental resistence with op at 228 V
rd = 13*V_T/(I_S*exp(228/(V_T)));

Vout = zeros(1, length(t));
Vout2 = zeros(1, length(t));

for i =1:length(t)
  Vout(i) = fsolve(@(v) vO(i) - v - R2*I_S*(exp(v/(V_T*13)) - 1), 3);
  %fun = vO(i) - v - R2*I_S*(exp(v/V_T/2) - 1)
endfor

hf = figure()
plot(t*1000, Vout)
title("Regulator circuit output with 3 diodes ");
xlabel("t(ms)");
grid on
ylabel("Output voltage (V)");
print (hf, "OutputV.png");

hf = figure()
plot(t*1000, Vout);
hold on
plot(t*1000,vO);
title("Regulator circuit output with 13 diodes ");
xlabel("t(ms)");
ylabel("Output voltage (V)");
legend("Output", "Envelope");
grid on
print (hf, "OutputCom.png");

%Plotting Vout - 12
hf = figure()
plot(t*1000, Vout-12)
title("V_0 - 12V");
grid on
xlabel("t(ms)");
ylabel("Output voltage (V)");
print (hf, "Level.png");


%Computing ripple
ripple = max(Vout) - min(Vout);
ripple2 = max(vO) - min(vO);
DCLevel = mean(Vout);
improvement = 100*(ripple/ripple2);


disp("\n Ripple at the envelope circuit"), disp(ripple2), disp("\n Ripple at the regulator circuit"), disp(ripple);
disp("\n Ripple effect diminuished in (%)"), disp(100*(ripple2/ripple))
disp("\n DC Level: "), disp(DCLevel);

%Writting DC level and ripple to file
fileID = fopen("Results.tex", 'w');
fprintf(fileID, "$$ ripple = %f V$$ \n", ripple);
fprintf(fileID, "$$ ripple \\, improvement = %f \\%% $$ \n", improvement);
fprintf(fileID, "$$ DC level = %f V $$ \n", DCLevel);
