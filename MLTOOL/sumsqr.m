function s = sumsqr(a)
%
%
% SUMSQR
%
% SYNTAXE :
%
%  s = SUMSQR(a)
%
% Norme au carré du vecteur a. Utilisé par les algorithmes
% d'apprentissage des réseaux MLP pour calculer l'erreur quadratique   
%
%
% ARGUMENTS :
%
% a  : le vecteur ou la matrice de vecteurs
%
% VALEURS DE RETOUR :
%
% s  : norme au carré de a ou des vecteurs composant a
%
%
% VOIR AUSSI :
%
%  mlpXXtrain  
%
% COMPATIBILITE : 
%   >= matlab 5.1
%

% LIS/P&C UPMC
% Création : <= 1996
% version : 1.0
% Derniere révision : -

s = sqrt(sum(sum(a.*a)));
