function [Trames, CutSignal, Signal] = uispeechget(arg1, arg2, arg3);
%
% SPEECHGET
%
% SYNTAXE :
%
% [Trames, CutSignal, Signal] = UISPEECHGET([filename,] [framesize, offset])
%
% GUI de la fonction SPEECHGET
%
% VOIR AUSSI :
%
%  SPEECHGET
%
% COMPATIBILITE : 
%   >= matlab 5.1
%

% Bruno Gas - LIS/P&C UPMC
% Création : 18 février 2001
% version : 1.0
% Derniere révision : -
%

errorbox = 'speechget : Erreur';
warningbox = 'speechget : Warning';
usage = '[Trames, CutSignal, Signal] = SPEECHGET([filename,] [framesize, offset])';
Base = 0;


if nargin>3
   errordlg('[Trames, CutSignal, Signal] = SPEECHGET([filename,] [framesize, offset])',...
      'Erreur d''usage dans uispeechget');
   error;
end;

if nargin==0 | nargin==2
   [filename, pathname] = uigetfile('sélectionnez un fichier .wav ', '*.wav');
   if isempty(filename)
      errordlg('Fichier introuvable !','erreur dans uispeechget'); error;   end;   
   filename = [pathname filename];
   if nargin==2, framesize = arg1; offset = arg2;   end;
end;

if nargin==0 | nargin==1

   default={'256','128'};
	prompt={'Longueur des trames : ','Facteur d''entrelacement (en nbr. d''échantillons) : '};
	titre = 'Segmentation du signal de parole';
   answer=inputdlg(prompt,titre,1,default);
   if isempty(answer)
      errordlg('Pas de réponse : pas de signal en retour!',errorbox);
      return;
   end;
   framesize = str2num(char(answer(1)));
	offset = str2num(char(answer(2)));
 
   if nargin==1, filename = arg1;   end;
end;

if nargin==3, filename = arg1; framesize = arg2; offset = arg3; end;

[Trames, CutSignal, Signal] = speechget(filename, framesize, offset);
 
