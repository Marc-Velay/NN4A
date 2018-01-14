function Gagnants = khn2run (Base, Centres)
%
% KHN2RUN
% 
%   Classification par carte de Kohonen 2D  
% 
% SYNTAXE :
%
%  Gagnants = khn2run (Base, Centres)
%
% ARGUMENTS : 
%
%  Base 			: base des exemples à classer
%  Centres		: matrice des centres de la carte
%
% VALEURS DE RETOUR :
%
%  Gagnants	   : position des neurones gagnants
%
%
% VOIR AUSSI :
%
%  KHNCLASS  KHN2DEF  KHN2TRAIN  KHN1* 
%
%
% COMPATIBILITE : 
%
%  Matlab 5.3+

% KHN2RUN
% Bruno Gas - LIS/P&C UPMC <gas@ccr.jussieu.fr>
% Création : 9 novembre 2000
% Version 1.1
% Dernieres révisions : 
% - B.Gas (27/1/2001) : mise à jour tbx RdF
%

errorbox = 'khn2run : erreur';
usage = 'Gagnants = khn2run (Base, Centres)';


% controle des arguments :
if nargin~=2, error('[KHN2RUN] usage: Gagnants = khn2run (Base, Centres)'); end;

[ExSize, ExNbr] = size(Base);       [CentreNbr, InputNbr] = size(Centres);

if InputNbr~=ExSize
   error('[KHN2RUN] Pbm. de dimension entre les arguments <Base> et <Centres>'); end;

Gagnants = zeros(1,ExNbr);
for ex=1:ExNbr    
   delta = Centres' - Base(:,ex)*ones(1,CentreNbr);
   dist = sum(delta.^2);
   [val ind] = min(dist);      
   Gagnants(ex) = ind(1);				% centre le plus proche 
end;   
