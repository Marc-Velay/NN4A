
clear all;
 
% Chargement base de chiffres :

BaseApp = chifget('basechif.mat', 'app', 50);
[ExNbrApp, ExSizeApp, ClassNbrApp] = basesize(BaseApp);
[BaseApp, LabelApp] = base2label(BaseApp);
BaseApp = basenorm(BaseApp,-1,+1);

% Chargement base de test :
BaseTst = chifget('basechif.mat', 'tst', 8);
[ExNbrTst, ExSizeTst, ClassNbrTst] = basesize(BaseTst); 
[BaseTst, LabelTst] = base2label(BaseTst);
BaseTst = basenorm(BaseTst,-1,+1);

% K-ppv avec rejet éventuel :
Class = kppv(BaseApp, LabelApp, BaseTst, 1, 'reject');

% taux de rejet et taux de reconnaissance :
[ind val] = find(Class~=0);
Class = Class(ind);
LabelTst = LabelTst(ind);
NewExNbrTst = length(Class);
tauxrejet = (ExNbrTst-NewExNbrTst)*100/ExNbrTst; 
tauxreco = sum(Class==LabelTst)*100/NewExNbrTst;

% Affichage résultats :
disp(['taux de rejet:' num2str(tauxrejet) ' %']);
disp(['taux de reconnaissance 1-ppv : ' num2str(tauxreco) ' %']);




