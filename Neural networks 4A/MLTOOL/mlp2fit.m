function [out1, out2, out3, out4] = mlp2fit(in1, in2, in3, in4, in5, in6, in7);
%
% MLP2FIT
%
% SYNTAXE :
%
% [W1,B1,W2,B2] = mlp2fit(X, Y, N [,err]);
% Y = mlp2fit(W1, B1, W2, B2, X [,Ymin, Ymax]);
% 
% mlp2fit(X, Y, N) calcul les poids d'un réseau 
% de neurones R à deux couches et à N cellules sur la couche cachée, 
% qui 'fit' les données Y ~= R(X). L'algorithme de rétropropagation 
% est utilisé pour la minimisation de la fonction de coût quadratique.
%
% Y = mlp2fit(W1, B1, W2, B2, X [,Ymin, Ymax]) calcule la ou les valeurs 
% du réseau R pour une ou plusieurs valeurs X.
%
% ARGUMENTS :
%
% X   		: matrice des données rangées en vecteurs colonnes
% Y      	: vecteur des sorties
% N			: nombre de cellules de la couche cachée
% W1, B1 	: poids et seuils de la première couche
% W2, B2 	: poids et seuils de la deuxième couche
% err 		: [OPTIONNEL] critère d'arret - seuil erreur quadratique minimum
% Ymin, Ymax: [OPTIONNEL] extrema de la fonction fitée.
%
%
% VALEURS DE RETOUR :
%
% W1, B1, W2, B2 : les poids calculés à l'issue de l'apprentissage
% Y              : les valeurs estimées du réseau
%
%
% COMPATIBILITE :
%
%   Matlab 4.3+
%


% Bruno Gas - LISIF/PARC UPMC
% Création : 14/ avril 2001
% Version : 1.0
% Derniere révision : 

if nargin<5 & nargout ==4
   if nargin==3, err = 0.001; else, err = in4; end;
   X = in1; Y=in2; N = in3;   
   
   [InputNbr, ExNbr] = size(X);
   [Ydim, ans] = size(Y);
   if Ydim~=1
      error('[MLP2FIT] erreur : mlp2fit ne fit que des fonctions à valeurs scalaires');
   elseif ans~=ExNbr
      error('[MLP2FIT] erreur : X et Y doivent avoir même nombre d''éléments');
   end;
   Ymin = min(Y); Ymax = max(Y);
   Y = Y - Ymin; Y = Y*1.6/(Ymax-Ymin) - 0.8;
   
   [W1, B1, W2, B2] = mlp2def(InputNbr, N, 1);
   lr = [1, 0.9, 1.1, 1.0];
 	[W1,B1,W2,B2] = mlp2atrain(X, Y, W1, B1, W2, B2, lr, 10000, err);
   out1=W1; out2=B1; out3=W2; out4=B2;
   return;
    
elseif nargin >=5 & nargout ==1
	W1=in1; B1=in2; W2=in3; B2=in4; X=in5;   
   [InputNbr, ExNbr] = size(X);
   [N, ans] = size(W1);
   if ans~=InputNbr
      error('[MLP2FIT] erreur dans les arguments : dimensions de X et W1 incoherentes');
   end;
   
   Y = mlp2run(X,W1,B1,W2,B2);
   if nargin==7
      Ymin=in6; Ymax=in7;
      Y = Y + 0.8; Y = Y*(Ymax-Ymin)/1.6 + Ymin;
   end;
   out1=Y;
   return;
   
else
   disp('[MLP2FIT] usage : [W1,B1,W2,B2] = mlp2fit(X, Y, N [,err]');
   disp('                  Y = mlp2fit(W1, B1, W2, B2, X [,Ymin, Ymax])');
   error(' ');
end;

