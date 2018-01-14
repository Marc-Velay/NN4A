function mlp2front(Base, Labels, Centres, ClassCentres);
%
% LVQIFRONT
%
% SYNTAXE :
%
% LVQIFRONT(Base, Labels, centres ClassCentres);
%
% Visualise les fronti�res s�paratrices entre prototypes 2D
% r�alis�es par un r�seau LVQ-I.
%
%
% ARGUMENTS :
%
% Base       : la base des protoptypes (rang�s en colonne, sans les labels)
% Labels     : vecteur ligne des labels des prototypes
% Centres, ClassCentre : param�tres du r�seau LVQ
%
% VALEURS DE RETOUR :
%
% -
%
% VOIR AUSSI :
%
%   LVQIDEF LVQITRAIN LVQIRUN
% 

% LVQIFRONT
% Bruno Gas - LISIF/PARC UPMC - bruno.gas@upmc.fr
% Cr�ation : 14/11/2004
% Version : 1.0
% Derniere r�vision : -


% controle des arguments :
if nargin ~= 4
   error('Usage : lvqIfront Base Labels Centres ClassCentres');
end;

[ExSize ExNbr] = size(Base);
if ExSize~=2
   error('[LVQIFRONT] : les exemples doivent de dimension 2 (utiliser une analyse discriminantes)');
end;
if size(Labels,2)~=ExNbr
   error('[LVQIRONT] : la dimension du vecteur des labels n''est pas coh�rente avec celles de la Base');
end;
if min(Labels)<1
   error('[LVQIFRONT] : le vecteur des labels comporte des labels inf�rieurs � 1');
end;

ClassNbr = max(Labels);

disp(['Probl�me � ' num2str(ClassNbr) ' classes']);

% contruction de la base de test :
pas = 0.05;
ZoneTestX = [min(Base(1,:)):pas:max(Base(1,:))];
ZoneTestY = [min(Base(2,:)):pas:max(Base(2,:))];

TstExNbr = length(ZoneTestX)*length(ZoneTestY);
BaseTst = zeros(2,TstExNbr);
ind = 1;
for i=min(Base(1,:)):pas:max(Base(1,:))
   for j=min(Base(2,:)):pas:max(Base(2,:))
      BaseTst(1,ind) = i;
      BaseTst(2,ind) = j;
      ind = ind + 1;
   end;
end;

% classification :
LabelTst = lvqIrun(BaseTst, Centres, ClassCentres);

% affichage :
close all;
coul = ['rbgymck'];
hold on;

% affichage donn�es de test :
for cl=1:ClassNbr
   ind = find(LabelTst==cl);
   DataTstX = BaseTst(1,ind);
   DataTstY = BaseTst(2,ind);
   plot(DataTstX, DataTstY, [coul(cl) '.']);
end;

% affichage donn�es de la base :
for cl=1:ClassNbr
   ind = find(Labels==cl);
   disp(['classe ' num2str(cl) ' : ' num2str(length(ind)) ' prototypes trouv�s.']);
   DataX = Base(1,ind);
   DataY = Base(2,ind);
   plot(DataX, DataY, [coul(cl) '*']);
end;
hold off
disp('[LVQIFRONT] : tapez <Return> pour continuer...');
pause;


