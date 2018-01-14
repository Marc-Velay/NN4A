function Signal=sighamming(Signal);
%
% SIGHAMMING
%
% SYNTAXE :
%
% Signal = SIGHAMMING(Signal)
%
% Fen�trage de Hamming d'une matrice de signaux,
% en g�n�ral de parole.
%
%
%
% ARGUMENTS :
%
% Signal 	: le signal � fenetrer ou la matrice de signaux rang�s en lignes
%
% VALEURS DE RETOUR :
%
% Signal : signal ou matrice des signaux apr�s fen�trage de Hamming
%          (signaux rang�s en lignes).
%
% VOIR AUSSI :
%
%  SPEECHGET, SIGPREACC
%
% COMPATIBILITE : 
%   >= matlab 5.1, octave 2.0
%

% Bruno Gas - LIS/P&C UPMC
% Cr�ation : novembre 2004
% version : 1.0
% Derniere r�vision : -


[sig_nbr, sig_size] = size(Signal);

winhamming = hamming(sig_size)';
for i=1:sig_nbr
   Signal(i,:) = Signal(i,:).*winhamming;
end;
