function [W1, B1, InputNbr, OutputNbr] = mlp1def (InputNbr, OutputNbr, seed)
%
% usage: [W1, B1 [, InputNbr, OutputNbr]] 
%               = mlp1def ([InputNbr, OutputNbr] [, seed])
%
% Définition de la structure d'un réseau perceptron 1 couche.
%
% MLP1DEF permet de définir la structure d'un réseau de neurones
% MLP à une couche (pas de couche cachée) en fonction des
% paramètres souhaités : nombre d''entrées et nombre de sorties.
% Les poids sont générées avec des valeurs aléatoires.
%
%
%
% ARGUMENTS : [requis mais optionnels]
%
% InputNbr 	= nombre d'entrées
% OutputNbr = nombre de sorties
%
% ARGUMENTS : [optionnels]
% seed      = valeur d'initialisation du générateur aléatoire
%
% VALEURS DE RETOUR :
%
% W1      	: matrice des poids
% B1      	: vecteur des seuils
%
% VALEURS DE RETOUR [optionnelles] :
%
% InputNbr 	= nombre d'entrées
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
% MLP1DEF utilise la fonction RANDWEIGHTS pour générer les poids.
%
% VOIR AUSSI :
%
% UIMLP1DEF  RANDWEIGHTS  MLP1TRAIN  MLP1RUN
%


% MLP1DEF
% Bruno Gas - LIS/P&C UPMC <gas@ccr.jussieu.fr>
% Création : octobre 2000
% Version 1.1
% Dernieres révisions : 
%  - B.Gas (9/02/2001) : mise à jour tbx RdF

% controle des arguments :
if nargin==1 | nargin >3
   error('[MLP1DEF] Usage : [W1, B1 [, InputNbr, OutputNbr]] = mlp1def ([InputNbr, OutputNbr] [, seed])');
end;	   

if nargin==1,   seed = InputNbr;
elseif nargin==0 | nargin==2,   seed = -1;  end;

if nargin==0 | nargin==1
   disp('Architecture du codeur réseau MLP 1 couche : ');
   InputNbr = input('Nombre d''entrées du réseau = ');
   OutputNbr = input('Nombre de sorties = ');
end;

if seed==-1	
	[W1,B1] = randweights(OutputNbr,InputNbr);
else
   [W1,B1] = randweights(OutputNbr,InputNbr,seed);
end;
	
W1 = W1/InputNbr ;
B1 = B1/InputNbr ;

disp(['Classifieur MLP 1 couche généré : [' num2str(InputNbr) ' x ' num2str(OutputNbr) ']']);	

