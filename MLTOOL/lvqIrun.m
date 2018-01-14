function Labels = lvqIrun(Base, Centres, ClassCentres);
%
% LVQIRUN
%
% SYNTAXE :
%
%   Labels = lvqIrun(Base, Centres, ClassCentres)
%
%
% ARGUMENTS :
%
% Base   		: matrice des échantillons de la base d'apprentissage
% Centres 		: matrice initiale des centres  
% ClassCentres	: classe d'appartenace des centres
%
% VALEURS DE RETOUR :
%
% Labels    : classes des vecteurs 
%
%
% COMPATIBILITE :
%
%   Matlab 4.3+, Octave 2.0+
%


% Bruno Gas - LIS/P&C UPMC
% Création : 27 octobre 2000
% Version : 1.3
% Derniere révision : -
%  - B.Gas (1/12/2000) : help  
%  - B.Gas (4/2/2001)  : mise à jour tbx RdF
%  - B.Gas (6/12/2001) : correction du Help et pbm. d'ouverture inutile d'une figure

% --- Controle des arguments :

V = Centres*Base;			% prod. scalaire exemple.centres
[val, gagnant] = max(V);     		% rech. cell. gagnante
Labels = ClassCentres(gagnant)';	% classe gagnante       
