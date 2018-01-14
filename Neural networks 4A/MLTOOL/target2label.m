function Label = target2label(Target);
%
% TAGET2LABEL
%
% SYNTAXE :
%
% Label = target2label(Target)
%
% Construit le vecteur ds labels à partir de la matrice des cibles
% donnée en argument.
%
% ARGUMENTS :
%
% Target : matrice des vecteurs cibles (en colonnes) à valeurs
%          binaires +1 ou -1. Chaque vecteur cible code un label
%          du vecteur Label. Les composantes sont à -1, sauf la
%          composante dont l'indice correspond au label à codé
%          qui est à +1.
%
% VALEURS DE RETOUR :
%
% Label : vecteur des labels (rang de la composante à +1).
%
% COMPATIBILITE :
%
%   Matlab 5.3+, Octave 2.x+
%

% Bruno Gas - LIS/P&C UPMC
% Création : octobre 2000
% Version 1.2
% Derniere révision : 
%  - B.Gas (24/02/2001) : mise à jour tbx RdF
%  - B.Gas (15/11/2001) : correction du help 

[val Label] = max(Target);

