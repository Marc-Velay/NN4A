function [Base, Label] = base2label(Base);
%
% BASE2LABEL
%
% SYNTAXE :
%
% [Base Label] = base2label(Base)
%
% Extrait le vecteur des labels � partir de la base donn�e
% en argument et retourne la base sans les labels.
%
% ARGUMENTS :
%
% Base : matrice des formes labellis�es.
%        les formes sont rang�es en ligne.
%        le dernier �l�ment de chaque ligne est le label de la forme
%
% VALEURS DE RETOUR :
%
% Label  : matrice ligne des labels
% Base   : matrice des �chantillons de la base, sans les labels.
%          les formes sont rang�es en colonnes
% 
% COMPATIBILITE :
%
%    Matlab 4.3+, Octave 2.x+
%


% Bruno Gas - LIS/P&C UPMC
% Cr�ation : mai 2000
% Version 1.1
% Derniere r�vision : 
%  - B. Gas (27/10/2000) : labels rang�s en ligne


[ex_nbr ex_size] = size(Base);
ex_size = ex_size - 1;

Label = Base(:,ex_size+1)';
Base = Base(:,1:ex_size)';
