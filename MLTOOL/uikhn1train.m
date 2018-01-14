function [NCentres, L] = uikhn1train (Base, Centres, nb_it, lr0, v0)
%
% UIKHN2TRAIN
% 
%  Définition d'un carte de Kohonen 1 dimension
%  GUI de la fonction KHN1TRAIN.
% 
% SYNTAXE :
%
%  [NCentres, L] = khn1train (Base, Centres [, nb_it, lr, v0])
%
% VOIR AUSSI :
%
%  KHN1TRAIN  KHN2DEF KHN1RUN 
%
%
% COMPATIBILITE : 
%
%  Matlab 5.3+

% Bruno Gas - UPMC LIS/PARC <gas@ccr.jussieu.fr>
% Création : 27 janvier 2000
% Version 1.0
% Dernieres révisions : -
%

% controle des arguments :
if nargin<2 | nargin>5, 
   errordlg('NCentres = khn1train (Base, Centres [, nb_it, lr0, v0])',...
      'erreur d''usage dans <uikhn1train>'); error; end;

[ExSize, ExNbr] = size(Base);
[CentreNbr, InputNbr] = size(Centres);

if InputNbr~=ExSize
   errordlg('Pbm. de dimension entre <Base> et <Centres>','Erreur dans <uikhn1train>');
   error;
end;

if nargin==2
   default={'1000','0.001','3'};
   prompt={	'Nombre d''itérations d''apprentissage :',...
            'Valeur initiale du pas adaptatif : ',...
         	'Valeur initiale du voisinage : '...               
         };
	titre = 'KOHONEN1TRAIN : Paramètres de l''apprentissage';
   answer=inputdlg(prompt,titre,1,default);
   if isempty(answer)
      errordlg('Pas de réponse : échec','Erreur de dialogue dans <uikhn1train>'); error;
   end; 
   nb_it	= str2num(char(answer(1)));
   lr0	= str2num(char(answer(2)));   
	v0		= str2num(char(answer(3)));
elseif nargin~=5
   errordlg('NCentres = khn1train (Base, Centres [, nb_it, lr0, v0])',...
  		'erreur d''usage dans <uikhn1train>'); error; end;
end;

NCentres = khn1train(Bases, Centres, nb_it, lr0, v0);

