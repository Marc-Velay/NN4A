function S = softmax(V)
%
% SYNTAXE :
%
% S = SOFTMAX(V)
%
% Fonction sigmoïde logique à sorties probabilités.
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
%         Si V est une matrice ligne, le réseau ne comporte qu'une seule
%         sortie, donc une seule classe, et la probabilité en sortie est toujour à 1 (!)
%
% VALEURS DE RETOUR :
%
% S   : valeur de la fonction sigmoïde logique probabiliste en V dans [0,+1] 
%        
%
% COMPATIBILITE :
%
%    Matlab 4.3+, Octave 2.x+ 
%
% VOIR AUSSI :
%
%    softmaxp,  sigmobl, sigmoblp,  sigmo,  sigmop
% 

% SOFTMAX
% Création : Bruno Gas (15 mars 2001) 
% Version : 1.0
% Derniere révision : - 
    
ind = find(V>500);
if length(ind)>0, V(ind) = 500; end;

x = exp(V);
y = sum(x);

[l ans] = size(V); 
S = x./(ones(l,1)*y);


