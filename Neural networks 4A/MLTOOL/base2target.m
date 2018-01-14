function [Base, Target] = base2target(Base);
%
% BASE2TARGET
%
% SYNTAXE :
%
% [Base Target] = base2target(Base)
%
% Construit le vecteur des cibles a partir de la base donn�e
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
% Target : matrice des vecteurs cibles (en colonnes)
% Base   : matrice des �chantillons de la base, sans les labels.
%          les formes sont rang�es en colonnes
% 
% COMPATIBILITE :
%
%    matlab 4.3+, Octave 2.x+
%

% Bruno Gas - LIS/P&C UPMC
% Cr�ation : novembre 1999
% Version : 1.0
% Derniere r�vision : 

[ex_nbr ex_size] = size(Base);
ex_size = ex_size - 1;

pattern = Base(:,1:ex_size);
label = Base(:,ex_size+1);
class_nbr = max(label);

Target = label2target(label);
Base = Base(:,1:ex_size)';
