function Gagnants = khn1run (Base, Centres)
%
% KHN1RUN
% 
%  Définition d'un carte de Kohonen 1 dimension
%
% 
% SYNTAXE :
%
%  Gagnants = khn1run (Base, Centres)
%
%
% ARGUMENTS : 
%
%  Base 	  : la base des exemples à traiter, rangés en colonnes.
%  Centres : poids des neurones distance, lex centres, rangés en ligne 
%
% VALEURS DE RETOUR :
%
%  Gagnants: la liste des numéros de neurones gagnants correspondant à chacun 
%            des exemples. Les neurones (centres) sont numérotés dans leur
%            ordre d'apparition dans la matrice <Centres>. 
% 				 Attention, ces labels ne correspondent pas aux classes d'appartenance
%            des exemples. 
%
% DESCRIPTION :
%
%
% VOIR AUSSI :
%
%  KHNCLASS  KHN1TRAIN  KHN1DEF 
%
%
% COMPATIBILITE : 
%
%  Matlab 5.3+

% KHN1RUN
% Bruno Gas - LIS/P&C UPMC <gas@ccr.jussieu.fr>
% Création : 29 octobre 2000
% Version 1.2
% Dernieres révisions : -
%  -B. Gas (13/11/2000) : help 
%  -B. Gas (27/01/2001) : mise à jour tbx RdF


% controle des arguments :
if nargin~=2, error('[KHN1RUN] usage: Gagnants = khn1run (Base, Centres)'); end;

[ExSize, ExNbr] = size(Base);
[CentreNbr, InputNbr] = size(Centres);

if InputNbr~=ExSize
   error('[KHN1RUN] Pbm. de dimension entre les args. <Base> et <Centres>');   
end;

Gagnants = zeros(1,ExNbr);
for ex=1:ExNbr   
	delta = Centres' - Base(:,ex)*ones(1,CentreNbr);
	dist = sum(delta.^2);
	[val ind] = min(dist);       
	Gagnants(ex) = ind(1);			% centre le plus proche 
end;   
