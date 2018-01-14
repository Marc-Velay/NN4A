function Output = mlp1run(Input,W1,B1);
%
% SYNTAXE :
%
% Output = mlp1run(Input,W1,B1);
%
%
% ARGUMENTS :
%
% Input = matrice des exemples à tester (ex_size X ex_nbr)
% W1,B1 = poids et biais
%
% MLP1RUN calcule les sorties d'un réseau de neurones pour chacun des
% exemples dans 'Input'.
% Les exemples sont rangés en colonnes.
%
%
% VALEURS DE RETOUR :
%
% Output   : le vecteur des sorties du réseau.
%
%
% Voir aussi MLP1DEF  MLP1TRAIN
%

% MLP1RUN
% Bruno Gas - LIS/P&C UPMC <gas@ccr.jussieu.fr>
% Création : octobre 2000
% Version 1.1
% Derniere révision : 
%  - B.Gas (10/02/2001) : mise à jour tbx RdF 


% nb. total d'exemples à tester :
[input_nbr ex_nbr] = size(Input);

[n_cell n_in] = size(W1); 
if input_nbr~=n_in
  error('[MLP1RUN] Défaut de cohérence dans les arguments : W1 et Input'); end;
if size(B1)~=[n_cell 1]
  error('[MLP1RUN] Défaut de cohérence dans les arguments : W1 et B1'); end;  

%Sortie réseau  :
V1 = W1*Input+B1*ones(1,ex_nbr);
Output = sigmo(V1);

