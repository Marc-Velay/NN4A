function [Base, Target] = base2target(Base);
%
% BASE2TARGET
%
% SYNTAXE :
%
% [Base Target] = base2target(Base)
%
% Construit le vecteur des cibles a partir de la base donnée
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
% Target : matrice des vecteurs cibles (en colonnes)
% Base   : matrice des échantillons de la base, sans les labels.
%          les formes sont rangées en colonnes
% 
% COMPATIBILITE :
%
%    matlab 4.3+, Octave 2.x+
%

% Bruno Gas - LIS/P&C UPMC
% Création : novembre 1999
% Version : 1.0
% Derniere révision : 

[ex_nbr ex_size] = size(Base);
ex_size = ex_size - 1;

pattern = Base(:,1:ex_size);
label = Base(:,ex_size+1);
class_nbr = max(label);

Target = label2target(label);
Base = Base(:,1:ex_size)';
