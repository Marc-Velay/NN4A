function Target = label2target(Label);
%
% LABEL2TARGET
%
% SYNTAXE :
%
% Label = label2target(Target)
%
% Construit la matrice des cibles a partir du vecteur des labels
% donné en argument.
%
% ARGUMENTS :
%
% Label : vecteur des labels.
%
% VALEURS DE RETOUR :
%
% Target : matrice des vecteurs cibles (en colonnes) à valeurs
%          binaires +1 ou -1. Chaque vecteur cible code un label
%          du vecteur Label. Les composantes sont à -1, sauf la
%          composante dont l'indice correspond au label à codé
%          qui est à +1.
%
% COMPATIBILITE :
%
%   Matlab 5.3+, Octave 2.x+
%

% Bruno Gas - LIS/P&C UPMC
% Création : mai 2000
% Version : 1.2
% Derniere révision : 
%  - B. Gas (4/2/2001) : mise à jour tbx RdF
%  - B. Gas (15/11/2001) : modifs mineures

if is_vector(Label) ~= 1 & is_scalar(Label) ~=1
  error('[LABEL2TARGET] erreur : L''argument <Label> doit être un vecteur');  end;

if sum(floor(Label)-Label) ~= 0
  error('[LABEL2TARGET] erreur : le vecteur des labels ne doit comporter que des valeurs entières positives');  
end;

if sum(Label <=0) ~= 0
	error('[LABEL2TARGET] erreur : présence de valeurs négatives ou nulles dans le vecteur des labels');	
end;

if min(Label)~=1
  error('[LABEL2TARGET] erreur : le plus petit label doit être "1"'); end;



ExNbr = length(Label);
ClassNbr = max(Label);

Target = -ones(ClassNbr,ExNbr);
for i=1:ExNbr
	Target(Label(i),i) = +1;
end;

