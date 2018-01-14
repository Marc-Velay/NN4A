function trames = sig2trame(signal, framesize, offset);
%
% SIG2TRAME
%
% SYNTAXE :
%
% trames = sig2trame(signal [, framesize [, offset]])
%
% Découpe le signal donné en argument en trames successives, 
% éventuellement entrelacées
%
% ARGUMENTS : [OPTIONNELS]
%
% signal 	: le signal
% framesize : largeur des trames
% offset    : facteur d'entrelacement
%
% VALEURS DE RETOUR :
%
% trames    : tableau des trames de signaux, rangés en colonne
%
% VOIR AUSSI :
%
%  
%
% COMPATIBILITE : 
%   >= matlab 5.1
%

% Bruno Gas - LISIF/PARC UPMC
% Création : 22 novembre 2002
% version : 1.0
% Derniere révision : 
 
if nargin==1
    framesize = input('dimension des trames = ');
    offset = input('entrelacement des trames = ');
elseif nargin==2
    offset = input('entrelacement des trames = ');    
elseif nargin~=3
    error('[SIG2TRAME] usage : trames = sig2trame(signal [, framesize [, offset]])');   
end;

if framesize<1, error('[SIG2TRAME] erreur : la taille des trames doit être >= 1'); end;
if offset <1, error('[SIG2TRAME] erreur : le facteur d''entrelacement doit être >= 1'); end;
if offset >framesize, error('[SIG2TRAME] erreur : le facteur d''entrelacement doit être <= à framesize'); end;
 

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
   Signal = (Signal(:,1) + Signal(:,2))/2;  % stéréo -> mono
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
WSignal = sum((Trames.^2)');  		% P signal bruité
Pnoise = min(WSignal);			      % estim. P du bruit minimum
Pmax = max(WSignal - Pnoise);       % P max du signal sans le bruit

Pseuil = Pnoise + (100-seuil)*Pmax/100; % seuil de la puissance

% Sélection des trames :
ind = find(WSignal>Pseuil);	
first = min(ind);							% 1ere trame supérieure au seuil
last = max(ind);							% dernière trame > seuil

Trames = Trames(first:last,:);      % première <= trames <= dernière
%Trames = Trames(ind,:);				% seules les trames > seuil

% Retour des signaux d'origine et tronqué :
indfirst = (first-1)*offset+1;
indlast = (last-1)*offset+framesize;
Detect = [indfirst indlast];
if isempty(Detect)
   warning('[SPEECHDETECT] seuil trop faible : aucun signal détecté');
   Detect = [0 0];   
end;



