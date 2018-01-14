function Code = codret(Base, Dx, Dy, NDx, NDy);
%
% CODRET
%
%   Codage rétinien d'images binaires  
%
% SYNTAXE :
%
%   Code = CODRET(Base, Dx, Dy, NDx, NDy);
%
%
% ARGUMENTS :
%
%   Base 	   : Base d'images sans les labels (formes rangées en colonnes).
%   Dx, Dy     : dimensions des images
%   NDx, NDy   : dimensions des nouvelles images codées
%
%
% VALEURS DE RETOUR :
%
%   Code    : Base codée des images sur 256 niveaux de gris
%
%
% DESCRIPTION :  Le codage proposé consiste en un centrage des formes suivi
%                d'une réduction aux dimensions désirées. 
%
%
% VOIR AUSSI :
%
%   gcadre, reduc   
%
% COMPATIBILITE : 
%    matlab 5.3, octave 2.0
%

% Bruno Gas - LISIF/PARC UPMC <gas@ccr.jussieu.fr>
% Création : 30 juillet 2001
% version : 1.0
% Derniere révision : 

if nargin~=5
   error('[CODRET] usage : Base = CODRET(Base, Dx, Dy, NDx, NDy);');      
end;

[PixelNbr, ImgNbr] = size(Base);				% dimensions de la base
Code = zeros(NDx*NDy,ImgNbr);					% dimensions du code

for i=1:ImgNbr,
   Img = reshape(Base(:,i),Dx, Dy);
   Img = gcadre(Img);
   Img = reduc(Img,NDx,NDy);
   
   Code(:,i) = Img(:);
end;
 