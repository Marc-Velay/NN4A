function distance=disteditnum(A,B);
%
% DISTEDIT - distance d'édition avec attributs numériques
%
% SYNTAXE :
%
% distance = DISTEDITNUM(A, B);
%
% Calcul la distance d'édition entre les deux chaînes A et B par
% l'algorithme de Wagner et Fisher.
% Les coûts d'insertion et de suppression sont proportionnels
% à la norme des composantes vectorielles de l'élément.
% Les coûts de substitution sont proportionnels à la norme
% de la différence des composantes vectorielles des deux éléments
% (distance euclidienne).
% 
%
% ARGUMENTS :
%
%
% A, B	: Les deux chaînes à comparer : les vecteurs
%          numériques constituant les chaînes sont rangés en ligne :
%          [ ---- symbole 1 ----- ;
%            ---- symbole 2 ----- ;
%                     :
%            ---- symbole N ----- ]
%
%
% VALEURS DE RETOUR :
%
% distance 	: la distance d'édition entre A et B
%
% COMPATIBILITE :
%
% 	Matlab 4.3+
%
% VOIR AUSSI :
%
%  DISTEDIT  BELDIST  DTW
% 

% M. Milgram, C. Achard, etc. (LIS/PARC - UPMC)
% Création : <= 96
% Version : 1.2
% Derniere révision : 
%  - B.Gas (1/11/2000) <gas@ccr.jussieu.fr>
%  - B.Gas (27/1/2001) : mise à jour tbx RdF

[n,dim]=size(A);
[m,dim1]=size(B);

if dim1~=dim, 
   error('[DISTEDITNUM] erreur: (<A> et <B> doivent avoir même nombre de colonnes)');
end;

%calcul de cout des éléments (suppression/insertion)
for i=1:n, cout_A(i)=norm(A(i,:)); end;
for i=1:m, cout_B(i)=norm(B(i,:)); end;

%init matrice D
D=ones(n,m)*inf;

% bcle de récurrence sur n,m
% Attention (1,1) correspond en fait à (0,0) d'où décalage

D(1,1)=0;

%remplissage première colonne
for i=2:n+1, D(i,1)=D(i-1,1)+cout_A(i-1); end;
%remplissage première ligne
for i=2:m+1, D(1,i)=D(1,i-1)+cout_B(i-1); end;

%remplissage du reste
%uniquement une bande
%bande=round(max(n,m)/5);
bande=max(n,m);

for i=2:n+1,
deb=max(2,i-bande);
fin=min(m+1,i+bande);
	for j=deb:fin,
		U=D(i-1,j-1)+norm(A(i-1,:)-B(j-1,:));
		V=D(i-1,j)+cout_A(i-1);
		W=D(i,j-1)+cout_B(j-1);
		D(i,j)=min([U,V,W]);
	end;
end;
distance=D(n+1,m+1);
