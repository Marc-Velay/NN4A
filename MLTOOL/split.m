function tabstring = split(string,sep);
%
% SPLIT
%
% SYNTAXE :
%
%   Tab = split(s,sep);
%
% Convertit une cha�ne de caract�res <s> compos�e de sous cha�nes
% s�par�es les uns des autres par le caract�re <sep> en un tableau 
% des sous cha�nes en question. Les sous cha�nes sont compl�t�es
% par des caract�res blancs pour �tre de longueur identique.
% 
%
% ARGUMENTS :
%
%   s    : cha�ne � convertir
%   sep  : caract�re s�parateur 
%
%
% VOIR AUSSI :
%
%  BLANKS  DEBLANK
%
% COMPATIBILITE :
%
%   matlab >= 5.1 (existe d�j� sous octave)
%
%
% EXEMPLE :
%
%  tab=split('premi�re cha�ne /2eme cha�ne /... ','/');
%


% Bruno Gas - LIS/P&C UPMC <gas@ccr.jussieu.fr>
% Cr�ation : 12 d�cembre 2000
% version : 1.0
% Derniere r�vision :
% - B.Gas (24/02/2001) : ~



if nargin ~= 2, error('[SPLIT] usage : tabstring = split(string,sep)'); end;

if length(sep) ~= 1,
   error('[SPLIT] le caract�re s�parateur <sep> doit �tre compos� d''un seul caract�re !'); end;

 
deb = [1 findstr(string,sep)+1];              % ind. de d�but des sous-cha�nes
fin = [findstr(string,sep)-1 length(string)]; % fin des sous-cha�nes
lg = fin - deb +1;                            % longueur des sous-cha�nes
lgmax = max(lg);                              % plus longue sous-cha�ne
StringNbr = length(lg);                       % nombre de sous-cha�nes

tabstring = []; 
for i=1:StringNbr
   buf = string(deb(i):fin(i));               % r�cup�ration sous-cha�ne
   buf = [buf blanks(lgmax-lg(i))];           % blancs compl�mentaires
   tabstring = [tabstring ; buf];             % rangement dans tableau
end;

