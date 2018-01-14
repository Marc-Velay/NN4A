function Signal=signorm(Signal, fact_norm);
%
% SIGNORM
%
% SYNTAXE :
%
% Signal = SIGNORM(Signal, fact_norm)
%
% Normalisation d'un signal ou d'une matrice de signaux
% (un signal par ligne).
%
%
% ARGUMENTS :
%
% Signal 	: le signal � normaliser
% fact_norm : le facteur de normalisation
%
% VALEURS DE RETOUR :
%
% Signal : signal ou matrice des signaux normalis�s
%
% VOIR AUSSI :
%
%
% COMPATIBILITE : 
%   >= matlab 5.1, octave 2.0
%

% Bruno Gas - LIS/P&C UPMC
% Cr�ation : octobre 2000
% version : 1.1
% Derniere r�vision : 
% - B.Gas (24/02/2001) : mise � jour tbx RdF

[sig_nbr, sig_size] = size(Signal);
maxSignal = max(abs(Signal'))' * ones(1,sig_size);
Signal = (Signal*fact_norm)./maxSignal;

%Signal = Signal*fact_norm/max(abs(Signal));

 
