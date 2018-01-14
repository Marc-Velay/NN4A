function [W1,B1,W2,B2,L] = probmlp2train(Base, Target, W1, B1, W2, B2, lr, n, err_glob, freqplot);
%
% PROBMLP2TRAIN
%
% SYNTAXE :
%
% [W1,B1,W2,B2,L]=probmlp2train(Base, Target, W1, B1, W2, B2, lr, n, err_glob [, freqplot]);
%
% Apprentissage des poids d'un Perceptron MultiCouche � sorties probabilit�s 
% (une couche cach�e) par l'algorithme de r�tropropagation (gradient total).
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
% Les fonctions de transition utilis�es sont, pour la couche cach�e la fonction 'sigmoide'
% et pour la couche de sortie la fonction 'softmax' qui permet d'interpr�ter les sorties
% en tant que probabilit�s (somme � 1).
% Les cibles (sorties d�sir�es) doivent �galement sommer � un !
%
% VALEURS DE RETOUR :
%
% W1, B1, W2, B2 : les poids calcul�s � l'issue de l'apprentissage
% L              : co�t quadratique
%
%
% COMPATIBILITE :
%
%   Matlab 4.3+, Octave 2.0+
%


% Bruno Gas - LIS/P&C UPMC <gas@ccr.jussieu.fr>
% Cr�ation : 17 mars 2001
% Version : 1.4
% Derniere r�vision : -

% --- Controle des arguments :
if nargin<9 | nargin>10
   error('[PROBMLP2TRAIN] Usage : [W1,B1,W2,B2,L] = probmlp2train(Base, Target, W1, B1, W2, B2, lr, n, err_glob [, freqplot])');
end;
if nargin==9, freqplot = n+1;	      % pas d'affichage par d�faut
else clf, hold off; end;		      % initialisation graphique


% --- nb. total d'exemples � apprendre :
[input_nbr ex_nbr] = size(Base);

% --- coh�rence :
[n_cell n_in] = size(W1);
[output_nbr n_ex] = size(Target);

if input_nbr~=n_in
  error('[PROBMLP2TRAIN] D�faut de coh�rence dans les arguments : W1 et Base'); end;
if size(B1)~=[n_cell 1]
  error('[PROBMLP2TRAIN] D�faut de coh�rence dans les arguments : W1 et B1'); end;  
if size(W2)~=[output_nbr n_cell]
  error('[PROBMLP2TRAIN] D�faut de coh�rence dans les arguments : W2 et Base'); end; 
if size(B2)~=[output_nbr 1]
  error('[PROBMLP2TRAIN] D�faut de coh�rence dans les arguments : W2 et B2'); end; 
if sum(sum(Target)~=1)~=0
  error('[PROBMLP2TRAIN] argument <Target> : les colonnes devraient sommer � 1 (probabilit�s)'); end;

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
S2 = softmax(V2);

%Calcul de l'erreur : 
E = Target - S2;
Delta2 = -2*(E.*(1-S2.*S2) - S2.*(ones(output_nbr,1)*sum(E.*S2) - E.*S2) ) ;
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
