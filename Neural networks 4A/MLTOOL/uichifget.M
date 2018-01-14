function Base=uichifget(arg1, arg2, arg3);
%
% SYNTAXE :
%
% Base = UICHIFGET([filename [, set [, nbr]]])
%
% GUI de la fonction CHIFGET
%
% COMPATIBILITE :
%
%    Matlab 5.3+
%
% VOIR AUSSI :
%
%    chifget, base2target
% 

% Bruno Gas - LIS/P&C UPMC
% Création : 26 janvier 2001
% Version 1.0
% Derniere révision : -

 
% controle des arguments :

if nargin>3,	
   errordlg('Usage : Base =UICHIFGET([filename [, set [, nbr]]])',...
      'Erreur d''usage dans uichifget');
   error;
end

if nargin==0	
   [filename pathname] = uigetfile('basechif.mat','Recherche du fichier <basechif.mat>');   
   if (filename==0)	
      errordlg('Aucune base saisie !','Erreur de dialogue dans uichifget');
      error;
   end;   
   filename = [pathname filename];
else
   filename = arg1;
end;   
   
% choix de la base (apprentissage, test ou les deux) :
if nargin <2   
	set = questdlg('Choix de la base à utiliser : apprentissage, test ou les deux ?', ...
                         'Base d''apprentissage, base de test ou les deux ?', ...
                         'app','tst','apptst','apptst');
else
   set = arg2;   
end;

% nombre d'exemples à extraire par classe :
if nargin<3      
   default = {'9'};
	prompt={'Nombre d''exemples par classe à extraire : '};
	titre = 'Extraction des images de chiffres';
   answer=inputdlg(prompt,titre,1,default);
   if isempty(answer)
      errordlg('Pas de réponse : Base vide en retour!','erreur de dialogue dans uichifget');
      error;
   end;   
   nbr = str2num(char(answer(1)));
else   
   nbr = arg3;
end;


% extraction de la base :
Base = chifget(filename, set, nbr);









 