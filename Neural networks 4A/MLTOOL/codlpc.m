function Coeff = codlpc(Signal, coeff_nbr);
%
% CODLPC
%
% SYNTAXE :
%
% Coeff = CODLPC(Signal, coeff_nbr)
%
% Linear Predictive Coding : Codage LPC de signaux de parole 
%
%
% ARGUMENTS :
%
% Signal 	: le signal ou la matrice de signaux à coder (rangés en colonnes)
% coeff_nbr : nombre de coefficients de codage (dimension du filtre)
%
% VALEURS DE RETOUR :
%
% Coeff  : vecteur ou matrice des coefficients de code (en colonnes)
%
% VOIR AUSSI :
%
%   codlpcc, codmfcc
%
% COMPATIBILITE : 
%    matlab 5.3
%

% Bruno Gas - LIS/P&C UPMC
% Création : octobre 2000
% version : 1.3
% Derniere révision :
%  - B.Gas (27/1/2001) : ~
%  - B.Gas (17/3/2001) : coefficients rangés en colonnes et partie réelle des coeff.
%  - B.Gas (30/10/2004): plus de partie réelle ...

Coeff = lpc(Signal,coeff_nbr);
Coeff = real(Coeff(:,2:end))';


 


