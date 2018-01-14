function [W1, B1, InputNbr, OutputNbr] = uimlp1def (InputNbr, OutputNbr, seed)
%
% usage: [W1, B1 [, InputNbr, OutputNbr]] 
%               = uimlp1def ([InputNbr, OutputNbr] [, seed])
%
% Définition de la structure d'un réseau perceptron 1 couche.
% Interface graphique de la fonction mlp1def
% 
%
% VOIR AUSSI :
%
% MLP1DEF  RANDWEIGHTS  MLP1TRAIN  MLP1RUN
%


% UIMLP1DEF
% Bruno Gas - LIS/P&C UPMC <gas@ccr.jussieu.fr>
% Création : 9 février 2001
% Version 1.0
% Dernieres révisions : -
%

usage = 'Usage : [W1, B1 [, InputNbr, OutputNbr]] = mlp1def ([InputNbr, OutputNbr] [, seed])';


% controle des arguments :

if nargin==1 | nargin >3,
	errordlg(usage,'Erreur d''usage dans uimlp1def'); error; end;

if nargin==1,   seed = InputNbr;
elseif nargin==0 | nargin==2,   seed = -1;  end;

if nargin==0 | nargin==1
   default={'100','10'};
   prompt={'Nombre d''entrées du réseau :','Nombre de sorties : '};
   
	titre = 'Architecture du codeur réseau MLP 1 couche';
   answer=inputdlg(prompt,titre,1,default);
   if isempty(answer)
      errordlg('Pas de réponse : échec','Erreur de saisie dans uimlp1def');
      error;
   end;
   InputNbr = str2num(char(answer(1)));
   OutputNbr = str2num(char(answer(2)));
end;
 

if seed==-1	
   [W1, B1] = mlp1def (InputNbr, OutputNbr);
else
   [W1, B1] = mlp1def (InputNbr, OutputNbr, seed);
end;
	
