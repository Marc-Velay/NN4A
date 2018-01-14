function trames = sig2trame(signal, framesize, offset);
%
% SIG2TRAME
%
% SYNTAXE :
%
% trames = sig2trame(signal [, framesize [, offset]])
%
% D�coupe le signal donn� en argument en trames successives, 
% �ventuellement entrelac�es
%
% ARGUMENTS : [OPTIONNELS]
%
% signal 	: le signal
% framesize : largeur des trames
% offset    : facteur d'entrelacement
%
% VALEURS DE RETOUR :
%
% trames    : tableau des trames de signaux, rang�s en colonne
%
% VOIR AUSSI :
%
%  
%
% COMPATIBILITE : 
%   >= matlab 5.1
%

% Bruno Gas - LISIF/PARC UPMC
% Cr�ation : 22 novembre 2002
% version : 1.0
% Derniere r�vision : 
 
if nargin==1
    framesize = input('dimension des trames = ');
    offset = input('entrelacement des trames = ');
elseif nargin==2
    offset = input('entrelacement des trames = ');    
elseif nargin~=3
    error('[SIG2TRAME] usage : trames = sig2trame(signal [, framesize [, offset]])');   
end;

if framesize<1, error('[SIG2TRAME] erreur : la taille des trames doit �tre >= 1'); end;
if offset <1, error('[SIG2TRAME] erreur : le facteur d''entrelacement doit �tre >= 1'); end;
if offset >framesize, error('[SIG2TRAME] erreur : le facteur d''entrelacement doit �tre <= � framesize'); end;
 

if size(signal,1)~=1
    if size(signal,2)~=1
        error('[SIG2TRAME] erreur : le signal doit etre un vecteur 1D (ligne) et non une matrice'); end;
    else
        signal = signal';
    end;
else
    if <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        
[ans, ech_nbr] = size(Signal);

if 

% extraction des trames de signal :
[ech_nbr chanel] = size(Signal);
if chanel == 2
   Signal = (Signal(:,1) + Signal(:,2))/2;  % st�r�o -> mono
end;
Signal = Signal';

frame_nbr = fix((ech_nbr-framesize)/(framesize-offset));
lost_nbr = rem((ech_nbr-framesize), framesize-offset);

Trames = zeros(frame_nbr,framesize);
frame_num = 1;
for ech=1:offset:(frame_nbr-1)*offset+1; 
	Trames(frame_num,:) = Signal(ech:ech+framesize-1);
	frame_num = frame_num + 1;
end;

% calcul puissance du bruit sur chaque trame :
WSignal = sum((Trames.^2)');  		% P signal bruit�
Pnoise = min(WSignal);			      % estim. P du bruit minimum
Pmax = max(WSignal - Pnoise);       % P max du signal sans le bruit

Pseuil = Pnoise + (100-seuil)*Pmax/100; % seuil de la puissance

% S�lection des trames :
ind = find(WSignal>Pseuil);	
first = min(ind);							% 1ere trame sup�rieure au seuil
last = max(ind);							% derni�re trame > seuil

Trames = Trames(first:last,:);      % premi�re <= trames <= derni�re
%Trames = Trames(ind,:);				% seules les trames > seuil

% Retour des signaux d'origine et tronqu� :
indfirst = (first-1)*offset+1;
indlast = (last-1)*offset+framesize;
Detect = [indfirst indlast];
if isempty(Detect)
   warning('[SPEECHDETECT] seuil trop faible : aucun signal d�tect�');
   Detect = [0 0];   
end;



