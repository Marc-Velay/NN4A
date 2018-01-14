function Base = baseunit(Base);
%
% BASEUNIT
%
% SYNTAXE :
%
% Base = BASEUNIT(Base)
%
% BASEUNIT calcul la base "norm�e", i.e. norme tous les vecteurs de la base :
% v -> v/norm(v); Les exemples deviennent tous des vecteurs unitaires.
%
% ARGUMENTS :
%
% Base	   : la base RdF � normaliser (exemples sans les labels)
%
% VALEURS DE RETOUR :
%
% Base	: la nouvelle base RdF norm�e
%          
%
% VOIR AUSSI :
%
%   NORM  BASESIZE  BASE2LABEL  BASE2TARGET, etc.  
%
%
% COMPATIBILITE : 
%   >= matlab 5.1, octave 2.0
%

% Bruno Gas - LIS/P&C UPMC
% Cr�ation : 27 octobre 2000
% version : 1.1
% Derniere r�vision : 
%  - B.Gas (24/01/2001) : ~

if nargin~=1, error('Base = BASEUNIT(Base)'); end;

[ExSize, ExNbr] = size(Base);
for i=1:ExNbr
	Base(:,i) = Base(:,i)/norm(Base(:,i));   
end;


