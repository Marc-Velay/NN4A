function Base = gensig(Fe, Freq, Nbr, N, Rsb, Ph);
%
% GENSIG
%
% SYNTAXE :
%
% Base = gensig(Fe, Freq, Nbr, N, Rsb [,Ph])
%
% Construit une base de signaux sinusoïdaux à différentes
% fréquences, éventuellement bruités. les signaux sont
% labellisés selon leur fréquence.
%
% ARGUMENTS :
%
% Fe   : fréquence d'échantillonnage
%
% Freq : tableau des fréquences en Hz. La dimension du tableau définit le
%        nombre de classes de signaux et donc le nombre de labels
%        différents générés.
% Nbr  : nombre de signaux générés pour chaque fréquence. Le nombre total
%        de signaux générés est donc égal à Freq*Nbr.
%
% N    : nombre d'échantillons désiré par signal généré
%
% Rsb  : Rapport signal sur bruit. Le bruit généré est
%        un bruit blanc additif.
%
% Ph   : [optionnel] tableau des phases à l'origine (en radians)
%
%
% VALEURS DE RETOUR :
%
% Base   : matrice des signaux rangés en ligne, avec les labels
%          en dernier élément de chaque ligne.
%          Pour extraire ces labels de la base et construire un vecteur
%          de cibles, utiliser BASE2TARGET
% 
% COMPATIBILITE :
%
%   Matlab 4.3+, Octave 2.0+
%

% Bruno Gas - UPMC LIS/P&C, <gas@ccr.jussieu.fr>
% Création : février 2000
% Derniere révision : 
% Version : 1.1
%  - B.Gas (27/01/2001) : révision tbx RdF


if nargin<5 | nargin>6
  error('[GENSIG] usage : Base = gensig(Fe, Freq, Nbr, N, Rsb [,Ph])');
end;

if nargin==5
  Ph = zeros(1,length(Freq));
elseif length(Freq) ~= length(Ph)
  error('[GENSIG] erreur: Les arguments Freq et Ph doivent avoir même dimension');  
end;

ClassNbr = length(Freq);

Te = 1/Fe;
theta = 2*pi*(0:N-1)*Te;

if is_vector(Freq) & rows(Freq)>1          % si vecteur colonne
  warning('[GENSIG] warning: <Freq> devrait être un vecteur ligne');
  Freq = Freq';
end;
f = ones(Nbr,1)*Freq;
f = f(:);
ArgCos = f*theta;

Phi = ones(Nbr,1)*Ph;
Phi = Phi(:);
Phi = Phi*ones(1,N);

Base = cos(ArgCos + Phi);

% bruit additif :

rand('seed',1);						% init. générateur aléatoire
Noise = 2*rand(size(Base))-1;
PNoise = sum(Noise'.^2)'/N;		% puissance du bruit
PSig = sum(Base'.^2)'/N;         % puissance du signal
RSB1 = 10*log(PSig./PNoise);     % RSB 1dB
alpha = sqrt(10.^((RSB1 - Rsb)/10));
Base = Base + Noise.*(alpha*ones(1,N));

% labellisation des signaux :

Labels = ones(Nbr,1)*(1:ClassNbr);
Labels = Labels(:);
Base = [Base Labels];
