function MC = confusion(Labels, LabelsD);
%
% CONFUSION
%
% SYNTAXE :
%
%  MC = confusion(Labels, LabelsD)
%
% Calcul la matrice de confusion sur le r�sultat
% d'une classification
%
%
% ARGUMENTS :
%
% 
% Labels  	: vecteur des labels des formes class�s par le classifieur
% LabelsD	: vecteur des labels r�els de ces formes
%
% VALEURS DE RETOUR :
%
% MC        : la matrice de confusion.  
%             Les lignes repr�sentent les classes d'appartenance des
%             �chantillons et les colonnes les classes donn�es par le
%             classifieur. La derni�re colonne comptabilise
%				  les exemples rejet�s (les exemples dont le label est 0).
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
% Cr�ation : octobre 2000
% version : 1.1
% Derniere r�vision : 
%  - B. Gas (27/1/2001) : mise � jour


if nargin~=2, error('[CONFUSION] usage : MC = confusion(Labels, LabelsD)'); end;

[ans LabelsNbr] = size(Labels);
if ans~=1, error('[CONFUSION] erreur: l''argument <Labels> devrait �tre un vecteur ligne'); end;
[ans LabelsDNbr] = size(Labels);
if ans~=1, error('[CONFUSION] erreur: l''argument <LabelsD> devrait �tre un vecteur ligne'); end;
if LabelsNbr~=LabelsDNbr, error('[CONFUSION] erreur: arguments <Labels> et <LabelsD> incompatibles'); end;

% nombre de classes repr�sent�es :
ClassNbr = max(LabelsD);

if max(Labels) > ClassNbr
   error('[CONFUSION] erreur : labels sup�rieurs au nombre de classes dans <Labels>');   
end;

% matrice de confusion :
MC = zeros(ClassNbr, ClassNbr+1);

for i=1:LabelsNbr
	if Labels(i)==0		% exemples rejet�s		   
      MC(LabelsD(i), ClassNbr+1) = MC(LabelsD(i), ClassNbr+1) + 1;
   else
		MC(LabelsD(i), Labels(i)) = MC(LabelsD(i), Labels(i)) + 1;      
   end;
end;
