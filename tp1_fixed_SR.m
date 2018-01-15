close all
clear all
addpath("./MLTOOL")

%chargement base
nb_base = menu('chargement', 'base1', 'base2', 'base3') ;
load(sprintf('base%d', nb_base)) ;
[dim max_ex] = size(data) ;
max_classe = max(label) ;

%affichage base
figure(1), axis([-1 1 -1 1]), hold on
drawdata(data, label, 'all')

%base d'apprentissage = tirage aléatoire des exemples
%split_ratio = input('ratio apprentissage/test : ') ;

 accuracy = zeros(15, 1);
 acc_c = 1;
 split_ratio=0.8;
   
 [data_app, label_app, data_tst, label_tst] = splitbase(data, label, split_ratio);
      
 for k = 1:15
      answer_vec = zeros(length(data_tst),1);
      for i = 1:length(data_tst)
        dist = euclideanDistance(data_tst(:,i), data_app, label_app, k);
        answer_vec(i) = isCorrect(dist, unique(label_tst));
      end;
      diff_vec = answer_vec-label_tst';
      errors = sum(diff_vec!=0);
      accuracy(acc_c) = 1-errors/length(data_tst);
      acc_c = acc_c +1;
      disp('ratio: '), disp(split_ratio)
      disp('accuracy: '), disp(1-errors/length(data_tst))
      confusion_matrix = confusion(answer_vec, label_tst, unique(label_tst))
      disp('Paused, press enter')
      %pause
 end
 figure(2)
 plot([1:15], accuracy)