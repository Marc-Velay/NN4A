function Base2D = acpn(Base,option);
%
% ACPN
%
%  Analyse en Composantes Principales Normées
%
% SYNTAXE :
%
%  usage: acpn(Base [,option])
%
%
% ARGUMENTS [optionnels] :
%
% Base      : Matrice des exemples rangés en colonnes ( ExDim x ExNbr )
% option 	= 'A' ou 'a' Affichage de l'analyse en composantes principales normées
%					Sinon pas d'affichage
%
% VALEURS DE RETOUR :
%
% Base2D    : projection des données sur les deux premiers axes factoriels
%
%
%
% VOIR AUSSI :
%
%  ad
%
% 
 
% J-L Zarader - LIS/P&C UPMC <zarader@ccr.jussieu.fr>
% Création : 
% Version 1.2
% Dernieres révisions : -
%  - M. Chetouani (13/03/2001) : import. toolbox RdF
%  - B. Gas (7/8/2001) : help
%

aff =0; % Condition d'affichage
if nargin ~=2,
   aff =0;
else
   if strcmp(option,'a')==1 |strcmp(option,'A')==1,
      aff =1;
   end;
   
end;

y= mat2vec(Base); % Transformation de la matrice Base en vecteur y

[ExDim ExNbr] = size(Base);
Tot_Ex=ExNbr*ExDim;

close all

v     = reshape(y(1:Tot_Ex ),ExDim,ExNbr)';
deca  = v-ones(ExNbr,1)*mean(v);
Ecart_Type =sqrt(ones(1,ExDim)./mean(deca.*deca));
deca  = deca.*(ones(ExNbr,1)*Ecart_Type);
covar = deca'*deca;
[Vect_Prop,Vale_Prop]=eig(covar);
Vec1  = Vect_Prop(:,ExDim:ExDim);
Vec2  = Vect_Prop(:,(ExDim-1:ExDim-1));
Axes_Fact = [Vec1 Vec2];
Auto_Proj = v*Axes_Fact;
  
  if aff ==1,
     % Visualisation des resultats
     plot(Auto_Proj(:,1),Auto_Proj(:,2),'o')
     xlabel('Axe principal');
     ylabel('Axe secondaire');
     title('Analyse en Composantes Principales Normées')
     pause
  end;
  
Base2D = Auto_Proj';
  
  


