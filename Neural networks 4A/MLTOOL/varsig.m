function var = varsig(s, winsize);
%
% VARSIG
%
% SYNTAXE :
%
% var = varsig(s, winsize)
%
% Calcul la variance court terme d'un signal.
%
% ARGUMENTS :
%
% s    : signal
%
% winsize : taille de la fenêtre de calcul en nombre d'échantillons
%
% VALEURS DE RETOUR :
%
% var  : la variance
%
% COMPATIBILITE :
%
%   Matlab 5.3+
%

% Bruno Gas - UPMC LIS/P&C, <gas@ccr.jussieu.fr>
% Création : octobre 2004
% Derniere révision : 
% Version : 1.0
%

if nargin~=2
  error('[VARSIG] usage : var = varsig(sig, winsize)');
end;

sigsize=length(s);

var = zeros(1,sigsize-winsize);
for i=1:sigsize-winsize
	var(i)=sumsqr(s(i:i+winsize))/winsize;   
end;


