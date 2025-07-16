clear all;clc;

% Oustaloup's recursive filter is capable of producing a very good fitting
% to the fractional-order elements within a chosen frequency band.
% (s^a) where 0 <= a <= 1
% To allow for extended integral fractional order expressions,
% (s^-a) = (s^(1-a) / s) where -1 <= a <= 1

extendedA = 0.6; % fractional order
if extendedA >= 0
    alpha = extendedA;
else
    alpha = 1 + extendedA;
end
approxOrder = 3; % Approximation order
bottomFrequency = 0.01;
highFrequency = 100;
gainK = highFrequency^alpha;

%% Simplified Oustaloup Filter
% Baranowski, J., Bauer, W., Zagórowska, M., Dziwiński, T., & Piątek, P. (2015, August).
% Time-domain oustaloup approximation.
% In 2015 20th international conference on methods and models in automation and robotics (MMAR) (pp. 116-120). IEEE.
wu = (highFrequency/bottomFrequency)^0.5;
iterate = 1:approxOrder;
zeros = bottomFrequency*(wu).^((2*iterate-1-alpha)/(approxOrder));
poles = bottomFrequency*(wu).^((2*iterate-1+alpha)/(approxOrder));

TF1 = tf([1 zeros(1)],[1 poles(1)]);
TF2 = tf([1 zeros(2)],[1 poles(2)]);
TF3 = tf([1 zeros(3)],[1 poles(3)]);

if extendedA >= 0
    simpleOusta = gainK*TF1*TF2*TF3;
else
    simpleOusta = gainK*TF1*TF2*TF3*tf(1,[1 0]);
end
minreal(simpleOusta)

%% Oustaloup's Recursive Filter
% Oustaloup A., Levron F., Mathiew B., Nanot F.
% Frequency band complex noninteger differentiator: Characterization and synthesis.
% IEEE Transactions on Circuits and Systems I: Fundamental Theory and Applications, 2000, 47(1):25–39
iterate = -approxOrder:approxOrder;
oustaZeros = bottomFrequency*(highFrequency/bottomFrequency).^((iterate+approxOrder+0.5*(1-alpha))/(2*approxOrder+1));
oustaPoles = bottomFrequency*(highFrequency/bottomFrequency).^((iterate+approxOrder+0.5*(1+alpha))/(2*approxOrder+1));

TF1 = tf([1 oustaZeros(1)],[1 oustaPoles(1)]);
TF2 = tf([1 oustaZeros(2)],[1 oustaPoles(2)]);
TF3 = tf([1 oustaZeros(3)],[1 oustaPoles(3)]);
TF4 = tf([1 oustaZeros(4)],[1 oustaPoles(4)]);
TF5 = tf([1 oustaZeros(5)],[1 oustaPoles(5)]);
TF6 = tf([1 oustaZeros(6)],[1 oustaPoles(6)]);
TF7 = tf([1 oustaZeros(7)],[1 oustaPoles(7)]);

if extendedA >= 0
    ousta = gainK*TF1*TF2*TF3*TF4*TF5*TF6*TF7;
else
    ousta = gainK*TF1*TF2*TF3*TF4*TF5*TF6*TF7*tf(1,[1 0]);
end
minreal(ousta)

%% Refined Oustaloup Filter
% D. Xue, Y.Q. Chen, D.P. Atherton,
% Linear Feedback Control Analysis and Design with MATLAB,
% Advances in Design and Control, Siam, 2007.
b=10;
d=9;
iterate = -approxOrder:approxOrder;
refineZeros = (d*bottomFrequency/b).^((alpha-2*iterate)/(2*approxOrder+1));
refinePoles = (b*highFrequency/d).^((alpha+2*iterate)/(2*approxOrder+1));
refinedGainK = (d*highFrequency/b)^alpha;
quadraticTF = tf([d b*highFrequency 0],[d*(1-alpha) b*highFrequency d*alpha]);

TF1 = tf([1 refineZeros(1)],[1 refinePoles(1)]);
TF2 = tf([1 refineZeros(2)],[1 refinePoles(2)]);
TF3 = tf([1 refineZeros(3)],[1 refinePoles(3)]);
TF4 = tf([1 refineZeros(4)],[1 refinePoles(4)]);
TF5 = tf([1 refineZeros(5)],[1 refinePoles(5)]);
TF6 = tf([1 refineZeros(6)],[1 refinePoles(6)]);
TF7 = tf([1 refineZeros(7)],[1 refinePoles(7)]);

if extendedA >= 0
    refinedOusta = refinedGainK*quadraticTF*TF1*TF2*TF3*TF4*TF5*TF6*TF7;
else
    refinedOusta = refinedGainK*quadraticTF*TF1*TF2*TF3*TF4*TF5*TF6*TF7*tf(1,[1 0]);
end
minreal(refinedOusta)

%% Plotting
refInductor = tf([1 0],1);
refCapacitor = tf(1,[1 0]);
refResistor = tf(1,1);
if extendedA > 0
    bode(simpleOusta,ousta,refinedOusta,refInductor)
    figure;
    nyquist(simpleOusta,ousta,refinedOusta,refInductor)
elseif extendedA == 0
    bode(simpleOusta,ousta,refinedOusta,refResistor)
    figure;
    nyquist(simpleOusta,ousta,refinedOusta,refResistor)
else
    bode(simpleOusta,ousta,refinedOusta,refCapacitor)
    figure;
    nyquist(simpleOusta,ousta,refinedOusta,refCapacitor)
end