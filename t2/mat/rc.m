close all
clear all

%%EXAMPLE SYMBOLIC COMPUTATIONS

pkg load symbolic

printf("----- Lab 01 -----\n\n");

printf("Defining numerical values from data.txt\n");
fileID1 = fopen("data.txt", "r");
A = fscanf(fileID1, "%f")
R1 = A(1)
R2 = A(2)
R3 = A(3)
R4 = A(4)
R5 = A(5)
R6 = A(6)
R7 = A(7)
Vs = A(8)
C = A(9)
Kb = A(10)
Kd = A(11)
%%Close data input file
fclose(fileID1);

printf("Stationary vaules for t < 0s (from nodal analysis):\n");
node1 = [1, 0, 0, 0, 0, 0, 0]
node2 = [-1/R1, 1/R1 + 1/R2 + 1/R3, -1/R2, -1/R3, 0, 0, 0]
node3 = [0, Kb + 1/R2, -1/R2, -Kb, 0, 0, 0]
node4 =[-1/R1, 1/R1, 0, 1/R4, 0, 1/R6, 0]
node5 = [0, 0, 0, 1, 0 ,Kd/R6, -1]
node6 = [0, Kb, 0, -Kb - 1/R5, 1/R5, 0, 0]
node7 = [0, 0, 0, 0, 0, -1/R6 - 1/R7, 1/R7]

nodal = [node1; node2; node3; node4; node5; node6; node7]
b = [Vs; 0; 0; 0; 0; 0; 0]
sol_op = nodal\b

%printing results to .tex file
fileID2 = fopen("tableOP1.tex", 'w')
fprintf(fileID2, "$V_1$ & %f V\\\\ \n", sol_op(1));
fprintf(fileID2, "$V_2$ & %f V\\\\ \n", sol_op(2));
fprintf(fileID2, "$V_3$ & %f V\\\\ \n", sol_op(3));
fprintf(fileID2, "$V_4$ & %f V\\\\ \n", sol_op(4));
fprintf(fileID2, "$V_5$ & %f V\\\\ \n", sol_op(5));
fprintf(fileID2, "$V_6$ & %f V\\\\ \n", sol_op(6));
fprintf(fileID2, "$V_7$ & %f V\\\\ \n", sol_op(7));
fclose(fileID2);


printf("Calculating Equivalent resistence with b.c. V(6)-V(8)\n");
Vx = sol_op(5) - sol_op(7)
eq2 = [-1/R1-1/R2-1/R3, 1/R2, 0, 0, 0, 0, 0]
eq3 = [-1/R2-Kb, 1/R2, Kb, 0, 0, 0, 0]
eq5 = [0, 0, -1, 0, -Kd/R6, 1, 0]
eq4 = [-1/R1, 0, -1/R4, 0, -1/R6, 0, 0]
eq6 = [-Kb, 0, Kb+1/R5, -1/R5, 0, 0, +1]
eq7 = [0, 0, 0, 0, 1/R6-1/R7, -1/R7, 0]
eq8 = [0, 0, 0, 1, 0, -1, 0]
matrix = [eq2; eq3; eq4; eq5; eq6; eq7; eq8]
b= [0;0;0;0;0;0; Vx]
sol_n = matrix\b
Req = Vx/sol_n(7)
%%Printing results to .tex file
fileID3 = fopen("tableOP2.tex", 'w');
fprintf(fileID3, "$V_2$ & %f V\\\\ \n", sol_n(1));
fprintf(fileID3, "$V_3$ & %f V\\\\ \n", sol_n(2));
fprintf(fileID3, "$V_5$ & %f V\\\\ \n", sol_n(3));
fprintf(fileID3, "$V_6$ & %f V\\\\ \n", sol_n(4));
fprintf(fileID3, "$V_7$ & %f V\\\\ \n", sol_n(5));
fprintf(fileID3, "$V_8$ & %f V\\\\ \n", sol_n(6));
fprintf(fileID3, "$I_x$ & %f mA\\\\ \n", sol_n(7));
fprintf(fileID3, "$R_{eq}$ & %f mA\\\\ \n", Req);
fprintf(fileID3, "$\\tau$ & %f ms\\\\ \n", Req*C);

fclose(fileID3);

printf("Ploting natural solutuion for Vc\n");
%for 0 < t < 20 ms
syms t
syms r
syms c
syms v
V = sol_n(4) - sol_n(7)
vn = v*exp(-t/(r*c))
vn = subs(vn, v, vpa(Vx, 11))
vn = subs(vn, c, vpa(C, 11))
vn = subs(vn, r, vpa(Req, 11))
%Plotting natural solution
hf = figure()
ezplot(vn, [0, 20])
axis([0 20 0 9])
xlabel("time (ms)");
ylabel("Voltage (V)");
title("V*exp(-t/(Req*C))");
print (hf, "natural.png");
%Writting natural solution to .tex file
fileID5 = fopen("NaturalSol.tex", "w");
chr = latex(vn)
fprintf(fileID5, "$$");
fprintf(fileID5, "%s", chr);
fprintf(fileID5, "$$");
fclose(fileID5)

printf("Forced solution t > 0 ms\n");
node1 = [1, 0, 0, 0, 0, 0, 0]
node2 = [-1/R1, 1/R1 + 1/R2 + 1/R3, -1/R2, -1/R3, 0, 0, 0]
node3 = [0, Kb + 1/R2, -1/R2, -Kb, 0, 0, 0]
node4 =[-1/R1, 1/R1, 0, 1/R4, 0, 1/R6, 0]
node5 = [0, 0, 0, 1, 0 ,Kd/R6, -1]
node6 = [0, Kb, 0, -Kb - 1/R5, 1/R5+j*2*pi*C, 0, -j*2*pi*C]
node7 = [0, 0, 0, 0, 0, -1/R6 - 1/R7, 1/R7]
nodal = [node1; node2; node3; node4; node5; node6; node7]
b= [1;0;0;0;0;0;0]
sol_f = nodal\b
%printing results to .tex file
fileID4 = fopen("tableF1.tex", 'w')
fprintf(fileID4, "$abs(V_1)$ & %f V\\\\ \n", abs(sol_f(1)));
fprintf(fileID4, "$abs(V_2)$ & %f V\\\\ \n", abs(sol_f(2)));
fprintf(fileID4, "$abs(V_3)$ & %f V\\\\ \n", abs(sol_f(3)));
fprintf(fileID4, "$abs(V_5)$ & %f V\\\\ \n", abs(sol_f(4)));
fprintf(fileID4, "$abs(V_6)$ & %f V\\\\ \n", abs(sol_f(5)));
fprintf(fileID4, "$abs(V_7)$ & %f V\\\\ \n", abs(sol_f(6)));
fprintf(fileID4, "$abs(V_8)$ & %f V\\\\ \n", abs(sol_f(7)));
fclose(fileID4)


%%Writting full solution
syms phase
syms amp
sol_f_c = sol_f(5)
Vf1 = amp*sin(vpa(2*pi)*t +  phase)
Vf1 = subs(Vf1, amp, vpa(abs(sol_f_c),11))
Vf1 = subs(Vf1, phase, vpa(arg(sol_f_c),11))
%Writting forced solution on t > 0 to .tex file
fileID6 = fopen("ForcedSolP.tex", 'w')
chr = latex(Vf1)
fprintf(fileID6, "$$");
fprintf(fileID6, "%s", chr);
fprintf(fileID6, "$$");

%%Plotting forced solution 0 < t < 20
hf = figure()
ezplot(Vf1, [0, 20])
axis([0 20 -1 1])
xlabel("time (ms)");
ylabel("Voltage (V)");
title("Forced solution V6");
print (hf, "forced_1.png");

printf("Full solution -5 < t < 20 ms\n");
%not using symbolic pkg

hf = figure()
x = -5:1e-2:0.01;
yS = 1
yT = Vx
plot(x, yS, 'g')
title("V6 Solution(blue) and Source voltage(green)")
xlabel("time (ms)");
ylabel("Voltage (V)");
grid on
hold on
plot(x, yT, 'b')
hold on
x = 0.01:1e-2:20;
yT = abs(sol_f_c)*sin(2*pi*x - arg(sol_f_c)) + Vx*exp(-x/(Req*C));
yS = sin(2*pi*x);
plot(x, yT, 'b')
hold on
plot(x, yS, 'g')
print (hf, "fullSolution.png");

%Writting full solutuion for t > 0 in .tex file
fileID7 = fopen("FullSolutionP.tex", "w")
full = vn + Vf1
chr = latex(full)
fprintf(fileID7, "$$");
fprintf(fileID7, "%s", chr);
fprintf(fileID7, "$$");

%Computing transfer function
syms f
syms Vi
syms v1
syms v2
syms v3
syms v5
syms v6
syms v7
syms v8

yes1 = v1 == Vi
yes2 = -v1/vpa(R1, 11) + v2*(1/vpa(R1, 11) + 1/vpa(R2, 11) + 1/vpa(R3, 11)) - v3/vpa(R2, 11) - v5/vpa(R3, 11) == 0
yes3 = (vpa(Kb, 11) + 1/vpa(R2, 11))*v2 - v3/vpa(R2,11) - vpa(Kb, 11)*v5 == 0
yes4 = -v1/vpa(R1, 11) + v2/vpa(R1, 11) + v5/vpa(R4, 11) + v7/vpa(R6, 11) == 0
yes5 = v5 + v7*(vpa(Kd, 11)/vpa(R6, 11)) - v8 == 0
yes6 = v2*vpa(Kb, 11) - (vpa(Kb, 11) + 1/vpa(R5, 11))*v5 + v6*(1/vpa(R5, 11) + vpa(2*pi*j)*f*vpa(C, 11)) - v8*(vpa(2*pi*j)*f*vpa(C, 11)) == 0
yes7 = v7*(-1/vpa(R6, 11) - 1/vpa(R7, 11)) + v8/vpa(R7, 11) == vpa(0)

S = solve(yes1, yes2, yes3, yes4, yes5, yes6, yes7, v1, v2, v3, v5, v6, v7, v8)
T1 = simplify(S.v6/Vi) %transfer function for V6
T2 = simplify((S.v6 - S.v8)/Vi) %tranfer function for Vc
%Writting transfer functions to .tex file
fileID8 = fopen("Transfer.tex", "w")
chr = latex(T1)
fprintf(fileID8, "$$");
fprintf(fileID8, "%s", chr)
fprintf(fileID8, "$$\n");
chr = latex(T2)
fprintf(fileID8, "$$");
fprintf(fileID8, "%s", chr );
fprintf(fileID8, "$$\n");



%plotting transfer functions
%yes(f) = symfun(T2, f)
freq_1 = function_handle(T1) %'Real' matlab func from symfun
freq_2 = function_handle(T2) %'Real' matlab func from symfun


x = logspace(-4, 3);%generating values between values  1e-4 and 1e3 kHz !!!!

%Amplitude plots
hf = figure()

y = freq_1(x);
semilogx(x, 20*log10(abs(y)))
hold on
y = freq_2(x);
semilogx(x, 20*log10(abs(y)))
y = 1;
semilogx(x, 20*log10(abs(y)))
title("Signal Magnitude")
legend("abs(T(V6))", "abs(T(V6-V8))", "abs(T(vs))")
xlabel("kHz")
ylabel("V")
grid on
print (hf, "TransAbs.png");

%Phase (deg) plots
hf = figure()

y = freq_1(x);
semilogx(x, arg(y)*180/pi)
hold on
y = freq_2(x);
semilogx(x, arg(y)*180/pi)
y = 0;
semilogx(x, arg(y)*180/pi)
title("Signal Phase")
legend("arg(T(V6))", "arg(T(V6-V8))", "arg(T(vs))")
xlabel("kHz")
ylabel("degrees")
grid on
print (hf, "TransPha.png");
