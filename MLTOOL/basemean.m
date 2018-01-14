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
%  Calcul les centres de classe de la base donn�e en arguments.
%  Les centres sont rang�s en colonnes successives dans <CENTER> et les classes 
%  correspondantes sauvegard�es dans le vecteur ligne <CLabel>
%  
%
% ARGUMENTS :
%
% Base	   : la base RdF (exemples sans les labels)
% Label     : classes d'appartenance des �chantillons de la base rang�s en ligne
%
% VALEURS DE RETOUR :
%
% Center	   : Matrice des centres de classe rang�s en colonnes
% CLabel    : vecteur ligne des labels associ�s aux centres de classes
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
% Cr�ation : 12 aout 2001
% version : 1.0
% Derniere r�vision :

[L, ExNbr] = size(Label);
[ExSize, C2]= size(Base);

if L~=1 
   warning('[BASEMEAN] warning : L''argument <Label> devrait �tre un vecteur ligne');
   Label = Label';
   [L, ExNbr] = size(Label);
end;
if ExNbr~=C2, error('[BASEMEAN] erreur : dimension incoh�rente des arguments'); end;

MaxLabel = max(Label);
CLabel = [];
Center = [];
for i=1:MaxLabel
   ind = find(Label==i);
   if isempty(ind)==0      							% si la classe est repr�sent�e
      CLabel = [CLabel i];								% sauvegarde du label
      Center = [Center mean(Base(:,ind),2)];		% calcul du vecteur moyen      
   end;   
end;



