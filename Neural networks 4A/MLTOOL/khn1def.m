function Centres = khn1def (InputNbr, CentreNbr, seed)
%
% KOHONEN1DEF
% 
%  Définition d'un carte de Kohonen 1 dimension
%
% 
% SYNTAXE :
%
%  Centres = khn1def (InputNbr, CentreNbr [, seed])
%
%
% ARGUMENTS : 
%
%  InpuNbr 		: nombre d'entrées (dimension du vecteur d'entrée)
%  CentreNbr	: nombre de neurones dans la carte
%  seed			: [optionnel] initialisation du générateur aléatoire
%
%
% VALEURS DE RETOUR :
%
%  Centres 		: vecteurs centres initialisés
%
%
% DESCRIPTION :
%
%
% VOIR AUSSI :
%
%  KHN2DEF  KHN1TRAIN KHN1RUN 
%
%
% COMPATIBILITE : 
%
%  Matlab 5.3+

% KOHONEN1DEF
% Bruno Gas - LIS/P&C UPMC <gas@ccr.jussieu.fr>
% Création : 29 octobre 2000
% Version 1.1
% Dernieres révisions : -
% - B.Gas (27/1/2001) : mise à jour tbx RdF
%

% controle des arguments :
if nargin==3
   rand('seed',seed);
elseif nargin~=2
   error('[KHN1DEF] usage: Centres = khn1def (InputNbr, CentreNbr, seed)');	
end;

Centres = 2*rand(CentreNbr,InputNbr)-1;

