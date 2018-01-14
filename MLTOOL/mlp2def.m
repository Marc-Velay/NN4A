function [W1, B1, W2, B2, InputNbr, HcellNbr, OutputNbr] = mlp2def (InputNbr, HcellNbr, OutputNbr, seed)

% usage: [W1, B1, W2, B2 [, InputNbr, HcellNbr, OutputNbr]] 
%               = mlp2def ([InputNbr, HcellNbr, OutputNbr] [, seed])
%
% D�finition de la structure d'un r�seau MLP 2 couches.
%
% MLP2DEF permet de d�finir la structure d'un r�seau de neurones
% MLP � deux couches cach�es (Multi Layer Perceptron) en fonction des
% param�tres souhait�s : nombre d''entr�es, de cellules cach�es et
% nombre de sorties.
% Les poids sont g�n�r�es avec des valeurs al�atoires.
%
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
%
% Lorsqu'aucun argument n'est sp�cifi� ou que seul l'argument 'seed' l'est,
% l'utilisateur est sollicit� par la fonction pour donner les arguments
% optionnels mais requis.
% Les matrices de poids sont initialis�es al�atoirement. Si l'argument 'seed'
% est donn�, le g�n�rateur al�atoire est r�initialis� � cette valeur, sinon
% il n'est r�initialis�.
% MLP2DEF utilise la fonction RANDWEIGHTS pour g�n�rer les poids.
%
% VOIR AUSSI :
%
% RANDWEIGHTS  MLP2TRAIN  MLP2ATRAIN  MLP2RUN
%


% MLP2DEF
% Bruno Gas - LIS/P&C UPMC <gas@ccr.jussieu.fr>
% Cr�ation : mai 2000
% Version : 1.1
% Dernieres r�visions : 
%  - B.Gas (10/02/2001) : mise � jour tbx RdF
%


% controle des arguments :

if nargin==2 | nargin >4
   error('[MLP2DEF] Usage : [W1, B1, W2, B2] = mlp2def ([InputNbr, HcellNbr, OutputNbr] [, seed]);');   
end;

if nargin==1, seed = InputNbr;
elseif nargin==0 | nargin==3, seed = -1; end;

if nargin==0 | nargin==1
   disp('Architecture du r�seau MLP 2 couches : ');
   InputNbr  = input('Nombre d''entr�es du r�seau = ');
   HcellNbr  = input('Nombre de cellules cach�es = ');
   OutputNbr = input('Nombre de sorties = ');
end;

if seed==-1	
	[W1,B1] = randweights(HcellNbr,InputNbr);
	[W2,B2] = randweights(OutputNbr,HcellNbr);	
else
   [W1,B1] = randweights(HcellNbr,InputNbr,seed);
	[W2,B2] = randweights(OutputNbr,HcellNbr);	   
end;
	
disp(['Classifieur MLP 2 couches g�n�r� : [' num2str(InputNbr) ' x ' num2str(HcellNbr) ' x ' num2str(OutputNbr) ']']);	

