function [W1, B1, InputNbr, OutputNbr] = mlp1def (InputNbr, OutputNbr, seed)
%
% usage: [W1, B1 [, InputNbr, OutputNbr]] 
%               = mlp1def ([InputNbr, OutputNbr] [, seed])
%
% D�finition de la structure d'un r�seau perceptron 1 couche.
%
% MLP1DEF permet de d�finir la structure d'un r�seau de neurones
% MLP � une couche (pas de couche cach�e) en fonction des
% param�tres souhait�s : nombre d''entr�es et nombre de sorties.
% Les poids sont g�n�r�es avec des valeurs al�atoires.
%
%
%
% ARGUMENTS : [requis mais optionnels]
%
% InputNbr 	= nombre d'entr�es
% OutputNbr = nombre de sorties
%
% ARGUMENTS : [optionnels]
% seed      = valeur d'initialisation du g�n�rateur al�atoire
%
% VALEURS DE RETOUR :
%
% W1      	: matrice des poids
% B1      	: vecteur des seuils
%
% VALEURS DE RETOUR [optionnelles] :
%
% InputNbr 	= nombre d'entr�es
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
% MLP1DEF utilise la fonction RANDWEIGHTS pour g�n�rer les poids.
%
% VOIR AUSSI :
%
% UIMLP1DEF  RANDWEIGHTS  MLP1TRAIN  MLP1RUN
%


% MLP1DEF
% Bruno Gas - LIS/P&C UPMC <gas@ccr.jussieu.fr>
% Cr�ation : octobre 2000
% Version 1.1
% Dernieres r�visions : 
%  - B.Gas (9/02/2001) : mise � jour tbx RdF

% controle des arguments :
if nargin==1 | nargin >3
   error('[MLP1DEF] Usage : [W1, B1 [, InputNbr, OutputNbr]] = mlp1def ([InputNbr, OutputNbr] [, seed])');
end;	   

if nargin==1,   seed = InputNbr;
elseif nargin==0 | nargin==2,   seed = -1;  end;

if nargin==0 | nargin==1
   disp('Architecture du codeur r�seau MLP 1 couche : ');
   InputNbr = input('Nombre d''entr�es du r�seau = ');
   OutputNbr = input('Nombre de sorties = ');
end;

if seed==-1	
	[W1,B1] = randweights(OutputNbr,InputNbr);
else
   [W1,B1] = randweights(OutputNbr,InputNbr,seed);
end;
	
W1 = W1/InputNbr ;
B1 = B1/InputNbr ;

disp(['Classifieur MLP 1 couche g�n�r� : [' num2str(InputNbr) ' x ' num2str(OutputNbr) ']']);	

