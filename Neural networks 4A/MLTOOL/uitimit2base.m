function [Baset, Infor] = uitimit2base;
%
% BASE
% 
%
% SYNTAXE :
%
% [Baset, Infor] = uitimit2base
%
% Construit une base de donnée compatible avec la Toolbox à partir 
% de la base de données TIMIT
%
% ARGUMENTS :
%
% 
% VALEURS DE RETOUR :
%
% Baset   : matrice des échantillons de la base, avec les labels.
% Infor	: informations sur la construction de la base 
%					Liste des différents fichiers de la base
%					Nombre de classe de la base
% 
% COMPATIBILITE :
%
%    matlab 5.3
%

% Mohamed Chetouani - LIS/P&C UPMC
% Création : Mars 2001
% Version : 1.2
% Derniere révision : 
% - B.Gas (1/6/2001) : import toolbox RdF

% Interface graphique 
taillehaut = 480;
saut = 20;
reponse = 'Oui';
Baset = [];
Infor='Fichier								Nombre d''exemples';
c =1;

button = questdlg('Realisation de la base?','Timit2Base','Oui','Non','Non');
 if strcmp(button,'Oui')
   while strcmp(reponse,'Oui'), 
      [filename pathname] = uigetfile('*.mat','Constitution de la base de donnée');   
      if (filename==0)	
          errordlg('Aucune base saisie !','Erreur de dialogue dans Timit2Base');
          error;
          return;
      	end;   
      	filename = [pathname filename];
         load(filename);
         [NbrEx Longueur] = size(Base);
      	prompt   = {['Entrez le nombre d''exemples Maximum : 'num2str(NbrEx)]};
	   	title    = 'Constitution de la base';
	   	lines = 1;
	   	def     = {'0'};
         answer   = inputdlg(prompt,title,lines,def);
         if length(answer) ==0, errordlg('[Timit2Base] : Erreur sur le nombre d''exemples');
            error;
            return;
         end;
         
        	nbr = str2num(char(answer(1)));
        	% Informations sur la base
	      Infor = [ Infor setstr(13) filename ' ' char(answer(1))]
         % Label
         n = round( rand(1,nbr)*NbrEx)
         i=find(n==0); n(i)=1;
       	B= cat(2,Base(n,:),c*ones(nbr,1));        
       	c=c+1; 
			% Extraction et concatenation des signaux
   		Baset = cat(1,Baset,B(1:nbr,:));
   
   		reponse = questdlg('Inclure d''autres phonemes?','Tirmit2Base','Oui','Non','Non');
   end;
   % Sauvegarde de la base 
   [newfile,newpath] = uiputfile('NewBase.mat','Sauvegarde de la nouvelle base');
   if (filename==0)	
          errordlg('Aucune base saisie !','Erreur de dialogue dans BaseTimit2USER');
          error;
          return;
    end; 
   newfile = [ newpath newfile];
	save (newfile, 'Baset');
   
   % Sauvegarde des infos sur la base 
   Nbr_classe = c-1;
   Infor = [ Infor setstr(13) 'Nombre de classes : ' num2str(Nbr_classe)];

   [newfile,newpath] = uiputfile('NewBaseInfo.mat','Sauvegarde des Informations sur la base');
   if (filename==0)	
          errordlg('Aucune base saisie !','Erreur de dialogue dans BaseTimit2USER');
          error;
          return;
    end; 
   newfile = [ newpath newfile];
	save (newfile, 'Infor','Nbr_classe','n');

   elseif strcmp(button,'Non')
      
end;



  
    
