function distance=distedit(A,B, MatCout);
%
% DISTEDIT - distance d'�dition
%
% SYNTAXE :
%
% distance = DISTEDIT(A, B [, MatCout]);
%
% Calcul la distance d'�dition entre les deux cha�nes A et B par
% l'algorithme de Wagner et Fisher.
%
% ARGUMENTS :
%
% MatCout	: [optionnel] matrice des couts de dimension NbSymb+1 x NbSymb+1 o�
%             NbSymb est le nombre de symboles diff�rents.
%             MatCout(i,j) donne le cout de substitution du symbole i
%             par le symbole j. en i=1 et j=1, on trouve le symbole neutre,
%             MatCout(i,1) donne donc le cout de suppression du symbole i
%             tandis que MatCout(1,j) donne le cout d'insertion du symbole j.
%             Si MatCout n'est pas sp�cifi�e, une matrice de couts unitaires
%             � �l�ments diagonaux nuls est cr�e par d�faut.
%
% A, B	: Les deux cha�nes � comparer : deux matrices colonnes
%             comportant les symboles constitutifs.
%             Les symboles sont repr�sent�s par des nombre entiers
%             de 1 � NbSymb.
%
%
% VALEURS DE RETOUR :
%
% distance 	: la distance d'�dition entre A et B
%
% COMPATIBILITE :
%
% 	Matlab 4.3+
%
% VOIR AUSSI :
%
%  DISTEDITNUM  BELDIST  DTW   
% 

% M. Milgram, C. Achard, etc. (LIS/PARC - UPMC)
% Cr�ation : <= 96
% Version : 1.2
% Derniere r�vision : 
%  - B.Gas (octobre 2000) <gas@ccr.jussieu.fr>
%  - B.Gas (27/1/2001) : mise � jour tbx RdF

if nargin~=2 & nargin~=3 , 
   error('[DISTEDIT] usage: distance = DISTEDIT(A, B [, MatCout])'); 
end;

if nargin==2
	NbSymb = max(max(A),max(B));
	MatCout = ones(NbSymb+1, NbSymb+1);
	for i=1:NbSymb+1, MatCout(i,i)=0; end;
end;

[LgA, ans] = size(A);
if ans~=1, error('[DISTEDIT] erreur: L''argument A n''est pas un vecteur colonne'); end;
[LgB, ans] = size(B);
if ans~=1, error('[DISTEDIT] erreur: L''argument B n''est pas un vecteur colonne'); end;


%initialisation matrice des distances cumul�es D :
D=zeros(LgA+1,LgB+1);
D(1,1) = 0;
for i=2:LgA+1,  D(i,1) = D(i-1,1) + MatCout(A(i-1)+1,1); end;
for j=2:LgB+1,  D(1,j) = D(1,j-1) + MatCout(1,B(j-1)+1); end;

for i=2:LgA+1,
	for j=2:LgB+1,
		U=D(i-1,j-1)+MatCout(A(i-1)+1,B(j-1)+1);	% substitution de A(i-1) et B(j-1)
		V=D(i-1,j)+MatCout(1,B(j-1)+1);			% suppression de B(j-1)
		W=D(i,j-1)+MatCout(A(i-1)+1,1);			% insertion de A(i-1)
		[D(i,j),P(i,j)]=min([U,V,W]);
	end;
end;
distance=D(LgA+1,LgB+1);
 