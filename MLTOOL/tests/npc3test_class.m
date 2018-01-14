
% tests du codeur NPC-III en classification

clear all;
close all;


% paramètres NPC :
%-----------------
NPC_iter_nbr = input('nombre d''itérations d''apprentissage en paramétrisation = ');
NPC_lr = 1;
NPC_alpha = 1;

NPCC_iter_nbr = 100;
NPCC_lr = 1;


% paramètres de l'apprentissage :
%--------------------------------
MLP_lr0 = 0.001;						% pas initial
MLP_lr_inc = 1.1;						% incrément du pas
MLP_lr_dec = 0.9;						% décrément du pas
MLP_err_ratio = 1.0;					% interval de pas constant
MLP_nb_it = 1000;						% nombre d'itérations d'apprentissage
MLP_err_glob = 0.001;					% Critère d'arret sur l'erreur
MLP_freqplot = 10;						% fréquence d'affichage
MLP_freqvalid = 2;                      % fréquence de validation
MLP_hcell_nbr = 10;						% nombre de cellules cachées


% Extraction de phonèmes (p-t-q) :
%---------------------------------

load Timit-P-T-Q;

% Construction d'une base :
%--------------------------
[P_sig_nbr, N] = size(p);
[T_sig_nbr, ans] = size(t);
[Q_sig_nbr, ans] = size(q);

% paramètres base de donnée :
%----------------------------
sig_nbr = min([P_sig_nbr T_sig_nbr Q_sig_nbr]);                 % autant d'exemples par phonèmes
disp(['Nombre maximum de signaux disponibles par classes : ' num2str(sig_nbr)]);
sig_nbr_app = input('Nombre à récupérer pour la base d''apprentissage = ');
sig_nbr_tst = input('Nombre à récupérer pour la base de test = ');


BaseApp = [p(1:sig_nbr_app,:)' t(1:sig_nbr_app,:)' q(1:sig_nbr_app,:)'];        % concaténation des base p-t-q
LabelsApp = [ones(1,sig_nbr_app) 2*ones(1,sig_nbr_app) 3*ones(1,sig_nbr_app)];  % construction des labels
TargetApp = label2target(LabelsApp);                                            % construction des cibles

BaseTst = [p(P_sig_nbr-sig_nbr_tst+1:P_sig_nbr,:)' t(T_sig_nbr-sig_nbr_tst+1:T_sig_nbr,:)' q(Q_sig_nbr-sig_nbr_tst+1:Q_sig_nbr,:)'];
LabelsTst = [ones(1,sig_nbr_tst) 2*ones(1,sig_nbr_tst) 3*ones(1,sig_nbr_tst)];  % construction des labels
TargetTst = label2target(LabelsTst);                                            % construction des cibles

clear p t q;

class_nbr = 3;                                                  % 3 classes (p-t-q)
sig_nbr_app = sig_nbr_app*class_nbr;                            % nombre total d'exemples
BaseApp = basenorm(BaseApp, 0.8);                               % normalisation à (+-)0.8
sig_nbr_tst = sig_nbr_tst*class_nbr;                            % nombre total d'exemples
BaseTst = basenorm(BaseTst, 0.8);                               % normalisation à (+-)0.8

% Structure NPC-III :
%--------------------
[W1 B1 codes_size win_size] = npc3def(1);

% Génération des codes :
%-----------------------
Codes0 = randcodes(codes_size, class_nbr, 1);

% Paramétrisation :
%------------------
args = [NPC_iter_nbr NPC_lr NPC_alpha];
[NW1, NB1, Codes, L, Lpred, Ldisc, sigma] = npc3param(BaseApp, LabelsApp, W1, B1, Codes0, args);

figure(1);
subplot(211); plot(Lpred);
subplot(212); plot(Ldisc./Lpred);
drawnow;

% Codage :
%---------
args = [NPCC_iter_nbr NPCC_lr];
Codes0 = randcodes(codes_size, class_nbr*sig_nbr_app, 1);
[CodesApp, L] = npc3code(BaseApp, NW1, NB1, Codes0, args);  

Codes0 = randcodes(codes_size, class_nbr*sig_nbr_tst, 1);
[CodesTst, L] = npc3code(BaseTst, NW1, NB1, Codes0, args);  
 

% Structure du classifieur MLP :
%-------------------------------
[W1, B1, W2, B2] = mlp2def(codes_size, MLP_hcell_nbr, class_nbr, 2);


% Apprentissage avec pas adaptatif :
%-----------------------------------
figure(2);
lr = [MLP_lr0 MLP_lr_dec, MLP_lr_inc, MLP_err_ratio];
%[NW1,NB1,NW2,NB2,L,LR]=mlp2atrain(CodesApp, TargetApp, W1, B1, W2, B2, lr, MLP_nb_it, MLP_err_glob, MLP_freqplot);

[NW1,NB1,NW2,NB2,L,LR,LA,LV,a,b,c,d]=mlp2acrvtrain(CodesApp, TargetApp, CodesTst, TargetTst, W1, B1, W2, B2,...
    lr, MLP_nb_it, MLP_err_glob, MLP_freqvalid, MLP_freqplot);

figure(3);
plot(1:length(LA),LA,'g',1:length(LV),LV,'r');

% taux de reconnaissance en apprentissage :
%------------------------------------------
Output  = mlp2run(CodesApp,NW1,NB1,NW2,NB2);
Labels  = mlpclass(Output);
taux    = score(Labels, LabelsApp);
disp(['taux de reconnaissance en apprentissage : ' num2str(taux) ' %']);


% taux de reconnaissance en test :
%---------------------------------
Output  = mlp2run(CodesTst,NW1,NB1,NW2,NB2);
Labels  = mlpclass(Output);
taux    = score(Labels, LabelsTst);
disp(['taux de reconnaissance en test : ' num2str(taux) ' %']);

 
