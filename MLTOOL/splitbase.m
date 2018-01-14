function [BaseApp, labelsApp, BaseTst, labelsTst] = splitbase(Base, labels, split_ratio);
%
% SPLITBASE
%
% SYNTAXE :
%
% [BaseApp, labelsApp, BaseTst, labelsTst] = SPLITBASE(Base, labels, split_ratio);
%
% Décomposition d'une base en deux sous-bases:
%       - BaseApp, labelsApp: Apprentissage
%       - BaseTst, labelsTst: Test (généralisation)
%    Décomposition selon split_ratio   
%        split_ratio compris entre 0 et 1
%                   0: Aucun exemple en base d'apprentissage
%                   1: 100% des exemples font partis de la base d'apprentissage
%
%
% ARGUMENTS :
%
% Base       : la base des protoptypes (rangés en colonne, sans les labels)
% labels     : vecteur ligne des labels des prototypes
%
% VALEURS DE RETOUR :
% BaseApp    : Base d'apprentissage
% labelsApp  : Vecteur ligne des labels des prototypes d'apprentissage
% BaseTst    : Base de test 
% labelsTst  : Vecteur ligne des labels des prototypes de test
%
%
% VOIR AUSSI :
%
%   BASE2TARGET  BASE2LABEL LABEL2TARGET GENBASE SHOWBASE
% 

% SPLITBASE
% Mohamed Chetounai - LISIF/PARC UPMC
% Création : 24/10/2004
% Version : 1.1
% Derniere révision : - Bug sur l'extraction des exemples (permutation des
% exemples avant extraction)
%                     - La permutation ne modifie pas la place des exemples
%  

% controle des arguments :
if nargin ~= 3
   error('Usage : [BaseApp, labelsApp, BaseTst, labelsTst]= splitbase (Base, labels, split_ratio)');
end;

if split_ratio<0 | split_ratio >1,
    error('[SPLITBASE]: 0 < split_ratio < 1');
end;

[ExSize ExNbr] =size(Base);


if split_ratio==1,
    BaseApp = Base;
    labelsApp = labels;
    BaseTst = [];
    labelsTst = [];
else
    ClassNbr = max(labels);
    [ExSize, ExNbr] = size(Base);
    BaseApp = [];
    labelsApp = [];
    BaseTst = [];
    labelsTst = [];
    
    for cl=1:ClassNbr
        ind = find(labels==cl);
        count = sum(sign(diff(ind))~=0)+1;
        taux  = round(count * split_ratio);
        
        indices = randperm(count)+min(ind)-1;
        B = Base(:,indices);  

        
        BaseApp = [BaseApp Base(:,indices(1:taux))];
        labelsApp = [labelsApp labels(indices(1:taux))];

        BaseTst = [BaseTst Base(:,indices(taux+1:count))];
        labelsTst = [labelsTst labels(indices(taux+1:count))];
    end;
end;






