function mlp1front(Base, Labels, W1, B1);
%
% MLP2FRONT
%
% SYNTAXE :
%
% VISUFRONT(Base, Labels);
%
% Visualise les fronti�res s�paratrices entre prototypes 2D
% r�alis�es par un r�seau MLP1.
%
%
% ARGUMENTS :
%
% Base       : la base des protoptypes (rang�s en colonne, sans les labels)
% Labels     : vecteur ligne des labels des prototypes
% W1, B1     : poids du r�seau MLP1
%
% VALEURS DE RETOUR :
%
% -
%
% VOIR AUSSI :
%
%   MLP2FRONT MLP1RUN MLPCLASS
% 

% VISUFRONT
% Bruno Gas - LISIF/PARC UPMC
% Cr�ation : 17/10/2004
% Version : 1.0
% Derniere r�vision : -


% controle des arguments :
if nargin ~= 4
   error('Usage : mlp1front Base Labels W1, B1');
end;

[ExSize ExNbr] = size(Base);
if ExSize~=2
   error('[MLP2FRONT] : les exemples doivent de dimension 2 (utiliser une analyse discriminantes)');
end;
if size(Labels,2)~=ExNbr
   error('[MLP2RONT] : la dimension du vecteur des labels n''est pas coh�rente avec celles de la Base');
end;
if min(Labels)<1
   error('[MLP2FRONT] : le vecteur des labels comporte des labels inf�rieurs � 1');
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
Output = mlp1run(BaseTst, W1, B1);
LabelTst = mlpclass(Output);

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
disp('[MLP1FRONT] : tapez <Return> pour continuer...');
pause;




