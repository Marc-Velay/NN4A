function Labels = mlpclass(Output, rejet, seuil1, seuil2);

%
% CLASSIF
%
% SYNTAXE :
%
% Labels = MLPCLASS(Output [, rejet, seuil1 [, seuil2]])
%
% Catégorisation en classes d'appartenance des vecteurs
% de sortie d'un réseau de neurone. Utiliser d'abord MLPxRUN pour
% calculer les sorties du réseau de neurones.
%
% Deux critères de rejet sont disponibles en option : un critère 
% de distance et un critère d'ambiguïté.
% Un 3eme critère de rejet (rejet en valeur absolue) est disponible
% pour les réseaux utilisés en modélisation
% Le label 0 est affecté aux exemples rejetés. 
%
% ARGUMENTS :
%
% Output 	: matrice des vecteurs de sorties à classer
% rejet 		: [optionnel] = {'dist', 'mod', 'amb'}
%             'dist'     : rejet sur un critère de distance : la sortie de la cellule 
%                          la plus active est supérieure à un seuil donné en troisième argument
%             'mod'      : rejet en module : la sortie de la cellule la plus active en valeur absolue
%                          est supérieure au seuil donné en 3eme argument
%             'amb'      : rejet sur un critère d'ambiguïté : les sorties des deux 
%                          cellules les plus actives sont trop proches, au delà de la valeur
%                          de seuil donnée en troisième argument.
%             'dist+amb' : les deux critères de rejet précédents sont employés
%                          avec les seuils donnés en argument <seuil1> et <seuil2> 
% seuil1    : [optionnel] valeur du seuil utilisé pour le rejet par distance ou module
% seuil2    : [optionnel] valeur du seuil utilisé pour le rejet par ambiguïté 
%
%
% VALEURS DE RETOUR :
%
% Labels    : labels calculés pour les exemples classés (vecteur ligne)
%
% VOIR AUSSI :
%
%  MLPxDEF  MLPxTRAIN  MLPxRUN  CONFUSION  
%
% COMPATIBILITE : 
%   >= matlab 5.1
%

% Bruno Gas - LIS/P&C UPMC
% Création : octobre 2000
% version : 1.2
% Derniere révision : 
%  - B.Gas (23/02/2001) : mise à jour tbx RdF 
%  - B.Gas (30/11/2002) : ajout du rejet "module"

if nargin==1,   rej = 0;
elseif nargin==3, 
   if strcmp(rejet,'dist')==1, rej=1;
   elseif strcmp(rejet,'amb')==1, rej=2;
   elseif strcmp(rejet,'mod')==1, rej=4;
   else errordlg(usage,'errorbox'); return; end;
elseif nargin==4 & strcmp(rejet,'dist+amb')==1
   rej = 3;
else error('[MLPCLASS] usage : Labels = MLPCLASS(Output [, rejet, seuil1 [, seuil2]])'); end;   

if rej==0, [val Labels] = max(Output);   return;  end;

[ClassNbr ans] = size(Output);
[val ind] = sort(Output);
Labels = ind(ClassNbr,:);		

% recherche des rejets :
if rej==1
   % rejet critère de distance : 
   valmax = val(ClassNbr,:);
   [ans ind_rej] = find(valmax<seuil1);
   Labels(ind_rej) = 0;

elseif rej==2   
   % rejet par ambiguïté :
   val1 = val(ClassNbr,:);
   val2 = val(ClassNbr-1,:);
   [ans ind_rej] = find((val1-val2)<seuil1);
   Labels(ind_rej) = 0;
   
elseif rej==3
   % rejet distance && ambiguïté :
   valmax = val(ClassNbr,:);
   [ans ind_rej] = find(valmax<seuil1);
   Labels(ind_rej) = 0;
   
   val2 = val(ClassNbr-1,:);
   [ans ind_rej] = find((valmax-val2)<seuil1);
   Labels(ind_rej) = 0;
elseif rej==4
   % rejet en module :
   [val ind] = sort(abs(Output));
   Labels = ind(ClassNbr,:);		
   valmax = val(ClassNbr,:);
   [ans ind_rej] = find(valmax<seuil1);
   Labels(ind_rej) = 0;
end;
