function [W1,B1,L,LR] = uimlp1atrain(Base, Target, W1, B1, lr, n, err_glob, freqplot);
%
% MLP1ATRAIN
%
% SYNTAXE :
%
% [W1,B1,L,LR]=uimlp1atrain(Base, Target, W1, B1 [,lr, n, err_glob] [, freqplot]);
%
% Apprentissage des poids d'un Perceptron (sans couche cachée) par
% l'algorithme de rétropropagation (gradient total) et pas adaptatif.
% Interface graphique de la fonction mlp1atrain
%
%
% COMPATIBILITE :
%
%   Matlab 5.3+
%


% Bruno Gas - LISIF/PARC UPMC <gas@ccr.jussieu.fr>
% Création : 10 février 2001
% Version : 1.0
% Derniere révision :  -


% --- Controle des arguments :

if (nargin<8 | nargin>9) & nargin~=4 & nargin~=5,  
   errordlg('Usage : [W1,B1,L,LR] = uimlp1atrain(Base, Target, W1, B1 [, lr, n, err_glob] [, freqplot])',...
      'Erreur d'usage dans UIMLP1ATRAIN');   
   error;
end;
if nargin==4 | nargin==8, freqplot = 0;
elseif nargin==5, freqplot = lr; end;

if nargin<8
   default={'1000','0.001','0.001','0.9','1.1','1'};
   prompt={	'Nombre d''itérations d''apprentissage :',...
            'Erreur minimale (critère d''arrêt) : ',...
         	'Pas initial d''apprentissage : ',...
         	'Décrément du pas : ',...
            'Incrément du pas : ',...
            'Plage de stabilité du pas : '...         
         };
	titre = 'MLP1ATRAIN : Paramètres de l''apprentissage';
   answer=inputdlg(prompt,titre,1,default);
   if isempty(answer)
      errordlg('Pas de réponse : échec',errorbox); return;
   end;
   n			= str2num(char(answer(1)));
   err_glob	= str2num(char(answer(2)));   
	lr(1)		= str2num(char(answer(3)));
   lr(2)	   = str2num(char(answer(4)));
   lr(3)	   = str2num(char(answer(5)));
   lr(4)    = str2num(char(answer(6)));      
end;

if freqplot==0  
	[W1,B1,L,LR] = mlp1atrain(Base, Target, W1, B1, lr, n, err_glob);
else
   [W1,B1,L,LR] = mlp1atrain(Base, Target, W1, B1, lr, n, err_glob, freqplot);
end;



