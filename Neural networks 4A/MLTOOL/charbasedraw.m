function Base = charbasedraw(ClassNbr, ExNbr, Size, opt);
%
% CHARBASEDRAW
%
% SYNTAXE :
%
% [Base [, ClassNbr, ExNbr, Size]] = charbasedraw([ClassNbr, ExNbr ,Size, opt]);
%
% Construit une base de formes 'jouet', dessinées à l'aide de la souris.
% Les formes sont représentées par la liste des coordonnées normalisées 
% des points saisis. Les listes sont de longueurs identiques et égales à 
% <Size> sauf si cet argument vaut 0, auquel cas elles sont
% de longueur variable. Dans ce dernier cas, la matrice Base est 
% surdimensionnée aux dimensions de l'exemple le plus long et la valeur
% NaN est affectée aux éléments non utilisés.
% 
%
% ARGUMENTS [optionnels] :
%
% ClassNbr	: Nombre de classes 
% ExNbr		: Nombre d'exemples à dessiner par classe
% Size		: dimension des exemples en nombre de composantes
%				  si <Size> vaut 0, les composantes sont en nombre 
%             variable et non déterminé par défaut.
% opt       : options de normalisation :
%               'sans' : pas de normalisation
%               'moy'  : normalisation / moyenne
%               'var'  : normalisation / variance
%               'varmoy' : norm. moyenne et variance
%
% VALEURS DE RETOUR :
%
% Base 	: Base au format des bases RdF regroupant l'ensemble des formes 
%			  dessinées. Les exemples sont rangés en ligne, chaque ligne se terminant
%          par le label associé à la forme.
%			  Chaque forme est représentée par une liste de points dont les coordonnées
%          sont rangées les unes après les autres : 
%			  ligne i -> [x1 y1 x2 y2 .... x<Size> y<Size> label]
% ClassNbr, ExNbr, Size : [optionnels] voir les arguments. 
%
%
% COMPATIBILITE :
%
% 	Matlab 5.3+, Octave 2.0+
%
% VOIR AUSSI :
%
%  UICHARBASEDRAW, BASE2LABEL, BASE2TARGET, etc.   
% 

% B. Gas LIS-PARC - UPMC <gas@ccr.jussieu.Fr>
% Création : octobre 2000
% version 1.4
% Derniere révision : 
% - B. Gas (18/12/2000) : options de normalisation
% - B. Gas (24/1/2001) : TUI et GUI
% - B. Gas (22/11/2001) : fonction visu remplacée par fonction visustroke
% - B. Gas (17/12/2001) : implémentation listes de longueur variable
%
% BUG : Size=15 -> warning (parce que impair ??)


if nargin==0			% TUI
    ClassNbr = input('Nombre de classes = ');
    ExNbr = input('Nombre d''exemples par classe à dessiner = ');
    Size = input('Dimension des exemples (répondre 0 si quelconque) = ');
    opt = input('Option de normalisation (sans, moy, var ou varmoy) :','s');
end;
%if Size==0
%   	error('Désolé, option non implémentée encore (charbasedraw 1.2)');
%end;

if strcmp(opt,'sans')==1
    opt = 0;
elseif strcmp(opt,'moy')==1
    opt = 1;
elseif strcmp(opt,'var')==1
    opt = 2;
elseif strcmp(opt,'varmoy')==1
    opt = 3;
elseif strcmp(opt,'moyvar')==1
    opt = 3;
else
    error('option  = {''sans'', ''moy'', ''var'' ou ''varmoy''}');
end;


ind=1;
Label = 0;
Base = [];
lgvect = [];

F = figure(2);
clf;
for cl=1:ClassNbr
    for ex=1:ExNbr   
        %        [x, y] = scanmouse;                     % saisie
        figure(1)
        [x, y, tab] = mouseBase('depart','Acquistion');
        if opt==1
            x=x-mean(x);y=y-mean(y);			% centrage et normalisation
        elseif opt==2 
            x=x/std(x);y=y/std(y);				% normalisation
        elseif opt==3
            x=(x-mean(x))/std(x);y=(y-mean(y))/std(y); 
        end;
        
        if Size>0
            [x, y] = tab2vec(x,y,Size);				% ramène à <Size> points
            xy = [x';y']; xy = xy(:)';
            Base = [Base ; xy];      
        else
            xy = [x';y']; xy = xy(:)';
            [lig, col] = size(Base);
            lg = length(xy(:));
            if lig>0
                if lg>col                              % On complète par des 0
                    Base = [Base NaN*ones(lig,lg-col)];                 
                elseif lg<col
                    xy = [xy NaN*ones(1,col-lg)];
                end;
            end;     
            Base = [Base ; xy];      
        end;
        figure(2)
        subplot(ExNbr, ClassNbr, ind);
        visustroke([x,y,ones(length(x),1)],['Ex n° ' num2str(ex) ' Label ' num2str(cl)]);
        ind = ind+1;  
    end;       
    Label = [Label ; cl*ones(ExNbr,1)];
end;

Label = Label(2:ExNbr*ClassNbr+1);
Base = [Base Label];

pause;
close(F);

