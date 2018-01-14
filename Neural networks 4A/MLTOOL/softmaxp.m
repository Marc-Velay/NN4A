function S = softmaxp(V)
%
% SYNTAXE :
%
% S = SOFTMAX(V)
%
% Fonction sigmo�de logique � sorties probabilit�s d�riv�e.
% Fonction de transition utilis�e dans les r�seaux
% de neurones dont les sorties sont interpr�t�es comme
% les probabilit�s conditionnelles (relativement � l'entr�e)
% � post�riori, d'appartenance � une classe.
% 
%
% ARGUMENTS :
%
% V 	: vecteur des potentiels des cellules de sortie du r�seau.
%         Si V est une matrice, le calcul est fait par colonnes, consid�rant 
%         que chaque colonne correspond � un exemple � classer.
%
% VALEURS DE RETOUR :
%
% S   : valeur de la fonction sigmo�de logique probabiliste d�riv�e en V  
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
% Cr�ation : Bruno Gas (15 mars 2001) 
% Version : 1.0
% Derniere r�vision : - 
    
x = softmax(V);
>>>>>>>>>>>>>>>>>>>>>>>>>>><
sv = sum(V)
x = exp(V);
y = sum(x);

[l ans] = size(V); 
S = x./(ones(l,1)*y);


