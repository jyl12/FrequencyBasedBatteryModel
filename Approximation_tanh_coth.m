% =========================================================================
% Script: Rational Approximation of tanh(x) and coth(x)
% =========================================================================
% Description:
% This script approximates the hyperbolic tangent (tanh) and hyperbolic
% cotangent (coth) functions using:
%   - Padé approximants (of orders [2/2], [3/2], [3/3], [4/4])
%   - Partial fraction approximations (2nd, 4th, 6th order)
% The approximations are expressed as transfer functions and can be
% analyzed via Bode plots (some are commented out).
%
% Applications include control systems, nonlinear modeling, and hardware-
% efficient implementations of tanh/coth in embedded systems.
%
% Assumption:
% x = sqrt(s); x^2 = s where s is Laplace.

%% --- Padé Approximants for tanh(x) ---
% tanh(x) = (e^x - e^(-x)) / (e^x + e^(-x))
% pade m/n based on https://en.wikipedia.org/wiki/Pad%C3%A9_table
% pade 2/2
% (144x+12x^3)/(144+60x^2+x^4)
% pade 3/2
% (7200x+768x^3+6*x^5)/(7200+3168*x^2+102*x^4)
% pade 3/3
% (14400x+1680x^3+24x^5)/(14400+6480x^2+264x^4+x^6)
% pade 4/3
% (1411200x+177600x^3+3600x^5+8x^7)/(141120+648000x^2+31440x^4+248x^6)
% pade 4/4
% 20(141120x+18480x^3+444x^5+2x^7)/((1680)^2+1310400^2+69360^4+760^6+x^8)

% Find tanh(x)/(x)
tanhpade22=tf([12 144],[1 60 144]);
tanhpade32=tf([6 768 7200],[102 3168 7200]);
tanhpade33=tf([24 1680 14400],[1 264 6480 14400]);
tanhpade43=tf([8 3600 177600 1411200],[248 31440 648000 1411200]);
tanhpade44=tf([20*2 20*444 20*18480 20*141120],[1 760 69360 1310400 1680^2]);

%% --- Padé Approximants for coth(x) ---
% Find coth(x)/(x)
cothpade22=tf([1 60 144],[12 144 0]);
cothpade32=tf([102 3168 7200],[6 768 7200 0]);
cothpade33=tf([1 264 6480 14400],[24 1680 14400 0]);
cothpade43=tf([248 31440 648000 1411200],[8 3600 177600 1411200 0]);
cothpade44=tf([2 1520 138720 2620800 2*1680^2],[40*2 40*444 40*18480 40*141120 0]);

%% --- Partial Fraction Approximations for tanh(x) ---
% tanh(x) = (e^x - e^(-x)) / (e^x + e^(-x))
% based on the following:
% https://functions.wolfram.com/ElementaryFunctions/Tanh/10/0001/
% https://varietyofsound.wordpress.com/2011/02/14/efficient-tanh-computation-using-lamberts-continued-fraction/
%
% 2nd order
% (15x+x^3)/(15+6x^2)
% 4th order
% (945x+105x^3+x^5)/(945+420x^2+15x^4)
% 6th order
% (135135x+17325x^3+378x^5+x^7)/(135135+62370x^2+3150x^4+28x^6)

% Find tanh(x)/(x)
tanhpartial2=tf([1 15],[6 15]);
tanhpartial4=tf([1 105 945],[15 420 945]);
tanhpartial6=tf([1 378 17325 135135],[28 3150 62370 135135]);

%% --- Partial Fraction Approximations for coth(x) ---
% Find coth(x)/(x)
cothpartial2=tf([6 15],[1 15 0]);
cothpartial4=tf([15 420 945],[1 105 945 0]);
cothpartial6=tf([28 3150 62370 135135],[1 378 17325 135135 0]);

%% Plotting
% figure
% bode(tanhpade22,tanhpade32,tanhpade33,tanhpade43,tanhpade44)
% figure
% bode(cothpade22,cothpade32,cothpade33,cothpade43,cothpade44)
% figure
% bode(tanhpade22,tanhpartial4);
% figure
% bode(tanhpade33,tanhpartial6);
% figure
% bode(cothpade22,cothpartial2);
% figure
% bode(cothpade33,cothpartial4);
% figure
% bode(cothpade44,cothpartial6);