function [Labels, ProbAPriori, LabelsSR] = probmlpclass(Output, rejet, seuil1, seuil2);
%
% MLPCLASS
%
% SYNTAXE :
%
% [Labels, ProbAPriori, LabelsSR] = probmlpclass(Output [, rejet, seuil1 [, seuil2]]);
%
% Cat�gorisation en classes d'appartenance des vecteurs
% de sortie d'un r�seau de neurone � sorties probabilit�s.
% Utiliser PROBMLP2RUN pour calculer les sorties du r�seau de neurones.
% La classification est du type d�cision Bay�sienne : choix de la classe 
% qui maximise les probabilit�s � post�riori calcul�es par le r�seau.
%
% Deux crit�res de rejet sont disponibles en option : un crit�re 
% de distance et un crit�re d'ambigu�t�.
% Le label 0 est affect� aux exemples rejet�s. 
%
% ARGUMENTS :
%
% Output 	: matrice des vecteurs de sorties � classer
% rejet 		: [optionnel] = {'dist', 'amb'}
%             'dist'     : rejet sur un crit�re de distance : la sortie de la cellule 
%                          la plus active est sup�rieure � un seuil donn� en troisi�me argument :
%                          Probabilit� d'appartenance � une classe sup�rieure ou �gale au seuil (0->1)
%             'amb'      : rejet sur un crit�re d'ambigu�t� : les sorties des deux 
%                          cellules les plus actives sont trop proches, au del� de la valeur
%                          de seuil donn�e en troisi�me argument :
%                          diff�rence des probabilit�s d'appartenance � deux classes inf�rieure au seuil.
%             'dist+amb' : les deux crit�res de rejet pr�c�dents sont employ�s
%                          avec les seuils donn�s en argument <seuil1> et <seuil2> 
% seuil1    : [optionnel] valeur du seuil utilis� pour le rejet par distance
% seuil2    : [optionnel] valeur du seuil utilis� pour le rejet par ambigu�t� 
%
%
% VALEURS DE RETOUR :
%
% Labels          : labels calcul�s pour les exemples class�s (vecteur ligne)
% ProbAPriori     : probabilit�s a priori des classes, estim�es � partir des probabilit�s � post�riori
%                   sur l'ensemble de la base <Output>. A signaler que cette estimation n'est valable
%                   qu'� condition d'etre calcul�e sur un grand nombre d'exemples.
% LabelsSR        : labels, y compris ceux des exemples rejet�s
%
% VOIR AUSSI :
%
%  probmlp2def,  probmlp2train,  probmlp2run  
%
% COMPATIBILITE : 
%   >= matlab 5.1
%

% Bruno Gas - LIS/PARC UPMC
% Cr�ation : 17 mars 2001
% version : 1.1
% Derniere r�vision :  
%  - B. Gas (14/01/2002) : retour des labels des exemples rejet�s (arg 3) 
%                          + erreur sur le seuil2
%

% Controle arguments et donn�es :
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
 %   error('[PROBMLPCLASS] erreur : les sorties du r�seau ne sont pas des probabilit�s (utiliser <probmlp2run>)'); end;
if nargin>=3 & (seuil1<0 | seuil1>1)
    error('[PROBMLPCLASS] erreur : l''arg. <seuil1> (rejet distance) doit etre compris entre 0 et 1'); end;
if nargin>=4 & (seuil2<0 | seuil2>1)
    error('[PROBMLPCLASS] erreur : l''arg. <seuil2> (rejet ambiguit�) doit etre compris entre 0 et 1'); end;

ProbAPriori = sum(Output')/ExNbr;
% Pas de rejet :
%---------------
if rej==0, [val Labels] = max(Output); return;  end;

[val ind] = sort(Output);       % rangement des sorties par ordre croissant des valeurs
Labels = ind(ClassNbr,:);		% sortie maxi = probabilit� � post�riori la plus �lev�e
LabelsSR = Labels;              % labels sans rejet

% recherche des rejets :
%-----------------------
if rej==1                       % rejet crit�re de distance :     
   valmax = val(ClassNbr,:);
   [ans ind_rej] = find(valmax<seuil1);
   Labels(ind_rej) = 0;

elseif rej==2                   % rejet par ambigu�t� :
   val1 = val(ClassNbr,:);
   val2 = val(ClassNbr-1,:);
   [ans ind_rej] = find((val1-val2)<seuil1);
   Labels(ind_rej) = 0;
   
elseif rej==3                   % rejet distance et ambigu�t� :
   valmax = val(ClassNbr,:);
   [ans ind_rej] = find(valmax<seuil1);
   Labels(ind_rej) = 0;
   
   val2 = val(ClassNbr-1,:);
   [ans ind_rej] = find((valmax-val2)<seuil2);
   Labels(ind_rej) = 0;
end;
