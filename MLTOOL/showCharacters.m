function showCharacters(Base, labels);
%
% SHOWCHARACTERS
%
% SYNTAXE :
%
% SHOWCHARACTERS(Base, labels);
%
% Affichage de certains exemples de la base de caracteres
%
% ARGUMENTS :
%
% Base       : la base des protoptypes (rang�s en colonne, sans les labels)
% labels     : vecteur ligne des labels des prototypes
%
% VALEURS DE RETOUR :
%
%
% VOIR AUSSI :
%
% 
% 

% SHOWCHARACTERS
% Mohamed Chetounai - LISIF/PARC UPMC
% Cr�ation : 21/11/2004
% Version : 1
% Derniere r�vision : 
% 
%   
close all
[ExSize ExNbr] = size(Base);
car = 'BCDEFGHIJK';
for i=1:50:ExNbr,
       Img = reshape(Base(:,i),12,12);
       
       imgview(1-Img,'g',1); title(['Caractere ' car(labels(i))]);
       pause
   end;
       