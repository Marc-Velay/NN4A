function Coeff = codmfcc(Signal, CoeffNbr, Fe);
%
% CODMFCC
%
% SYNTAXE :
%
%   Coeff = CODMFCC(Signal, CoeffNbr, Fe)
%
% Mel Frequency Cepstrum Coding : Codage MFCC de signaux de parole 
%
%
% ARGUMENTS :
%
%  Signal 	: le signal ou la matrice de signaux à coder (en colonnes)
%  coeff_nbr : nombre de coefficients de codage (dimension du filtre)
%  Fe        : fréquence d'échantillonnage
%
% VALEURS DE RETOUR :
%
%  Coeff  : vecteur ou matrice des coefficients de code (en colonnes)
%
% VOIR AUSSI :
%
%  codlpc, codlpcc
%
% COMPATIBILITE : 
%    matlab 5.3
%

% Jean Luc Zarader - UPMC LIS/P&C 
% Création : < 97
% version : 1.4
% Derniere révision :
%  - B. Gas (4/11/2000) : intégration dans la toolbox RdF
%  - B. Gas (27/1/2001) : ~
%  - B. Gas (31/3/2001) : Coeff en colonnes plutot qu'en ligne
%  - B. Gas (4/04/2001) : modif. précédente non reportée sur le help


[PtsNbr, ExNbr] = size(Signal);
Coeff = zeros(ExNbr, CoeffNbr);

% Calcul des filtres Triangulaires nécessaires au codage MFCC :

Pas_En_Freq = Fe/PtsNbr;   
Plage_Freq  = 0:Pas_En_Freq:Pas_En_Freq*PtsNbr/2;   
Filtres = zeros(PtsNbr/2+1,20);  
Mat_Cos = zeros(20,CoeffNbr);

Tri     = triang(241);  
for i=0:6,   
   Indi    = find(Plage_Freq>i*120 & Plage_Freq<i*120+240);   
   Interm  = zeros(PtsNbr/2+1,1);   
   Interm(Indi) = Tri(round(Plage_Freq(Indi)-i*120)); 
   Filtres(:,i+1) = Interm;   
end;

Tri     = triang(301);
for i=0:4,   
   Indi    = find(Plage_Freq>i*150+850 & Plage_Freq<i*120+300+850);   
   Interm  = zeros(PtsNbr/2+1,1);   
   Interm(Indi) = Tri(round(Plage_Freq(Indi)-i*150-850));  
   Filtres(:,i+8) = Interm;   
end;

Tri = triang(401);      
for i=0:3,   
   Indi    = find(Plage_Freq>i*200+1600 & Plage_Freq<i*200+400+1600);   
   Interm  = zeros(PtsNbr/2+1,1);   
   Interm(Indi) = Tri(round(Plage_Freq(Indi)-i*200-1600));   
   Filtres(:,i+13) = Interm;   
end;

Tri = triang(601);      
for i=0:2,   
   Indi    = find(Plage_Freq>i*300+2400 & Plage_Freq<i*200+600+2400);   
   Interm  = zeros(PtsNbr/2+1,1);   
   Interm(Indi) = Tri(round(Plage_Freq(Indi)-i*300-2400));   
   Filtres(:,i+17) = Interm;   
end;

Tri     = triang(1001);      
Indi    = find(Plage_Freq>3200 & Plage_Freq<4200);
Interm  = zeros(PtsNbr/2+1,1);
Interm(Indi) = Tri(round(Plage_Freq(Indi)-3200));
Filtres(:,20) = Interm;
Filtres = Filtres.^2;
Lon = 1:20;

for i=1:CoeffNbr,   
   Mat_Cos(:,i) = cos(i*(Lon-.5)*pi/20)';   
end;

% Codage des trames :
for ex=1:ExNbr
   sp      = fft(Signal(:,ex)');
   sp      = abs(sp(1:PtsNbr/2+1)).^2*Filtres;
   ind     = find(sp==0);
   sp(ind) = eps;
   sp      = log10(sp);
   Coeff(ex,:) = sp*Mat_Cos;
end;

Coeff = Coeff';

