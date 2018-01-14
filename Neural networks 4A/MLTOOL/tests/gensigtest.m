
% tests générateur de signaux

clear;


% génération d'une base de signaux :
%-----------------------------------

Fe = 1000;
N = 256;
Freq = [10 20 30 40 50 60 70 80 90 100 110 120 130 140 150];
Phase = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
Nbr = 1;
Rsb = 50;

freq_nbr = length(Freq);
sig_nbr = Nbr*freq_nbr;
Base=gensig(Fe,Freq,Nbr,N,Rsb,Phase);
[Base Target] = base2target(Base);
Base = Base*0.8;

for i=1:sig_nbr
	plot(Base(:,i));
	pause;
end;


%Base = Base + (rand(size(Base))*2-1)/2;

