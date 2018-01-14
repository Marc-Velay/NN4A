function [W1,B1,W2,B2,L,LR] = uimlp2atrain(Base, Target, W1, B1, W2, B2, lr, n, err_glob, freqplot);
%
% UIMLP2ATRAIN
%
% SYNTAXE :
%
% [W1,B1,W2,B2,L,LR]=uimlp2atrain(Base, Target, W1, B1, W2, B2 [, lr, n, err_glob] [, freqplot]);
%
% Apprentissage des poids d'un Percepteron MultiCouche par
% l'algorithme de rétropropagation (gradient total) et pas
% d'apprentissage adaptatif.
% Interface graphique de la fonction mlp2atrain
%
% ARGUMENTS :
%
% Base   		: matrice des échantillons de la base d'apprentissage
% Target 		: matrice des vecteurs sorties désirées
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
% freqplot		: [optionnel] fréquence d'affichage, par défaut : pas d'affichage
%
%
% VALEURS DE RETOUR :
%
% W1, B1, W2, B2 	: les poids calculés à l'issue de l'apprentissage
% L              	: coût quadratique
% LR					: valeurs du pas adaptatif
%
% DESCRIPTION :
%
% L'argument 'freqplot' est optionnel : s'il n'est pas donné, il n'y a pas
% d'affichage. S'il est donné, sa valeur donne le fréquence d'affichage
% de l'erreur quadratique et du pas adaptatif.
% Les arguments lr, n, et err_glob sont également optionnels en bloc. S'ils ne sont
% pas donnés, la fonction interroge l'utilisateur (interface graphique).
%
% COMPATIBILITE :
%
%  Matlab 5.3+
%

% Bruno Gas - LIS/P&C UPMC
% Création : 10 février 2001
% Version : 1.0
% Derniere révision : -

% Algorithme :
%
%	Wtmp <- W
%	calculer l'erreur de sortie avec W
%	calculer L
%
% a:  si k>1
%		  	si L < err_glob ,
%					sortir
%			fin si
%		 	si L(k) > TL*err_ratio
%			 		décrémenter lr
%			 		W <- Wtmp;
%		 			W <- W + lr*modif
%	     	sinon	
%					si L(k) < TL
%	  	 				incrémenter lr		
%     			fin si
%					Wtmp <- W
%   				rétropropager sur W (calculer modif)
%		 			W <- W + lr*modif
%					TL <- L(k)
%   		fin si
%     sinon
%   		rétropropager sur W (calculer modif)
%	      Wtmp <- W
%			W <- W + lr*modif
% 	    	TL <- L(k)
%    	fin si
%
% 		calculer l'erreur de sortie  avec W
% 		calculer L
% 		aller en a:
%


errorbox = 'mlp2atrain : Erreur';
warningbox = 'mlp2atrain : Warning';
usage = 'Usage : [W1,B1,W2,B2,L,LR] = uimlp2atrain(Base, Target, W1, B1, W2, B2 [, lr, n, err_glob] [, freqplot])';
 


% controle des arguments :
%-------------------------

if (nargin<9 | nargin>10) & nargin~=6 & nargin ~=7
   errordlg('Usage : [W1,B1,W2,B2,L,LR] = uimlp2atrain(Base, Target, W1, B1, W2, B2 [, lr, n, err_glob] [, freqplot])',...
      'Erreur dans uimlp2atrain');
   error;
end;

>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

if nargin==6 | nargin==9
   graph_mode = 0;
   freqplot = n+1;	% pas d'affichage par défaut
else
   graph_mode = 1;
   if nargin==7
      freqplot = lr; % arg N. 7 = freq. d'affichage
   end;   
end;



if nargin<9
   default={'1000','0.001','0.001','0.9','1.1','1'};
   prompt={	'Nombre d''itérations d''apprentissage :',...
            'Erreur minimale (critère d''arrêt) : ',...
         	'Pas initial d''apprentissage : ',...
         	'Décrément du pas : ',...
            'Incrément du pas : ',...
            'Plage de stabilité du pas : '...         
         };
	titre = 'MLP2ATRAIN : Paramètres de l''apprentissage';
   answer=inputdlg(prompt,titre,1,default);
   if isempty(answer)
      errordlg('Pas de réponse : échec',errorbox); return;
   end;
   n			= str2num(char(answer(1)));
   err_glob	= str2num(char(answer(2)));   
	lr0		= str2num(char(answer(3)));
   lr_dec	= str2num(char(answer(4)));
   lr_inc	= str2num(char(answer(5)));
   err_ratio= str2num(char(answer(6)));
   
   lr = [lr0 lr_dec, lr_inc, err_ratio];
elseif length(lr) ~= 4
   errordlg('Arguments <lr> incorrecte (lr=[lr0, lr_dec, lr_inc, delta]','errorbox');
	return;
end;

% Initialisation graphique :
%---------------------------
if graph_mode==1, clf; hold off;	end;



% nb. total d'exemples à apprendre :
%---------------------------------------
[input_nbr ex_nbr] = size(Base);


% --- cohérence des arguments :
[n_cell n_in] = size(W1);
if input_nbr~=n_in
  error('Défaut de cohérence dans les arguments : W1 et Data');
  return;
end;
if size(B1)~=[n_cell 1]
  error('Défaut de cohérence dans les arguments : W1 et B1');
  return;
end;
[output_nbr n_ex] = size(Target);
if size(W2)~=[output_nbr n_cell]
  error('Défaut de cohérence dans les arguments : W2 et Class');
  return;
end;
if size(B2)~=[output_nbr 1]
  error('Défaut de cohérence dans les arguments : W2 et B2');
  return;
end;



% pas adaptatif :
%----------------
lr0 = lr(1);				% valeur initiale du pas
lr_dec = lr(2);			% décrément du pas
lr_inc = lr(3);			% incrément du pas
err_ratio = lr(4);		% seuil de déclenchement du décrément

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

V2 = W2*S1+B2*ones(1,ex_nbr);
S2 = sigmo(V2);

E = Target - S2;


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






