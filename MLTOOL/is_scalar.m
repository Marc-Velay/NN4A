function boolean = is_scalar(data)
%
% SYNTAXE :
%
% boolean = IS_SCALAR(data)
%
% IS_SCALAR retourne 1 si data est un scalaire, 0 sinon
% Portage octave->matlab : IS_SCALAR n'existe pas sous matlab.
%
%
% COMPATIBILITE :
%   matlab 4.3+, octave 2.x+
%

% IS_SCALAR
% Bruno Gas, octobre 2000 <gas@ccr.jussieu.fr>
% Version 1.1
% Derniere révision : -
% - B.Gas (27/1/2001) : mise à jour tbx RdF

if nargin~=1, error('[IS_SCALAR] usage: boolean = IS_SCALAR(data)'); end;

[lig_nbr, col_nbr] = size(data);
if (lig_nbr==1 & col_nbr ==1), boolean = 1; else   boolean = 0;  end;
