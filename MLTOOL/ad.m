function [X, Centre] = ad(Base, Target, cte);
%
% AD - Analyse Discriminante
%
% SYNTAXE :
%
% [X, Centre] = AD(Base, Target [,cte]);
%
% Analyse discriminante de données.
% Ce programme permet d'extraire les 2 premiers axes factoriels d'un ensemble
% de données. Ces données sont présentées sous forme d'une matrice de
% de dimension (Dim x ExNbr) : dimension des données X nombre d'exemples.
% Les classes d'appartenance des données sont spécifiées dans la matrice
% 'Target' sous forme de labels successifs (1,2,3 etc.), mais éventuellemnt
% rangées dans un ordre quelconque.
% le nombre d'exemple par classe doit être identique.
% Les nouvelles coordonnées sont rangées dans la matrice 'X'.
% 'cte' est la normalisation de l'écart type pour l'interpolation
% graphique des nuages de point. Si 'cte' n'est pas spécifiée, aucune
% représentation graphique n'est réalisée. Dans le cas contraire,
% les nuages de points correspondant à chaque classe sont représentés.
%
%
% ARGUMENTS :
%
% Base 	 : matrice des données
% Target	 : classe d'appartenance des vecteurs
% cte     : normalisation de l'écart type pour la représentation graphique
%
% VALEURS DE RETOUR :
%
% X				: matrice des vecteurs exemples projetés.
% Centre			: matrice des centres des classes
%
% VOIR AUSSI :  -
%
% COMPATIBILITE :
%
%    Octave 2.x+, Matlab 5.x+
%

% J-L Zarader - LIS/P&C UPMC <zarader@ccr.jussieu.fr>
% Création : 1996
% version 1.4
% Derniere révision :
%  - B.Gas (28/04/2000) : import. toolbox RdF
%  - B.Gas (24/01/2001) : gestion des erreurs
%  - B.gas (17/02/2001) : dernière figure : points dans les ellipses
%	- M.Chetouani (26/03/2001) : 	- Ajout des Numeros de Classes
%											- Argument de Retour matrice des centres des Classes

if nargin<2 | nargin>3, error('[AD] erreur d''usage : X = ad(Base, Target [,cte] )'); end
if nargin==2, cte = 0; end;

[ExDim ExNbr] = size(Base);
TargetNbr = max(Target);
ClassNbr = TargetNbr;

% controle et réorganisation des données :
%-----------------------------------------

if length(Target)~=ExNbr
   error('[AD] Incohérence : dimension de <Target> non concordante avec celle de <Base>'); 
end

if min(Target) <= 0
	error('[AD] Labels erronés : les valeurs doivent être comprises entre 1 et "nombre de classes"');
end

[Target, index] = sort(Target);
Base = Base(:,index);

ExTargetNbr = sum(Target==1)
if ExTargetNbr == 0
  error('[AD] La label "1" n''est pas représenté dans <Target>');  
else
	for cible = 2 : TargetNbr
	  ans = sum(Target==cible);
	  if ans == 0
	  	error(['[AD] Le label ' num2str(cible) ' n''est pas représenté dans <Target>']);		    
	  elseif ans ~= ExTargetNbr
	  	error('[AD] Labels : le nombre d''exemples par classe doit être identique');	  	
    end;
	end;
end;



% Calcul de la matrice de covariance totale:
%-------------------------------------------
Moy_Tot_Coeff = mean(Base');
deca  = Base'-ones(ExNbr,1)*Moy_Tot_Coeff;
Norm  = 1/ExNbr;
Covar_Tot = Norm*deca'*deca;
Inv_Covar_Tot = inv(Covar_Tot);

% Calcul de la matrice de covariance inter phonèmes:
%---------------------------------------------------
Mat_Moy = [];
for class_num=1:ClassNbr
  Moy_Pho = mean(  Base(:,(class_num-1)*ExTargetNbr+1:class_num*ExTargetNbr)'   );
  Mat_Moy =[Mat_Moy;Moy_Pho-Moy_Tot_Coeff];
end

% Extraction des axes factoriels:
%--------------------------------
Norm = ExTargetNbr/ExNbr;
Covar_Inter_Pho = Norm*Mat_Moy'*Mat_Moy;
[Vect_Prop,Vale_Prop]=eig(Inv_Covar_Tot*Covar_Inter_Pho);
Valeurs = abs(sum(Vale_Prop));
[Max_Val Ind_Val] = max(Valeurs);
Vec1  = Vect_Prop(:,Ind_Val:Ind_Val) ;
Valeurs(Ind_Val) = 0;
[Max_Val Ind_Val] = max(Valeurs);
Vec2  = Vect_Prop(:,Ind_Val:Ind_Val) ;
Axes_Fact = [Vec1 Vec2];

% Projection des exemples:
%-------------------------
X = zeros(ExNbr,2);
for class_num=1:ClassNbr
	X((class_num-1)*ExTargetNbr+1:class_num*ExTargetNbr,:)...
		= Base(:,(class_num-1)*ExTargetNbr+1:class_num*ExTargetNbr)' * Axes_Fact;
	Proj = X((class_num-1)*ExTargetNbr+1:class_num*ExTargetNbr,:);   
end;

Centre     = [];
% Determination des Barycentres
for class_num=1:ClassNbr
   Proj = X((class_num-1)*ExTargetNbr+1:class_num*ExTargetNbr,:);   
	Centre=[Centre;mean(Proj)];
end;

% Représentation graphique:
%--------------------------

if cte~=0
	Centre     = [];
	Ecart_Type = [];
	cte        = cte^2;
	D          = [];

	for class_num=1:ClassNbr,
  	Proj = X((class_num-1)*ExTargetNbr+1:class_num*ExTargetNbr,:);

	  Mi   = min(Proj) ; Ma = max(Proj);
  	Mres = Ma-Mi ; Ax = max(Mres);
	  Ech=[Ma(1)-Ax Ma(1) Ma(2)-Ax Ma(2)];

  	x1=min(Proj(:,1)):(max(Proj(:,1))-min(Proj(:,1)))/1000:max(Proj(:,1));
	  interpol=polyfit(Proj(:,1),Proj(:,2),1);
  	y1=interpol(1)*x1+interpol(2);

	  Centre=[Centre;mean(Proj)];
  	Ecart_Type = [Ecart_Type;std(Proj)];
	  r1=Ecart_Type(class_num,1);
  	r2=Ecart_Type(class_num,2);
	  x0=Centre(class_num,1);
  	y0=Centre(class_num,2);

	  ph=atan(interpol(1));
  	if r2>r1, ph=ph+pi/2; end;
	  M=[cos(ph) -sin(ph);sin(ph) cos(ph)];

  	xab=-r1*sqrt(cte):(2*r1*sqrt(cte))/1000:r1*sqrt(cte);
	  yor=sqrt(abs(cte-(xab.*xab/r1/r1)))*r2;
  	V=[xab;yor];
	  D1=V'*M';
  	D1(:,1)=D1(:,1)+x0;
  	D1(:,2)=D1(:,2)+y0;
  	V=[xab;-yor];
	  D2=V'*M';
  	D2(:,1)=D2(:,1)+x0;
	  D2(:,2)=D2(:,2)+y0;
  	plot(x1,y1,'r',Proj(:,1:1),Proj(:,2:2),'+',D1(:,1:1),D1(:,2:2),'b',D2(:,1:1),D2(:,2:2),'b')
  	xlabel('Axe principal');
  	ylabel('Axe secondaire');
  	title(['Projection de la classe labellisée <' num2str(class_num) '>']);
  	pause
  	D=[D D1 D2];
	end

	xlabel('Axe principal');
	ylabel('Axe secondaire');
	title(['Projection de l''ensemble des classes (std=' num2str(cte) ')']);
   
   class_num = 1;
	plot(D(:,1),D(:,2),'r',D(:,3),D(:,4),'r');
	text(Centre(class_num,1)+Ecart_Type(class_num,1),Centre(class_num,2)+Ecart_Type(class_num,2),[ num2str(class_num)])
	
	hold on

	for class_num=2:ClassNbr,
	  plot(D(:,4*(class_num-1)+1:4*(class_num-1)+1),...
	  	D(:,4*(class_num-1)+2:4*(class_num-1)+2),'r',...
	  	D(:,4*(class_num-1)+3:4*(class_num-1)+3),...
      D(:,4*(class_num-1)+4:4*(class_num-1)+4),'r')
     text(Centre(class_num,1)+Ecart_Type(class_num,1),Centre(class_num,2)+Ecart_Type(class_num,2),[ num2str(class_num)])
   end

	pause;   
   
   plot(X(:,1),X(:,2),'.');
	hold off;
    
end;

X = X';




