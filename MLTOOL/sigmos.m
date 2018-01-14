function S = sigmos(V)
%
% SYNTAXE :
%
% S = SIGMOS(V)
%
% Fonction sigmoïde dérivée seconde. La fonction sigmoïde est la fonction de 
% transition utilisée dans les réseaux de neurones "perceptron multicouches".
%
% ARGUMENTS :
%
% V 	: argument de la fonction (variable "état" du neurone ou 
%       "potentiel de membrane").
%       Si V est un vecteur ou une matrice, la sortie est calculée sur toutes
%       les composantes du vecteur ou de la matrice.
%
% VALEURS DE RETOUR :
%
% S   : valeur de la fonction sigmoïde dérivée seconde en V dans [-1,+1]
%        
%
% COMPATIBILITE :
%
%    Matlab 4.3+, Octave 2.x+ 
%
% VOIR AUSSI :
%
%    SIGMO, SIGMOP, MLP2LEARN, MLP2RUN, etc.
% 

% Bruno Gas - LIS/P&C UPMC
% Création : 27 novembre 2001
% Version 1.0
% Derniere révision : -

if (nargin ~= 1),	error('[SIGMOS] erreur d''usage : S = sigmos(V)'); end;
  
S = -2*sigmo(V).*sigmop(V);
