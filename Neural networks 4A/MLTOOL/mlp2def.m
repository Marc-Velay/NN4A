function [W1, B1, W2, B2, InputNbr, HcellNbr, OutputNbr] = mlp2def (InputNbr, HcellNbr, OutputNbr, seed)

% usage: [W1, B1, W2, B2 [, InputNbr, HcellNbr, OutputNbr]] 
%               = mlp2def ([InputNbr, HcellNbr, OutputNbr] [, seed])
%
% Définition de la structure d'un réseau MLP 2 couches.
%
% MLP2DEF permet de définir la structure d'un réseau de neurones
% MLP à deux couches cachées (Multi Layer Perceptron) en fonction des
% paramètres souhaités : nombre d''entrées, de cellules cachées et
% nombre de sorties.
% Les poids sont générées avec des valeurs aléatoires.
%
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
%
% Lorsqu'aucun argument n'est spécifié ou que seul l'argument 'seed' l'est,
% l'utilisateur est sollicité par la fonction pour donner les arguments
% optionnels mais requis.
% Les matrices de poids sont initialisées aléatoirement. Si l'argument 'seed'
% est donné, le générateur aléatoire est réinitialisé à cette valeur, sinon
% il n'est réinitialisé.
% MLP2DEF utilise la fonction RANDWEIGHTS pour générer les poids.
%
% VOIR AUSSI :
%
% RANDWEIGHTS  MLP2TRAIN  MLP2ATRAIN  MLP2RUN
%


% MLP2DEF
% Bruno Gas - LIS/P&C UPMC <gas@ccr.jussieu.fr>
% Création : mai 2000
% Version : 1.1
% Dernieres révisions : 
%  - B.Gas (10/02/2001) : mise à jour tbx RdF
%


% controle des arguments :

if nargin==2 | nargin >4
   error('[MLP2DEF] Usage : [W1, B1, W2, B2] = mlp2def ([InputNbr, HcellNbr, OutputNbr] [, seed]);');   
end;

if nargin==1, seed = InputNbr;
elseif nargin==0 | nargin==3, seed = -1; end;

if nargin==0 | nargin==1
   disp('Architecture du réseau MLP 2 couches : ');
   InputNbr  = input('Nombre d''entrées du réseau = ');
   HcellNbr  = input('Nombre de cellules cachées = ');
   OutputNbr = input('Nombre de sorties = ');
end;

if seed==-1	
	[W1,B1] = randweights(HcellNbr,InputNbr);
	[W2,B2] = randweights(OutputNbr,HcellNbr);	
else
   [W1,B1] = randweights(HcellNbr,InputNbr,seed);
	[W2,B2] = randweights(OutputNbr,HcellNbr);	   
end;
	
disp(['Classifieur MLP 2 couches généré : [' num2str(InputNbr) ' x ' num2str(HcellNbr) ' x ' num2str(OutputNbr) ']']);	

