function Base=chifget(arg1, arg2, arg3);
%
% SYNTAXE :
%
% Base = CHIFGET([filename [, set [, nbr]]])
%
% CHIFGET extrait des images de chiffres de la base de donnée chiffres
% (fichier "basechif.mat" d'images binaires (10 par 10 pixels sur 256 niveaux de gris))
%
% Sans arguments, la fonction entame un dialogue avec l'utilisateur
% pour obtenir le nom du fichier, le nombre d'images, etc.
% à extraire.
% Le fichier contient deux ensembles d'images : un ensemble pour
% l'apprentissage (1106 images) et un ensemble pour les tests
% (249 images). L'argument 'set' permet de choisir 
% l'appartenance des images.
%
%
% ARGUMENTS (optionnels) :
%
% filename 	= nom du fichier à ouvrir (basechif.mat)
% set       = appartenance des images :
%             'app' = base d'apprentissage
%             'tst' = base de test
%             'apptst' = peu importe
% nbr			= nombre d'images à extraire par classe
%             (10 signifie 10 images par classe, i.e. 
%             10x10=100 images)
%
%
% VALEURS DE RETOUR :
%
% Base : matrice des images au format des bases d'apprentissage,
%        c.a.d. une image par ligne suivie du label de la forme.
%        le label est un nombre entier de 1 à 10 (1 pour la classe
%        0, 2 pour la classe 1, ... 10 pour la classe des 9).
%
% COMPATIBILITE :
%
%    Matlab 5.3+
%
% VOIR AUSSI :
%
%   uichifget, base2target
% 

% Bruno Gas - LIS/P&C UPMC
% Création : octobre 2000
% Version 1.4
% Derniere révision : 
% - B. Gas (20/01/2001) : conflit var. Ttest avec la fonction ttest
% - B. Gas (26/01/2001) : interface TUI
% - B. Gas (27/07/2001) : 'basechif10.mat' remplace 'basechif.mat' (conflit avec ttest)


% controle des arguments :
if nargin>3,  error('Usage : Base = CHIFGET([filename [, set [, nbr]]])'); end

if nargin==0	
   filename = input('[CHIFGET] Nom du fichier de base (basechif.mat) = ','s');
else
   filename = arg1;
end;   
   
% chargement du fichier 'basechif10.mat' :
load(filename);
if exist('BaseApp')~=1 | exist('BaseTst')~=1 | exist('LabelApp')~=1 | exist('LabelApp')~=1
   error('[CHIFGET] fichier "basechif10.mat" non reconnu : variables recherchées introuvables');
end;

 
% nombre d'exemples disponibles par classe et par base :
[PixelNbr AppExNbr] = size(BaseApp);
[PixelNbr TstExNbr] = size(BaseTst);

for i=1:10
   ClassAppExNbr(i) = sum(LabelApp==i);
	ClassTstExNbr(i) = sum(LabelTst==i);   
end;
% plus petit nombre commun possible :
MaxAppNbr = min(ClassAppExNbr);
MaxTstNbr = min(ClassTstExNbr);
MaxNbr = MaxAppNbr + MaxTstNbr;

% choix de la base (apprentissage, test ou les deux) :
if nargin <2   
   disp('[CHIFGET] base d''apprentissage (app), de test (tst), les deux (apptst)');
   set = input('[CHIFGET] Base à utiliser (app,tst,apptst) = ','s');
else
   set = arg2;   
end;

% nombre maxi d'exemples selon la base :
if strcmp(set,'app')==1 
   set = 1;
   NMax = MaxAppNbr;
elseif strcmp(set,'apptst')==1 | strcmp(set,'tstapp')==1
   set = 3;
   NMax = MaxNbr;      
else      
   set = 2;
   NMax = MaxTstNbr;   
end;

% nombre d'exemples à extraire par classe :
if nargin<3      
   nbr = input('[CHIFGET] Nombre d''exemples par classe à extraire = ');
else   
   nbr = arg3;
end;

if nbr > NMax
   error('Base trop petite : nombre d''exemple demandé trop important');
end;


% extraction de la base :
Base = zeros(1,101);				% 101 = les 100 pixels + le label
if set==1 | (set==3 & nbr<=MaxAppNbr)
   offset = 1;
   for i=1:10      
      Base = [Base; [BaseApp(:,offset:offset+nbr-1)' ones(nbr,1)*i]];
      offset = offset + ClassAppExNbr(i);
   end;
elseif set==2
   offset = 1;
   for i=1:10      
      Base = [Base; [BaseTst(:,offset:offset+nbr-1)' ones(nbr,1)*i]];
      offset = offset + ClassTstExNbr(i);
   end;
else
   offsetApp = 1;
   offsetTst = 1;
   for i=1:10
      Base = [Base; [BaseApp(:,offsetApp:offsetApp+MaxAppNbr-1)' ones(MaxAppNbr,1)*i]; ...
            [BaseTst(:,offsetTst:offsetTst+nbr-MaxAppNbr-1)' ones(nbr-MaxAppNbr,1)*i]];
      offsetApp = offsetApp + ClassAppExNbr(i);
      offsetTst = offsetTst + ClassTstExNbr(i);      
   end;   
end;

Base = Base(2:nbr*10+1,:);
% normalisation entre 0 et 255 :
Base(:,1:100) = Base(:,1:100)*255; 
