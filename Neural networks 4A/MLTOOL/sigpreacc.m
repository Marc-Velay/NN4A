function Signal=sigpreacc(Signal, fact_preacc);
%
% SIGPREACC
%
% SYNTAXE :
%
% Signal = SIGPREACC(Signal, fact_preacc)
%
% Préaccentuation d'un signal ou d'une matrice de signaux,
% en général de parole.
%
%
%
% ARGUMENTS :
%
% Signal 	: le signal à préaccentuer
% fact_norm : le facteur de préaccentuation
%
% VALEURS DE RETOUR :
%
% Signal : signal ou matrice des signaux préaccentués
%          (signaux rangés en ligne).
%
% VOIR AUSSI :
%
%  SPEECHGET, SIGNORM
%
% COMPATIBILITE : 
%   >= matlab 5.1, octave 2.0
%

% Bruno Gas - LIS/P&C UPMC
% Création : octobre 2000
% version : 1.2
% Derniere révision :
%  - B.Gas (25/11/2000) : élim. discontinuité 1er échantillon
%  - B.Gas (24/02/2001) : mise à jour tbx RdF

[sig_nbr, sig_size] = size(Signal);

Signal = Signal - fact_preacc*[Signal(:,1)  Signal(:,1:sig_size-1)];

