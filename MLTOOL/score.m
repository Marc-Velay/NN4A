function [taux, rejet, rejerr] = score(Labels, LabelsD, LabelsSR);

%
% SCORE
%
% SYNTAXE :
%
%  [taux [, rejet [,rejerr]]] = score(Label, LabelD [,LabelSR])
%
% Calcul du taux de reconnaissance en classification 
%
%
% ARGUMENTS :
%
% LabelD  	: vecteur ligne des labels des échantillons classés
% Label	    : vecteur ligne des labels calculés par le classifieur
% LabelSR   : [optionnel] labels y-compris ceux des exemples rejetés
%
% VALEURS DE RETOUR :
%
% taux      : taux de reconnaissance obtenu exprimé en pourcentage
%             du nombre d'exemple reconnus sur le nombre total d'exemples
%             non rejetés (labels non nuls).
% rejet		: [optionnel] taux de rejet exprimé en pourcentage du nombre
%             d'exemples rejetés (labels à 0) sur le nombre total 
%             d'exemples.
% rejerr    : [optionnel] taux d'erreur de rejet exprimé en pourcentage du nombre
%             d'exemples rejetés par erreur sur le nombre total d'exemples rejetés
%             (le 3eme arg. devient alors obligatoire)
%
% VOIR AUSSI :
%
%  MLPCLASS  CONFUSION  
%
% COMPATIBILITE : 
%   >= matlab 5.1
%

% Bruno Gas - LIS/P&C UPMC
% Création : octobre 2000
% version : 1.3
% Derniere révision : 
%  - B.Gas (27/11/2000) : inversion ordre des arg. de retour
%  - B.Gas (24/02/2001) : pbm. des exemples tous rejetés
%  - B.Gas (14/01/2002) : suppression du warning quand tous rejetés (retourne 0% et 100%) 
%                         + calcul du taux d'erreur de rejet
%
if nargin~=2 & nargin ~=3 
    error('[SCORE] usage : [taux [, rejet [,rejerr]]] = score(Label, LabelD [, LabelSR])'); 
end;
if nargout==3 & nargin ==2
    error('[SCORE] usage : La calcul (optionnel) du taux d''erreur de rejet nécessite l''argument <LabelSR>');
end;

if size(Labels)~= size(LabelsD), error('[SCORE] : arguments incompatibles'); end;

[ans, ExNbr] = size(Labels);
if ans~= 1, error('[SCORE] : <Labels> devrait être un vecteur ligne'); end;

RejectNbr = sum(Labels==0);
if ExNbr==RejectNbr
%   warning('[SCORE] : exemples tous rejetés : impossible d''établir un score');
   taux = 0; rejet = 100;
else
   taux = sum(LabelsD==Labels)*100/(ExNbr-RejectNbr);
   rejet = RejectNbr*100/ExNbr;
end;

if nargout==3 & RejectNbr>0
    [val ind] = find(Labels==0);
    rejerr = sum(LabelsSR(ind) == LabelsD(ind))*100/RejectNbr;
else
    rejerr = 0;
end;

 
