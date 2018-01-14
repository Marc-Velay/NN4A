
clear all;

%Matrice des couts :
C = [0 1 1 1 1; 1 0 1 1 1; 1 1 0 1 1; 1 1 1 0 1 ; 1 1 1 1 0];

% chaines :
A = [1 1 2 1 3 4]';
B = [1 2 4]';

%distance = distedit(B, A, C);
distance = distedit(B, A);

disp(['distance = ' num2str(distance)]);