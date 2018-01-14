function boolean = is_matrix(data)
%
% SYNTAXE :
%
% boolean = IS_MATRIX(data)
%
% IS_MATRIX retourne 1 si data est une matrice, 0 sinon
% Portage octave->matlab : IS_MATRIX n'existe pas sous matlab.
%
%
% COMPATIBILITE :
%   matlab 4.3+, octave 2.x+
%   ne fonctionne que pour les matrices 2D
%

% IS_MATRIX
% Bruno Gas, octobre 2000 <gas@ccr.jussieu.fr>
% Version 1.1
% Derniere révision :
%  B. Gas (27/1/2001) : mise à jour tbx RdF
%

if nargin~=1, error('[IS_MATRIX] usage: boolean = IS_MATRIX(data)'); end

[lig_nbr, col_nbr] = size(data);
if (lig_nbr>1 & col_nbr>1), boolean = 1;  else  boolean = 0;  end;
