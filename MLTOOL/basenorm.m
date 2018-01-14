function Base = BASENORM(Base, MinNorm, MaxNorm);
%
% BASENORM
%
% SYNTAXE :
%
% Base = BASENORM(Base, [MaxAbs | MinNorm, MaxNorm])
%
% Normalisation d'une base d'exemple RdF entre [<NormMin> <NormMax>] ou
% <MaxAbs>, en valeur absolue, ou encore calcul de la base norm�e.
% Lorsque les arguments <MinNorm> et <MaxNorm> ou <MaxAbs> sont sp�cifi�s, la normalisation 
% est globale : calcul�e sur toutes les composantes
% de tous les exemples de la base. La base doit �tre au format 
% "un exemple par colonne" sans les labels, c'est � dire apr�s
% passage par la fonction BASE2TARGET ou BASE2LABEL. 
% Lorsque les arguments <MinNorm> et <MaxNorm> ou <MaxAbs> ne sont pas sp�cifi�s,
% les vecteurs de la base sont norm�s, et non pas normalis�s :
% leur norme vaut 1 apr�s le traitement (utilis� avec les cartes de Kohonen
% par exemple).
% Lorsque <MaxAbs> est sp�cifi�, la base est normalis� en valeur absolue
% (la valeur <MaxAbs> n'est pas d�pass�e en valeur absolue par aucun �chantillon du signal)
% Dans ce cas de figure, le signal est syst�matiquement centr�.
% Au contraire, avec la normalisation entre <MinNorm> et <MaxNorm>, le signal
% r�sultant n'est pas garanti centr�.
%
% ARGUMENTS :
%
% Base	    : la base RdF � normaliser (exemples sans les labels)
% MaxAbs    : [optionnel] valeur maximale d�sir�e en valeur absolue
% MinNorm	: [optionnel] valeur minimale d�sir�e
% MaxNorm	: [optionnel] valeur maximale d�sir�e
%
% VALEURS DE RETOUR :
%
% Base	: la nouvelle base RdF normalis�e
%
% VOIR AUSSI :
%
%   BASESIZE  BASE2LABEL  BASE2TARGET, etc.  
%
%
% COMPATIBILITE : 
%   >= matlab 5.1, octave 2.0
%

% Bruno Gas - LIS/P&C UPMC
% Cr�ation : octobre 2000
% version : 1.4
% Derniere r�vision :
%  - B. Gas (27/11/2000) : am�lioration du Help
%  - B. Gas (4/12/2000) : calcul des vecteurs norm�s 
%  - B. Gas (24/1/2001) : gestion non graphique des erreurs 
%  - B. Gas (7/3/2001)  : normalisation avec centrage

% Normalisation au max en valeur absolue (signaux centr�s)
if nargin==2
    MaxD = abs(MinNorm);                      % le max d�sir� en val. absolue
    [N, sig_nbr] = size(Base);                % dimensions de la base
    Base = Base - sum(sum(Base))/N/sig_nbr;   % centrage
    MaxVal = abs(max(max(Base)));             % val. max du signal en valeur absolue
    MaxVal = max([MaxVal abs(min(min(Base)))]);
    Base = Base*MaxD/MaxVal;                  % normalisation
    
% Normalisation de la base entre min et max (signaux non centr�s): 
elseif nargin==3
	MaxVal = max(max(Base));
	MinVal = min(min(Base));

	DeltaVal = MaxVal-MinVal;
	DeltaNorm = MaxNorm - MinNorm;

	Base = ((Base-MinVal)*DeltaNorm)/DeltaVal + MinNorm;
   
% Calcul des vecteurs norm�s :   
else
   [SizeEx, ans] = size(Base);
   normvec = sum(abs(Base).^2).^(0.5);
   Base = Base./(ones(SizeEx,1)*normvec);   
end;






