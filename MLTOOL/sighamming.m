function Signal=sighamming(Signal);
%
% SIGHAMMING
%
% SYNTAXE :
%
% Signal = SIGHAMMING(Signal)
%
% Fenêtrage de Hamming d'une matrice de signaux,
% en général de parole.
%
%
%
% ARGUMENTS :
%
% Signal 	: le signal à fenetrer ou la matrice de signaux rangés en lignes
%
% VALEURS DE RETOUR :
%
% Signal : signal ou matrice des signaux après fenêtrage de Hamming
%          (signaux rangés en lignes).
%
% VOIR AUSSI :
%
%  SPEECHGET, SIGPREACC
%
% COMPATIBILITE : 
%   >= matlab 5.1, octave 2.0
%

% Bruno Gas - LIS/P&C UPMC
% Création : novembre 2004
% version : 1.0
% Derniere révision : -


[sig_nbr, sig_size] = size(Signal);

winhamming = hamming(sig_size)';
for i=1:sig_nbr
   Signal(i,:) = Signal(i,:).*winhamming;
end;
