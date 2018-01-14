function [matlpc, matmfcc]=comp_codeur(Base, code_size);
%
% COMP_CODEUR
%
% SYNTAXE :
%
%    [matlpc, matmfcc]= COMP_CODEUR(BASE, code_size)
%
% Comparaison de la qualité des codeurs de signaux de parole
% 	en terme de discrimination
%
%
% ARGUMENTS :
%
%	Base : Base regroupant les differents signaux à coder  
%				Les signaux sont rangés en colonne
%
% VALEURS DE RETOUR :
%	matlpc : Matrice des Codes LPC des Exemples
% 	matlpc : Matrice des Codes MFCC des Exemples
%
% VOIR AUSSI :
%
%  codlpc, codmfcc
%
% COMPATIBILITE : 
%    matlab 5.3
%

% Mohamed Chetouani 
% Création : Mars 2001
% version : 1.0
% Derniere révision :
%
%

Fe = 16e3; % Frequence d'echantillonnage des signaux de parole


[ExNbr ExSize ClassNbr] = BASESIZE(Base);

% Base de données
[Base Label] = base2label(Base);
Base = Base*0.8;

X = ad(Base,Label,0.5);

% Codage de la base;
[ LongSig NbrEx ] = size(Base);
matlpc = [];
matmfcc = [];

for k=1:NbrEx
   coeflpc = codlpc( Base(:,k), code_size);
 	matlpc = cat(2,matlpc,coeflpc');
   coefmfcc = codmfcc( Base(:,k), code_size, Fe);
  	matmfcc = cat(2,matmfcc,coefmfcc');
end;


Xlpc =ad(matlpc,Label,1);title('Codeur LPC');pause
Xmfcc =ad(matmfcc,Label,1);title('Codeur MFCC');
