function S = sigmop(V)
%
% SYNTAXE :
%
% S = SIGMOP(V)
%
% Fonction sigmoïde dérivée. La fonction sigmoïde est la fonction de 
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
% S   : valeur de la fonction sigmoïde dérivée en V dans [0,+1]
%        
%
% COMPATIBILITE :
%
%    Matlab 4.3+, Octave 2.x+ 
%
% VOIR AUSSI :
%
%    SIGMO, SIGMOS, MLP2LEARN, MLP2RUN, etc.
% 

% Bruno Gas - LIS/P&C UPMC
% Création : octobre 1999
% Version 1.2
% Derniere révision :
%  - B.Gas (24/02/2001) : mise à jour tbx RdF
%  - B.Gas (27/11/2001) : m.a.j. help

if (nargin ~= 1),	error('[SIGMOP] erreur d''usage : S = sigmop(V)'); end;
  
x = sigmo(V);
S = 1 - x.*x;

