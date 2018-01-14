
close all;
clear all;

% Chargement base d'apprentissage :
BaseApp = chifget('basechif.mat', 'app', 10);
[ExNbrApp, ExSizeApp, ClassNbrApp] = basesize(BaseApp);
[BaseApp, TargetApp] = base2target(BaseApp);
BaseApp = basenorm(BaseApp,-1,+1);


% Chargement base de validation :
BaseCrv = chifget('basechif.mat', 'tst', 8);
[ExNbrCrv, ExSizeCrv, ClassNbrCrv] = basesize(BaseCrv); 
[BaseCrv, TargetCrv] = base2target(BaseCrv);
BaseCrv = basenorm(BaseCrv,-1,+1);


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


% Apprentissage avec pas adaptatif :
lr = [lr0 lr_dec, lr_inc, err_ratio];
freqvalid = 10;
[NW1,NB1,NW2,NB2,L,LR,LA,LV]=mlp2acrvtrain(BaseApp, TargetApp, BaseCrv, TargetCrv, W1, B1, W2, B2, freqvalid, freqplot);
 
figure(2);
subplot(211); plot(LA);
subplot(212); plot(LV);


% taux de reconnaissance en apprentissage :
Output = mlp2run(BaseApp,NW1,NB1,NW2,NB2);
AppLabels = classif(Output);
AppLabelsD = target2label(TargetApp);
taux = sum(AppLabelsD==AppLabels)*100/ExNbrApp;

disp(['taux de reconnaissance en apprentissage : ' num2str(taux) ' %']);


% taux de reconnaissance en test :
Output = mlp2run(BaseCrv,NW1,NB1,NW2,NB2);
TstLabels = classif(Output);
TstLabelsD = target2label(TargetCrv);
taux = sum(TstLabelsD==TstLabels)*100/ExNbrCrv;

disp(['taux de reconnaissance en validation : ' num2str(taux) ' %']);
