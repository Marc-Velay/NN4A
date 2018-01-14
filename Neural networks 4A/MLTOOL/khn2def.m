function Centres = khn2def (InputNbr, XCentreNbr, YCentreNbr, seed)
%
% KHN2DEF
% 
%  Définition d'un carte de Kohonen 2 dimensions
%
% 
% SYNTAXE :
%
%  Centres = khn2def (InputNbr, XCentreNbr, YCentreNbr [, seed])
%
%
% ARGUMENTS : 
%
%  InputNbr 	: nombre d'entrées (dimension du vecteur d'entrée)
%  XCentreNbr	: nombre de neurones dans la carte en abcisse
%  YCentreNbr  : nombre de neurones dans la carte en ordonnées
%  seed			: [optionnel] initialisation du générateur aléatoire
%
%
% VALEURS DE RETOUR :
%
%  Centres 		: vecteurs centres initialisés dans l'ordre
%                lignes après lignes de la carte
%                  
%
%
% DESCRIPTION :
%
%
% VOIR AUSSI :
%
%  KHN2TRAIN KHN2RUN  KHN1* 
%
%
% COMPATIBILITE : 
%
%  Matlab 5.3+

% KOHONEN2DEF
% Bruno Gas - LIS/P&C UPMC <gas@ccr.jussieu.fr>
% Création : 9 novembre 2000
% Version 1.1
% Dernieres révisions : 
% - B.Gas (27/1/2000) : révision tbx RdF
%

% controle des arguments :
if nargin==4
   rand('seed',seed);
elseif nargin~=3
   error('KHN2DEF] usage: Centres = khn2def (InputNbr, XCentreNbr, YCentreNbr [, seed])');	  
end;

Centres = 2*rand(XCentreNbr*YCentreNbr,InputNbr)-1;
