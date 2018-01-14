function Base = BASENORM(Base, MinNorm, MaxNorm);
%
% BASENORM
%
% SYNTAXE :
%
% Base = BASENORM(Base, [MaxAbs | MinNorm, MaxNorm])
%
% Normalisation d'une base d'exemple RdF entre [<NormMin> <NormMax>] ou
% <MaxAbs>, en valeur absolue, ou encore calcul de la base normée.
% Lorsque les arguments <MinNorm> et <MaxNorm> ou <MaxAbs> sont spécifiés, la normalisation 
% est globale : calculée sur toutes les composantes
% de tous les exemples de la base. La base doit être au format 
% "un exemple par colonne" sans les labels, c'est à dire après
% passage par la fonction BASE2TARGET ou BASE2LABEL. 
% Lorsque les arguments <MinNorm> et <MaxNorm> ou <MaxAbs> ne sont pas spécifiés,
% les vecteurs de la base sont normés, et non pas normalisés :
% leur norme vaut 1 après le traitement (utilisé avec les cartes de Kohonen
% par exemple).
% Lorsque <MaxAbs> est spécifié, la base est normalisé en valeur absolue
% (la valeur <MaxAbs> n'est pas dépassée en valeur absolue par aucun échantillon du signal)
% Dans ce cas de figure, le signal est systématiquement centré.
% Au contraire, avec la normalisation entre <MinNorm> et <MaxNorm>, le signal
% résultant n'est pas garanti centré.
%
% ARGUMENTS :
%
% Base	    : la base RdF à normaliser (exemples sans les labels)
% MaxAbs    : [optionnel] valeur maximale désirée en valeur absolue
% MinNorm	: [optionnel] valeur minimale désirée
% MaxNorm	: [optionnel] valeur maximale désirée
%
% VALEURS DE RETOUR :
%
% Base	: la nouvelle base RdF normalisée
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
% Création : octobre 2000
% version : 1.4
% Derniere révision :
%  - B. Gas (27/11/2000) : amélioration du Help
%  - B. Gas (4/12/2000) : calcul des vecteurs normés 
%  - B. Gas (24/1/2001) : gestion non graphique des erreurs 
%  - B. Gas (7/3/2001)  : normalisation avec centrage

% Normalisation au max en valeur absolue (signaux centrés)
if nargin==2
    MaxD = abs(MinNorm);                      % le max désiré en val. absolue
    [N, sig_nbr] = size(Base);                % dimensions de la base
    Base = Base - sum(sum(Base))/N/sig_nbr;   % centrage
    MaxVal = abs(max(max(Base)));             % val. max du signal en valeur absolue
    MaxVal = max([MaxVal abs(min(min(Base)))]);
    Base = Base*MaxD/MaxVal;                  % normalisation
    
% Normalisation de la base entre min et max (signaux non centrés): 
elseif nargin==3
	MaxVal = max(max(Base));
	MinVal = min(min(Base));

	DeltaVal = MaxVal-MinVal;
	DeltaNorm = MaxNorm - MinNorm;

	Base = ((Base-MinVal)*DeltaNorm)/DeltaVal + MinNorm;
   
% Calcul des vecteurs normés :   
else
   [SizeEx, ans] = size(Base);
   normvec = sum(abs(Base).^2).^(0.5);
   Base = Base./(ones(SizeEx,1)*normvec);   
end;






