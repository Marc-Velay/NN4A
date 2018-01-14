function [Base, Label] = base2label(Base);
%
% BASE2LABEL
%
% SYNTAXE :
%
% [Base Label] = base2label(Base)
%
% Extrait le vecteur des labels à partir de la base donnée
% en argument et retourne la base sans les labels.
%
% ARGUMENTS :
%
% Base : matrice des formes labellisées.
%        les formes sont rangées en ligne.
%        le dernier élément de chaque ligne est le label de la forme
%
% VALEURS DE RETOUR :
%
% Label  : matrice ligne des labels
% Base   : matrice des échantillons de la base, sans les labels.
%          les formes sont rangées en colonnes
% 
% COMPATIBILITE :
%
%    Matlab 4.3+, Octave 2.x+
%


% Bruno Gas - LIS/P&C UPMC
% Création : mai 2000
% Version 1.1
% Derniere révision : 
%  - B. Gas (27/10/2000) : labels rangés en ligne


[ex_nbr ex_size] = size(Base);
ex_size = ex_size - 1;

Label = Base(:,ex_size+1)';
Base = Base(:,1:ex_size)';
