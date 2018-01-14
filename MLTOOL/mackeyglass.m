function signal = mackeyglass (N);
%
% MAKEYGLASS
%
% Génération de la série de Mackey-Glass
%
% SYNTAXE :
%
% signal = mackeyglass (N);
%
% ARGUMENTS :
%
% N : nombre d'échantillons
%
% VALEURS DE RETOUR :
%
% signal : le signal généré sur N points
%
% VOIR AUSSI :
%    
%  - 
%
% COMPATIBILITE : 
%    matlab 5.3
%

%+----------------------------------------------------------------------------+
%| Eric A. Wan          | Dept. of Electrical Engineering and Applied Physics |
%|    	                | Oregon Graduate Institute of Science & Technology   |
%+----------------------+-----------------------------------------------------+
%| ericwan@eeap.ogi.edu | Mailing:                |  Shipping:                |
%| tel (503) 690-1164   | P.O. Box 91000          |  20000 N.W. Walker Road   |
%| fax (503) 690-1406   | Portland, OR 97291-1000 |  Beaverton, OR 97006      |
%+----------------------------------------------------------------------------+
%| Home page: http://www.cse.ogi.edu/~ericwan                                 |
%+----------------------------------------------------------------------------+

% Mohamed Chetouani - Mohamed.Chetouani@lis.jussieu.fr
% Création : 9 novembre 2001
% version : 1.0
% Derniere révision : -

% mg.m: Mackey Glass generator  


tt = 6;              % sampling rate
dt= 0.01;            % inegrate step
NN = N*tt/dt         % final number of samples

tau = 30/dt;         % Mackey-Glass paramater
x = .9*ones(NN+1,1); % initial conditions

% Runge-Kutta Method

for n = tau+1:NN,
 xx = x(n);
 xxd = x(n-tau);
 xk1 = dt*mg1(xx,xxd);
 xk2 = dt*mg1(xx+xk1/2,xxd);
 xk3 = dt*mg1(xx+xk2/2,xxd);
 xk4 = dt*mg1(xx+xk3,xxd);
 nn = n+1;
 x(nn) = xx + xk1/6 + xk2/3 +xk3/3 +xk4/6;

end

% resample every tt/dt
signal = x(1:tt/dt:NN);


% function mg1 for Mackey-Glass
function [mgx] = mg1(x,xd)
mgx = -0.1*x + .2*xd/(1+xd^10);

