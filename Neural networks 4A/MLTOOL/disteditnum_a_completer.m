function [distance, match] = disteditnum_a_completer(A,B)
%
% DISTEDIT - distance d'�dition avec attributs num�riques
%
% SYNTAXE :
%
% distance = DISTEDITNUM(A, B);
%
% Calcul la distance d'�dition entre les deux cha�nes A et B par
% l'algorithme de Wagner et Fisher.
% Les co�ts d'insertion et de suppression sont proportionnels
% � la norme des composantes vectorielles de l'�l�ment.
% Les co�ts de substitution sont proportionnels � la norme
% de la diff�rence des composantes vectorielles des deux �l�ments
% (distance euclidienne).
% 
%
% ARGUMENTS :
%
%
% A, B	: Les deux cha�nes � comparer : les vecteurs
%          num�riques constituant les cha�nes sont rang�s en ligne :
%          [ ---- symbole 1 ----- ;
%            ---- symbole 2 ----- ;
%                     :
%            ---- symbole N ----- ]
%
%
% VALEURS DE RETOUR :
%
% distance 	: la distance d'�dition entre A et B
% match     : chemin de matching
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
% Cr�ation : <= 96
% Version : 1.2
% Derniere r�vision : 
%  - B.Gas (1/11/2000) <gas@ccr.jussieu.fr>
%  - B.Gas (27/1/2001) : mise � jour tbx RdF

[n,dim]=size(A);
[m,dim1]=size(B);

if dim1~=dim, 
   error('[DISTEDITNUM] erreur: (<A> et <B> doivent avoir m�me nombre de colonnes)');
end;

%calcul de cout des �l�ments (suppression/insertion)
for i=1:n, cout_A(i)=norm(A(i,:)); end;
for i=1:m, cout_B(i)=norm(B(i,:)); end;

%init matrice D
D=ones(n,m)*inf;

% bcle de r�currence sur n,m
% Attention (1,1) correspond en fait � (0,0) d'o� d�calage

D(1,1)=0;

% %remplissage premi�re colonne
% for ...
% %remplissage premi�re ligne
% for ...
% 
% 
% caclcul de la distance
% for ...
% 	for ...
% 		U =...
% 		V =...
% 		W =...
% 		[D(i,j) P(i,j)] = min([U,V,W]);
% 	end;
% end;
% distance=D(n+1,m+1);
%
%d�termination du chemin de matching
%
% i = n+1 ;
% j = m+1 ;
% match = [] ;
% while ...
%         switch P(i,j)
%         case ...
%                 match ...
%         case ...
%                 match ...
%         case ... 
%                 match ...
%     end
% end



