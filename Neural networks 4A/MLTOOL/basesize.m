function [ExNbr, ExSize, ClassNbr] = basesize(Base);
%
% BASESIZE
%
% SYNTAXE :
%
% [ExNbr ExSize ClassNbr] = BASESIZE(BASE)
%
% Dimension d'une base d'exemple RdF
% (les exemples sont rangés en lignes avec leur label en 
% dernière colonne).
%
%
% ARGUMENTS :
%
% Base 	: la base d'exemples
%
% VALEURS DE RETOUR :
%
% ExNbr		: nombre d'échantillons (exemples) présents dans la base
% ExSize		: dimension en nombre de composantes des échantillons
% ClassNbr	: nombre total de classes d'appartenance
%
% VOIR AUSSI :
%
%  BASE2LABEL, BASENORM, etc.
%
% COMPATIBILITE : 
%   >= matlab 5.1, octave 2.0
%

% Bruno Gas - LIS/P&C UPMC
% Création : octobre 2000
% version : 1.1
% Derniere révision : 
%  - B. Gas (24/01/2004) : ~

[ExNbr ExSize] = size(Base);
ExSize = ExSize - 1;				% le label en moins
[Base Labels] = base2label(Base);
ClassNbr = max(Labels);



