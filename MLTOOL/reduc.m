function D=reduc(S,dx,dy)
%
%
% SYNTAXE :
%
% ImgOut = REDUC(ImgIn [,dx,dy])
% 
% Réduction d'une image binaire aux dimensions dX x dY.
% ImgIn image initiale; ImgOut image resultat en niveaux de gris 
% de dx lignes et dy colonnes
% il faut que dx<=nblignes de ImgIn dy<=nbcol ImgIn
% Conservation de l'intégrale de l'intensité
% (0 <= valeurs des pixels <= 1*255)
% 
% ARGUMENTS :
%
% 
% ImgIn 	   : Image à traiter
% dx, dy    : dimensions demandées (optionnel)
%
% VALEURS DE RETOUR :
%
% ImgOut		: Image réduite aux dimensions (dx,dy)
%
% 
% COMPATIBILITE :
%
%    Matlab 5.x+
%

% REDUC
% Maurice Milgram -LIS/P&C UPMC <maum@ccr.jussieu.fr>
% Création : < 1996
% Version 1.4
% Révisions : 
% - Catherine Achard (1997)
% - B.Gas (octobre 1999) : HELP, GUI
% - B.Gas (octobre 2000) : Image résultat en 255 niveaux de gris
% - B.gas (23/02/2001) : mise à jour tbx RdF


if nargin==0 | nargin==2 | nargin>3
   error('[REDUC] usage : ImgOut = reduc(ImgIn [, dx, dy])');   
elseif nargin==1   
   disp('Donner les dimensions de l''image réduite : ');
   dx = input('Dimension dx = ');
   dy = input('Dimension dy = ');
end;

[sx sy]=size(S);
D=zeros(dx,dy);
if sy<dy | sx<dx ,%%image input trop petite
   warning('[REDUC] : Image source plus petite que la réduction demandée : recadrage');
	debx=max(1,ceil((dx-sx)/2));deby=max(1,ceil((dy-sy)/2));
 	D(debx:(debx+sx-1),deby:(deby+sy-1))=S;
   return; 
end

kx=sx/dx;ky=sy/dy;
fi=floor(kx*(1:dx));
fj=floor(ky*(1:dy));
fi1=floor(kx*((1:dx)-1));
fj1=floor(ky*((1:dy)-1));
ci=ceil(kx*(1:dx));
cj=ceil(ky*(1:dy));
ci1=ceil(kx*((1:dx)-1));
cj1=ceil(ky*((1:dy)-1));
ki=kx*(1:dx);
kj=ky*(1:dy);

Tx=1;Ty=1;
%%% on cherche le grand pixel flotant contenant (k,l)
for i=1:dx, 
	for j=1:dy,
		kmin=ci1(i);if kmin<=0, kmin=1; end;
		lmin=cj1(j);if lmin<=0, lmin=1; end
		kmax=fi(i)+1;if kmax>sx, kmax=sx; end;
		lmax=fj(j)+1;if lmax>sy, lmax=sy; end;
		%%[kmin kmax lmin lmax]
		for k=kmin:kmax,
  		 	for l=lmin:lmax,
				if S(k,l)>0,
					%% cas inclusion par défaut
					Tx=1;Ty=1;
					%% calcul des surfaces communes au grd et petit pixel
					%% cas chevauchant à gauche
					if k-1<=fi1(i), Tx=k-kx*(i-1); end;
					if l-1<=fj1(j), Ty=l-ky*(j-1); end;
					%% cas chevauchant à droite
					if k>=ci(i), Tx=ki(i)-k+1; end;
					if l>=cj(j), Ty=kj(j)-l+1; end;
					%% accumulation dans D()
					%%[i j k l Tx Ty]
					D(i,j)=D(i,j)+Tx*Ty*S(k,l);
				end %%if S()>0
    
			end 
		end
	end
end
D=floor(D*255/max(D(:)));
