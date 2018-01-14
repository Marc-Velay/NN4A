function Coeff = codlpcc(Signal, coeff_nbr);
%
% CODLPCC
%
% SYNTAXE :
%
% Coeff = CODLPCC(Signal, coeff_nbr)
%
% Linear Predictive Cepstrum Coding : Codage LPCC de signaux de parole 
%
%
% ARGUMENTS :
%
% Signal 	: le signal ou la matrice de signaux à coder (signaux rangés en colonnes)
% coeff_nbr : nombre de coefficients de codage (dimension du filtre)
%
% VALEURS DE RETOUR :
%
% Coeff  : vecteur ou matrice des coefficients de code (en colonnes)
%
% VOIR AUSSI :
%
%  codlpc, codmfcc
%
% COMPATIBILITE : 
%   matlab 5.3+
%

% J.L. zarader - LIS/P&C UPMC <zarader@ccr.jussieu.fr>
% Création : 1997
% version : 1.5
% Derniere révision : 
%  B.Gas (2/11/2000) : intégration dans la toolbox RdF
%  B.Gas (27/1/2001) : ~
%  B.Gas (31/3/2001) : Coeff en colonnes plutot qu'en ligne
%  B.Gas (3/4/2001)  : err. suite à la dernière modif. (ligne 38)
%  B.Gas (7/6/2001)  : Correction Help

a = codlpc(Signal, coeff_nbr)';
[SigSize, NbrSig] = size(Signal);

for frame = 1:NbrSig
	Coeff(frame,1) = -a(frame,1);
	for i=2:coeff_nbr;
		somme = -a(frame,i);
	   for j=1:i-1;
   		somme = somme-(1-j/i)*a(frame,j)*Coeff(frame,i-j);   
	   end;
   	Coeff(frame,i)=somme;
   end;
end;

Coeff = Coeff';
 


