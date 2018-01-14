function [y,E] = lpcfilter(code, x);
%
% LPCFILTER 
%
% filtre LPC
%
% SYNTAXE :
%
% [y [,E]]  = LPCFILTER(code, x);
%
% Filtrage LPC du signal x
%
% ARGUMENTS :
%
% code		: codes LPC
% x   		: signal � filtrer (vecteur ligne)
%
% VALEURS DE RETOUR :
%
% y       : signal filtr�
% E  	  : [optionnel] erreur de pr�diction si le filtre est pr�dicteur
%
%
% COMPATIBILITE :
%
%  >= Matlab 4.3
%

% Mohamed Chetouani LIS/P&C UPMC, mohamed.chetouani@lis.jussieu.fr
% Cr�ation : 23 ctobre 2001
% Version : 1.0
% Derniere r�vision :  

if nargin~=2
	error('[LPCFILTER] usage : y = LPCFILTER(code, x)')	
end

% dimensions :
N =length(x);              % nombre d'�chantillons du signal
y= filter(code,1,x);

E = x-y;
y=y';
E=E';
