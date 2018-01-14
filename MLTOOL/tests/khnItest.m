
clear all;

% Chargement base d'apprentissage :
BaseApp = chifget('basechif.mat', 'app', 10);
[ExNbrApp, ExSizeApp, ClassNbrApp] = basesize(BaseApp);
[BaseApp, TargetApp] = base2target(BaseApp);
BaseApp = basenorm(BaseApp,-1,+1);
LabelApp = target2label(TargetApp);

% Chargement base de test :
BaseTst = chifget('basechif.mat', 'tst', 8);
[ExNbrTst, ExSizeTst, ClassNbrTst] = basesize(BaseTst); 
[BaseTst, TargetTst] = base2target(BaseTst);
BaseTst = basenorm(BaseTst,-1,+1);


% Structure du réseau :

InputNbr = ExSizeApp;
CentreNbr = 10;
Centres = khn1def (InputNbr, CentreNbr, 1);


% Apprentissage :

nb_it = 200;
v0 = 3;
lr0 = 0.01;
[NCentres, L] = khn1train(BaseApp, Centres, nb_it, lr0, v0);

figure(1);
plot(L);


% Visualisation des centres :

Im = floor(basenorm(NCentres',0,255));

for i=1:ClassNbrApp
	figure(2);   
   imgview(reshape(Im(:,i),10,10));
   pause;
end;

% reconnaissance app. :

AppLabels = khn1run(BaseApp, NCentres);

AppLabelsD = target2label(TargetApp);
taux = sum(AppLabelsD==AppLabels)*100/ExNbrApp;

disp(['taux de reconnaissance en apprentissage : ' num2str(taux) ' %']);
disp('matrice de confusion : ');
confusion(AppLabels, AppLabelsD)

% reconnaissance tst. :

TstLabels = khn1run(BaseTst, NCentres);

TstLabelsD = target2label(TargetTst);
taux = sum(TstLabelsD==TstLabels)*100/ExNbrTst;

disp(['taux de reconnaissance en test : ' num2str(taux) ' %']);
disp('matrice de confusion : ');
confusion(TstLabels, TstLabelsD)






