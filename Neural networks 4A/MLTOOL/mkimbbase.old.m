function Base = mkimbbase
%
% MKIMBBASE
%
% SYNTAXE :
%
% Base = MKIMBBASE
%
% Construit une base de donn�es labelis�e � partir
% des bases disponibles (base de lettres Kangourou,
% base de chiffres).
%
%
% ARGUMENTS :
%
% VALEURS DE RETOUR :
%
% Base : matrice des vecteurs images.
%        Les images sont rang�es en ligne. Le dernier
%        �l�ment de chaque ligne code le label. 
%        Pour g�n�rer une base avec ses vecteurs cibles,
%        utiliser BASE2TARGET ou BASE2LABEL.
%
%
% VOIR AUSSI :
%
%   IMBGET  BASE2TARGET  BASE2LABEL
% 

% MKIMBBASE
% Bruno Gas - LIS/P&C UPMC <gas@ccr.jussieu.fr>
% Cr�ation : 8/11/2000
% Version : 1.1
% Derniere r�vision : 
%  - B. Gas (9/02/2001) : mise � jour tbx RdF 

Base = [];
% recherche du chemin o� sont rang�s les fichiers :
pathname = input('R�pertoire o� sont rang�s les fichiers <.imb> = ','s');
% choix du nombre de classes diff�rentes :
ClassNbr = input('Nombre de classes diff�rentes d�sir�es = ','s');

% Choix des classes d'exemples :
disp('Choix : 25 lettres de B � Z');
for i=1:ClassNbr
   filename = [pathname char('A'+i) '.imb'];
   Nbim = imbsize(filename);

	lettre = input(['Classe N. ' num2str(i) ' : lettre choisie (ex:B) = '],'s'); 
   if lettre <'B' | lettre > 'Z'
      error('[MKIMBBASE] Mauvaix choix : caract�re non repr�sent� dans la base'); end;         
   lettres(i) = lettre;
   Nbr(i) = input('Nombre d''exemples pour cette classe (ex: 10) = ');
   Rang(i) = input('Rang de la premi�re lettre (ex: 1) = ');    
   if Rang(i)+Nbr(i)-1 > Nbim
         error('[MKIMBBASE]erreur: Trop de lettres demand�es ou rang trop �lev�'); end;             
end;


% Extraction de la base :
Base = [];
Labels = [];
 
for i=1:ClassNbr
   filename = [pathname Lettres(i) '.imb'];
   B = imbget(filename, i, Rang(i), Rang(i)+ Nbr(i)-1);
   Base = [Base; B];
end;



