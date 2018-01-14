function Base=genbase(max_classe, max_mode, var, nb_ex);
%
% GENBASE
%
% SYNTAXE :
%
% Base = GENBBASE
%
% Génère une base de prototypes en deux dimensions 
% selon une distribution gaussienne ou multi-gaussienne.
% Les prototypes générés appartiennent à une ou plusieurs classes
%
%
% ARGUMENTS :
%
% max_classe : nombre de classes souhaité
% max_mode   : tableau du nombre de gaussiennes désirées pour chacune des classes
% var        : tableau 2D des variances pour chacune des classes et des gaussiennes 
% nb_ex      : nombre de prototypes demandé pout chacune des classes
%
% VALEURS DE RETOUR :
%
% Base : matrice des vecteurs générés.
%        Les prototypes sont rangées en ligne. Le dernier
%        élément de chaque ligne code le label. 
%        Pour générer une base avec ses vecteurs cibles,
%        utiliser BASE2TARGET ou BASE2LABEL.
%
%
% VOIR AUSSI :
%
%   BASE2TARGET  BASE2LABEL LABEL2TARGET
% 

% GENBASE
% Lionel Prevost - LISIF/PARC UPMC
% Création : 14/10/2004
% Version : 1.1
% Derniere révision : 
%  - B.Gas (15/10/2004): import toolbox RdF 
%  - B.Gas (17/10/2004): correction bug 

% controle des arguments :
if nargin ~= 0 & nargin ~= 4
   error('Usage : genbase [max_classe max_mode var nb_ex]');
end;

if nargin ~= 0
   if size(max_mode) ~= max_classe
      error('[GENBASE] incohérence : la dim. du tableau des modes ne correspond pas au nombre de classes');
   end;
   if size(var,1) ~= max_classe
      error('[GENBASE] incohérence : la dim. du tableau des variances ne correspond pas au nombre de classes');
   end;
   if size(nb_ex) ~= max_classe
	   error('[GENBASE] incohérence : la dim. du tableau nb_ex ne correspond pas au nombre de classes');
	end;
else
	max_classe = input('nombre de classes ? ') ;
end;

x1 = [] ;
x2 = [] ;
label = [] ;
close all;

disp(' ')
figure(1), axis([-1 1 -1 1]), hold on
n = 1 ;
%color = 'krbgcm' ;
color = 'rbgymck';
for nb_classe = 1 : max_classe
    if nargin == 0
       max_mode(nb_classe) = input(['classe ' num2str(nb_classe) ' nombre de mode(s) ? ']) ;
    end;
    for nb_mode = 1 : max_mode(nb_classe)
	    if nargin == 0
       	nb_ex(nb_classe, nb_mode) = input(['classe ' num2str(nb_classe) '  mode ' num2str(nb_mode) ' : nombre d''exemples ? ']) ;
         var(nb_classe, nb_mode) = input(['classe ' num2str(nb_classe) '  mode ' num2str(nb_mode) ' : variance (0 < v < 1) ? ']) ;
       end;
       disp(' ')
       title('cliquer pour positionner le centre de classe')
       figure(1)
       [xmc1(nb_classe, nb_mode) xmc2(nb_classe, nb_mode)] = ginput(1) ;
       xm1 = xmc1(nb_classe, nb_mode) + var(nb_classe, nb_mode)*randn(1, nb_ex(nb_classe, nb_mode)) ;
       xm2 = xmc2(nb_classe, nb_mode) + var(nb_classe, nb_mode)*randn(1, nb_ex(nb_classe, nb_mode)) ;
       plot(xm1, xm2, [color(n) '+']) ;
       x1 = [x1 xm1] ;
       x2 = [x2 xm2] ;    
       label = [label nb_classe*ones(1, nb_ex(nb_classe, nb_mode))] ;
    end
    n= n+1 ;
end
data = [x1 ; x2] ;

Base = [data' label'];
disp('[GENBASE] tapez <Return> pour terminer.');
pause;
close all;


%c = menu('sauvegarder', 'oui', 'non') ;
%if c==1
%    fname = input('nom du fichier ? ')
%    save(fname, 'data', 'label') ;
%end



