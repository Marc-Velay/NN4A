function Base = charbasedraw(ClassNbr, ExNbr, Size, opt);
%
% CHARBASEDRAW
%
% SYNTAXE :
%
% [Base [, ClassNbr, ExNbr, Size]] = charbasedraw([ClassNbr, ExNbr ,Size, opt]);
%
% Construit une base de formes 'jouet', dessin�es � l'aide de la souris.
% Les formes sont repr�sent�es par la liste des coordonn�es normalis�es 
% des points saisis. Les listes sont de longueurs identiques et �gales � 
% <Size> sauf si cet argument vaut 0, auquel cas elles sont
% de longueur variable. Dans ce dernier cas, la matrice Base est 
% surdimensionn�e aux dimensions de l'exemple le plus long et la valeur
% NaN est affect�e aux �l�ments non utilis�s.
% 
%
% ARGUMENTS [optionnels] :
%
% ClassNbr	: Nombre de classes 
% ExNbr		: Nombre d'exemples � dessiner par classe
% Size		: dimension des exemples en nombre de composantes
%				  si <Size> vaut 0, les composantes sont en nombre 
%             variable et non d�termin� par d�faut.
% opt       : options de normalisation :
%               'sans' : pas de normalisation
%               'moy'  : normalisation / moyenne
%               'var'  : normalisation / variance
%               'varmoy' : norm. moyenne et variance
%
% VALEURS DE RETOUR :
%
% Base 	: Base au format des bases RdF regroupant l'ensemble des formes 
%			  dessin�es. Les exemples sont rang�s en ligne, chaque ligne se terminant
%          par le label associ� � la forme.
%			  Chaque forme est repr�sent�e par une liste de points dont les coordonn�es
%          sont rang�es les unes apr�s les autres : 
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
% Cr�ation : octobre 2000
% version 1.4
% Derniere r�vision : 
% - B. Gas (18/12/2000) : options de normalisation
% - B. Gas (24/1/2001) : TUI et GUI
% - B. Gas (22/11/2001) : fonction visu remplac�e par fonction visustroke
% - B. Gas (17/12/2001) : impl�mentation listes de longueur variable
%
% BUG : Size=15 -> warning (parce que impair ??)


if nargin==0			% TUI
    ClassNbr = input('Nombre de classes = ');
    ExNbr = input('Nombre d''exemples par classe � dessiner = ');
    Size = input('Dimension des exemples (r�pondre 0 si quelconque) = ');
    opt = input('Option de normalisation (sans, moy, var ou varmoy) :','s');
end;
%if Size==0
%   	error('D�sol�, option non impl�ment�e encore (charbasedraw 1.2)');
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
            [x, y] = tab2vec(x,y,Size);				% ram�ne � <Size> points
            xy = [x';y']; xy = xy(:)';
            Base = [Base ; xy];      
        else
            xy = [x';y']; xy = xy(:)';
            [lig, col] = size(Base);
            lg = length(xy(:));
            if lig>0
                if lg>col                              % On compl�te par des 0
                    Base = [Base NaN*ones(lig,lg-col)];                 
                elseif lg<col
                    xy = [xy NaN*ones(1,col-lg)];
                end;
            end;     
            Base = [Base ; xy];      
        end;
        figure(2)
        subplot(ExNbr, ClassNbr, ind);
        visustroke([x,y,ones(length(x),1)],['Ex n� ' num2str(ex) ' Label ' num2str(cl)]);
        ind = ind+1;  
    end;       
    Label = [Label ; cl*ones(ExNbr,1)];
end;

Label = Label(2:ExNbr*ClassNbr+1);
Base = [Base Label];

pause;
close(F);

