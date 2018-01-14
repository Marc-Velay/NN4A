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
      confusion_matrix = confusion(answer_vec, label_tst, unique(label_tst))
 end
 figure(2)
 plot([0.1:0.05:0.95], accuracy)
