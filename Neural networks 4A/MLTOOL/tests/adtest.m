
% tests analyse discriminante

clear;



load BaseApp1.mat;
Base = EntreeApp;
Target = InfoApp;

clear ClassApp EntreeApp InfoApp Phonemes;


X = ad(Base,Target,0.5);

figure(2);
plot(X(1,:),X(2,:),'+');