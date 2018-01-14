function [W,B] = randweights(LayerSize,InputSize,seed)
%
% SYNTAXE :
%
% [W [,B]] = RANDWEIGHTS(LayerSize,InputSize [,seed])
%
% RANDWEIGHTS est une fonction de génération aléatoire symétrique
%					des poids et biais d'une couche d'un réseau de type MLP.
%					Les poids et biais sont initialisés par des valeurs obéissant
%					à une distribution aléatoire uniforme [-1,+1].
%	
% ARGUMENTS :
%
% LayerSize : dimension de la couche en nombre de neurones.
% InputSize : nombre d'entrées.
%	seed      : [optionnel] Valeur d'initialisation du générateur aléatoire
%
%
% VALEURS DE RETOUR :
%
% W 	: une matrice de poids aléatoires (LayerSize x InputSize)
% B   : [optionnel] un vecteur de seuils aléatoires (LayerSize x 1)
%
%
% COMPATIBILITE :
%   matlab 5.x, octave 2.x
%

% RANDWEIGHTS
% M.H. Beale & H.B. Demuth, 1-31-92,  rands()
% Copyright (c) 1992 by the MathWorks, Inc.
% Version 1.2
% Derniere révision : -
% - F. Andrianasy 2-09-94, rand('dist')
% - B. Gas (Janvier 2000) <gas@ccr.jussieu.fr>
% - B. Gas (9/02/2001) : mise à jour tbx RdF
%

if nargin<2 | nargin>3
  error('[RANDWEIGHTS] Usage : [W [,B]] = RANDWEIGHTS(LayerSize,InputSize [,seed]).'); end;

if nargin==3, rand('seed',seed); end;

W = 2*rand(LayerSize,InputSize)-1;
if nargout==2, B = 2*rand(LayerSize,1)-1; end;

