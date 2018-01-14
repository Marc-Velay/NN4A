
clear all;

% Chargement base d'apprentissage :
BaseApp = chifget('basechif.mat', 'app', 10);
[ExNbrApp, ExSizeApp, ClassNbrApp] = basesize(BaseApp);
[BaseApp, TargetApp] = base2target(BaseApp);
BaseApp = basenorm(BaseApp,-1,+1);


% Chargement base de test :
BaseTst = chifget('basechif.mat', 'tst', 8);
[ExNbrTst, ExSizeTst, ClassNbrTst] = basesize(BaseTst); 
[BaseTst, TargetTst] = base2target(BaseTst);
BaseTst = basenorm(BaseTst,-1,+1);


% Structure du réseau :
InputNbr = ExSizeApp;			% nombre d'entrées
HcellNbr = 10;						% nombre de cellules cachées
OutputNbr = ClassNbrApp;      % nombre de cellules de sortie

[W1, B1, W2, B2] = mlp2def(InputNbr, HcellNbr, OutputNbr, 2);


% paramètres de l'apprentissage :
lr0 = 0.001;						% pas initial
lr_inc = 1.1;						% incrément du pas
lr_dec = 0.9;						% décrément du pas
err_ratio = 1.0;					% interval de pas constant
nb_it = 1000;						% nombre d'itérations d'apprentissage
err_glob = 0.01;					% Critère d'arret sur l'erreur
freqplot = 10;						% fréquence d'affichage


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


% taux de reconnaissance en test :
Output = mlp2run(BaseTst,NW1,NB1,NW2,NB2);
TstLabels = classif(Output);
TstLabelsD = target2label(TargetTst);
taux = sum(TstLabelsD==TstLabels)*100/ExNbrTst;

disp(['taux de reconnaissance en test : ' num2str(taux) ' %']);
