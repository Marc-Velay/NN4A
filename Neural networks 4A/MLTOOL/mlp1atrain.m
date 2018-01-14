function [W1,B1,L,LR] = mlp1atrain(Base, Target, W1, B1, lr, n, err_glob, freqplot);
%
% MLP1ATRAIN
%
% SYNTAXE :
%
% [W1,B1,L,LR]=mlp1atrain(Base, Target, W1, B1 [,lr, n, err_glob] [, freqplot]);
%
% Apprentissage des poids d'un Perceptron (sans couche cach�e) par
% l'algorithme de r�tropropagation (gradient total) et pas adaptatif.
% L'affichage de l'erreur quadratique est en option.
%
% ARGUMENTS :
%
% Base   	: matrice des �chantillons de la base d'apprentissage
% Target 	: matrice des vecteurs sorties d�sir�es
% W1, B1 	: poids et seuils de la premi�re couche
% lr     	: [optionnel] vecteur pas d'apprentissage adaptatif :
%					lr = [lr0 lr_dec, lr_inc, delta]
%          		lr0    : pas d'apprentissage initial
%          		lr_dec : valeur d'incr�ment du pas
%          		lr_inc : valeur de d�cr�ment du pas
%          		err_ratio : seuil de d�clenchement du d�cr�ment
%
% n      	: [optionnel] nombre maximum d'it�rations d'apprentissage
% err_glob 	: [optionnel] crit�re d'arret - seuil erreur quadratique minimum
% freqplot	: [optionnel] fr�quence d'affichage, par d�faut : pas d'affichage
%
%
% DESCRIPTION : -
%   La fonction normalise le pas adaptatif initial lr0 par rapport
%   au nombre d'exemples et au nombre de sorties du r�seau :
%   lr0 -> lr0/OutputNbr/ExNbr.
%   Les valeurs retourn�es par la fonction sont d�normalis�es :
%   LR -> LR*OutputNbr*ExNbr.
%
% VALEURS DE RETOUR :
%
% W1, B1    : les poids calcul�s � l'issue de l'apprentissage
% L         : co�t quadratique
% LR			: valeurs du pas adaptatif
%
% COMPATIBILITE :
%
%   Matlab 4.3+, Octave 2.0+
%


% Bruno Gas - LIS/P&C UPMC
% Cr�ation : octobre 2000
% Version : 1.2
% Derniere r�vision :  
%  - B.Gas (10/02/2001) : help et mise � jour tbx RdF
%  - B.Gas (19/11/2002) : pbm. ctrl des arguments

% --- Controle des arguments :

if (nargin<7 & nargin~=4 & nargin~=5) | nargin>8,  
   error('[MLP1ATRAIN] Usage : [W1,B1,L,LR] = mlp1atrain(Base, Target, W1, B1 [, lr, n, err_glob] [, freqplot])');   
end;
if nargin==4 | nargin==7, graph_mode = 0; freqplot = n+1;	% pas d'affichage par d�faut
else graph_mode = 1;
   if nargin==5, freqplot = lr; end;                        % arg N. 5 = freq. d'affichage   
end;

if nargin<7
   disp('MLP1ATRAIN : Param�tres de l''apprentissage');
   n         = input('Nombre d''it�rations d''apprentissage (1000) = ');
   err_glob  = input('Erreur minimale (crit�re d''arr�t) (0.001) = ');
   lr0       = input('Pas initial d''apprentissage (1) = ');
   lr_dec    = input('D�cr�ment du pas (0.9) = ');
   lr_inc    = input('Incr�ment du pas (1.1) = ');
   err_ratio = input('Plage de stabilit� du pas (1) = ');
       
else
   if length(lr) ~= 4
      error('[MLP1ATRAIN] Arguments <lr> incorrecte (lr=[lr0, lr_dec, lr_inc, delta]');
   else
		lr0 = lr(1);				% valeur initiale du pas
		lr_dec = lr(2);			% d�cr�ment du pas
		lr_inc = lr(3);			% incr�ment du pas
		err_ratio = lr(4);		% seuil de d�clenchement du d�cr�ment      
	end;
end;

% Initialisation graphique :
%---------------------------
if graph_mode==1, clf; hold off;	end;

% --- nb. total d'exemples � apprendre :
[input_nbr ex_nbr] = size(Base);

% --- coh�rence des arguments :
[n_cell n_in] = size(W1);
[output_nbr n_ex] = size(Target);

if input_nbr~=n_in
	error('[MLP1ATRIN] D�faut de coh�rence dans les arguments : W1 et Base'); end;
if size(B1)~=[n_cell 1]
	error('[MLP1ATRAIN] D�faut de coh�rence dans les arguments : W1 et B1'); end;  
if output_nbr ~= n_cell, 
   error('[MLP1ATRAIN] dimensions de <Target> et <W1> incoh�rentes'); end;


% --- fonction cout quadratique :
L = zeros(1,n);
MaxL = ex_nbr*output_nbr;

% Normalisations :
%-----------------
lr0 =lr0/MaxL;

% --- initialisation du pas :
lr = lr0;					
LR = zeros(1,n);


% --- Erreur en sortie :

V1 = W1*Base+B1*ones(1,ex_nbr);
S1 = sigmo(V1);
E = Target - S1;

% --- boucle d'apprentissage :

for it=1:n
   
% --- Cout quadratique :   
	L(it) = sumsqr(E)/MaxL;
	LR(it) = lr;
      
% --- Affichage erreur et pas adaptatif :
	if rem(it,freqplot)==0   	   
    	   subplot(211);
	   semilogy(0:it-1, L(1:it));
	   grid;
   	xlabel('It�rations d''apprentissage');
	   ylabel('Erreur quadratique');
   	title('MLP 1 couches : Co�t quadratique');
	   subplot(212);
   	semilogy(0:it-1, LR(1:it));
      grid;
	   xlabel('It�rations d''apprentissage');
   	ylabel('Valeur du pas adaptatif');   

		drawnow;
	end;
      
% --- Crit�re d'arret :
	if err_glob~=0 & L(it) <= err_glob
		L = L(1:it);
		LR = LR(1:it);
		return;
	end;	
   
% --- Adaptation du pas d'apprentissage :
	if it>1
  		if L(it) > TL*err_ratio

% --- Fonction Co�t croissante au dela du seuil :

% --- R�cup�ration des poids :
			W1 = TW1; B1 = TB1;

% --- d�cr�mentation du pas et modif. des poids :
			lr = lr*lr_dec;

			W1 = W1 - lr*D;
         B1 = B1 - lr*Delta*ones(ex_nbr,1);
      else

% --- Fonction Co�t d�croissante :
			if L(it) < TL	

% --- incr�mentation du lr :
				lr = lr*lr_inc;
	  		end

% --- r�tropropagation :
			Delta = -2*E.*sigmop(V1);
			D = Delta*Base';    

% --- Sauvegarde des poids courants et modif. des poids :
			TW1 = W1; TB1 = B1;
			TL = L(it);

	  		W1 = W1 - lr*D;
		 	B1 = B1 - lr*Delta*ones(ex_nbr,1);
		end
	else

% --- 1ere it�ration : pas de modification du lr :

% --- r�tropropagation :

		Delta = -2*E.*sigmop(V1);
		D = Delta*Base';    

% --- Sauvegarde des poids courants :
		TW1 = W1; TB1 = B1;
		TL = L(it);

% --- Modif. des poids :
	  	W1 = W1 - lr*D;
	 	B1 = B1 - lr*Delta*ones(ex_nbr,1);
 
	end

% --- erreur en sortie :
	V1 = W1*Base+B1*ones(1,ex_nbr);
	S1 = sigmo(V1);
	E  = Target - S1;			

end; %it
   
% D�normalisation :
%------------------
LR = LR*MaxL;

   






