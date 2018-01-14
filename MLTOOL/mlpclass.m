function Labels = mlpclass(Output, rejet, seuil1, seuil2);

%
% CLASSIF
%
% SYNTAXE :
%
% Labels = MLPCLASS(Output [, rejet, seuil1 [, seuil2]])
%
% Cat�gorisation en classes d'appartenance des vecteurs
% de sortie d'un r�seau de neurone. Utiliser d'abord MLPxRUN pour
% calculer les sorties du r�seau de neurones.
%
% Deux crit�res de rejet sont disponibles en option : un crit�re 
% de distance et un crit�re d'ambigu�t�.
% Un 3eme crit�re de rejet (rejet en valeur absolue) est disponible
% pour les r�seaux utilis�s en mod�lisation
% Le label 0 est affect� aux exemples rejet�s. 
%
% ARGUMENTS :
%
% Output 	: matrice des vecteurs de sorties � classer
% rejet 		: [optionnel] = {'dist', 'mod', 'amb'}
%             'dist'     : rejet sur un crit�re de distance : la sortie de la cellule 
%                          la plus active est sup�rieure � un seuil donn� en troisi�me argument
%             'mod'      : rejet en module : la sortie de la cellule la plus active en valeur absolue
%                          est sup�rieure au seuil donn� en 3eme argument
%             'amb'      : rejet sur un crit�re d'ambigu�t� : les sorties des deux 
%                          cellules les plus actives sont trop proches, au del� de la valeur
%                          de seuil donn�e en troisi�me argument.
%             'dist+amb' : les deux crit�res de rejet pr�c�dents sont employ�s
%                          avec les seuils donn�s en argument <seuil1> et <seuil2> 
% seuil1    : [optionnel] valeur du seuil utilis� pour le rejet par distance ou module
% seuil2    : [optionnel] valeur du seuil utilis� pour le rejet par ambigu�t� 
%
%
% VALEURS DE RETOUR :
%
% Labels    : labels calcul�s pour les exemples class�s (vecteur ligne)
%
% VOIR AUSSI :
%
%  MLPxDEF  MLPxTRAIN  MLPxRUN  CONFUSION  
%
% COMPATIBILITE : 
%   >= matlab 5.1
%

% Bruno Gas - LIS/P&C UPMC
% Cr�ation : octobre 2000
% version : 1.2
% Derniere r�vision : 
%  - B.Gas (23/02/2001) : mise � jour tbx RdF 
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
   % rejet crit�re de distance : 
   valmax = val(ClassNbr,:);
   [ans ind_rej] = find(valmax<seuil1);
   Labels(ind_rej) = 0;

elseif rej==2   
   % rejet par ambigu�t� :
   val1 = val(ClassNbr,:);
   val2 = val(ClassNbr-1,:);
   [ans ind_rej] = find((val1-val2)<seuil1);
   Labels(ind_rej) = 0;
   
elseif rej==3
   % rejet distance && ambigu�t� :
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
