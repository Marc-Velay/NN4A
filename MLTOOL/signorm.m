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
% Signal 	: le signal à normaliser
% fact_norm : le facteur de normalisation
%
% VALEURS DE RETOUR :
%
% Signal : signal ou matrice des signaux normalisés
%
% VOIR AUSSI :
%
%
% COMPATIBILITE : 
%   >= matlab 5.1, octave 2.0
%

% Bruno Gas - LIS/P&C UPMC
% Création : octobre 2000
% version : 1.1
% Derniere révision : 
% - B.Gas (24/02/2001) : mise à jour tbx RdF

[sig_nbr, sig_size] = size(Signal);
maxSignal = max(abs(Signal'))' * ones(1,sig_size);
Signal = (Signal*fact_norm)./maxSignal;

%Signal = Signal*fact_norm/max(abs(Signal));

 
