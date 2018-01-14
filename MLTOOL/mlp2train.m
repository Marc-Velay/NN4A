function [W1,B1,W2,B2,L,HLayer] = mlp2train(Base, Target, W1, B1, W2, B2, lr, n, err_glob, freqplot);
%
% MLP2TRAIN
%
% SYNTAXE :
%
% [W1,B1,W2,B2,L [,HLayer]]=mlp2train(Base, Target, W1, B1, W2, B2, lr, n, err_glob [, freqplot]);
%
% Apprentissage des poids d'un Perceptron MultiCouche (une couche cach�e) par
% l'algorithme de r�tropropagation (gradient total).
% L'affichage de l'erreur quadratique est en option.
%
% ARGUMENTS :
%
% Base   	: matrice des �chantillons de la base d'apprentissage
% Target 	: matrice des vecteurs sorties d�sir�es
% W1, B1 	: poids et seuils de la premi�re couche
% W2, B2 	: poids et seuils de la deuxi�me couche
% lr     	: pas d'apprentissage
% n      	: nombre maximum d'it�rations d'apprentissage
% err_glob 	: crit�re d'arret - seuil erreur quadratique minimum
% freplot   : [optionnel] fr�quence d'affichage, par d�faut : pas d'affichage.
%
%
% DESCRIPTION : -
%
% Le pas d'apprentissage lr est normalis� par la fonction (lr->lr/OutputNbr/ExNbr).
%
% VALEURS DE RETOUR :
%
% W1, B1, W2, B2 : les poids calcul�s � l'issue de l'apprentissage
% L              : co�t quadratique
% HLayer         : la matrice des sorties des cellules de la couche cach�e
%                  pour tous les exemples
%
% COMPATIBILITE :
%
%   Matlab 4.3+, Octave 2.0+
%


% Bruno Gas - LIS/P&C UPMC
% Cr�ation : d�cembre 1999
% Version : 1.5
% Derniere r�vision : 
%  - B.Gas (octobre 2000) : portage Matlab
%  - B.Gas (26/10/2000) : semilogy
%  - B.Gas (27/11/2000) : normalisation du lr
%  - B.Gas (10/02/2001) : help et mise � jour tbx RdF 
%  - B.Gas (15/10/2004) : ajout retour �tat des cell. cach�es

% --- Controle des arguments :
if nargin<9 | nargin>10
   error('[MLP2TRAIN] Usage : [W1,B1,W2,B2,L] = mlp2train(Base, Target, W1, B1, W2, B2, lr, n, err_glob [, freqplot])');
end;
if nargin==9, freqplot = n+1;	      % pas d'affichage par d�faut
else clf, hold off; end;		      % initialisation graphique


% --- nb. total d'exemples � apprendre :
[input_nbr ex_nbr] = size(Base);

% --- coh�rence :
[n_cell n_in] = size(W1);
[output_nbr n_ex] = size(Target);

if input_nbr~=n_in
  error('[MLP2TRAIN] D�faut de coh�rence dans les arguments : W1 et Base'); end;
if size(B1)~=[n_cell 1]
  error('[MLP2TRAIN] D�faut de coh�rence dans les arguments : W1 et B1'); end;  
if size(W2)~=[output_nbr n_cell]
  error('[MLP2TRAIN] D�faut de coh�rence dans les arguments : W2 et Base'); end; 
if size(B2)~=[output_nbr 1]
  error('[MLP2TRAIN] D�faut de coh�rence dans les arguments : W2 et B2'); end; 


% --- fonction cout quadratique :
L = zeros(1,n);
MaxL = ex_nbr*output_nbr;

% Normalisations :
%-----------------
lr =lr/MaxL;

% --- apprentissage :

for it=1:n

%Sortie couche cach�e :
	V1 = W1*Base+B1*ones(1,ex_nbr);
	S1 = sigmo(V1);

%Sortie couche de sortie : 
	V2 = W2*S1+B2*ones(1,ex_nbr);
	S2 = sigmo(V2);
 
%Calcul de l'erreur : 
	E = Target - S2;
	Delta2 = -2*E.*sigmop(V2);
	D2 = Delta2*S1';    
     
%r�tropropagation :  
	Delta1 = (W2'*Delta2).*sigmop(V1);
	D1 = Delta1*Base';
  
%apprentissage :
	W1 = W1 - lr*D1;
	B1 = B1 - lr*Delta1*ones(ex_nbr,1);
	W2 = W2 - lr*D2;
	B2 = B2 - lr*Delta2*ones(ex_nbr,1);

%Cout quadratique :
	L(it) = sumsqr(E)/MaxL;
  
%Affichage erreur :
	if rem(it,freqplot)==0   	   
   	semilogy(0:it-1, L(1:it));    
	   grid;
   	xlabel('It�rations d''apprentissage');
	   ylabel('Erreur quadratique');
   	title('MLP 2 couches : Co�t quadratique');
	   drawnow;
	end;

% Crit�re d'arret :
	if err_glob ~= 0 & L(it) <= err_glob		
   	L  = L(1:it);
	   return;
	end;

end; %it

%Sortie couche cach�e :
if nargout==6
	V1 = W1*Base+B1*ones(1,ex_nbr);
	HLayer = sigmo(V1);
end;





