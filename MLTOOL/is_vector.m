function boolean = is_vector(data)
%
% SYNTAXE :
%
% boolean = IS_VECTOR(data)
%
% IS_VECTOR retourne 1 si data est un vecteur ligne ou colonne, 0 sinon
% Portage octave->matlab : IS_VECTOR n'existe pas sous matlab.
%
%
% COMPATIBILITE :
%   matlab 4.3+, octave 2.x+
%

% IS_VECTOR
% Bruno Gas, octobre 2000 <gas@ccr.jussieu.fr>
% Version 1.1
% Derniere révision : -
% - B.Gas (27/1/2001) : révision tbx RdF 
%

if nargin~=1, error('[IS_VECTOR] usage: boolean = IS_VECTOR(data)'); end

[lig_nbr, col_nbr] = size(data);
if (lig_nbr==1 & col_nbr >1 )|(lig_nbr>1 & col_nbr==1), boolean = 1; else boolean = 0; end;

