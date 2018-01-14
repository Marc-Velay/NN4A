function Code = codret(Base, Dx, Dy, NDx, NDy);
%
% CODRET
%
%   Codage r�tinien d'images binaires  
%
% SYNTAXE :
%
%   Code = CODRET(Base, Dx, Dy, NDx, NDy);
%
%
% ARGUMENTS :
%
%   Base 	   : Base d'images sans les labels (formes rang�es en colonnes).
%   Dx, Dy     : dimensions des images
%   NDx, NDy   : dimensions des nouvelles images cod�es
%
%
% VALEURS DE RETOUR :
%
%   Code    : Base cod�e des images sur 256 niveaux de gris
%
%
% DESCRIPTION :  Le codage propos� consiste en un centrage des formes suivi
%                d'une r�duction aux dimensions d�sir�es. 
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
% Cr�ation : 30 juillet 2001
% version : 1.0
% Derniere r�vision : 

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
 