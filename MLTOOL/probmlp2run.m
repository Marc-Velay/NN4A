function Output = probmlp2run(Input,W1,B1,W2,B2);
%
% SYNTAXE :
%
% Output = probmlp2run(Input,W1,B1,W2,B2);
%
%
% ARGUMENTS :
%
% Input = matrice des exemples � tester (ex_size X ex_nbr)
% W1,B1 = poids et biais couche cach�e
% W2,B2 = poids et biais couche de sortie
%
% PROBMLP2RUN calcule les sorties d'un r�seau de neurones pour chacun des
% exemples dans 'Input'.
% Les exemples sont rang�s en colonnes.
% Les sorties sont les probabilit�s � post�riori d'appartenance aux classes.
%
%
% VALEURS DE RETOUR :
%
% Output   : le vecteur des sorties du r�seau.
%
%
% Voir aussi PROBMLP2DEF  PROBMLP2TRAIN  PROBMLPCLASS
%

% PROBMLP2RUN
% Bruno Gas - LIS/P&C UPMC <gas@ccr.jussieu.fr>
% Cr�ation : 17 mars 2001
% Version 1.0
% Derniere r�vision : -

% nb. total d'exemples � tester :
[input_nbr ex_nbr] = size(Input);

[n_cell n_in] = size(W1); 
if input_nbr~=n_in
  error('[PROBMLP2RUN] D�faut de coh�rence dans les arguments : W1 et Input');
end;
if size(B1)~=[n_cell 1]
  error('[PROBMLP2RUN] D�faut de coh�rence dans les arguments : W1 et B1');
end;  
[n_out ans] = size(W2);
if ans~=n_cell
  error('[PROBMLP2RUN] D�faut de coh�rence dans les arguments : W2 et W1');
end; 
if size(B2)~=[n_out 1]
  error('[PROBMLP2RUN] D�faut de coh�rence dans les arguments : W2 et B2');
end; 


%Sortie couche cach�e :
  V1 = W1*Input+B1*ones(1,ex_nbr);
  S1 = sigmo(V1);

%Sortie couche de sortie : 
  V2 = W2*S1+B2*ones(1,ex_nbr); 
  Output = softmax(V2);




