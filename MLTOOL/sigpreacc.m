function Signal=sigpreacc(Signal, fact_preacc);
%
% SIGPREACC
%
% SYNTAXE :
%
% Signal = SIGPREACC(Signal, fact_preacc)
%
% Pr�accentuation d'un signal ou d'une matrice de signaux,
% en g�n�ral de parole.
%
%
%
% ARGUMENTS :
%
% Signal 	: le signal � pr�accentuer
% fact_norm : le facteur de pr�accentuation
%
% VALEURS DE RETOUR :
%
% Signal : signal ou matrice des signaux pr�accentu�s
%          (signaux rang�s en ligne).
%
% VOIR AUSSI :
%
%  SPEECHGET, SIGNORM
%
% COMPATIBILITE : 
%   >= matlab 5.1, octave 2.0
%

% Bruno Gas - LIS/P&C UPMC
% Cr�ation : octobre 2000
% version : 1.2
% Derniere r�vision :
%  - B.Gas (25/11/2000) : �lim. discontinuit� 1er �chantillon
%  - B.Gas (24/02/2001) : mise � jour tbx RdF

[sig_nbr, sig_size] = size(Signal);

Signal = Signal - fact_preacc*[Signal(:,1)  Signal(:,1:sig_size-1)];

