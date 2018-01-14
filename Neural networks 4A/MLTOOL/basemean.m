function [Center, CLabel] = BASEMEAN(Base, Label);
%
% BASEMEAN
%
%  Calcul des centres de classe
%
% SYNTAXE :
%
%  Center = BASEMEAN(Base, Label)
%
%  Calcul les centres de classe de la base donnée en arguments.
%  Les centres sont rangés en colonnes successives dans <CENTER> et les classes 
%  correspondantes sauvegardées dans le vecteur ligne <CLabel>
%  
%
% ARGUMENTS :
%
% Base	   : la base RdF (exemples sans les labels)
% Label     : classes d'appartenance des échantillons de la base rangés en ligne
%
% VALEURS DE RETOUR :
%
% Center	   : Matrice des centres de classe rangés en colonnes
% CLabel    : vecteur ligne des labels associés aux centres de classes
%
% VOIR AUSSI :
%
%  base2label  
%
%
% COMPATIBILITE : 
%   >= matlab 5.1, octave 2.0
%

% Bruno Gas - LISIF/PARC UPMC
% Création : 12 aout 2001
% version : 1.0
% Derniere révision :

[L, ExNbr] = size(Label);
[ExSize, C2]= size(Base);

if L~=1 
   warning('[BASEMEAN] warning : L''argument <Label> devrait être un vecteur ligne');
   Label = Label';
   [L, ExNbr] = size(Label);
end;
if ExNbr~=C2, error('[BASEMEAN] erreur : dimension incohérente des arguments'); end;

MaxLabel = max(Label);
CLabel = [];
Center = [];
for i=1:MaxLabel
   ind = find(Label==i);
   if isempty(ind)==0      							% si la classe est représentée
      CLabel = [CLabel i];								% sauvegarde du label
      Center = [Center mean(Base(:,ind),2)];		% calcul du vecteur moyen      
   end;   
end;



