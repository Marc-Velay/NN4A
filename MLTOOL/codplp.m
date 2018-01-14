function Coeff = codplp(signal, coeff_nbr, Fe);
%
% CODPLP
%
%	Perceptual Linear Predictive Coding : codage PLP de signaux de parole
%
% SYNTAXE :
%
%   Coeff = CODPLP(Signal, CoeffNbr, Fe)
% 
%
% ARGUMENTS :
%
%   Signal 	  : le signal ou la matrice de signaux à coder (en colonnes)
%   coeff_nbr : nombre de coefficients de codage (dimension du filtre)
%   Fe        : [OPTIONNEL] fréquence d'échantillonnage. Par défaut, 16000 Hz
%
% VALEURS DE RETOUR :
%
%   Coeff  : vecteur ou matrice des coefficients de code (en colonnes)
%
%
% REFERENCES :
%
%   H. Hermansky "Perceptual Linear Predictive (PLP) Analysis of Speech"
%	Journal of the Acoustical Society of America, vol 4, pp1738-1752,1990
%
% VOIR AUSSI :
%
%  codlpc, codlpcc, codmfcc
%
% COMPATIBILITE : 
%    matlab 5.3
%

%
% Mohamed Chetouani - mohamed.chetouani@lis.jussieu.fr
% Création : 2 Novembre 2001
% version  : 1.0	
% Dernière révision : -


if nargin == 2,
    Fe = 16e3; % Frequence d'echantillonnage des signaux de parole
elseif nargin ~= 3
    error('[CODPLP] usage : Coeff = CODPLP(Signal, CoeffNbr [, Fe])');
end;

[ExSize ExNbr] = size(signal);
for i=1:ExNbr,
   signalTraite = signal(:,i);
   
   Nbr_Pts = ExSize;
   Pas_En_Freq = Fe/Nbr_Pts; 
   f  = 0:Pas_En_Freq:Pas_En_Freq*(Nbr_Pts-1)/2;  
   w=2*pi.*f;
   
   % Transformation hertz - echelle bark
   Omega=6*log( w/(1200*pi) + sqrt( w/(1200*pi) .* w/(1200*pi) +1) ); % Echelle Bark
   
   % Calcul du Spectre
   fftsignal = fft(signalTraite);
   fftsignal = fftsignal(1:Nbr_Pts/2);
   
   % Calcul de la puissance spectrale 
   Realfftsignal =real(fftsignal);
   Imagfftsignal =imag(fftsignal);
   Pfft = Realfftsignal.*Realfftsignal + Imagfftsignal.*Imagfftsignal; % Spectre de puissance
   
   % Masquage (Critical-Band)
   % Calcul de PHI (fonction de masque)
   PHI = PHI_function(Omega);
   
   % Convolution avec le spectre de puissance
   THETA = conv(Pfft,PHI);
   THETA = THETA(1:Nbr_Pts/2);
   
   % Approximation de la sensibilite de l'oreille humaine
   % par l'intermediaire de la fonction de transfert E(w)
   %
   w_carre = w.*w;
   w_4 = w_carre.*w_carre;
   k1 = 56.8e6;
   k2 = 6.3e6;
   k3 = 0.38e9;
   
   Eperception = (w_carre+k1).*w_4./( (w_carre+k2).*(w_carre+k2).*(w_carre+k3));
   
   Esensibilite=Eperception.*THETA;


   % La non linéarité entre l'intensité du son et sa force de perception par l'oreille
   % est ensuite approximée par une loi de puissance
   Gamma = Esensibilite.^(1/3);
   IfftGamma = ifft(Gamma); % Fonction d'autocorrelation
   R = IfftGamma;

   % Calcul des coefficients du filtre correspondant à la fonction autocorelation R
   Coeffa = levinson(R,coeff_nbr);
   Coeff(:,i) = real(Coeffa(2:length(Coeffa)))';
	
end;
 

% Courbe de masquage PHI  (Critical Band filter)
% PHI(Omega) =		
%		0 					si Omega < -1.3
%		10e2.5*(Omega+0.5)	si -1.3 < Omega  < -0.5
%		1                   si -0.5 < Omega  < 0.5
%		10e-1*(Omega-0.5)	si  0.5 < Omega  < 2.5
%		0					si  Omega > 2.5
%
function PHI = PHI_function(Omega);
PHI = zeros(1, length(Omega));

PHI(find(Omega<-1.3))=0;

indices = find(Omega>=-1.3 & Omega<-0.5);
PHI(indices) = exp(-1*(Omega(indices)+0.5)*log(10));

PHI(find(Omega>=-0.5 & Omega<0.5)) = 1;

indices = find(Omega >=0.5 & Omega<2.5);
PHI(indices) = exp(-1*(Omega(indices)-0.5)*log(10));

PHI(find(Omega >= 2.5)) = 0;
