function distance = beldist(A, B)
%
% SYNTAXE :
%
% distance = BELDIST(A, B);
%
% Distance de Belmann : algoritme de comparaison dynamique 
% (dynamic pattern matching).
%
% L'élaboration de la matrice des distance cumulées
% est effectuée à l'aide de la distance euclidienne
% entre les symboles constitutifs des deux chaînes.
% Ces symboles peuvent être des vecteurs de dimension
% identique.
%
% ARGUMENTS :
%
% A, B : Les deux chaînes à comparer : deux matrices codant
%        sur chaque ligne les symboles constitutifs 
%        (données numériques éventuellement vectorielles).
%        exemple :
%
%        A = [a1 a2 a3 ... an  :   symbole 1 (vecteur de dimension n)
%             b1 b2 b3 ... bn  :   symbole 2            "
%                  ...               ... 
%            ]
%					
%
% VALEURS DE RETOUR :
%
% distance : distance de Belmann calculée entre A et B
%
%
% VOIR AUSSI :
%
%   DISTEDIT
%
%
% COMPATIBILITE :
%
%  Matlab 4.3+
%

% BELDIST
% Sylvain Machel - UPMC DESS-IE (98)
% Création : 1999
% Version : 1.5
% Derniere révision :
%  - B. Gas (octobre 2000) <gas@ccr.jussieu.fr>
%  - B. Gas (24/10/2000) : bug: A(:,i) -> A(i,:), idem pour B
%  - B. Gas (26/10/2000) : bug: D(1,1) = 0
%  - B. Gas (1/11/2000) : init. de D(1,:) et D(:,1) revue
%  - B. Gas (24/1/2001) : erreurs en mode texte

if nargin~=2, errordlg('distance = BELDIST(A, B)'); end;
 
[LgA ASymbDim] = size(A);
[LgB BSymbDim] = size(B);

if ASymbDim ~= BSymbDim, 
   error('Symboles de la chaîne A et de la chaîne B incompatibles','errorbox');
else
   SymbDim = ASymbDim;
%	clear ASymbDim BSymbDim;   
end;

D = zeros(LgA, LgB); 

infini = 10000;
D(1,1) = 2*norm(A(1,:)-B(1,:));
for i=2:LgA, D(i,1) = infini; end;
 
for j = 2 : LgB
   for i = 1 : LgA  
      d = norm(A(i,:)-B(j,:));		%distance euclidienne entre les symboles

      if i==1
      	D(i,j) = D(i,j-1)+d;      
 		else
      	U = D(i-1,j);
      	V = D(i-1,j-1)+d;
      	W = D(i,j-1);
      	D(i,j) = d + min([U, V, W]);      
      end;
   end
end
 
distance = D(LgA,LgB)/(LgA+LgB);
