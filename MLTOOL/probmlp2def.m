function [W1, B1, W2, B2, InputNbr, HcellNbr, OutputNbr] = probmlp2def (arg1, arg2, arg3, arg4)

% usage: [W1, B1, W2, B2 [, InputNbr, HcellNbr, OutputNbr]] 
%               = probmlp2def ([InputNbr, HcellNbr, OutputNbr] [, seed])
%
% D�finition de la structure d'un r�seau MLP 2 couches � sorties probabilit�s.
%
% PROBMLP2DEF permet de d�finir la structure d'un r�seau de neurones
% MLP � deux couches cach�es (Multi Layer Perceptron) et sorties probabilit�s en fonction des
% param�tres souhait�s : nombre d''entr�es, de cellules cach�es et
% nombre de sorties. Les poids sont g�n�r�es avec des valeurs al�atoires.
% La structure g�n�r�e est identique � celle d'un r�seau MLP 2 couches.
%
%
% ARGUMENTS : [requis mais optionnels]
%
% InputNbr 	= nombre d'entr�es
% HcellNbr  = nombre de cellules sur la couche cach�e
% OutputNbr = nombre de sorties
%
% ARGUMENTS : [optionnels]
% seed      = valeur d'initialisation du g�n�rateur al�atoire
%
% VALEURS DE RETOUR :
%
% W1      	: matrice des poids premi�re couche
% B1      	: vecteur des seuils premi�re couche
% W2      	: matrice des poids deuxi�me couche
% B2      	: vecteur des seuils deuxi�me couche
%
% VALEURS DE RETOUR [optionnelles] :
%
% InputNbr 	= nombre d'entr�es
% HcellNbr  = nombre de cellules sur la couche cach�e
% OutputNbr = nombre de sorties
%
% DESCRIPTION :
%
% voir MLP2DEF pour plus de pr�cisions.
%
% VOIR AUSSI :
%
%  mlp2def, randweights,  probmlp2train,  probmlp2run,  probmlpclass
%


% PROBMLP2DEF
% Bruno Gas - LIS/P&C UPMC <gas@ccr.jussieu.fr>
% Cr�ation : 17 mars 2001
% Version : 1.0
% Dernieres r�visions : -
%


switch nargin
case 0, [W1, B1, W2, B2, InputNbr, HcellNbr, OutputNbr] = mlp2def;
case 1, [W1, B1, W2, B2, InputNbr, HcellNbr, OutputNbr] = mlp2def(arg1);
case 3, [W1, B1, W2, B2, InputNbr, HcellNbr, OutputNbr] = mlp2def(arg1, arg2, arg3);
case 4, [W1, B1, W2, B2, InputNbr, HcellNbr, OutputNbr] = mlp2def(arg1, arg2, arg3, arg4);
otherwise
    error('[PROBMLP2DEF] Usage : [W1, B1, W2, B2, InputNbr, HcellNbr, OutputNbr] = probmlp2def ([InputNbr, HcellNbr, OutputNbr] [, seed]);');
end;
	

