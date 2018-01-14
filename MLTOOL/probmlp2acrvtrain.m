function [BW1,BB1,BW2,BB2,L,LR,LA,LV,W1,B1,W2,B2] = ...
            probmlp2acrvtrain(Base, Target, BaseCrv, TargetCrv, W1, B1, W2, B2, arg9, arg10, arg11, arg12, arg13);
%
%
%
% PROBMLP2ACRVTRAIN
%
% SYNTAXE :
%
% [BW1,BB1,BW2,BB2,L,LR,LA,LV,W1,B1,W2,B2] =
%            probmlp2acrvtrain(Base, Target, BaseCrv, TargetCrv, W1, B1, W2, B2 [, lr, n, err_glob, freqvalid] [, freqplot]);
%
% Apprentissage des poids d'un Perceptron MultiCouche � sorties probabilit�s 
% (une couche cach�e) par l'algorithme de r�tropropagation (gradient total
% avec pas adaptatif et cross-validation).
% L'affichage de l'erreur quadratique est en option.
% Contrairement au r�seau MLP classique, les sorties du r�seau PROBMLP sont 
% comprises entre 0 et 1 et correspondent (pour le crit�re erreur quadratique minimis�)
% aux probabilit�s � post�riori d'appartenance aux diff�rentes classes, conditionn�es
% par les entr�es (voir PROBMLPCLASS).
%
% ARGUMENTS :
%
% Base   	: matrice des �chantillons de la base d'apprentissage
% Target 	: matrice des vecteurs sorties d�sir�es
% BaseCrv  	: matrice des �chantillons de la base de cross-validation
% TargetCrv	: matrice des vecteurs sorties d�sir�es de cross-validation
% W1, B1 	: poids et seuils de la premi�re couche
% W2, B2 	: poids et seuils de la deuxi�me couche
% lr = [lr0 lr_dec, lr_inc, err_ratio] :
% lr0       : valeur initiale du pas d'apprentissage
% lr-dec    : d�cr�ment multiplicatif du pas d'apprentissage
% lr_inc    : incr�ment multiplicatif du pas d'apprentissage
% err_ratio : plage de stabilit� du pas d'apprentissage
% n      	: nombre maximum d'it�rations d'apprentissage
% err_glob 	: crit�re d'arret - seuil erreur quadratique minimum
% freqvalid : fr�quence de cross-validation
% freplot   : [optionnel] fr�quence d'affichage, par d�faut : pas d'affichage.
%
%
% DESCRIPTION : -
%
% Le pas d'apprentissage lr est normalis� par la fonction (lr->lr/OutputNbr/ExNbr).
% Les fonctions de transition utilis�es sont, pour la couche cach�e la fonction 'sigmoide'
% et pour la couche de sortie la fonction 'softmax' qui permet d'interpr�ter les sorties
% en tant que probabilit�s (somme � 1).
% Les cibles (sorties d�sir�es) doivent �galement sommer � un !
%
% VALEURS DE RETOUR :
%
% BW1, BB1, BW2, BB2: les poids calcul�s � la meilleur validation
% W1, B1, W2, B2    : les poids calcul�s � l'issue de l'apprentissage
% L                 : co�t quadratique incluant les phases d'adaptation
% LR				: valeurs du pas adaptatif
% LA                : co�t quadratique sur la base d'apprentissage
% LV                : co�t quadratique sur la base de validation
%
%
% COMPATIBILITE :
%
%   Matlab 4.3+, Octave 2.0+
%

% Bruno Gas - LISIF/PARC UPMC <gas@ccr.jussieu.fr>
% Cr�ation : 15 octobre 2001
% Version : 1.3
% Derniere r�vision : 
%  B. Gas (19/10/2001) : le pas adaptatif n'est plus affich� en �chelle log. 
%  B. Gas (15/11/2001) : am�lioration gestion des arguments
%  B. Gas (19/11/2004) : am�lioration du help

% --- Controle des arguments :
if ((nargin<12 & nargin~=8 & nargin ~=9) | nargin>13)
   error('[PROBMLP2ACRVTRAIN] Usage : [BW1,BB1,BW2,BB2,L,LR,LA,LV,W1,B1,W2,B2] = probmlp2acrvtrain(Base, Target, BaseCrv,TargetCrv,W1, B1, W2, B2 [, lr, n, err_glob,freqvalid] [, freqplot])');
end;

if nargin==8 | nargin==12, graph_mode = 0; freqplot = n+1;	  % pas d'affichage par d�faut
else 
   graph_mode = 1;
   if nargin==9, freqplot = arg9; else freqplot = arg13; end; % arg N. 7 = freq. d'affichage   
end;

if nargin==8 | nargin==9
   disp('PROBMLP2ACRVTRAIN : Param�tres de l''apprentissage');
   n         = input('Nombre d''it�rations d''apprentissage (1000) = ');
   err_glob  = input('Erreur minimale (crit�re d''arr�t) (0.001) = ');
   lr0       = input('Pas initial d''apprentissage (1) = ');
   lr_dec    = input('D�cr�ment du pas (0.9) = ');
   lr_inc    = input('Incr�ment du pas (1.1) = ');
   err_ratio = input('Plage de stabilit� du pas (1) = ');
   freqvalid = input('Fr�quence de validation crois�e (10) = '); 
   lr = [lr0 lr_dec, lr_inc, err_ratio];
else 
   lr = arg9; n = arg10; err_glob = arg11; freqvalid = arg12;
	if length(lr) ~= 4
   	error('[PROBMLP2ACRVTRAIN] Arguments <lr> incorrecte (lr=[lr0, lr_dec, lr_inc, delta]'); 
	end;
end;


% Initialisation graphique :
%---------------------------
if graph_mode==1, clf; hold off;	end;

% nb. total d'exemples � apprendre :
%-----------------------------------
[input_nbr ex_nbr] = size(Base);
[inputcrv_nbr excrv_nbr] = size(BaseCrv);

% coh�rence des arguments :
%--------------------------
[n_cell n_in] = size(W1);
[output_nbr n_ex] = size(Target);
[outputcrv_nbr ans] = size(TargetCrv);

if input_nbr~=n_in
  error('[PROBMLP2ACRVTRAIN] D�faut de coh�rence dans les arguments : W1 et Data'); end;
if size(B1)~=[n_cell 1]
  error('[PROBMLP2ACRVTRAIN] D�faut de coh�rence dans les arguments : W1 et B1'); end;
if size(W2)~=[output_nbr n_cell]
  error('[PROBMLP2ACRVTRAIN] D�faut de coh�rence dans les arguments : W2 et Class'); end;
if size(B2)~=[output_nbr 1]
  error('[PROBMLP2ACRVTRAIN] D�faut de coh�rence dans les arguments : W2 et B2'); end;
if inputcrv_nbr ~= input_nbr
  error('[PROBMLP2ACRVTRAIN] erreur : Les bases de validation et d''apprentissage n''ont pas meme dimension'); end;
if outputcrv_nbr ~= output_nbr
  error('[PROBMLP2ACRVTRAIN] erreur : Les bases de validation et d''apprentissage n''ont pas meme dimension'); end;
if sum(sum(Target)~=1)~=0
  error('[PROBMLP2TRAIN] argument <Target> : les colonnes devraient sommer � 1 (probabilit�s)'); end;
if sum(sum(TargetCrv)~=1)~=0
  error('[PROBMLP2TRAIN] argument <TargetCrv> : les colonnes devraient sommer � 1 (probabilit�s)'); end;

% pas adaptatif :
%----------------
lr0 = lr(1);			% valeur initiale du pas
lr_dec = lr(2);			% d�cr�ment du pas
lr_inc = lr(3);			% incr�ment du pas
err_ratio = lr(4);		% seuil de d�clenchement du d�cr�ment

% --- fonction cout quadratique :
L = zeros(1,n);
MaxL = ex_nbr*output_nbr;
MaxLA = MaxL; 
MaxLV = excrv_nbr*outputcrv_nbr; 

% Normalisations :
%-----------------
lr0 =lr0/MaxL;

% initialisation du pas :
%------------------------
lr = lr0;					
LR = zeros(1,n);

% initialisation des meilleurs poids :
%-------------------------------------
BW1 = W1; BB1 = B1; BW2 = W2; BB2 = B2;

% Erreur en validation :
%-----------------------
V1 = W1*BaseCrv + B1*ones(1,excrv_nbr);
S1 = sigmo(V1);

V2 = W2*S1 + B2*ones(1,excrv_nbr);
S2 = softmax(V2);

Ecrv  = TargetCrv - S2;
LV(1) = sumsqr(Ecrv)/MaxLV;
min_valid = LV(1);

% Erreur en sortie :
%-------------------
V1 = W1*Base + B1*ones(1,ex_nbr);
S1 = sigmo(V1);

V2 = W2*S1 + B2*ones(1,ex_nbr);
S2 = softmax(V2);

E = Target - S2;
LA(1) = sumsqr(E)/MaxLA; 

% boucle d'apprentissage :
%-------------------------
it_valid = 2;
for it=1:n

% Cout quadratique :	
%-------------------
	L(it) = sumsqr(E)/MaxL;
	LR(it) = lr;
   
% Affichage erreur et pas adaptatif :
%------------------------------------
	if rem(it,freqplot)==0   	   
        subplot(211);
        semilogy(0:it-1, L(1:it));
        grid;
        xlabel('It�rations d''apprentissage');
        ylabel('Erreur quadratique');
        title('MLP 2 couches : Co�t quadratique');
        subplot(212);
        plot(0:it-1, LR(1:it));
        grid;
        xlabel('It�rations d''apprentissage');
        ylabel('Valeur du pas adaptatif');   
        drawnow;
	end;

% Crit�re d'arret :
%------------------
	if err_glob~=0 & L(it) <= err_glob
		L = L(1:it);
		LR = LR(1:it);
		return;
	end;	

% Adaptation du pas d'apprentissage :
%------------------------------------
    if it>1
 		if L(it) > TL*err_ratio

% --- Fonction Co�t croissante au dela du seuil :
% --- R�cup�ration des poids :
			W1 = TW1; B1 = TB1; W2 = TW2; B2 = TB2;

% --- d�cr�mentation du pas et modif. des poids :
			lr = lr*lr_dec;

			W1 = W1 - lr*D1;
	 		B1 = B1 - lr*Delta1*ones(ex_nbr,1);
		  	W2 = W2 - lr*D2;
		 	B2 = B2 - lr*Delta2*ones(ex_nbr,1);
   	    else
            
% --- Fonction Co�t d�croissante :
			if L(it) < TL	

% --- incr�mentation du lr :
				lr = lr*lr_inc;
	  		end

% --- r�tropropagation :
         Delta2 = -2*(E.*(1-S2.*S2) - S2.*(ones(output_nbr,1)*sum(E.*S2) - E.*S2) );
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
                S2 = softmax(V2);

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
        
% --- 1ere it�ration : pas de modification du lr :
% --- r�tropropagation :
      Delta2 = -2*(E.*(1-S2.*S2) - S2.*(ones(output_nbr,1)*sum(E.*S2) - E.*S2) ) ;
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
	S2 = softmax(V2);

	E = Target - S2;			

end; %it

% D�normalisation :
%------------------
LR = LR*MaxL;

