function [NCentres, L] = uikhn2train (Base, Centres, DimX, DimY, nb_it, lr0, v0)
%
% KHN2TRAIN
% 
%  Apprentissage d'une carte de Kohonen 2 dimensions,
%  Interface graphique de la fonction khn2train.
% 
% SYNTAXE :
%
%  [NCentres, L] = uikhn2train (Base, Centres, DimX, DimY [, nb_it, lr, v0])
%
%
% VOIR AUSSI :
%
%  KHN2TRAIN  KHN2DEF  KHN2RUN  KHN1* 
%
%
% COMPATIBILITE : 
%
%  Matlab 5.3+

% Bruno Gas - LIS/P&C UPMC <gas@ccr.jussieu.fr>
% Création : 4 février 2001
% Version 1.0
% Dernieres révisions : -

% controle des arguments :
if nargin<4 | nargin>7,    
   errordlg('usage: NCentres = khn2train (Base,Centres,DimX,DimY [,nb_it,lr0,v0])',...
      'erreur d''usage dans uikhn2train');
   error;
end;

[ExSize, ExNbr] = size(Base);  [CentreNbr, InputNbr] = size(Centres);   InputNbr = ExSize;
if DimX*DimY ~= CentreNbr
   errordlg('Dimensions de la carte incompatibles avec le nombre de centres',...
      'erreur dans les arguments de uikhn2train');   
   error;
end;

if nargin==4
   default={'1000','0.001','3'};
   prompt={	'Nombre d''itérations d''apprentissage :',...
            'Valeur initiale du pas adaptatif : ',...
         	'Valeur initiale du voisinage : '...               
         };
	titre = 'Carte de Kohonen 2 couches : Paramètres de l''apprentissage';
   answer=inputdlg(prompt,titre,1,default);
   if isempty(answer)
      errordlg('Pas de réponse : échec','erreur dialogue utilisateur'); error;
   end; 
   nb_it	= str2num(char(answer(1)));
   lr0	= str2num(char(answer(2)));   
	v0		= str2num(char(answer(3)));
   
elseif nargin~=7
   errordlg('usage: NCentres = khn2train (Base,Centres,DimX,DimY [,nb_it,lr0,v0])',...
      'erreur d''usage dans uikhn2train');
   error;
end;

[NCentres, L] = khn2train (Base, Centres, DimX, DimY, nb_it, lr0, v0);

