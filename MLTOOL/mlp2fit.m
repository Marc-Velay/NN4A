function [out1, out2, out3, out4] = mlp2fit(in1, in2, in3, in4, in5, in6, in7);
%
% MLP2FIT
%
% SYNTAXE :
%
% [W1,B1,W2,B2] = mlp2fit(X, Y, N [,err]);
% Y = mlp2fit(W1, B1, W2, B2, X [,Ymin, Ymax]);
% 
% mlp2fit(X, Y, N) calcul les poids d'un r�seau 
% de neurones R � deux couches et � N cellules sur la couche cach�e, 
% qui 'fit' les donn�es Y ~= R(X). L'algorithme de r�tropropagation 
% est utilis� pour la minimisation de la fonction de co�t quadratique.
%
% Y = mlp2fit(W1, B1, W2, B2, X [,Ymin, Ymax]) calcule la ou les valeurs 
% du r�seau R pour une ou plusieurs valeurs X.
%
% ARGUMENTS :
%
% X   		: matrice des donn�es rang�es en vecteurs colonnes
% Y      	: vecteur des sorties
% N			: nombre de cellules de la couche cach�e
% W1, B1 	: poids et seuils de la premi�re couche
% W2, B2 	: poids et seuils de la deuxi�me couche
% err 		: [OPTIONNEL] crit�re d'arret - seuil erreur quadratique minimum
% Ymin, Ymax: [OPTIONNEL] extrema de la fonction fit�e.
%
%
% VALEURS DE RETOUR :
%
% W1, B1, W2, B2 : les poids calcul�s � l'issue de l'apprentissage
% Y              : les valeurs estim�es du r�seau
%
%
% COMPATIBILITE :
%
%   Matlab 4.3+
%


% Bruno Gas - LISIF/PARC UPMC
% Cr�ation : 14/ avril 2001
% Version : 1.0
% Derniere r�vision : 

if nargin<5 & nargout ==4
   if nargin==3, err = 0.001; else, err = in4; end;
   X = in1; Y=in2; N = in3;   
   
   [InputNbr, ExNbr] = size(X);
   [Ydim, ans] = size(Y);
   if Ydim~=1
      error('[MLP2FIT] erreur : mlp2fit ne fit que des fonctions � valeurs scalaires');
   elseif ans~=ExNbr
      error('[MLP2FIT] erreur : X et Y doivent avoir m�me nombre d''�l�ments');
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

