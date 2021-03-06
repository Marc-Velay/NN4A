function [W1, B1, W2, B2, InputNbr, HcellNbr, OutputNbr] = uimlp2def (InputNbr, HcellNbr, OutputNbr, seed)
%
% usage: [W1, B1, W2, B2 [, InputNbr, HcellNbr, OutputNbr]] 
%               = mlp2def ([InputNbr, HcellNbr, OutputNbr] [, seed])
%
% D�finition de la structure d'un r�seau MLP 2 couches.
% Interface graphique de mlp2def.
%
% VOIR AUSSI :
%
%  MLP2DEF  RANDWEIGHTS  MLP2TRAIN  MLP2ATRAIN  MLP2RUN
%


% MLP2DEF
% Bruno Gas - LIS/P&C UPMC <gas@ccr.jussieu.fr>
% Cr�ation : 10/02/2001
% Version : 1.0
% Dernieres r�visions : -



usage = 'Usage : [W1, B1, W2, B2] = mlp2def ([InputNbr, HcellNbr, OutputNbr] [, seed]);';

% controle des arguments :

if nargin==2 | nargin >4
   errordlg('Usage : [W1, B1, W2, B2] = mlp2def ([InputNbr, HcellNbr, OutputNbr] [, seed]);',...
      'Erreur d''usage dans UIMLP2DEF'); 
	error;
end;

if nargin==1, seed = InputNbr;
elseif nargin==0 | nargin==3, seed = -1; end;

if nargin==0 | nargin==1
   default={'100','8','10'};
   prompt={'Nombre d''entr�es du r�seau :','Nombre de cellules cach�es : ',...
         'Nombre de sorties : '};
   
	titre = 'Architecture du codeur r�seau MLP 2 couches';
   answer=inputdlg(prompt,titre,1,default);
   if isempty(answer)
      errordlg('Pas de r�ponse : �chec',errorbox);
      return;
   end;
   InputNbr = str2num(char(answer(1)));
   HcellNbr = str2num(char(answer(2)));       
   OutputNbr = str2num(char(answer(3)));
end;

if seed==-1	   
   [W1, B1, W2, B2] = mlp2def (InputNbr, HcellNbr, OutputNbr);
else
   [W1, B1, W2, B2] = mlp2def (InputNbr, HcellNbr, OutputNbr, seed);   
end;
	
