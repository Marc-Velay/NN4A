close all
clear all
addpath("./MLTOOL")

%chargement base
nb_base = menu('chargement', 'base1', 'base2', 'base3') ;
load(sprintf('base%d', nb_base)) ;
[dim max_ex] = size(data) ;
max_classe = max(label) ;

%affichage base

%base d'apprentissage = tirage aléatoire des exemples
%split_ratio = input('ratio apprentissage/test : ') ;

 accuracy = zeros(18, 1);
 acc_c = 1;
 k=1;
 for split_ratio = 0.1:0.05:0.95
      %disp('pausing')
      %pause
      %close all
      %affichage base
      %figure(1), axis([-1 1 -1 1]), hold on
      split_ratio
      [data_app, label_app, data_tst, label_tst] = splitbase(data, label, split_ratio);
      %récupération des étiquettes
      %drawdata(data_app, label_app, 'app')
      %k = input('number of neighbors k: ');
      answer_vec = zeros(length(data_tst),1);
      for i = 1:length(data_tst)
        dist = euclideanDistance(data_tst(:,i), data_app, label_app, k);
        %expected_label = labeltst(:,i)
        answer_vec(i) = isCorrect(dist, unique(label_tst));
      end;
      diff_vec = answer_vec-label_tst';
      errors = sum(diff_vec!=0);
      accuracy(acc_c) = 1-errors/length(data_tst);
      acc_c = acc_c +1;
 end
 y = [0.1:0.05:0.95]
 accuracy
 size(accuracy)
 size(y)
 figure(2)
 plot([0.1:0.05:0.95], accuracy)

#{
%génération des sorties désirées
target = label2target(label_app) ;

%définition du résau
%InputNbr = ...............;
%OutputNbr = ...............;

InputNbr = size(data_app,1);
OutputNbr = size(label_app,1);


[W1, B1] = mlp1def(InputNbr, OutputNbr) ;

%paramétres d'apprentissage
lr = input('pas : ') ;
it = input('nombre d''itérations : ') ;
err_glob = 0.001;
freqplot = 10;

%apprentissage
figure(2)
[NW1, NB1, L] = mlp1train(data_app, target, W1, B1, lr, it, err_glob, freqplot);

%évaluation 
Output = mlp1run(data_app, NW1, NB1);
Label = mlpclass(Output);
TR_app = score(Label, label_app);
disp(' ')
disp(['taux de reconnaissance obtenu en apprentissage = ' num2str(TR_app) '%']);

%frontiére
figure(1)
mlp1draw(NW1, NB1)
#}
