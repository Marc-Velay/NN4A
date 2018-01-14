function [x, y] = scanmouse()
%
% SCANMOUSE
%
% SYNTAXE : [x, y] = scanmouse()
%
% SCANMOUSE retourne les coord (x,y)
% d'une suite de points entrés à la souris.
% bouton gauche ou milieu		: valide un point
% bouton droit 					: FIN du tracé
% touche clavier 					: FIN du tracé 
%
%
% ARGUMENTS : -
%
% VALEURS DE RETOUR :
%
% s	: tableau des abcisses.
% y   : tableau des ordonnées
% 
% COMPATIBILITE :
%
%    Matlab 5.1+
%

% M. Milgram, C. Achard -LIS PARC - UPMC
% Création : <= 96
% Version 1.2
% Derniere révision :
% - B.Gas (mai 2000)
% - B.Gas (octobre 2000) : help


x=0;y=0;
F=figure;
hold on;

button = 1;
while button<=2
   [xi, yi, button] = ginput(1);
   if button<=2
      x = [x; xi];
      y = [y; yi];
      plot(xi,yi,'go',xi,yi,'w-','era','back'); 
   else
      close(F);
      PtNbr = length(x);
      x = x(2:PtNbr);
      y = y(2:PtNbr);
   end;
end;
