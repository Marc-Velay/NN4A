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
% LabelD  	: vecteur ligne des labels des �chantillons class�s
% Label	    : vecteur ligne des labels calcul�s par le classifieur
% LabelSR   : [optionnel] labels y-compris ceux des exemples rejet�s
%
% VALEURS DE RETOUR :
%
% taux      : taux de reconnaissance obtenu exprim� en pourcentage
%             du nombre d'exemple reconnus sur le nombre total d'exemples
%             non rejet�s (labels non nuls).
% rejet		: [optionnel] taux de rejet exprim� en pourcentage du nombre
%             d'exemples rejet�s (labels � 0) sur le nombre total 
%             d'exemples.
% rejerr    : [optionnel] taux d'erreur de rejet exprim� en pourcentage du nombre
%             d'exemples rejet�s par erreur sur le nombre total d'exemples rejet�s
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
% Cr�ation : octobre 2000
% version : 1.3
% Derniere r�vision : 
%  - B.Gas (27/11/2000) : inversion ordre des arg. de retour
%  - B.Gas (24/02/2001) : pbm. des exemples tous rejet�s
%  - B.Gas (14/01/2002) : suppression du warning quand tous rejet�s (retourne 0% et 100%) 
%                         + calcul du taux d'erreur de rejet
%
if nargin~=2 & nargin ~=3 
    error('[SCORE] usage : [taux [, rejet [,rejerr]]] = score(Label, LabelD [, LabelSR])'); 
end;
if nargout==3 & nargin ==2
    error('[SCORE] usage : La calcul (optionnel) du taux d''erreur de rejet n�cessite l''argument <LabelSR>');
end;

if size(Labels)~= size(LabelsD), error('[SCORE] : arguments incompatibles'); end;

[ans, ExNbr] = size(Labels);
if ans~= 1, error('[SCORE] : <Labels> devrait �tre un vecteur ligne'); end;

RejectNbr = sum(Labels==0);
if ExNbr==RejectNbr
%   warning('[SCORE] : exemples tous rejet�s : impossible d''�tablir un score');
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

 
