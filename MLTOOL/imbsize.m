function Dim=imbsize(filename);
%
% IMBSIZE
%
% SYNTAXE :
%
% Base = IMBSIZE(filename)
%
% Retourne le nombre d'images présentes dans un fichier
% de lettres Kangourou au format '.imb'.
%
% ARGUMENTS :
%
% filename 	: nom du fichier à ouvrir
%
% VALEURS DE RETOUR :
%
% Dim : nombre d'images présentes dans le fichier
%
% COMPATIBILITE :
%
% Matlab 5.3+
%
% VOIR AUSSI :
%
%   IMBGET, IMK2IMB
% 

% Bruno Gas - LIS/P&C UPMC
% Création : octobre 1999
% Version : 1.1
% Derniere révision : 
% - B. Gas (27/1/2001) : révision tbx RdF


Dim = 0;
if nargin==0, error('[IMBSIZE] usage: imbsize(filename)'); end;

% calcul nb de caractères :
fid=fopen(filename);
if fid==-1
   error(['[IMBSIZE] erreur: ouverture du fichier <' filename '> impossible.']);   
end;

fseek(fid,0,1);   Dim = (ftell(fid)*8)/(60*60);    fclose(fid); 