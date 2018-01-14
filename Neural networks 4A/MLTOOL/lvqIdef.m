function [Centres, ClassCentres] = lvqIdef (Base, Labels, CentreNbr, opt, seed)
%
% LVQIDEF :
%
%  [Centres, ClassCentres] = lvqIdef (Base, Labels, CentreNbr, opt [, seed])
%
%  Initialisation des centres d'un r�seau LVQ. 
%  Les <CentreNbr> centres par classe sont choisis selon trois m�thodes
%  possibles : 
%     - 'rand' : initialisation al�atoires des centres
%     - 'copy' : centres choisis al�atoirement parmi les exemples de la base selon leur classe
%     - 'mean' : centres correspondant aux barycentres des classes (un centre par classe)
%
% ARGUMENTS : 
%
%  Base      : exemples de la base d'apprentissage
%  Labels    : vecteur ligne des labels de la base
%  CentreNbr : nombre de centres par classe d�sir�
%  opt       : {'rand', 'copy', 'mean'} option d'initialisation des centres
%  seed      : [OPTIONNEL] initialisation du g�n�rateur al�atoire
%
%
% VALEURS DE RETOUR :
%
%  Centres     : matrice des centres g�n�r�s et stock�s en ligne 
%                dans la matrice
%  ClassCentre : vecteur colonne des labels des centres
%
%
% DESCRIPTION :
%
%  L'option 'mean' fonctionne � condition de ne demander qu'un centre par classe
%
%
% VOIR AUSSI :
%
%  lvqItrain, lvqIrun, score, confusion
%


% LVQIDEF
% Bruno Gas - LIS/P&C UPMC <gas@ccr.jussieu.fr>
% Cr�ation : 27 octobre 2000
% Version 1.3
% Dernieres r�visions : 
% - B. Gas (1/12/2000) : help et argument <seed>
% - B. Gas (4/2/2001) : mise � jour tbx RdF
% - B. Gas (en cours) : options d'initialisation des centres


% controle des arguments :

if nargin==4
  	rand('seed',seed);
elseif nargin~=3
   error('[LVQIDEF] erreur d''usage : [Centres, ClassCentres] = lvqIdef (Base, Labels, CentreNbr, seed)');
end;
  

ClassNbr = max(Labels);				% nombre de classes
[InputNbr, ExNbr] = size(Base);	% dimension de la base
CellNbr = ClassNbr*CentreNbr;		% nombre de cellules

Centres = zeros(1,InputNbr);		% init. matrice des centres
ClassCentres = 0;
for cl=1:ClassNbr
   ind = find(Labels==cl);
   Ex = Base(:,ind);				% echantilllons d'une m�me classe
   [ans, ClExNbr] = size(Ex); % leur nombre
  										% on en tire <CentresNbr> au hasard
  	ind = floor(rand(1,CentreNbr)*(ClExNbr-1))+1;	          
   Centres = [Centres ; Ex(:,ind)'];   
   ClassCentres = [ClassCentres ; cl*ones(CentreNbr,1)];       
end;

Centres = Centres(2:CellNbr+1,:);
ClassCentres = ClassCentres(2:CellNbr+1,:);
