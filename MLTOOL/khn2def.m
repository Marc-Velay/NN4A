function Centres = khn2def (InputNbr, XCentreNbr, YCentreNbr, seed)
%
% KHN2DEF
% 
%  D�finition d'un carte de Kohonen 2 dimensions
%
% 
% SYNTAXE :
%
%  Centres = khn2def (InputNbr, XCentreNbr, YCentreNbr [, seed])
%
%
% ARGUMENTS : 
%
%  InputNbr 	: nombre d'entr�es (dimension du vecteur d'entr�e)
%  XCentreNbr	: nombre de neurones dans la carte en abcisse
%  YCentreNbr  : nombre de neurones dans la carte en ordonn�es
%  seed			: [optionnel] initialisation du g�n�rateur al�atoire
%
%
% VALEURS DE RETOUR :
%
%  Centres 		: vecteurs centres initialis�s dans l'ordre
%                lignes apr�s lignes de la carte
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
% Cr�ation : 9 novembre 2000
% Version 1.1
% Dernieres r�visions : 
% - B.Gas (27/1/2000) : r�vision tbx RdF
%

% controle des arguments :
if nargin==4
   rand('seed',seed);
elseif nargin~=3
   error('KHN2DEF] usage: Centres = khn2def (InputNbr, XCentreNbr, YCentreNbr [, seed])');	  
end;

Centres = 2*rand(XCentreNbr*YCentreNbr,InputNbr)-1;
