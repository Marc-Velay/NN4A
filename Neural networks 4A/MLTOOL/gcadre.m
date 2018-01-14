function ImgOut=gcadre(ImgIn)
%
% GCADRE 
%
% SYNTAXE :
%
% ImgOut = GCADRE(ImgIn)
%
% Recadre l'image ImgIn en son centre de gravit� G.
% Les lignes et colonnes de pixels ext�rieurs � la forme
% sont �limin�es de sorte que l'image r�sultante est
% le plus petit carr� centr� en G et englobant les pixels
% de la forme.
% L'image est une image binaire (pixels du fond � 0 et pixels 
% de la forme � 1)
% 
% ARGUMENTS :
%
% ImgIn 	: forme � traiter (image binaire)
%
% VALEURS DE RETOUR :
%
% ImgOut : l'image de la forme recadr�e
% 
% 

% Maurice Milgram - LIS/P&C UPMC
% Cr�ation : <= 1996
% Version 1.2
% Dernieres r�visions : 
% - Catherine Achard (1997)
% - B. Gas (octobre 1999) : import dans toolbox RdF
% - B. Gas (27/1/2001) : r�vision tbx RdF

if nargin~=1, error('[GCADRE] usage : ImgOut = GCADRE(ImgIn)'); end;

[nl nc]=size(ImgIn);
plusgrand=max(nl,nc);
in1=zeros(plusgrand,plusgrand);
in1(1:nl,1:nc)=ImgIn;

%% on cadre d'abord
PV=(sum(in1'));			% profil vertical
PH=(sum(in1));				% profil horizontal

%% calcul G
masse=sum(ImgIn(:));
iG=sum((1:length(PV)).*PV)/masse;
jG=sum((1:length(PH)).*PH)/masse;

%% recherche des lignes/colonnes extr�mes
lignes_noires=find(PV>0);
col_noires=find(PH>0);
ideb=min(lignes_noires);	%% premi�re ligne non blanche
ifin=max(lignes_noires);	%% derni�re ligne non blanche
jdeb=min(col_noires);		%% premi�re col non blanche
jfin=max(col_noires);		%% derni�re col non blanche

%% calcul du demi-c�t� du carr�
demi=ceil(max(abs([iG-ideb,iG-ifin,jG-jdeb,jG-jfin])));
cote=2*demi+1;
ImgOut=zeros(cote,cote);
Di=fix(demi-iG);Dj=fix(demi-jG);
id=max(1,ideb+Di);
iff=id+(ifin-ideb); 

jd=max(1,jdeb+Dj);
jf=jd+(jfin-jdeb); 

ImgOut(id:iff,jd:jf)=in1(ideb:ifin,jdeb:jfin);
