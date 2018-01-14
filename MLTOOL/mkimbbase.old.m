function Base = mkimbbase
%
% MKIMBBASE
%
% SYNTAXE :
%
% Base = MKIMBBASE
%
% Construit une base de données labelisée à partir
% des bases disponibles (base de lettres Kangourou,
% base de chiffres).
%
%
% ARGUMENTS :
%
% VALEURS DE RETOUR :
%
% Base : matrice des vecteurs images.
%        Les images sont rangées en ligne. Le dernier
%        élément de chaque ligne code le label. 
%        Pour générer une base avec ses vecteurs cibles,
%        utiliser BASE2TARGET ou BASE2LABEL.
%
%
% VOIR AUSSI :
%
%   IMBGET  BASE2TARGET  BASE2LABEL
% 

% MKIMBBASE
% Bruno Gas - LIS/P&C UPMC <gas@ccr.jussieu.fr>
% Création : 8/11/2000
% Version : 1.1
% Derniere révision : 
%  - B. Gas (9/02/2001) : mise à jour tbx RdF 

Base = [];
% recherche du chemin où sont rangés les fichiers :
pathname = input('Répertoire où sont rangés les fichiers <.imb> = ','s');
% choix du nombre de classes différentes :
ClassNbr = input('Nombre de classes différentes désirées = ','s');

% Choix des classes d'exemples :
disp('Choix : 25 lettres de B à Z');
for i=1:ClassNbr
   filename = [pathname char('A'+i) '.imb'];
   Nbim = imbsize(filename);

	lettre = input(['Classe N. ' num2str(i) ' : lettre choisie (ex:B) = '],'s'); 
   if lettre <'B' | lettre > 'Z'
      error('[MKIMBBASE] Mauvaix choix : caractère non représenté dans la base'); end;         
   lettres(i) = lettre;
   Nbr(i) = input('Nombre d''exemples pour cette classe (ex: 10) = ');
   Rang(i) = input('Rang de la première lettre (ex: 1) = ');    
   if Rang(i)+Nbr(i)-1 > Nbim
         error('[MKIMBBASE]erreur: Trop de lettres demandées ou rang trop élevé'); end;             
end;


% Extraction de la base :
Base = [];
Labels = [];
 
for i=1:ClassNbr
   filename = [pathname Lettres(i) '.imb'];
   B = imbget(filename, i, Rang(i), Rang(i)+ Nbr(i)-1);
   Base = [Base; B];
end;



