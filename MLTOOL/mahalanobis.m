function distance = mahalanobis(X, Y, InvCovar)
%
% SYNTAXE :
%
%   distance = MAHALANOBIS(X, Y [,InvCovar]);
%
% Distance de Mahalanobis
%
%
% ARGUMENTS :
%
% X, Y : Les coordonnées des deux points dont on veut calculer la distance
%        de Mahalanobis à l'aide de la matrice de covariance inversée <InvCovar>.
%        ou :
%        Les coordonnées d'un point (X ou Y) et un ensemble d'obervations
%        (respectivement Y ou X), c'est à dire l'ensemble de points permettant
%        d'estimer la matrice de covariance (rangés en colonnes).
%        Le dernier argument n'est alors
%        pas utilisé et la distance calculé est la distance de Mahalanobis
%        du point au centre de gravité des points observés.
%					
%
% VALEURS DE RETOUR :
%
% distance : distance de mahalanobis d'un point à un autre ou à un nuage de points
%
%
% VOIR AUSSI :
%
%   COV
%
%
% COMPATIBILITE :
%
%  Matlab 4.3+
%

% MAHALANOBIS
% Friedrich Leisch <leisch@ci.tuwien.ac.at>
% Creation: Juillet 1993 (cf. Copyright)
% Revision : 1996 John W. Eaton
% Version : 1.0
% Derniere révision :
%  - B. Gas (27/11/2000) : adaptation à la tooblox RdF


errorbox = 'mahalanobis : Erreur';
warningbox = 'mahalanobis : Warning';
usage = 'distance = MAHALANOBIS(X, Y [,InvCovar])';


% Copyright (C) 1996 John W. Eaton
%
% This file is part of Octave.
%
% Octave is free software; you can redistribute it and/or modify it
% under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2, or (at your option)
% any later version.
%
% Octave is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
% General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with Octave; see the file COPYING.  If not, write to the Free
% Software Foundation, 59 Temple Place - Suite 330, Boston, MA
% 02111-1307, USA.
%
% Author: Friedrich Leisch <leisch@ci.tuwien.ac.at>
% Created: July 1993
% Adapted-By: jwe




function retval = mahalanobis (X, Y)

  if (nargin != 2)
    usage ("mahalanobis (X, Y)");
  endif

  [xr, xc] = size (X);
  [yr, yc] = size (Y);

  if (xc != yc)
    error ("mahalanobis: X and Y must have the same number of columns.");
  endif

  Xm = sum (X) / xr;
  Ym = sum (Y) / yr;

  X = X - ones (xr, 1) * Xm;
  Y = Y - ones (yr, 1) * Ym;

  W = (X' * X + Y' * Y) / (xr + yr - 2);

  Winv = inv (W);

  retval = (Xm - Ym) * Winv * (Xm - Ym)';

endfunction
