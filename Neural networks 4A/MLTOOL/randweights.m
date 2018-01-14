function [W,B] = randweights(LayerSize,InputSize,seed)
%
% SYNTAXE :
%
% [W [,B]] = RANDWEIGHTS(LayerSize,InputSize [,seed])
%
% RANDWEIGHTS est une fonction de g�n�ration al�atoire sym�trique
%					des poids et biais d'une couche d'un r�seau de type MLP.
%					Les poids et biais sont initialis�s par des valeurs ob�issant
%					� une distribution al�atoire uniforme [-1,+1].
%	
% ARGUMENTS :
%
% LayerSize : dimension de la couche en nombre de neurones.
% InputSize : nombre d'entr�es.
%	seed      : [optionnel] Valeur d'initialisation du g�n�rateur al�atoire
%
%
% VALEURS DE RETOUR :
%
% W 	: une matrice de poids al�atoires (LayerSize x InputSize)
% B   : [optionnel] un vecteur de seuils al�atoires (LayerSize x 1)
%
%
% COMPATIBILITE :
%   matlab 5.x, octave 2.x
%

% RANDWEIGHTS
% M.H. Beale & H.B. Demuth, 1-31-92,  rands()
% Copyright (c) 1992 by the MathWorks, Inc.
% Version 1.2
% Derniere r�vision : -
% - F. Andrianasy 2-09-94, rand('dist')
% - B. Gas (Janvier 2000) <gas@ccr.jussieu.fr>
% - B. Gas (9/02/2001) : mise � jour tbx RdF
%

if nargin<2 | nargin>3
  error('[RANDWEIGHTS] Usage : [W [,B]] = RANDWEIGHTS(LayerSize,InputSize [,seed]).'); end;

if nargin==3, rand('seed',seed); end;

W = 2*rand(LayerSize,InputSize)-1;
if nargout==2, B = 2*rand(LayerSize,1)-1; end;

