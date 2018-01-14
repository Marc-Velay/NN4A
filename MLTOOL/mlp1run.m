function Output = mlp1run(Input,W1,B1);
%
% SYNTAXE :
%
% Output = mlp1run(Input,W1,B1);
%
%
% ARGUMENTS :
%
% Input = matrice des exemples � tester (ex_size X ex_nbr)
% W1,B1 = poids et biais
%
% MLP1RUN calcule les sorties d'un r�seau de neurones pour chacun des
% exemples dans 'Input'.
% Les exemples sont rang�s en colonnes.
%
%
% VALEURS DE RETOUR :
%
% Output   : le vecteur des sorties du r�seau.
%
%
% Voir aussi MLP1DEF  MLP1TRAIN
%

% MLP1RUN
% Bruno Gas - LIS/P&C UPMC <gas@ccr.jussieu.fr>
% Cr�ation : octobre 2000
% Version 1.1
% Derniere r�vision : 
%  - B.Gas (10/02/2001) : mise � jour tbx RdF 


% nb. total d'exemples � tester :
[input_nbr ex_nbr] = size(Input);

[n_cell n_in] = size(W1); 
if input_nbr~=n_in
  error('[MLP1RUN] D�faut de coh�rence dans les arguments : W1 et Input'); end;
if size(B1)~=[n_cell 1]
  error('[MLP1RUN] D�faut de coh�rence dans les arguments : W1 et B1'); end;  

%Sortie r�seau  :
V1 = W1*Input+B1*ones(1,ex_nbr);
Output = sigmo(V1);

