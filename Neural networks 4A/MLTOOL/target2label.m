function Label = target2label(Target);
%
% TAGET2LABEL
%
% SYNTAXE :
%
% Label = target2label(Target)
%
% Construit le vecteur ds labels � partir de la matrice des cibles
% donn�e en argument.
%
% ARGUMENTS :
%
% Target : matrice des vecteurs cibles (en colonnes) � valeurs
%          binaires +1 ou -1. Chaque vecteur cible code un label
%          du vecteur Label. Les composantes sont � -1, sauf la
%          composante dont l'indice correspond au label � cod�
%          qui est � +1.
%
% VALEURS DE RETOUR :
%
% Label : vecteur des labels (rang de la composante � +1).
%
% COMPATIBILITE :
%
%   Matlab 5.3+, Octave 2.x+
%

% Bruno Gas - LIS/P&C UPMC
% Cr�ation : octobre 2000
% Version 1.2
% Derniere r�vision : 
%  - B.Gas (24/02/2001) : mise � jour tbx RdF
%  - B.Gas (15/11/2001) : correction du help 

[val Label] = max(Target);

