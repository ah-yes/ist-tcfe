% LAB 05:Active bandpass filter
close all
clear all

%defining an input signal
f = logspace(0,8,800);
vS = sin(2*pi.*f);

C1 = 220e-9
C2 = 110e-9
R1 = 1e3
R2 = 1e3
R3 = 1e3
R4 = 100e3

f2 = figure
Gain = (1 + R4/R3).*(R1.*2.*pi.*f.*C1./(1+R1.*j.*2.*pi.*f.*C1)).*(1./(j.*2.*pi.*f.*C2.*R2 + 1));
semilogx(f, 20*log10(abs(Gain)));
grid on
title("Gain");
ylabel("dB")
xlabel("input signal frequency (Hz)")
print(f2 ,"Gain.png");



f = 1.004690e+03
Gain = 20*log10(abs((1 + R4/R3).*(R1.*2.*pi.*f.*C1./(1+R1.*j.*2.*pi.*f.*C1)).*(1./(j.*2.*pi.*f.*C2.*R2 + 1))));
fileID = fopen("ResultsF.tex", "w")
fprintf(fileID, "$$ \\text{Gain} = %f$$ \n", Gain);
fclose(fileID)
