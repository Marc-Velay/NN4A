function S = softmaxp(V)
%
% SYNTAXE :
%
% S = SOFTMAX(V)
%
% Fonction sigmoïde logique à sorties probabilités dérivée.
% Fonction de transition utilisée dans les réseaux
% de neurones dont les sorties sont interprétées comme
% les probabilités conditionnelles (relativement à l'entrée)
% à postériori, d'appartenance à une classe.
% 
%
% ARGUMENTS :
%
% V 	: vecteur des potentiels des cellules de sortie du réseau.
%         Si V est une matrice, le calcul est fait par colonnes, considérant 
%         que chaque colonne correspond à un exemple à classer.
%
% VALEURS DE RETOUR :
%
% S   : valeur de la fonction sigmoïde logique probabiliste dérivée en V  
%        
%
% COMPATIBILITE :
%
%    Matlab 4.3+, Octave 2.x+ 
%
% VOIR AUSSI :
%
%    softmax,  sigmobl, sigmoblp,  sigmo,  sigmop
% 

% SOFTMAXP
% Création : Bruno Gas (15 mars 2001) 
% Version : 1.0
% Derniere révision : - 
    
x = softmax(V);
>>>>>>>>>>>>>>>>>>>>>>>>>>><
sv = sum(V)
x = exp(V);
y = sum(x);

[l ans] = size(V); 
S = x./(ones(l,1)*y);


