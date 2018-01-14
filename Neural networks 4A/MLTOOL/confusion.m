function MC = confusion(Labels, LabelsD);
%
% CONFUSION
%
% SYNTAXE :
%
%  MC = confusion(Labels, LabelsD)
%
% Calcul la matrice de confusion sur le résultat
% d'une classification
%
%
% ARGUMENTS :
%
% 
% Labels  	: vecteur des labels des formes classés par le classifieur
% LabelsD	: vecteur des labels réels de ces formes
%
% VALEURS DE RETOUR :
%
% MC        : la matrice de confusion.  
%             Les lignes représentent les classes d'appartenance des
%             échantillons et les colonnes les classes données par le
%             classifieur. La dernière colonne comptabilise
%				  les exemples rejetés (les exemples dont le label est 0).
%                    
%
% VOIR AUSSI :
%
%   score
%
% COMPATIBILITE : 
%   >= matlab 5.1
%

% Bruno Gas - LIS/P&C UPMC
% Création : octobre 2000
% version : 1.1
% Derniere révision : 
%  - B. Gas (27/1/2001) : mise à jour


if nargin~=2, error('[CONFUSION] usage : MC = confusion(Labels, LabelsD)'); end;

[ans LabelsNbr] = size(Labels);
if ans~=1, error('[CONFUSION] erreur: l''argument <Labels> devrait être un vecteur ligne'); end;
[ans LabelsDNbr] = size(Labels);
if ans~=1, error('[CONFUSION] erreur: l''argument <LabelsD> devrait être un vecteur ligne'); end;
if LabelsNbr~=LabelsDNbr, error('[CONFUSION] erreur: arguments <Labels> et <LabelsD> incompatibles'); end;

% nombre de classes représentées :
ClassNbr = max(LabelsD);

if max(Labels) > ClassNbr
   error('[CONFUSION] erreur : labels supérieurs au nombre de classes dans <Labels>');   
end;

% matrice de confusion :
MC = zeros(ClassNbr, ClassNbr+1);

for i=1:LabelsNbr
	if Labels(i)==0		% exemples rejetés		   
      MC(LabelsD(i), ClassNbr+1) = MC(LabelsD(i), ClassNbr+1) + 1;
   else
		MC(LabelsD(i), Labels(i)) = MC(LabelsD(i), Labels(i)) + 1;      
   end;
end;
