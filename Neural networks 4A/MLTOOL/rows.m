function n = rows(data)
%
% SYNTAXE :
%
% n = ROWS(data)
%
% ROWS retourne le nombre de lignes de data
% Portage octave->matlab : ROWS n'existe pas sous matlab.
%
%
% COMPATIBILITE :
%   matlab 4.3+, octave 2.x+
%

% ROWS
% Bruno Gas, octobre 2000 <gas@ccr.jussieu.fr>
% Version 1.1
% Derniere révision : 
% - B.Gas (24/02/2001) : mise à jour tbx RdF
%

[n, ans] = size(data);


