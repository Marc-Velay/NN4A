function Labels = khnclass(Gagnants, Class);
%
% KHNCLASS
%
% SYNTAXE :
%
% Labels = KHNCLASS(Gagnants, Class)
%
% Cat�gorisation en classes d'appartenance des vecteurs
% de sortie d'une carte de Kohonen. Utiliser d'abord KHNxRUN pour
% calculer les sorties du r�seau de neurones. Il convient ensuite
% de conna�tre les repr�sentants des classes dans la carte, i.e.
% les classes associ�es aux neurones.
%
%
% ARGUMENTS :
%
% Gagnants  : le vecteur ligne des indices des neurones gagnants pour un ensemble
%             de formes donn�es (obtenu par KHNxRUN)
% Class     : le vecteur colonne des classes d'appartenance (de 1 � Nbr. de Classes)
%             de chacun des neurones de la carte. 
%             Si un ou plusieurs neurones ne repr�sentent aucune classe (rejet), 
%             la valeur 0 doit leur �tre affect�e.
%
%
% VALEURS DE RETOUR :
%
% Labels    : labels (vecteur ligne) propos�s par la carte de Kohonen (de 1 � Nbr. de Classes, ou
%             0 en cas de rejet).
%
% VOIR AUSSI :
%
%  KHNxDEF KHNxTRAIN  KHNxRUN  
%
% COMPATIBILITE : 
%   >= matlab 5.1
%

% Bruno Gas - LIS/P&C UPMC <gas@ccr.jussieu.fr>
% Cr�ation : 13 novembre 2000
% version : 1.1
% Derniere r�vision :
% - B.Gas (27/1/2001) : mise � jour tbx RdF


if nargin~=2, error('Labels = khnclass(Gagnants, Class)'); end;

if size(Gagnants,1)>1 
   warning('[KHNCLASS] l''arg. <Gagnants> devrait �tre un vecteur ligne');
   Gagnants = Gagnants';
end;

if size(Class,2)>1
   warning('[KHNCLASS] l''arg. <Class> devrait �tre un vecteur colonne');
   Class = CLass';
end;
   
ExNbr = size(Gagnants,2);
CentresNbr = size(Class,1);   

if min(Gagnants) < 1 | max(Gagnants) > CentresNbr
   error('[KHNCLASS] <Gagnants> fait r�f�rence � des neurones qui n''existent pas');   
end;

   
Labels = Class(Gagnants)';

