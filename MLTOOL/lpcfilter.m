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
% x   		: signal à filtrer (vecteur ligne)
%
% VALEURS DE RETOUR :
%
% y       : signal filtré
% E  	  : [optionnel] erreur de prédiction si le filtre est prédicteur
%
%
% COMPATIBILITE :
%
%  >= Matlab 4.3
%

% Mohamed Chetouani LIS/P&C UPMC, mohamed.chetouani@lis.jussieu.fr
% Création : 23 ctobre 2001
% Version : 1.0
% Derniere révision :  

if nargin~=2
	error('[LPCFILTER] usage : y = LPCFILTER(code, x)')	
end

% dimensions :
N =length(x);              % nombre d'échantillons du signal
y= filter(code,1,x);

E = x-y;
y=y';
E=E';
