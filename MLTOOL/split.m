function tabstring = split(string,sep);
%
% SPLIT
%
% SYNTAXE :
%
%   Tab = split(s,sep);
%
% Convertit une chaîne de caractères <s> composée de sous chaînes
% séparées les uns des autres par le caractère <sep> en un tableau 
% des sous chaînes en question. Les sous chaînes sont complétées
% par des caractères blancs pour être de longueur identique.
% 
%
% ARGUMENTS :
%
%   s    : chaîne à convertir
%   sep  : caractère séparateur 
%
%
% VOIR AUSSI :
%
%  BLANKS  DEBLANK
%
% COMPATIBILITE :
%
%   matlab >= 5.1 (existe déjà sous octave)
%
%
% EXEMPLE :
%
%  tab=split('première chaîne /2eme chaîne /... ','/');
%


% Bruno Gas - LIS/P&C UPMC <gas@ccr.jussieu.fr>
% Création : 12 décembre 2000
% version : 1.0
% Derniere révision :
% - B.Gas (24/02/2001) : ~



if nargin ~= 2, error('[SPLIT] usage : tabstring = split(string,sep)'); end;

if length(sep) ~= 1,
   error('[SPLIT] le caractère séparateur <sep> doit être composé d''un seul caractère !'); end;

 
deb = [1 findstr(string,sep)+1];              % ind. de début des sous-chaînes
fin = [findstr(string,sep)-1 length(string)]; % fin des sous-chaînes
lg = fin - deb +1;                            % longueur des sous-chaînes
lgmax = max(lg);                              % plus longue sous-chaîne
StringNbr = length(lg);                       % nombre de sous-chaînes

tabstring = []; 
for i=1:StringNbr
   buf = string(deb(i):fin(i));               % récupération sous-chaîne
   buf = [buf blanks(lgmax-lg(i))];           % blancs complémentaires
   tabstring = [tabstring ; buf];             % rangement dans tableau
end;

