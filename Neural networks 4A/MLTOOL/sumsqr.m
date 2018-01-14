function s = sumsqr(a)
%
%
% SUMSQR
%
% SYNTAXE :
%
%  s = SUMSQR(a)
%
% Norme au carr� du vecteur a. Utilis� par les algorithmes
% d'apprentissage des r�seaux MLP pour calculer l'erreur quadratique   
%
%
% ARGUMENTS :
%
% a  : le vecteur ou la matrice de vecteurs
%
% VALEURS DE RETOUR :
%
% s  : norme au carr� de a ou des vecteurs composant a
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
% Cr�ation : <= 1996
% version : 1.0
% Derniere r�vision : -

s = sqrt(sum(sum(a.*a)));
