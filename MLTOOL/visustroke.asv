function visustroke(car,titre)
%
% VISUSTROKE
%
% SYNTAXE : 
%  visustroke(car,titre)
%
% Visualise 'car' (car=[x,y,s])
% 1 car. par écran; strokes de couleurs différentes; jonctions
% entre strokes en pointillés; sens de parcours.

%
%
% ARGUMENTS : -
% 
%  car   : tableau trois éléments [x, y, s]
%  titre : titre de la figure
%
% 
% COMPATIBILITE :
%
%    Matlab 5.1+
%

% M. Milgram, Andrianasy, C. Achard -LIS PARC - UPMC
% Création : 13/04/96
% Version 1.2
% Derniere révision :
% - B.Gas (mai 2000) : import tbx RdF
% - B.Gas (24/02/2001) : mise à jour tbx RdF


x=car(:,1);y=car(:,2);s=car(:,3);
x=300*x;y=300*y;
color='gyrbcmwk';smax=s(length(s));

%axis([-1000 +1000 -1000 +1000]);axis('equal');axis(axis);
axis('equal')
hold on;
 % Tracé des strokes successifs
 for i=1:smax,
 % Limiter le tracé au stroke courant
 ii=find(spones(spones(s-i)-1))';iimin=ii(1);iimax=ii(length(ii));
 xi=x(iimin:iimax);yi=y(iimin:iimax);xm=xi(1);ym=yi(1);
 %comet(xi,yi);
 %plot(xi,yi,[color(i) 'o'],xi,yi,[color(i) '-'],'era','back');
 plot(xi,yi,[color(i) '.'],xi,yi,[color(i) '-']);
 % Tracé du sens de parcours
 l=length(xi);ui=0.5*(xi(2:l)-xi(1:l-1));vi=0.5*(yi(2:l)-yi(1:l-1));
 
%%%quiver(xi(1:l-1),yi(1:l-1),ui,vi,0,[color(i) '-']);
%%%  EN TRAVAUX !!!!

  % Jonction entre strokes
  if 1<i, plot([xm0 xm],[ym0 ym],'r:','era','back'); end
 xm0=xi(length(xi));ym0=yi(length(yi));
 end
title(titre);
hold off;

