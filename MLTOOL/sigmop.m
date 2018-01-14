function S = sigmop(V)
%
% SYNTAXE :
%
% S = SIGMOP(V)
%
% Fonction sigmo�de d�riv�e. La fonction sigmo�de est la fonction de 
% transition utilis�e dans les r�seaux de neurones "perceptron multicouches".
%
% ARGUMENTS :
%
% V 	: argument de la fonction (variable "�tat" du neurone ou 
%       "potentiel de membrane").
%       Si V est un vecteur ou une matrice, la sortie est calcul�e sur toutes
%       les composantes du vecteur ou de la matrice.
%
% VALEURS DE RETOUR :
%
% S   : valeur de la fonction sigmo�de d�riv�e en V dans [0,+1]
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
% Cr�ation : octobre 1999
% Version 1.2
% Derniere r�vision :
%  - B.Gas (24/02/2001) : mise � jour tbx RdF
%  - B.Gas (27/11/2001) : m.a.j. help

if (nargin ~= 1),	error('[SIGMOP] erreur d''usage : S = sigmop(V)'); end;
  
x = sigmo(V);
S = 1 - x.*x;

