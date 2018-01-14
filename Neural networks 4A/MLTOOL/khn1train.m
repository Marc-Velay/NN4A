function [NCentres, L] = khn1train (Base, Centres, nb_it, lr0, v0)
%
% KHN2TRAIN
% 
%  Définition d'un carte de Kohonen 1 dimension
%
% 
% SYNTAXE :
%
%  [NCentres, L] = khn1train (Base, Centres [, nb_it, lr, v0])
%
%
% ARGUMENTS : 
%
%  Base			: base des exemples utilisés pour l'apprentissage
%  Centres	   : neurones de la carte
%  nb_it			: nombre d'itérations d'apprentissage à réaliser
%  lr0			: pas d'apprentissage initial
%  v0				: taille initiale du voisinage (en nombre de cellules)
%
%
% VALEURS DE RETOUR :
%
%  Centres 		: vecteurs centres initialisés
%
%
% DESCRIPTION :
%
%
% VOIR AUSSI :
%
%  KHN2DEF  KHN1RUN  KHNCLASS
%
%
% COMPATIBILITE : 
%
%  Matlab 5.3+

% Bruno Gas - LIS/P&C UPMC <gas@ccr.jussieu.fr>
% Création : 29 octobre 2000
% Version 1.1
% Dernieres révisions : -
%  - B.gas (27/01/2001) : mise à jour tbx RdF
%

% controle des arguments :
if nargin<2 | nargin>5, 
   error('[KHN1TRAIN] usage: NCentres = khn1train (Base, Centres [, nb_it, lr0, v0])');  end;

[ExSize, ExNbr] = size(Base);
[CentreNbr, InputNbr] = size(Centres);

if InputNbr~=ExSize
   error('[KHN1TRAIN] Pbm. de dimension entre les args. <Base> et <Centres>'); end;

if nargin==2
   nb_it = input('Nombre d''itérations d''apprentissage (1000) = ');
   lr0 = input('Valeur initiale du pas adaptatif (0.001) = ');
   v0 = input('Valeur initiale du voisinage (3) = ');   
elseif nargin~=5
   error('[KHN1TRAIN] usage: NCentres = khn1train (Base, Centres [, nb_it, lr0, v0])');
end;
   
   
L = zeros(1,nb_it);
for it=1:nb_it   
   if mod(it,10)==0
      it
   end;
      
   lr = lr0/it;						% adaptation du pas et du voisinage
   pourcent = max(0,100-it+1)/100;
   v = floor(v0*pourcent);

for ex=1:ExNbr   
      delta = Centres' - Base(:,ex)*ones(1,CentreNbr);
      dist = sum(delta.^2);
      [val ind] = min(dist);      
      gagnant = ind(1);				% centre le plus proche
      L(it) = L(it) + val(1); 	% erreur = distance au plus proche
      
      first = max(gagnant-v,1);	% voisinage du gagnant
      last = min(gagnant+v,CentreNbr);
      Centres(first:last,:) = Centres(first:last,:) - lr*delta(:,first:last)';     
   end;   
end;

NCentres = Centres;
