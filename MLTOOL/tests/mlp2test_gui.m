
clear all;

% Chargement base d'apprentissage :
BaseApp = chifget;
[ExNbrApp, ExSizeApp, ClassNbrApp] = basesize(BaseApp);
[BaseApp, TargetApp] = base2target(BaseApp);
BaseApp = basenorm(BaseApp,-1,+1);

% Chargement base de test :
BaseTst = chifget;
[ExNbrTst, ExSizeTst, ClassNbrTst] = basesize(BaseTst);
[BaseTst, TargetTst] = base2target(BaseTst);
BaseTst = basenorm(BaseTst,-1,+1);


% Structure du réseau :
InputNbr = ExSizeApp;
answer=inputdlg('Nombre de cellules de la couche cachée = ','Structure du réseau MLP 2 couches');
HcellNbr = str2num(char(answer(1)));
OutputNbr = ClassNbrApp;

[W1, B1, W2, B2] = mlp2def(InputNbr, HcellNbr, OutputNbr);

lr = 0.01/ExNbrApp/OutputNbr;
nb_it = 1000;
err_glob = 0.01/ExNbrApp/OutputNbr;
freqplot = 10;
[NW1,NB1,NW2,NB2,L]=mlp2train(BaseApp, TargetApp, W1, B1, W2, B2, lr, nb_it, err_glob, 10);




return;


freq_affichage = 10;
nb_it = 1000;
err_glob = 0.01/(Q*S2);
lr = 0.01/(Q*S2);
lr_inc = 1.1;
lr_dec = 0.9;
mom_const = 0.3;
err_ratio = 1.2;

TP = [freq_affichage nb_it err_glob lr lr_inc lr_dec mom_const err_ratio];

[NW1,NB1,NW2,NB2,TE,TR] = TRAINBPX(W1,B1,F1,W2,B2,F2,P,T,TP);

mlp2test(NW1, NB1, NW2, NB2, P, T, Ptest, Ttest);


