function z = zerosig(s, winsize);
%
% ZEROSIG
%
% SYNTAXE :
%
% z = zerosig(s, winsize)
%
% Calcul du taux de passages par zéros d'un signal.
%
% ARGUMENTS :
%
% s    : signal
%
% winsize : taille de la fenêtre de calcul en nombre d'échantillons
%
% VALEURS DE RETOUR :
%
% z  : taux de passage par zéro
%
% COMPATIBILITE :
%
%   Matlab 5.3+
%

% Bruno Gas - UPMC LIS/P&C, <gas@ccr.jussieu.fr>
% Création : octobre 2004
% Derniere révision : 
% Version : 1.0
%

if nargin~=2
  error('[ZEROSIG] usage : z = zerosig(sig, winsize)');
end;

sigsize=length(s);

z = zeros(1,sigsize-winsize-1);
for i=1:sigsize-winsize-1
   z(i) = sum(abs(sign(s(i+1:i+1+winsize)) - sign(s(i:i+winsize))))/winsize;
end;


