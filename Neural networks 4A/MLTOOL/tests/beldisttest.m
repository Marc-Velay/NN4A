
clear all;

% Dessin des modèles :

Lg = 20;
Base = charbasedraw(4, 1, Lg);
[Base, Label] = base2label(Base);

un = reshape(Base(1,:),Lg,2);
deux = reshape(Base(2,:),Lg,2);
trois = reshape(Base(3,:),Lg,2);
quatre = reshape(Base(4,:),Lg,2);

BaseTest = charbasedraw(1, 1, Lg);
[BaseTest, Labeltest] = base2label(BaseTest);

inconnu = reshape(BaseTest(1,:),Lg,2);

Dun = beldist(inconnu, un);
Ddeux = beldist(inconnu, deux);
Dtrois = beldist(inconnu, trois);
Dquatre = beldist(inconnu, quatre);


disp(Distances obtenues (1,2,3 et 4])

%Matrice des couts :
C = [0 1 1 1 1; 1 0 1 1 1; 1 1 0 1 1; 1 1 1 0 1 ; 1 1 1 1 0];

% chaines :
A = [1 1 2 1 3 4]';
B = [1 2 4]';

%distance = distedit(B, A, C);
distance = distedit(B, A);

disp(['distance = ' num2str(distance)]);