function VBase = mat2vec(Base);
%
% usage: VBase = mat2vec(Base);
%
%	Transformation d'une matrice en vecteur
%
%
%
%
% ARGUMENTS :
%
% Base      = Matrice d'exemples ( ExDim x ExNbr )
% 
%
% VALEURS DE RETOUR :
%
%	VBase = vecteur de la matrice transformée
%
% DESCRIPTION :
%	Transformation d'une matrice en vecteur
%
% VOIR AUSSI :
%
%  commande matlab Vbase = Base(:)

% 
% 
% Mohamed Chetouani : 14 Mars 20001
% Création : 
% Version 1.0
% Dernieres révisions : -
%
%

[ExDim ExNbr] = size(Base);

VBase = reshape(Base,1,ExDim*ExNbr);
