function Base=uiimbget(filename, arg1, arg2, arg3);
%
% SYNTAXE :
%
%    Base = UIIMBGET([filename, label [, nbr | premier, dernier])
%
%    GUI de la fonction imbget.
%
% COMPATIBILITE :
%
%    Matlab 5.3+
%
% VOIR AUSSI :
%
%    IMBGET, IMBSIZE, IMK2IMB
% 

% Bruno Gas - UPMC LIS/PARC - <gas@ccr.jussieu.fr>
% Cr�ation : 27 janvier 2001
% Version 1.0
% Derniere r�vision : -

Base = 0;

if nargin==0
   [filename pathname] = uigetfile('*.imb');
   if isempty(filename)
      errordlg('Aucune base saisie !','Erreur de saisie dans <uiimbget>'); error;      
   end;
   lettre = filename(1);
   if isletter(lettre)==0
      errordlg('Nom de fichier <.imb> inconnu','Erreur de saisie dans <uiimbget>'); error;      
   end;       
   filename = [pathname filename];
end;
Nbim = imbsize(filename);
 
if nargin<=1
   default={'1',num2str(Nbim),'1'};
   prompt={'num�ro de la premi�re lettre � extraire: ',...
         'Num�ro de la derni�re lettre � extraire: ',...
      	'label'};
 	titre = [num2str(Nbim) ' lettres pr�sentes num�rot�es de 1 � ' num2str(Nbim)];
   answer=inputdlg(prompt,titre,1,default);
   if isempty(answer)
      errordlg('Pas de r�ponse : Base vide en retour!','erreur de saisie dans <uiimbget>');
      error;
   end;

	first = str2num(char(answer(1)));
	last = str2num(char(answer(2)));
   label = str2num(char(answer(3)));

elseif nargin==2
   default={'1',num2str(Nbim)};
   prompt={'num�ro de la premi�re lettre � extraire: ',...
         'Num�ro de la derni�re lettre � extraire: '};
	titre = [num2str(Nbim) ' lettres pr�sentes num�rot�es de 1 � ' num2str(Nbim)];
   answer=inputdlg(prompt,titre,1,default);
   if isempty(answer)
      errordlg('Pas de r�ponse : Base vide en retour!','erreur de saisie dans <uiimnbget>');
      error;
   end;

	first = str2num(char(answer(1)));
	last = str2num(char(answer(2)));
   label = arg1;
       
elseif nargin==3
      
   label = arg1;
   first = 1;
   last = first + arg2 - 1;   
 
elseif nargin==4
   label = arg1;
   first = arg2;
   last = arg3;
end;

Base = imbget(filename, label, first, last);
