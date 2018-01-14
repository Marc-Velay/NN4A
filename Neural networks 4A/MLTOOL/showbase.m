function showbase(Base, labels);
%
% SHOWBASE
%
% SYNTAXE :
%
% SHOWBASE(Base, labels);
%
% Affiche une base de prototypes en deux dimensions 
%
%
% ARGUMENTS :
%
% Base       : la base des protoptypes (rangés en colonne, sans les labels)
% labels     : vecteur ligne des labels des prototypes
%
% VALEURS DE RETOUR :
%
%
%
% VOIR AUSSI :
%
%   BASE2TARGET  BASE2LABEL LABEL2TARGET GENBASE
% 

% SHOWBASE
% Mohamed Chetounai - LISIF/PARC UPMC
% Création : 17/10/2004
% Version : 1.0
% Derniere révision : 
%  

% controle des arguments :
if nargin ~= 2
   error('Usage : showbase (Base, labels)');
end;

ClassNbr = max(labels)
% affichage :
close all;
coul = ['rbgymck'];
hold on;

% affichage données: 
for cl=1:ClassNbr
   ind = find(labels==cl);
   DataTstX = Base(1,ind);
   DataTstY = Base(2,ind);
   plot(DataTstX, DataTstY, [coul(cl) '+']);
end;
title('Affichage d''une base en dimension 2');
xlabel('Dimension X'); 
ylabel('Dimension Y');







