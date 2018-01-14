function [Labels, ProbAPriori, LabelsSR] = probmlpclass(Output, rejet, seuil1, seuil2);
%
% MLPCLASS
%
% SYNTAXE :
%
% [Labels, ProbAPriori, LabelsSR] = probmlpclass(Output [, rejet, seuil1 [, seuil2]]);
%
% Catégorisation en classes d'appartenance des vecteurs
% de sortie d'un réseau de neurone à sorties probabilités.
% Utiliser PROBMLP2RUN pour calculer les sorties du réseau de neurones.
% La classification est du type décision Bayésienne : choix de la classe 
% qui maximise les probabilités à postériori calculées par le réseau.
%
% Deux critères de rejet sont disponibles en option : un critère 
% de distance et un critère d'ambiguïté.
% Le label 0 est affecté aux exemples rejetés. 
%
% ARGUMENTS :
%
% Output 	: matrice des vecteurs de sorties à classer
% rejet 		: [optionnel] = {'dist', 'amb'}
%             'dist'     : rejet sur un critère de distance : la sortie de la cellule 
%                          la plus active est supérieure à un seuil donné en troisième argument :
%                          Probabilité d'appartenance à une classe supérieure ou égale au seuil (0->1)
%             'amb'      : rejet sur un critère d'ambiguïté : les sorties des deux 
%                          cellules les plus actives sont trop proches, au delà de la valeur
%                          de seuil donnée en troisième argument :
%                          différence des probabilités d'appartenance à deux classes inférieure au seuil.
%             'dist+amb' : les deux critères de rejet précédents sont employés
%                          avec les seuils donnés en argument <seuil1> et <seuil2> 
% seuil1    : [optionnel] valeur du seuil utilisé pour le rejet par distance
% seuil2    : [optionnel] valeur du seuil utilisé pour le rejet par ambiguïté 
%
%
% VALEURS DE RETOUR :
%
% Labels          : labels calculés pour les exemples classés (vecteur ligne)
% ProbAPriori     : probabilités a priori des classes, estimées à partir des probabilités à postériori
%                   sur l'ensemble de la base <Output>. A signaler que cette estimation n'est valable
%                   qu'à condition d'etre calculée sur un grand nombre d'exemples.
% LabelsSR        : labels, y compris ceux des exemples rejetés
%
% VOIR AUSSI :
%
%  probmlp2def,  probmlp2train,  probmlp2run  
%
% COMPATIBILITE : 
%   >= matlab 5.1
%

% Bruno Gas - LIS/PARC UPMC
% Création : 17 mars 2001
% version : 1.1
% Derniere révision :  
%  - B. Gas (14/01/2002) : retour des labels des exemples rejetés (arg 3) 
%                          + erreur sur le seuil2
%

% Controle arguments et données :
%--------------------------------
if nargin==1,   rej = 0;
elseif nargin==3, 
   if strcmp(rejet,'dist')==1, rej=1;
   elseif strcmp(rejet,'amb')==1, rej=2;
   else errordlg(usage,'errorbox'); return; end;
elseif nargin==4 & strcmp(rejet,'dist+amb')==1
   rej = 3;
else error('[PROBMLPCLASS] usage : [Labels, ProbAPriori] = probmlpclass(Output [, rejet, seuil1 [, seuil2]])'); end;

[ExSize, ExNbr] = size(Output); % dim. des exemples
ClassNbr = ExSize;              % nbr.de classes

%if sum(sum(Output))~=ExNbr
 %   error('[PROBMLPCLASS] erreur : les sorties du réseau ne sont pas des probabilités (utiliser <probmlp2run>)'); end;
if nargin>=3 & (seuil1<0 | seuil1>1)
    error('[PROBMLPCLASS] erreur : l''arg. <seuil1> (rejet distance) doit etre compris entre 0 et 1'); end;
if nargin>=4 & (seuil2<0 | seuil2>1)
    error('[PROBMLPCLASS] erreur : l''arg. <seuil2> (rejet ambiguité) doit etre compris entre 0 et 1'); end;

ProbAPriori = sum(Output')/ExNbr;
% Pas de rejet :
%---------------
if rej==0, [val Labels] = max(Output); return;  end;

[val ind] = sort(Output);       % rangement des sorties par ordre croissant des valeurs
Labels = ind(ClassNbr,:);		% sortie maxi = probabilité à postériori la plus élevée
LabelsSR = Labels;              % labels sans rejet

% recherche des rejets :
%-----------------------
if rej==1                       % rejet critère de distance :     
   valmax = val(ClassNbr,:);
   [ans ind_rej] = find(valmax<seuil1);
   Labels(ind_rej) = 0;

elseif rej==2                   % rejet par ambiguïté :
   val1 = val(ClassNbr,:);
   val2 = val(ClassNbr-1,:);
   [ans ind_rej] = find((val1-val2)<seuil1);
   Labels(ind_rej) = 0;
   
elseif rej==3                   % rejet distance et ambiguïté :
   valmax = val(ClassNbr,:);
   [ans ind_rej] = find(valmax<seuil1);
   Labels(ind_rej) = 0;
   
   val2 = val(ClassNbr-1,:);
   [ans ind_rej] = find((valmax-val2)<seuil2);
   Labels(ind_rej) = 0;
end;
