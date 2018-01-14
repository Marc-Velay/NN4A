function S = sigmo(V)
%
% SYNTAXE :
%
% S = SIGMO(V)
%
% Fonction sigmo�de, fonction de transition utilis�e dans les r�seaux
% de neurones "perceptron multicouches".
% La pente � l'origine est fix�e � 1 et n'est pas ajustable.
% 
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
% S   : valeur de la fonction sigmo�de en V dans [-1,+1]
%        
%
% COMPATIBILITE :
%
%    Matlab 4.3+, Octave 2.x+ 
%
% VOIR AUSSI :
%
%    sigmop,  sigmos, mlpXtrain,  mlp2Xtrain,  mlpXXrun,  etc.
% 

% Mathworks, toolbox neural networks
% Cr�ation : -
% Version : 1.2
% Derniere r�vision : - 
%  - B.Gas (octobre 1999) : import dans Tbx RdF
%  - B.gas (24/02/2001) : mise � jour tbx RdF

  
if (nargin ~= 1), error('[SIGMO] erreur d''usage : S = sigmo(V)'); end;
  
x = exp(2*V);
S = (x-1)./(x+1);

i = find(isnan(S));
j = length(i);
if length(i) > 0
  S(i) = ones(1,j);
end
  

