function [X,Y]=tab2vec(x,y,N)
%
% TAB2VEC
%
% SYNTAXE : 
%  [X,Y]=tab2vec(x,y,N)
%
%  construit un tracé on line isometrique dense de N pts
%  UN SEUL STROKE !!!!
%
%
% ARGUMENTS : -
% 
%  x, y : vecteurs des coordonnées des points initiaux
%  N    : nombre de points désirés
%
% VALEURS DE RETOUR :
%
% X, Y  : les coordonnées des N points calculés
% 
% COMPATIBILITE :
%
%    Matlab 5.1+
%

% M. Milgram, C. Achard -LIS PARC - UPMC
% Création : <= 96
% Version 1.3
% Derniere révision :
% - B.Gas (mai 2000) : import tbx RdF
% - B.Gas (octobre 2000) : help
% - B.Gas (24/02/2001) : mise à jour tbx RdF


if nargin~=3, error('[TAB2VEC] usage : [X,Y]=tab2vec(x,y,N)'); end;

% longueur du tracé
Np=length(x);
if Np~=length(y), error('[TAB2VEC] : x et y devraient être de même dimension'); end;
   
% nb de strokes
NStroke=1;
% tableau des lg cumulées par stroke
% le premier pt d'un stroke a donc un cumul nul
cumul=zeros(Np,1);

for nst=1:NStroke, %% longueur du stroke n° nst
	index=1:Np;%%find(s==nst);
	xx=x(index);yy=y(index);
	Nps=length(index);
	lgp=0; %%init longueur
	i1=index(1);
	xp=xx(1);
	yp=yy(1);
	for i=2:Nps, %%bcle sur les pts du stroke n°nst
	ii=index(i);
	xs=xx(i);ys=yy(i);
	lgp=lgp+sqrt((xs-xp)^2+(ys-yp)^2);
	cumul(ii)=lgp;
	xp=xs;yp=ys;
	end  %for i
	lg(nst)=lgp; %%longueur du stroke n° nst
end %for nst

lgtot=sum(lg) ;%%longueur totale
DL=lgtot/(N-NStroke+1); % nb segments = nb de pts - nb de strokes

% réechantillonnage pour chaque stroke
% 
X=[];Y=[];S=[];
for nst=1:NStroke
	index=1:Np;%%%find(s==nst);
	xx=x(index);yy=y(index);
	Nps=length(index);Dernier=max(index);
	NS=1+lg(nst)/DL; %%nb de pts à prendre (y compris le premier)
	%% lg cumulée cible pour chaque pt
	cible(1:NS)=(1:NS)*DL-DL;
	%% traitement du premier pt
	X=[X xx(1)];Y=[Y yy(1)];S=[S nst];
	%% recherche des lg cumulées encadrantes pour chaque pt rééchant.
	for i=2:NS,
	%% recherche dans index de l'indice max  pos avec cumul<=cible
	pos=max(find(cumul(index)<=cible(i)));
	imoins=index(pos);%% indice absolu
		if imoins<Dernier & length(X)<N-1,   %%cas typique
		%% interpolation linéaire
		exces=cible(i)-cumul(imoins);
		lambda=exces/(cumul(imoins+1)-cumul(imoins));
		XX=(1-lambda)*x(imoins)+lambda*x(imoins+1);
		YY=(1-lambda)*y(imoins)+lambda*y(imoins+1);
		X=[X XX];Y=[Y YY];S=[S nst];
		else %%if 
		%%% on prend le dernier
		X=[X x(Dernier)];Y=[Y y(Dernier)];S=[S nst];
		end
	end %%NS
end %%% strokes
NV=length(X);
K=NV-N;
if K>0, %%trop de pts
	for i=1:K,
	ii=floor(i*NV/(K+1));
	index=[(1:ii) ((ii+2):NV)];
	X=X(index);Y=Y(index);S=S(index);
	end;
end
if K<0, %%manque des pts
	K=-K;
	for i=1:K,
	ii=floor(i*NV/(K+1));i2=ii+2;NV1=NV+1;
	X=[X 0];Y=[Y 0];S=[S 0];
	index=(ii+1):NV;
	X(i2:NV1)=X(index);Y(i2:NV1)=Y(index);S(i2:NV1)=S(index);
	end;
end

%%élimination des pts doubles
ptdb=find(diff(X)==0 & diff(Y)==0);
	if length(ptdb>0),
		for np=1:length(ptdb),
		X(ptdb(np))=0.9*X(ptdb(np))+0.1*X(ptdb(np)-1);
		Y(ptdb(np))=0.9*Y(ptdb(np))+0.1*Y(ptdb(np)-1);
		end
	end
X=X(1:N)';Y=Y(1:N)';S=S(1:N)';

