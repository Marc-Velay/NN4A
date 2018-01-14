
clear all;
close all;

% Chargement base d'apprentissage :
BaseApp = chifget('basechif.mat', 'app', 20);
[ExNbrApp, ExSizeApp, ClassNbrApp] = basesize(BaseApp);
[BaseApp, TargetApp] = base2target(BaseApp);
BaseApp = basenorm(BaseApp,-1,+1);
LabelApp = target2label(TargetApp);

% Désordonnancement des exemples :
ind = randperm(ExNbrApp);
BaseApp = BaseApp(:,ind);
LabelApp = LabelApp(ind);

% Chargement base de test :
BaseTst = chifget('basechif.mat', 'tst', 8);
[ExNbrTst, ExSizeTst, ClassNbrTst] = basesize(BaseTst); 
[BaseTst, TargetTst] = base2target(BaseTst);
BaseTst = basenorm(BaseTst,-1,+1);


% Structure du réseau :

InputNbr = ExSizeApp;
DimX = 4;
DimY = 4;
CentreNbr = DimX*DimY;
Centres = khn2def (InputNbr, DimX, DimY, 1);


% Apprentissage :

nb_it = 10000;
v0 = 5;
lr0 = 0.1;
[NCentres, L] = khn2train(BaseApp, Centres, DimX, DimY, nb_it, lr0, v0);

figure(1);
plot(L);


% Visualisation des centres :

Im = floor(basenorm(NCentres',0,255));
imageC = [];
for i=1:DimY
   img = [];
   for j=1:DimY
      img = [img reshape(Im(:,(i-1)*DimY+j),10,10)];
   end;
   imageC = [imageC;img];
end;
imgview(imageC);

CCentres = disp('Donner le vecteur des classes des centres :');
%CCentres = [7 0 9 5 1 9 3 8 4 0 0 8 4 6 10 2]';
 

% reconnaissance app. :

AppLabels = khn2run(BaseApp, NCentres);
AppLabels = khnclass(AppLabels, CCentres);
AppLabelsD = target2label(TargetApp);

%taux = sum(AppLabelsD==AppLabels)*100/ExNbrApp;
[rejet, taux] = score(AppLabels, AppLabelsD);

disp(['taux de reconnaissance en apprentissage : ' num2str(taux) ' %']);
disp(['taux de rejet : ' num2str(rejet) ' %']);
disp('matrice de confusion : ');
confusion(AppLabels, AppLabelsD)

% reconnaissance tst. :

TstLabels = khn2run(BaseTst, NCentres);
TstLabels = khnclass(TstLabels, CCentres);
TstLabelsD = target2label(TargetTst);

%taux = sum(TstLabelsD==TstLabels)*100/ExNbrTst;
[rejet, taux] = score(TstLabels, TstLabelsD);

disp(['taux de reconnaissance en test : ' num2str(taux) ' %']);
disp(['taux de rejet : ' num2str(rejet) ' %']);
disp('matrice de confusion : ');
confusion(TstLabels, TstLabelsD)






