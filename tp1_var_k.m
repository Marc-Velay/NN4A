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

 acc_c = 1;
 max_k=10;
 accuracy = zeros(18, max_k);
 for split_ratio = 0.1:0.05:0.95
 
      [data_app, label_app, data_tst, label_tst] = splitbase(data, label, split_ratio);
      
      for k = 1:max_k
        answer_vec = zeros(length(data_tst),1);
        for i = 1:length(data_tst)
          dist = euclideanDistance(data_tst(:,i), data_app, label_app, k);
          answer_vec(i) = isCorrect(dist, unique(label_tst));
        end;
        diff_vec = answer_vec-label_tst';
        errors = sum(diff_vec!=0);
        accuracy(acc_c, k) = 1-errors/length(data_tst);
        %disp('ratio: '), disp(split_ratio)
        %disp('accuracy: '), disp(1-errors/length(data_tst))
        confusion_matrix = confusion(answer_vec, label_tst, unique(label_tst));
        %remove comments to pause at each iter
        %disp('Paused, press enter')
        %pause
      end;
      acc_c = acc_c +1;
 end
 figure(2)
 
 
 mesh([1:max_k], [0.1:0.05:0.95], accuracy)
  xlabel ("k");
  ylabel ("split ratio");
  zlabel ("accuracy");