function [Detect, Signal, WSignal] = uispeechdetect(filename, seuil, framesize, offset);
%
% UISPEECHDETECT
%
% SYNTAXE :
%
% [Detect, Signal, WSignal] = UISPEECHDETECT([filename [, seuil [, framesize [,offset]]]])
%
% Interface graphique de la fonction speechdetect
%
%
%
% VOIR AUSSI :
%
%  speechdetect, speechget
%
% COMPATIBILITE : 
%   >= matlab 5.1
%

% Bruno Gas - LISIF/PARC UPMC
% Création : 28 juillet 2001
% version : 1.0
% Derniere révision : 
 
 if nargin==0
 	[filename pathname] = uigetfile('*.wav','Nom complet du fichier .wav à ouvrir');
   if isempty(filename)
      errordlg('Aucun fichier de parole saisi !','Erreur de saisie dans <uispeechdetect>'); error;      
   end;
   filename = [pathname filename];

   default={'99','256','128'};
   prompt={'seuil de détection (0->100% (100=détection maximale)) : ',...
         'dimension des trames de calcul de la puissance : ',...
      	'entrelacement des trames : '};
 	titre = ['Saisie des paramètres de segmentation'];
   answer=inputdlg(prompt,titre,1,default);
   if isempty(answer)
      errordlg('Pas de réponse : aucun signal extrait!','erreur de saisie dans <uispeechdetect>');
      error;
   end;

	seuil = str2num(char(answer(1)));
	framesize = str2num(char(answer(2)));
   offset = str2num(char(answer(3)));
elseif nargin==1
   
   default={'99','256','128'};
   prompt={'seuil de détection (0->100% (100=détection maximale)) : ',...
         'dimension des trames de calcul de la puissance : ',...
      	'entrelacement des trames : '};
 	titre = ['Saisie des paramètres de segmentation'];
   answer=inputdlg(prompt,titre,1,default);
   if isempty(answer)
      errordlg('Pas de réponse : aucun signal extrait!','erreur de saisie dans <uispeechdetect>');
      error;
   end;

	seuil = str2num(char(answer(1)));
	framesize = str2num(char(answer(2)));
   offset = str2num(char(answer(3)));

elseif nargin==2
   default={'256','128'};
   prompt={'dimension des trames de calcul de la puissance : ',...
      	'entrelacement des trames : '};
 	titre = ['Saisie des paramètres de segmentation'];
   answer=inputdlg(prompt,titre,1,default);
   if isempty(answer)
      errordlg('Pas de réponse : aucun signal extrait!','erreur de saisie dans <uispeechdetect>');
      error;
   end;
   
   framesize = str2num(char(answer(2)));
   offset = str2num(char(answer(3)));

elseif nargin==3
   default={num2str(fix(framesize/2))};
   prompt={'entrelacement des trames : '};
 	titre = ['Saisie des paramètres de segmentation'];
   answer=inputdlg(prompt,titre,1,default);
   if isempty(answer)
      errordlg('Pas de réponse : aucun signal extrait!','erreur de saisie dans <uispeechdetect>');
      error;
   end;
   
   offset = str2num(char(answer(3)));
end;

[Detect, Signal, WSignal] = speechdetect(filename, seuil, framesize, offset);