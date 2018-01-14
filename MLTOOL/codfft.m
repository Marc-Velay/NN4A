function Coeff = codfft(Signal, coeff_nbr, opt);
%
% CODFFT
%
% SYNTAXE :
%
% Coeff = CODFFT(Signal, coeff_nbr [, opt])
%
% Fast Fourrier Transform Coding : Codage FFT de signaux de parole 
%
%
% ARGUMENTS :
%
% Signal 	: le signal ou la matrice de signaux à coder (rangés en colonnes)
% coeff_nbr : nombre de coefficients de codage demandé
%
% AGUMENTS OPTIONNELS :
% option    : options de codage : échelle utilisée ('lineaire', 'mel')
%
% VALEURS DE RETOUR :
%
% Coeff  : vecteur ou matrice des coefficients de code (en colonnes)
%
% VOIR AUSSI :
%
%   codlpc, codlpcc, codmfcc, codplp
%
% COMPATIBILITE : 
%    matlab 5.3
%

% Bruno Gas - LIS/P&C UPMC
% Création : octobre 2004
% version : 1.0
% Derniere révision : -
%

if nargin<2 | nargin>3 
   error('[CODFFT] usage : Coeff = CODFFT(Signal, coeff_nbr [, opt, fe]');
end;

if nargin==3 & strcmp(opt,'mel')==0 & strcmp(opt,'lineaire')==0
     error('[CODFFT] option non implémentée ou inconnue');
end;

   
[sig_size sig_nbr] = size(Signal);
band_nbr = fix(sig_size/2);					% nombre de canaux FFT
band_width = fix(band_nbr/coeff_nbr);     % largeur des bancs de filtre en nombre de canaux

SF = fft(Signal);
%SFM = abs(SF(1:band_nbr,:))/sig_size;     % normalisée
SFM = abs(SF(1:band_nbr,:)).^2;
MEL = 1000*log(1+[0:fix(sig_size/2)-1]/1000)/log(2);


Coeff = zeros(coeff_nbr, sig_nbr);

if nargin==3 & strcmp(opt,'mel')~=0
   mel_band_nbr = 1000*log(1+band_nbr/1000)/log(2);
   mel_band_width = fix(mel_band_nbr/coeff_nbr);
   tab_mel_band_freq(1) = 1;
   for i=2:coeff_nbr
      tab_mel_band_freq(i) = fix(1000*(exp(log(2)*(mel_band_width*(i-1)+1)/1000) -1));
   end;
   tab_mel_band_freq(coeff_nbr+1) = fix(1000*(exp(log(2)*(mel_band_width*(coeff_nbr)+1)/1000) -1));

   for i=1:coeff_nbr
      mel_band_freq = tab_mel_band_freq(i+1)-1-tab_mel_band_freq(i);
      Coeff(i,:) = sum(SFM(tab_mel_band_freq(i):tab_mel_band_freq(i+1)-1,:))/(mel_band_freq);   
   end;
   
else
   for i=1:coeff_nbr
      Coeff(i,:) = sum(SFM((i-1)*band_width+1:i*band_width,:))/band_width;   
   end;
end;

% normalisation :
Coeff = Coeff./max(max(Coeff));
% log :
Coeff = log10(Coeff);

