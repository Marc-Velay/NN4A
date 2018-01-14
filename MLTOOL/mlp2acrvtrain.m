function [BW1,BB1,BW2,BB2,L,LR,LA,LV,W1,B1,W2,B2] = mlp2acrvtrain(Base, Target, BaseCrv, TargetCrv, W1, B1, W2, B2, arg9, arg10, arg11, arg12, arg13);
%
% MLP2ACRVTRAIN
%
% SYNTAXE :
%
% [BW1,BB1,BW2,BB2,L,LR,LA,LV,W1,B1,W2,B2] =mlp2acrvtrain(Base, Target, BaseCrv, TargetCrv, W1, B1, W2, B2 [, lr, n, err_glob, freqvalid] [, freqplot]);
%
% Apprentissage des poids d'un Percepteron MultiCouche par
% l'algorithme de rétropropagation (gradient total) et pas
% d'apprentissage adaptatif avec cross-validation.
%
% ARGUMENTS :
%
% Base   		: matrice des échantillons de la base d'apprentissage
% Target 		: matrice des vecteurs sorties désirées
% BaseCrv  		: matrice des échantillons de la base de validation
% TargetCrv		: matrice des vecteurs sorties désirées de la base de validation
% W1, B1 		: poids et seuils de la première couche
% W2, B2 		: poids et seuils de la deuxième couche
% lr     		: [optionnel] vecteur pas d'apprentissage adaptatif :
%					 		lr = [lr0 lr_dec, lr_inc, delta]
%          		lr0    : pas d'apprentissage initial
%          		lr_dec : valeur d'incrément du pas
%          		lr_inc : valeur de décrément du pas
%          		err_ratio : seuil de déclenchement du décrément
%
% n      		: [optionnel] nombre maximum d'itérations d'apprentissage
% err_glob 		: [optionnel] critère d'arret - seuil erreur quadratique minimum
% freqvalid     : [optionnel] fréquence de validation
% freqplot		: [optionnel] fréquence d'affichage, par défaut : pas d'affichage
%
%
% VALEURS DE RETOUR :
%
% BW1, BB1, BW2, BB2: les poids calculés à la meilleur validation
% L              	: coût quadratique incluant les phases d'adaptation
% LR				: valeurs du pas adaptatif
% LA                : coût quadratique sur la base d'apprentissage
% LV                : coût quadratique sur la base de validation
% W1, B1, W2, B2    : les poids calculés à l'issue de l'apprentissage
%
% DESCRIPTION :
%
% L'argument 'freqplot' est optionnel : s'il n'est pas donné, il n'y a pas
% d'affichage. S'il est donné, sa valeur donne le fréquence d'affichage
% de l'erreur quadratique et du pas adaptatif.
% Les arguments lr, n, err_glob et freqvalid sont également optionnels en bloc. S'ils ne sont
% pas donnés, la fonction interroge l'utilisateur.
% <LA> et <LV> comportent moins de points que <L> et <LR> qui prennent en compte
% les itérations d'adaptation du pas.
%
% COMPATIBILITE :
%
%  Matlab 5.3+
%

% Bruno Gas - LIS/P&C UPMC
% Création : 7 mai 2001
% Version : 1.3
% Derniere révision :  
% - B. Gas (16/10/2001) : E -> Ecrv pour le calcul de la 1ere err. de crv.
% - B. Gas (15/11/2001) : correction de multiples erreurs
% - R. Belaroussi (13/05/2004) : correction bug ligne 154 et 157

% controle des arguments :
%-------------------------

if ((nargin<12 & nargin~=8 & nargin ~=9) | nargin>13)
   error('[MLP2ACRVTRAIN] Usage : [BW1,BB1,BW2,BB2,L,LR,LA,LV,W1,B1,W2,B2] = mlp2acrvtrain(Base, Target, BaseCrv,TargetCrv,W1, B1, W2, B2 [, lr, n, err_glob,freqvalid] [, freqplot])');
end;

if nargin==8 | nargin==12, graph_mode = 0; %freqplot = n+1;	  % pas d'affichage par défaut
else 
   graph_mode = 1;
   if nargin==9, freqplot = arg9; else freqplot = arg13; end; % arg N. 7 = freq. d'affichage   
end;

if nargin==8 | nargin==9
   disp('MLP2ACRVTRAIN : Paramètres de l''apprentissage');
   n         = input('Nombre d''itérations d''apprentissage (1000) = ');
   err_glob  = input('Erreur minimale (critère d''arrêt) (0.001) = ');
   lr0       = input('Pas initial d''apprentissage (1) = ');
   lr_dec    = input('Décrément du pas (0.9) = ');
   lr_inc    = input('Incrément du pas (1.1) = ');
   err_ratio = input('Plage de stabilité du pas (1) = ');
   freqvalid = input('Fréquence de validation croisée (10) = '); 
   lr = [lr0 lr_dec, lr_inc, err_ratio];
else 
   lr = arg9; n = arg10; err_glob = arg11; freqvalid = arg12;
	if length(lr) ~= 4
   	error('[MLP2ACRVTRAIN] Arguments <lr> incorrecte (lr=[lr0, lr_dec, lr_inc, delta]'); 
	end;
end;


% Initialisation graphique :
%---------------------------
if graph_mode==1, clf; hold off;	end;


% nb. total d'exemples à apprendre :
%---------------------------------------
[input_nbr ex_nbr] = size(Base);
[inputcrv_nbr excrv_nbr] = size(BaseCrv);

% --- cohérence des arguments :
[n_cell n_in] = size(W1);
[output_nbr n_ex] = size(Target);
[outputcrv_nbr ans] = size(TargetCrv);

if input_nbr~=n_in
  error('[MLP2ACRVTRAIN] Défaut de cohérence dans les arguments : W1 et Data'); end;
if size(B1)~=[n_cell 1]
  error('[MLP2ACRVTRAIN] Défaut de cohérence dans les arguments : W1 et B1'); end;
if size(W2)~=[output_nbr n_cell]
  error('[MLP2ACRVTRAIN] Défaut de cohérence dans les arguments : W2 et Class'); end;
if size(B2)~=[output_nbr 1]
  error('[MLP2ACRVTRAIN] Défaut de cohérence dans les arguments : W2 et B2'); end;

% if inputcrv_nbr ~= input_nbr
%   error('[MLP2ACRVTRAIN] erreur : Les bases de validation et d''apprentissage n''ont pas meme dimension'); end;
% if outputcrv_nbr ~= output_nbr
%   error('[MLP2ACRVTRAIN] erreur : Les bases de validation et d''apprentissage n''ont pas meme dimension'); end;



% pas adaptatif :
%----------------
lr0 = lr(1);			% valeur initiale du pas
lr_dec = lr(2);			% décrément du pas
lr_inc = lr(3);			% incrément du pas
err_ratio = lr(4);		% seuil de déclenchement du décrément

% --- fonction cout quadratique :
L = zeros(1,n);
MaxL = ex_nbr*output_nbr;
MaxLA = MaxL; 
MaxLV = excrv_nbr*outputcrv_nbr; 

% Normalisations :
%-----------------
lr0 =lr0/MaxL;

% --- initialisation du pas :
lr = lr0;					
LR = zeros(1,n);

% initialisation des meilleurs poids :
%-------------------------------------
BW1 = W1; BB1 = B1; BW2 = W2; BB2 = B2;

%--- Erreur en validation :

V1 = W1*BaseCrv + B1*ones(1,excrv_nbr);%ex_nbr);   RB : modifified jeudi 13 mai 2004
S1 = sigmo(V1);

V2 = W2*S1 + B2*ones(1,excrv_nbr);%ex_nbr); RB : modifified jeudi 13 mai 200
S2 = sigmo(V2);

Ecrv  = TargetCrv - S2;
LV(1) = sumsqr(Ecrv)/MaxLV;
min_valid = LV(1);

% --- Erreur en sortie :

V1 = W1*Base + B1*ones(1,ex_nbr);
S1 = sigmo(V1);

V2 = W2*S1 + B2*ones(1,ex_nbr);
S2 = sigmo(V2);

E = Target - S2;
LA(1) = sumsqr(E)/MaxLA; 

% --- boucle d'apprentissage :
it_valid = 2;
for it=1:n

% --- Cout quadratique :	
	L(it) = sumsqr(E)/MaxL;
	LR(it) = lr;
   
% --- Affichage erreur et pas adaptatif :
	if rem(it,freqplot)==0   	   
    	   subplot(211);
	   semilogy(0:it-1, L(1:it));
	   grid;
   	xlabel('Itérations d''apprentissage');
	   ylabel('Erreur quadratique');
   	title('MLP 2 couches : Coût quadratique');
	   subplot(212);
   	semilogy(0:it-1, LR(1:it));
        grid;
	   xlabel('Itérations d''apprentissage');
   	ylabel('Valeur du pas adaptatif');   

		drawnow;
	end;

% --- Critère d'arret :
	if err_glob~=0 & L(it) <= err_glob
		L = L(1:it);
		LR = LR(1:it);
		return;
	end;	


% --- Adaptation du pas d'apprentissage :
  if it>1
 		if L(it) > TL*err_ratio

% --- Fonction Coût croissante au dela du seuil :

% --- Récupération des poids :
			W1 = TW1; B1 = TB1; W2 = TW2; B2 = TB2;

% --- décrémentation du pas et modif. des poids :
			lr = lr*lr_dec;

			W1 = W1 - lr*D1;
	 		B1 = B1 - lr*Delta1*ones(ex_nbr,1);
		  	W2 = W2 - lr*D2;
		 	B2 = B2 - lr*Delta2*ones(ex_nbr,1);
	
   	    else

% --- Fonction Coût décroissante :
			if L(it) < TL	

% --- incrémentation du lr :
				lr = lr*lr_inc;
	  		end

% --- rétropropagation :
			Delta2 = -2*E.*sigmop(V2);
			D2 = Delta2*S1';

			Delta1 = (W2'*Delta2).*sigmop(V1);
			D1 = Delta1*Base';

% --- Sauvegarde des poids courants et modif. des poids :
			TW1 = W1; TB1 = B1; TW2 = W2; TB2 = B2;
			TL = L(it);

	  		W1 = W1 - lr*D1;
		 	B1 = B1 - lr*Delta1*ones(ex_nbr,1);
		  	W2 = W2 - lr*D2;
	 		B2 = B2 - lr*Delta2*ones(ex_nbr,1);

%--- Erreur cross-validation :
            if rem(it_valid-1, freqvalid) ==0
                                
                V1 = W1*BaseCrv + B1*ones(1,excrv_nbr);
                S1 = sigmo(V1);

                V2 = W2*S1 + B2*ones(1,excrv_nbr);
                S2 = sigmo(V2);

                Ecrv  = TargetCrv - S2;
                LV(it_valid) = sumsqr(Ecrv)/MaxLV; 
                
%--- sauvegarde des meilleurs poids :
                if LV(it_valid) < min_valid
                    BW1 = W1; BB1 = B1; BW2 = W2; BB2 = B2;
                    min_valid = LV(it_valid);
                end;
            else
                LV(it_valid) = LV(it_valid-1);                
            end;
            LA(it_valid) = L(it);            
            it_valid = it_valid + 1;
            
        end
	else

% --- 1ere itération : pas de modification du lr :

% --- rétropropagation :
		Delta2 = -2*E.*sigmop(V2);
		D2 = Delta2*S1';

		Delta1 = (W2'*Delta2).*sigmop(V1);
		D1 = Delta1*Base';

% --- Sauvegarde des poids courants :
		TW1 = W1; TB1 = B1; TW2 = W2; TB2 = B2;
		TL = L(it);

% --- Modif. des poids :
	  	W1 = W1 - lr*D1;
	 	B1 = B1 - lr*Delta1*ones(ex_nbr,1);
	  	W2 = W2 - lr*D2;
	 	B2 = B2 - lr*Delta2*ones(ex_nbr,1);

	end

% --- erreur en sortie :
	V1 = W1*Base+B1*ones(1,ex_nbr);
	S1 = sigmo(V1);

	V2 = W2*S1+B2*ones(1,ex_nbr);
	S2 = sigmo(V2);

	E = Target - S2;			

end; %it


% Dénormalisation :
%------------------
LR = LR*MaxL;






