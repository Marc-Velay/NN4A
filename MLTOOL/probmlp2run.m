function Output = probmlp2run(Input,W1,B1,W2,B2);
%
% SYNTAXE :
%
% Output = probmlp2run(Input,W1,B1,W2,B2);
%
%
% ARGUMENTS :
%
% Input = matrice des exemples à tester (ex_size X ex_nbr)
% W1,B1 = poids et biais couche cachée
% W2,B2 = poids et biais couche de sortie
%
% PROBMLP2RUN calcule les sorties d'un réseau de neurones pour chacun des
% exemples dans 'Input'.
% Les exemples sont rangés en colonnes.
% Les sorties sont les probabilités à postériori d'appartenance aux classes.
%
%
% VALEURS DE RETOUR :
%
% Output   : le vecteur des sorties du réseau.
%
%
% Voir aussi PROBMLP2DEF  PROBMLP2TRAIN  PROBMLPCLASS
%

% PROBMLP2RUN
% Bruno Gas - LIS/P&C UPMC <gas@ccr.jussieu.fr>
% Création : 17 mars 2001
% Version 1.0
% Derniere révision : -

% nb. total d'exemples à tester :
[input_nbr ex_nbr] = size(Input);

[n_cell n_in] = size(W1); 
if input_nbr~=n_in
  error('[PROBMLP2RUN] Défaut de cohérence dans les arguments : W1 et Input');
end;
if size(B1)~=[n_cell 1]
  error('[PROBMLP2RUN] Défaut de cohérence dans les arguments : W1 et B1');
end;  
[n_out ans] = size(W2);
if ans~=n_cell
  error('[PROBMLP2RUN] Défaut de cohérence dans les arguments : W2 et W1');
end; 
if size(B2)~=[n_out 1]
  error('[PROBMLP2RUN] Défaut de cohérence dans les arguments : W2 et B2');
end; 


%Sortie couche cachée :
  V1 = W1*Input+B1*ones(1,ex_nbr);
  S1 = sigmo(V1);

%Sortie couche de sortie : 
  V2 = W2*S1+B2*ones(1,ex_nbr); 
  Output = softmax(V2);




