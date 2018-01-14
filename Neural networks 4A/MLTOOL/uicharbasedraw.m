function Base = uicharbasedraw(ClassNbr, ExNbr, Size, opt);
%
% CHARBASEDRAW
%
% SYNTAXE :
%
% [Base [, ClassNbr, ExNbr, Size]] = uicharbasedraw([ClassNbr, ExNbr ,Size, opt]);
%
% Interface utilisateur graphique de la fonction CHARBASEDRAW.
%
%
% COMPATIBILITE :
%
% 	Matlab 5.3+
%
% VOIR AUSSI :
% 
%  HELP CHARBASEDRAW
%

% B. Gas LIS-PARC - UPMC <gas@ccr.jussieu.Fr>
% Création : 24 janvier 2001
% version 1.0
% Derniere révision : -


if nargin~=0 & nargin~=4, 
   errordlg('usage : [Base [, ClassNbr, ExNbr, Size]] = uicharbasedraw([ClassNbr, ExNbr ,Size, opt])',...
   'erreur d''usage dans uicharbasedraw');
   error;
end;

if nargin==0			% GUI
   default = {'10','5','20','sans'};
   prompt={'Nombre de classes : ',
      'Nombre d''exemples par classe à dessiner : ',
      'Dimension des exemples (répondre 0 si quelconque) :',
   	'Option de normalisation (sans, moy, var ou varmoy) :'};
	titre = 'Dimensions de la base';
   answer=inputdlg(prompt,titre,1,default);
   if isempty(answer)
      Base = 0;
      errordlg('Pas de réponse : Base vide en retour!','Erreur de dialogue dans uicharbasedraw');
      error;
   end;   
   ClassNbr = str2num(char(answer(1)))
   ExNbr = str2num(char(answer(2)))
   Size = str2num(char(answer(3)))
   opt = char(answer(4)); 
end;   

if strcmp(opt,'sans')==1
   opt = 0;
elseif strcmp(opt,'moy')==1
   opt = 1;
elseif strcmp(opt,'var')==1
   opt = 2;
elseif strcmp(opt,'varmoy')==1
   opt = 3;
elseif strcmp(opt,'moyvar')==1
   opt = 3;
else
   errordlg('option  = {''sans'', ''moy'', ''var'' ou ''varmoy''}',...
      'erreur dans les options de uicharbasedraw');
   error;
end;

Base = charbasedraw(ClassNbr, ExNbr, Size, opt);


