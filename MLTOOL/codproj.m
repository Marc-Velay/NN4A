function Base = codproj(Base, DimX, DimY, opt);
%
% CODPROJ
%
%   Codage d'images binaires par projection vectorielle (horizontale ou verticale).
%
% SYNTAXE :
%
%   Base = CODPROJ(Base, DimX, DimY [, opt]);
%
%
% ARGUMENTS :
%
%   Base 	   : Base d'images sans les labels (formes rang�es en colonnes).
%   DimX, DimY : dimensions des images
%   opt        : options = {'vert, horz'}
%                 'vert' : projection verticale (par d�faut)
%                 'horz' : projection horizontale
%
%
% VALEURS DE RETOUR :
%
%   Base    : Base cod�e selon la direction choisie. Chaque composante exprime
%             un pourcentage de pixels.
%
% DESCRIPTION : Chaque composante de code exprime un pourcentage de pixels
%               compt�s selon l'une ou l'autre direction.
%
%
% VOIR AUSSI :
%
%   
%
% COMPATIBILITE : 
%    matlab 5.3, octave 2.0
%

% Bruno Gas - LISIF/PARC UPMC <gas@ccr.jussieu.fr>
% Cr�ation : 27 juillet 2001
% version : 1.0
% Derniere r�vision : 

if nargin<3
   error('[CODPROJ] usage : Base = CODPROJ(Base, DimX, DimY, [, opt]);');      
elseif nargin==3, 
   opt = 'vert'; 
end;

[PixelNbr, ImgNbr] = size(Base);				% dimensions de la base
SumPixel = sum(Base);							% nombre total de pixels pour chaque img.
if strcmp(opt,'vert')==1, D=1; CodSize = DimY; else,D=2; CodSize = DimX; end;

Code = zeros(CodSize,ImgNbr);
for i=1:ImgNbr,
   Img = reshape(Base(:,i),DimX, DimY);
   if D==1
      Code(:,i) = sum(Img')'/SumPixel(i);
   else
      Code(:,i) = sum(Img)'/SumPixel(i);
   end;
end;

Base = Code;