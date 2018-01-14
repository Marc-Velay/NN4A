function [NCentres, L] = lvqItrain(Base, Labels, Centres, ClassCentres, lr0, it_nbr, freqplot);
%
% LVQITRAIN
%
% SYNTAXE :
%
%  NCentres = LVQITRAIN(Base, Labels, Centres, ClassCentres, lr0, it, freqplot)
%
%
% ARGUMENTS :
%
% Base   		: matrice des échantillons de la base d'apprentissage
% labels 		: vecteur ligne des labels de la base
% Centres 		: matrice initiale des centres  
% ClassCentres	: classe d'appartenace des centres
% it 	     		: nombre maximum d'itérations d'apprentissage
% freplot      : [optionnel] fréquence d'affichage, par défaut : pas d'affichage
%
% VALEURS DE RETOUR :
%
% NCentres  : 
% L         : erreur moyenne
%
%
% COMPATIBILITE :
%
%   Matlab 4.3+, Octave 2.0+
%


% Bruno Gas - LIS/P&C UPMC
% Création : 27 octobre 2000
% Version : 1.4
% Derniere révision : -
%  - B.Gas (1/12/2000) : help
%  - B.Gas (1/12/2000) : lr0 en paramètre
%  - B.Gas (4/12/2000) : neurones distance 
%  - B.Gas (4/2/2001)  : mise à jour tbx RdF

% --- Controle des arguments :

if nargin==6
   freqplot = it_nbr+1;	% pas d'affichage par défaut
elseif nargin==7
   clf, hold off;			% initialisation graphique
else
   disp('[LVQITRAIN] erreur d''usage : ');
   error('[NCentres, L] = lvqItrain(Base, Labels, Centres, ClassCentres, lr, it, freqplot)');
end;

[ans, ExNbr] = size(Labels);
[SizeEx, ans] = size(Base);
if ans~=ExNbr, 
   error('[LVQITRAIN] erreur: Pbm. de dimensions entre <Base> et <Labels>'); end;

[CellNbr, InputNbr] = size(Centres);
if InputNbr~=SizeEx, 
   error('[LVQITRAIN] erreur: Pbm. de dimension entre <Base> et <Centres>'); end;

[lig, col] = size(ClassCentres);
if col~=1, 
   error('[LVQITRAIN] erreur: <ClassCentres> devrait être un vecteur colonne'); end;
if lig~=CellNbr, 
   error('[LVQITRAIN] erreur: Pbm. de dimension entre <Centres> et <ClassCentres>'); end;

for it=1:it_nbr
   mk = lr0/it;							% gain strictement décroissant
	L(it) = 0;   
   for ex=1:ExNbr
         	 
 		delta = Centres' - Base(:,ex)*ones(1,CellNbr);
      dist = sum(delta.^2);
      [val gagnant] = min(dist);  		% centre le plus proche						
		S = ClassCentres(gagnant);			% classe gagnante
      
      Err = Base(:,ex)' - Centres(gagnant,:);
      if S==Labels(ex)						% bien classé
         Centres(gagnant,:) = Centres(gagnant,:) + mk*Err;
      else										% mal classé
         Centres(gagnant,:) = Centres(gagnant,:) - mk*Err; 
      end;
      
      L(it) = L(it) + sum(Err.^2);
   end;  
   %Affichage erreur :
	if rem(it,freqplot)==0   	   
   	semilogy(0:it-1, L(1:it));    
	   grid;
   	xlabel('Itérations d''apprentissage');
	   ylabel('Erreur quadratique');
   	title('LVQ-I : Coût quadratique');
	   drawnow;
	end;

end;

NCentres = Centres;   
   