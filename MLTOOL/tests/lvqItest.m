
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
CentreNbr = 3;
[Centres, ClassCentres] = lvqIdef (BaseApp, LabelApp, CentreNbr, 1);

nb_it = 100;
freqplot = 10;						% fréquence d'affichage

[NCentres, L] = lvqItrain(BaseApp, TargetApp, Centres, ClassCentres, nb_it, freqplot);



return;





% Apprentissage avec pas fixe :
%lr = lr0;
%[NW1,NB1,NW2,NB2,L]=mlp2train(BaseApp, TargetApp, W1, B1, W2, B2, lr, nb_it, err_glob, freqplot);


% Apprentissage avec pas adaptatif :
lr = [lr0 lr_dec, lr_inc, err_ratio];
%[NW1,NB1,NW2,NB2,L,LR]=mlp2atrain(BaseApp, TargetApp, W1, B1, W2, B2, lr, nb_it, err_glob, freqplot);
[NW1,NB1,NW2,NB2,L,LR]=mlp2atrain(BaseApp, TargetApp, W1, B1, W2, B2, freqplot);
 

% taux de reconnaissance en apprentissage :
Output = mlp2run(BaseApp,NW1,NB1,NW2,NB2);
AppLabels = classif(Output);
AppLabelsD = target2label(TargetApp);
taux = sum(AppLabelsD==AppLabels)*100/ExNbrApp;

disp(['taux de reconnaissance en apprentissage : ' num2str(taux) ' %']);
disp('matrice de confusion : ');
confusion(AppLabels, AppLabelsD)


% taux de reconnaissance en test :
Output = mlp2run(BaseTst,NW1,NB1,NW2,NB2);
TstLabels = classif(Output);
TstLabelsD = target2label(TargetTst);
taux = sum(TstLabelsD==TstLabels)*100/ExNbrTst;

disp(['taux de reconnaissance en test : ' num2str(taux) ' %']);
disp('matrice de confusion : ');
confusion(TstLabels, TstLabelsD)
