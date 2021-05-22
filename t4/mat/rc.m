% LAB 04:Audio Amp
close all
clear all

%defining an input signal
f = logspace(2,8,800);
vS = sin(2*pi.*f);


printf("Gaining phase\n");
%Common emmiter with bias capacitor, input resistance and, emitir parallel of capacitor and resitence
printf("vS: ampltidude 10mv and freqncy from 10Hz to 100MHz (logscale)\n")
printf("Circuit parameters used + transistor charctheristics\n")
Rb1 = 65e3 %omh
Rb2 = 10e3 %omh
VCC = 12 %V
Ce =  80e-6 %Farad
Ccoupout = 8e-6 %Farad
Rin = 100 %ohm
Cbias = 1e-6 %Farad
Re = 70%omh
Rc = 800%omh
RL = 8 %omh -- Load

Rb = Rb1*Rb2/(Rb1+Rb2) %Equivalent resistence Rb1 Rb2
Veq = Rb2*VCC/(Rb1+Rb2) %Equivalent input resistence

%BJT charctheristics
Vbeon = 0.7 %V
betaf = 178.7
VT=25e-3
VAFN=69.7

%Singal = DC Part + AC

%Input circuit (high gain)
%DCAnalysis
%Working under the assumption bias C fully blocks dc component of vS
Ib = (Veq - Vbeon)/(Rb + (1+betaf)*Re)
Ic = betaf * Ib
Vo = VCC - Rc*Ic
fileID = fopen("Results1.tex", "w")
fprintf(fileID, "$$ I_b = %f A$$ \n", Ib);
fprintf(fileID, "$$ I_c = %f A$$ \n", Ic);
fprintf(fileID, "$$ V_O = %f V$$ \n", Vo);

%AC analysis
gm = Ic/VT
rpi = betaf/gm
ro = VAFN/Ic

printf("Max gain calculated in the limit of infinite frequency\n")
gain_max = abs(Rc.*(gm*rpi*ro)./((ro + Rc).*(Rb + rpi)))

ReEq = 1./(i.*2*pi.*f.*Ce + 1./Re); %Parallel of Re and Ce
RbEq = Rin + Rb + 1./(j.*2.*pi.*f.*Cbias);
gain = abs(Rc.*(ReEq - gm*rpi*ro)./((ro + Rc + ReEq).*(Rb + rpi + ReEq) + gm.*ReEq.*ro*rpi - ReEq.*ReEq));


%computing input impedence
%Zi = RbEq*rpi/(RbEq + rpi)
Zi = abs(RbEq.*rpi./(RbEq + rpi));
f5 = figure
Zi(1)
Zi1 = Rb*rpi/(Rb + rpi)
f3 = figure;
semilogx(f, abs(Zi));
grid on
title("Input impedence of the first circuit");
ylabel("(Omh)")
xlabel("input signal frequency (Hz)")
print(f3 ,"InZ1.png");

%computing output impendence
a1 = ro.*(ReEq + rpi + RbEq)./((RbEq+rpi).*ReEq);
a2 = (ro + rpi)./(ro.*rpi);
a3 = (rpi + RbEq)./(gm*rpi);
a4 = 1./(1./RbEq + 1./ReEq + 1./a3);
Zc = ro.*Rc./(ro + Rc);

Zc = 1./(1/Rc + (a2 + a4)./a1);
f3 = figure;
semilogx(f, abs(Zc));
grid on
title("Output impedence of the first circuit");
ylabel("(Omh)")
xlabel("input signal frequency (Hz)")
print(f3 ,"OutZ1.png");
Zc = ro.*Rc./(ro + Rc);



%Output stage
printf("Output phase\n");
%BJT charctheristics
Vebon = 0.7 %V
betaf_2 = 227.3
VT=25e-3 %V
VAFN=37.2 %V

Re = 100 %omh -- Rout

%DC component
Ie = (VCC - Vebon - Vo)/Re;
Ic = betaf_2/(1+betaf_2) * Ie;
Vout = VCC - Re*Ie;
fclose(fileID)
fileID = fopen("Results2.tex", "w")
fprintf(fileID, "$$ I_e = %f A$$ \n", Ie);
fprintf(fileID, "$$ I_c = %f A$$ \n", Ic);
fprintf(fileID, "$$ V_{out} = %f V$$ \n", Vout);

%AC component (No CE, as gain is not priority)
gm = Ic/VT;
rpi = betaf_2/gm;
ro = VAFN/Ic;

Geq = 1/Re + i.*2*pi*f*Ccoupout;% wo 8 omh load
printf("Gain\n")
gain2 = gm./(1/rpi + Geq + 1/ro + gm);
printf("Input impedence\n")
Zi = rpi.*(gm + 1/rpi + 1/ro + Geq)./(1/rpi + Geq + 1/ro);
printf("Output impendence\n")
Zo = 1./(1/rpi + Geq + 1/ro + gm);


f4 = figure;
semilogx(f, abs(Zo));
grid on ;
title("Output impedence of the second circuit");
ylabel("(Omh)");
xlabel("input signal frequency (Hz)");
print(f4 ,"OutZ2.png");

f4 = figure;
semilogx(f, abs(Zi));
grid on ;
title("Input impedence of the second circuit");
ylabel("(Omh)");
xlabel("input signal frequency (Hz)");
print(f4 ,"InZ2.png");



Zo = 1./(1/ro + gm.*rpi./(rpi+Zc) + Geq + 1./(rpi + Zc)); %factoring in output first circuit with 8omh load
%Plotting output impedence
f4 = figure;
semilogx(f, abs(Zo));
grid on ;
title("Output impedence of the second circuit considering impedence of the first")
ylabel("(Omh)")
xlabel("input signal frequency (Hz)")
print(f4 ,"OutZFull.png");


%Calculating gain of the full circuit
GainFull = gain.*(1./(rpi + Zc) + gm.*rpi./(rpi + Zc))./(1./(rpi+Zc) + Geq + 1/ro + gm*rpi./(rpi+Zc));

%Plotting Gains
f1 = figure;
semilogx(f, 20*log10(gain.*gain2));
hold on
semilogx(f, 20*log10(GainFull));
hold on
semilogx(f, 20*log10(gain))
hold on
semilogx(f, 20*log10(gain2))
grid on
legend("Product of the two gains","Gain Considering full Circuit", "Gain of first phase", "Gain of the second phase")
title("Incremental gain");
ylabel("gain (dB)")
xlabel("input signal frequency (Hz)")
print(f1 ,"Gains.png");

%vO = Vo + vS.*gain_max;
