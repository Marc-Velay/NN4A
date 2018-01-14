function [Trames, CutSignal, Signal] = speechget2(filename, framesize, offset ,seuil);
%
% SPEECHGET2
%
% SYNTAXE :
%
% [Trames, CutSignal, Signal] = SPEECHGET2([filename [, framesize, offset [, seuil]]])
%
% Extrait des signaux de mots � partir du fichier de parole
% au format wav donn� en argument avec �limination des zones de
% silence par seuillage.Les mots sont coll�s les uns � la suite des autres.
% Les signaux extraits sont normalis�s (entre -1 et +1) puis subdivis�s en trames 
% successives de longueur 'framesize'
% avec un entrelacement 'offset' et rang�s en ligne dans le tableau <Trames>
%
% ARGUMENTS : [OPTIONNELS]
%
% filename 	: nom du fichier � ouvrir
% framesize	: taille des trames en nombre d'�chantillons
% offset    : facteur d'entrelacement en nombre d'�chantillons
% seuil     : seuil de d�tection du signal de parole (0 � 1)
%             0 : le signal dont la puissance est sup�rieure � la puissance
%                 minimale en zone de silence est d�tect�
%             1 : seuil maximal, aucun signal d�tect�
% VALEURS DE RETOUR :
%
% Trames 	: matrice des trames de signaux rang�s en ligne
% Signal 	: le signal entier extrait du fichier
% CutSignal : le signal correspondant aux trames s�lectionn�es
%
% VOIR AUSSI :
%
%  UISPEECHGET
%
% COMPATIBILITE : 
%   >= matlab 5.1
%

% Bruno Gas - LIS/P&C UPMC
% Cr�ation : juin 2002
% version : 1.0
% Derniere r�vision : 
%  - modifs ant�rieures : voir SPEECHGET
%  - B. Gas (14/06/2002): extrait les mots d'une phrase (utiliser un seuil tr�s petit:0.005)

if nargin==0
    filename = input('Nom complet du fichier .wav � ouvrir = ','s');
    framesize = input('Longueur des trames (256) = ');
    offset = input('facteur d''entrelacement (128) = ');
    seuil = input('seuil de d�tection (0->1 (0=d�tection maximale)) = ');
elseif nargin==1
    framesize = input('Longueur des trames (256) = ');
    offset = input('facteur d''entrelacement (128) = ');
    seuil = input('seuil de d�tection (0 � 1 (0=d�tection maximale)) = ');
elseif nargin==3
    seuil = input('seuil de d�tection (0 � 1 (0=d�tection maximale)) = ');
elseif nargin ~=4
    error('[SPEECHGET] usage : [Trames, CutSignal, Signal] = SPEECHGET([filename [,framesize, offset [,seuil]])');   
end;

if seuil<0 | seuil>1, error('[SPEECHGET] erreur : l''argument <seuil> doit etre compris entre 0 et 1'); end;

Base = 0;

[sig,fe,nbits]=wavread(filename);

% extraction des trames de signal :
[ech_nbr chanel] = size(sig);
if chanel == 2
   sig = (sig(:,1) + sig(:,2))/2;  % st�r�o -> mono
end;
sig = sig';

% normalisation entre -1 et +1 :
sig = signorm(sig,1);

frame_nbr = fix((ech_nbr-framesize)/(framesize-offset));
lost_nbr = rem((ech_nbr-framesize), framesize-offset);

Trames = zeros(frame_nbr,framesize);
frame_num = 1;
for ech=1:offset:(frame_nbr-1)*offset+1; 
	Trames(frame_num,:) = sig(ech:ech+framesize-1);
	frame_num = frame_num + 1;
end;

% calcul puissance du bruit sur chaque trame :
Pnoisysig = sum((Trames.^2)');  		% P signal bruit�
Pnoise = min(Pnoisysig);				% estim. P du bruit minimum
Pmax = max(Pnoisysig - Pnoise);         % P max du signal sans le bruit

Pseuil = Pnoise + seuil*Pmax;       % seuil de la puissance
%Pseuil = Pmax/20;

% S�lection des trames :
ind = find(Pnoisysig>Pseuil);	
%first = min(ind);							% 1ere trame sup�rieure au seuil
%last = max(ind);							% derni�re trame > seuil

%Trames = Trames(first:last,:);      % premi�re <= trames <= derni�re
Trames = Trames(ind,:);				% seules les trames > seuil

% Retour des signaux d'origine et tronqu� :
tab=[]; %tab contient les indices de trame de d�but et de fin de chaque mot plac�s
        %les uns en dessous des autres
tab=[tab;ind(1)];
for i=1:length(ind)-1
   if ind(i+1)-ind(i)>1
      tab=[tab;ind(i);ind(i+1)];
   end
end
ind;
tab=[tab;ind(length(ind))];

CutSignal=[];
for i=1:2:length(tab)-1
	indfirst = (tab(i)-1)*offset+1;
   indlast = (tab(i+1)-1)*offset+framesize;
   CutSignal=[CutSignal  sig(indfirst:indlast)];
end
Signal = sig;