function [W1, B1, W2, B2, InputNbr, HcellNbr, OutputNbr] = probmlp2def (arg1, arg2, arg3, arg4)

% usage: [W1, B1, W2, B2 [, InputNbr, HcellNbr, OutputNbr]] 
%               = probmlp2def ([InputNbr, HcellNbr, OutputNbr] [, seed])
%
% Définition de la structure d'un réseau MLP 2 couches à sorties probabilités.
%
% PROBMLP2DEF permet de définir la structure d'un réseau de neurones
% MLP à deux couches cachées (Multi Layer Perceptron) et sorties probabilités en fonction des
% paramètres souhaités : nombre d''entrées, de cellules cachées et
% nombre de sorties. Les poids sont générées avec des valeurs aléatoires.
% La structure générée est identique à celle d'un réseau MLP 2 couches.
%
%
% ARGUMENTS : [requis mais optionnels]
%
% InputNbr 	= nombre d'entrées
% HcellNbr  = nombre de cellules sur la couche cachée
% OutputNbr = nombre de sorties
%
% ARGUMENTS : [optionnels]
% seed      = valeur d'initialisation du générateur aléatoire
%
% VALEURS DE RETOUR :
%
% W1      	: matrice des poids première couche
% B1      	: vecteur des seuils première couche
% W2      	: matrice des poids deuxième couche
% B2      	: vecteur des seuils deuxième couche
%
% VALEURS DE RETOUR [optionnelles] :
%
% InputNbr 	= nombre d'entrées
% HcellNbr  = nombre de cellules sur la couche cachée
% OutputNbr = nombre de sorties
%
% DESCRIPTION :
%
% voir MLP2DEF pour plus de précisions.
%
% VOIR AUSSI :
%
%  mlp2def, randweights,  probmlp2train,  probmlp2run,  probmlpclass
%


% PROBMLP2DEF
% Bruno Gas - LIS/P&C UPMC <gas@ccr.jussieu.fr>
% Création : 17 mars 2001
% Version : 1.0
% Dernieres révisions : -
%


switch nargin
case 0, [W1, B1, W2, B2, InputNbr, HcellNbr, OutputNbr] = mlp2def;
case 1, [W1, B1, W2, B2, InputNbr, HcellNbr, OutputNbr] = mlp2def(arg1);
case 3, [W1, B1, W2, B2, InputNbr, HcellNbr, OutputNbr] = mlp2def(arg1, arg2, arg3);
case 4, [W1, B1, W2, B2, InputNbr, HcellNbr, OutputNbr] = mlp2def(arg1, arg2, arg3, arg4);
otherwise
    error('[PROBMLP2DEF] Usage : [W1, B1, W2, B2, InputNbr, HcellNbr, OutputNbr] = probmlp2def ([InputNbr, HcellNbr, OutputNbr] [, seed]);');
end;
	

