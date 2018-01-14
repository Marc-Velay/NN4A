function boolean = is_octave;
%
%
% SYNTAXE :
%
%  boolean = IS_OCTAVE;
% 
% D�termine si l'on est sous octave en lisant le chemin
%
%
% 10 d�cembre 2000
% Bruno Gas <gas@ccr.jussieu.fr>
% Version : 1.0
%

p=path;
if sum(findstr (p, 'oct')) > 0, boolean = 1;  else 	boolean = 0;  end;	
