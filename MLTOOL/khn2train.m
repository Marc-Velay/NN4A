function [NCentres, L] = khn2train (Base, Centres, DimX, DimY, nb_it, lr0, v0)
%
% KHN2TRAIN
% 
%  Apprentissage d'une carte de Kohonen 2 dimensions
% 
% SYNTAXE :
%
%  [NCentres, L] = khn2train (Base, Centres, DimX, DimY [, nb_it, lr, v0])
%
% ARGUMENTS : 
%
%  Base			: base des exemples utilisés pour l'apprentissage
%  Centres	   : neurones de la carte
%  DimX, DimY  : dimensions de la carte en nombre de neurones
%  nb_it			: nombre d'itérations d'apprentissage à réaliser
%  lr0			: pas d'apprentissage initial
%  v0				: taille initiale du voisinage (en nombre de cellules
%                de coté : l voisinage est carré)
%
% VALEURS DE RETOUR :
%
%  NCentres 	: nouveaux vecteurs centres
%  L           : erreur
%
%
% VOIR AUSSI :
%
%  KHN2DEF  KHN2RUN  KHN1* 
%
%
% COMPATIBILITE : 
%
%  Matlab 5.3+

% Bruno Gas - LIS/P&C UPMC <gas@ccr.jussieu.fr>
% Création : 9 novembre 2000
% Version 1.1
% Dernieres révisions : 
% - B.Gas (27/1/2001)

% controle des arguments :
if nargin<4 | nargin>7,    
   error('[KHN2train] usage: NCentres = khn2train (Base,Centres,DimX,DimY [,nb_it,lr0,v0])');
end;

[ExSize, ExNbr] = size(Base);  [CentreNbr, InputNbr] = size(Centres);   InputNbr = ExSize;
if DimX*DimY ~= CentreNbr
   disp('[KHN2TRAIN] erreur :');
   error('Dimensions de la carte incompatibles avec le nombre de centres');   
end;

if nargin==4
   nb_it	= input('Nombre d''itérations d''apprentissage (1000) = ');
   lr0	= input('Valeur initiale du pas adaptatif (0.001) = ');   
	v0		= input('Valeur initiale du voisinage (3) = ');
elseif nargin~=7
   error('[KHN2train] usage: NCentres = khn2train (Base,Centres,DimX,DimY [,nb_it,lr0,v0])');
end;

% table des indices :
Table = 1:CentreNbr;
Table = reshape(Table,DimX, DimY)';
for j=1:DimY
   for i=1:DimX
      numCentre = Table(j,i); 
      CoordX(numCentre) = i;
      CoordY(numCentre) = j;
   end;
end;

L = zeros(1,nb_it);   
for it=1:nb_it   
   lr = lr0/it;						% adaptation du pas et du voisinage
   pourcent = max(0,100-it+1)/100;
   v = floor(v0*pourcent);

	for ex=1:ExNbr   
      delta = Centres' - Base(:,ex)*ones(1,CentreNbr);
      dist = sum(delta.^2);
      [val ind] = min(dist);      
      gagnant = ind(1);				% centre le plus proche
      L(it) = L(it) + val(1); 	% erreur = distance au plus proche
      
      gagnantX = CoordX(gagnant);
      gagnantY = CoordY(gagnant);
      
      firstX = max(gagnantX-v,1);	% voisinage du gagnant
      lastX = min(gagnantX+v,DimX);
      firstY = max(gagnantY-v,1);
      lastY = min(gagnantY+v,DimY);
      
      ind = Table(firstY:lastY,firstX:lastX);
      ind = ind(:);
      Centres(ind,:) = Centres(ind,:) - lr*delta(:,ind)';     
   end;   
end;

NCentres = Centres;
