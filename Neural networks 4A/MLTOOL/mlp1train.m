function [W1,B1,L] = mlp1train(Base, Target, W1, B1, lr, n, err_glob, freqplot);
%
% MLP1TRAIN
%
% SYNTAXE :
%
% [W1,B1,L]=mlp1train(Base, Target, W1, B1, lr, n, err_glob [, freqplot]);
%
% Apprentissage des poids d'un Perceptron (sans couche cach�e) par
% l'algorithme de r�tropropagation (gradient total).
% L'affichage de l'erreur quadratique est en option.
%
% ARGUMENTS :
%
% Base   	: matrice des �chantillons de la base d'apprentissage
% Target 	: matrice des vecteurs sorties d�sir�es
% W1, B1 	: poids et seuils de la premi�re couche
% lr     	: pas d'apprentissage
% n      	: nombre maximum d'it�rations d'apprentissage
% err_glob 	: crit�re d'arret - seuil erreur quadratique minimum
% freplot   : [optionnel] fr�quence d'affichage, par d�faut : pas d'affichage.
%
%
% DESCRIPTION : -
%
% Le pas d'apprentissage lr est normalis� par rapport au nombre d'exemples
% et au nombre de sorties du r�seau par la fonction (lr -> lr/OutputNbr/ExNbr).
% 
%
% VALEURS DE RETOUR :
%
% W1, B1    : les poids calcul�s � l'issue de l'apprentissage
% L         : co�t quadratique
%
%
% COMPATIBILITE :
%
%   Matlab 4.3+, Octave 2.0+
%
% VOIR AUSSI :
%
%   mlp1atrain, mlp1def, mlp1run, mlpclass, mlp2train, etc.
%

% Bruno Gas - LIS/P&C UPMC
% Cr�ation : octobre 2000
% Version : 1.3
% Derniere r�vision : 
%  - B. Gas (26/10/2000) : semilogy
%  - B. Gas (27/11/2000) : normalisation du lr 
%  - B. Gas (10/02/2001) : help et mise � jour tbx RdF


% --- Controle des arguments :
if nargin<7 | nargin>8,     
   error('[MLP1TRAIN] Usage : [W1,B1,L] = mlp1train(Base, Target, W1, B1, lr, n, err_glob [, freqplot])');
elseif nargin==7
   freqplot = n+1;	% pas d'affichage par d�faut
else
   clf, hold off;		% initialisation graphique
end;


% --- nb. total d'exemples � apprendre :
[input_nbr ex_nbr] = size(Base);

% --- coh�rence :
[n_cell n_in] = size(W1);
[output_nbr n_ex] = size(Target);

if input_nbr~=n_in
  	error('[MLP1TRAIN] D�faut de coh�rence dans les arguments : W1 et Base'); end;
if size(B1)~=[n_cell 1]
  	error('[MLP1TRAIN] D�faut de coh�rence dans les arguments : W1 et B1'); end;
if output_nbr ~= n_cell, 
	error('[MLP1TRAIN] erreur dans les arguments : dim. de <Target> et <W1> incoh�rentes'); end;



% --- fonction cout quadratique :
L = zeros(1,n);
MaxL = ex_nbr*output_nbr;

% --- normalisation du lr :
lr= lr/MaxL;

% --- apprentissage :

for it=1:n

%Sortie couche cach�e :
V1 = W1*Base+B1*ones(1,ex_nbr);
S1 = sigmo(V1);

%Calcul de l'erreur : 
E = Target - S1;
Delta = -2*E.*sigmop(V1);
D = Delta*Base';    

%apprentissage :
W1 = W1 - lr*D;
B1 = B1 - lr*Delta*ones(ex_nbr,1);

%Cout quadratique :
L(it) = sumsqr(E)/MaxL;
  
%Affichage erreur :
if rem(it,freqplot)==0   	   
   semilogy(0:it-1, L(1:it));    
   grid;
   xlabel('It�rations d''apprentissage');
   ylabel('Erreur quadratique');
   title('MLP 1 couche : Co�t quadratique');
   drawnow;
end;

% Crit�re d'arret :
if err_glob ~= 0 & L(it) <= err_glob		
   L = L(1:it);
   return;
end;

end; %it
	
