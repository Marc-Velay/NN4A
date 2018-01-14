function Base=imbget(arg0, arg1, arg2, arg3, arg4);
%
% SYNTAXE :
%
% Base = IMBGET([filename, label [, nbr | premier, dernier])
% Base = IMBGET('auto' [, pathname [, lettres [, nbr [, rang_premier]]]])
%
% IMBGET extrait des images � partir de la base de donn�e lettre
% (fichiers Kangourou) d'images binaires (60 par 60 pixels)
% au format '.imb'.
% Sans arguments, la fonction questionne l'utilisateur
% pour obtenir le nom du fichier, le nombre d'images, etc.
% � extraire.
% Les images d'origine de la base kangourou sont au format '.imk'.
% le format '.imb' permet une extraction plus rapide des images.
% La fonction IMK2IMB permet une conversion du format '.imk'
% vers le format '.imb'.
%
% Si le premier argument est la chaine 'auto',  IMBGET construit 
% une base multi-classes comportant les caract�res sp�cifi�s en deuxi�me argument 
% � raison de 'nbr' caract�res par classe tous prix � partir du rang
% d�sign� par 'premier'
%
% ARGUMENTS :
%
% Base = IMBGET([filename, label [, nbr | premier, dernier])
% filename 	       : nom du fichier � ouvrir
% label            : entier repr�sentant le label � attribuer � la forme
% nbr			   : nombre d'images � extraire
% premier, dernier : num�ro premi�re image et derniere image
%
% Base = IMBGET('auto' [, pathname [, lettres [, nbr [, rang_premier]]]])
% pathname       : chemin d'acc�s de la base
% lettres        : 'BCDEF...' liste des caract�res � extraire
% nbr            : nombre de caract�res par classe
% rang_premier   : rang dans la base du 1er caract�re � extraire
%
%
% VALEURS DE RETOUR :
%
% Base : matrice des images [60x60+1 ,nbr],
%        les 60 x 60 pixels suivis en derni�re colonne du label
%
% COMPATIBILITE :
%
%    Matlab 5.3+
%
% VOIR AUSSI :
%
%    uiimbget, imbsize, imk2imb
% 

% Bruno Gas - LIS/P&C UPMC - <gas@ccr.jussieu.fr>
% Cr�ation : octobre 1999
% Version 1.5
% Derniere r�vision : 
%  - B. Gas (octobre 2000) 
%  - B. Gas (8/11/2000) : ajout <arg1> des labels 
%  - B. Gas (27/1/2001) : mise � jour tbx RdF et GUI
%  - B. Gas (28/7/2001) : erreur dans le help � propos des labels
%  - B. Gas (19/11/2002): impl�mentation du mode 'auto' 

if nargin>=1 & strcmp(arg0,'auto')
    if nargin <=1, arg1 = input('Chemin d''ac�s � la base = ','s'); end;
    if nargin <=2, arg2 = input('Classes de caract�res � extraire (ex: BCDE) = ','s'); end;
    if nargin <=3, arg3 = input('Nombre d''images par classe � extraire = '); end;
    if nargin <=4, arg4 = input('Rang d''extraction dans la base = ');  end;
    if nargin >5,
        error('[IMBGET] usage : IMBGET(''auto'' [, pathname [, lettres [, nbr [, rang_premier]]]])');
    end;
   
    Base = imbautoget(arg1, arg2, arg3, arg4);
    return;
end
                
Base = 0;
        
if nargin==0
    filename = input('Nom et chemin du fichier de base (.imb) = ','s');
else
    filename = arg0;
end;
Nbim = imbsize(filename);

if nargin<=1
   first = input('Num�ro de la premi�re lettre � extraire = ');
   last = input('Num�ro de la derni�re lettre � extraire = ');
   label = input('Label = ');
   
elseif nargin==2
   first = input('Num�ro de la premi�re lettre � extraire = ');
   last = input('Num�ro de la derni�re lettre � extraire = ');
   label = arg1;
       
elseif nargin==3      
   label = arg1;
   first = 1;
   last = first + arg2 - 1;   
 
elseif nargin==4
   label = arg1;
   first = arg2;
   last = arg3;
end;

if first<1 | first>Nbim | last<first | last > Nbim   
   error('[IMBGET] erreur sur le nombre d''images demand�es', errorbox);
end;

Nbim = last-first+1;   				% nbr. d'images r�cup�r�es 
											% extraction des images :
Dim = 60;								% dimension des caract�res
Taille = Dim*Dim;

fid = fopen(filename,'r');
if first>1								% positionnement sur le 1er caract�re :
	fseek(fid,(Taille*(first-1))/8,-1);
end;
											% lecture binaire (1bit=1pixel)
Base = fread(fid,Nbim*Taille,'bit1');   
fclose(fid);

Base = (Base+1);						% le bit de signe devient +1 

Base = ~reshape(Base,Taille,Nbim)';
Base = [Base label*ones(Nbim,1)];% Label des images



function Base = imbautoget(pathname, lettres, nbr, rang_premier)

ClassNbr = length(lettres);

if ClassNbr==0
    error('[IMBGET(''auto'')] erreur : argument <lettres> vide ou non valide');
end;

Base = [];

for i=1:ClassNbr
    filename = [pathname '\' lettres(i) '.imb'];
    Nbim = imbsize(filename);
    if rang_premier+nbr-1 > Nbim
        disp(['Nombre d''exemples demand�s : ' num2str(nbr)]);
        disp(['Nombre d''exemples disponibles � partir du rang <' num2str(rang) '> : ' num2str(Nbim-rang)]);
        error('[IMBGET(-auto-)] erreur : nombre d ''exemple demand� trop important');
    end;
    Base = [Base; imbget(filename, i, rang_premier, rang_premier+nbr-1)]; 
end;
