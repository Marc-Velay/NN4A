%
% manip 2
%
% test sur l'estimation de fréquences
%

clear all; close all;

% génération des signaux bruités et non bruités :
%------------------------------------------------

Fe = 1;					% freq. normalisées
N = 512;					% nbr. d'échantillons
Freq = (0:0.02:0.5);	% fréquences
FreqNbr = length(Freq);
Freq = Freq(2:FreqNbr-1); FreqNbr = FreqNbr - 2;
Phase = zeros(1,FreqNbr);
Nbr = 1;					% nombre de signaux / fréquences
SigNbr = FreqNbr*Nbr;

Base 			= gensig(Fe, Freq, Nbr, N, 100, Phase);
BaseBruit 	= gensig(Fe, Freq, Nbr, N, 10, Phase);
[Base Label] = base2label(Base);
[BaseBruit LabelBruit] = base2label(BaseBruit);
Base = basenorm(Base,0.8);
BaseBruit = basenorm(BaseBruit,0.8);

% Structure NPC-I :
%--------------------

[W1, B1, CodeSize, WinSize] = npc2def(1);
Codes0 = randcodes(CodeSize, FreqNbr, 1);
%theta = (0:FreqNbr-1)*2*pi/FreqNbr;
%Codes0 = [cos(theta); sin(theta)];

% Paramétrisation sans bruit :
%-----------------------------
IterNbr = 400;
lr = [IterNbr 1 0.9 1.1 1];
[NW1, NB1, PCodes, L, LR] = npc2aparam(BaseBruit, Label, W1, B1, Codes0, lr);

figure(1);
subplot(211); plot(L); subplot(212); plot(LR);

% Codage des signaux :
%---------------------
[CCodes, CL] = npc2code(Base, NW1, NB1, Codes0, [100 1]);

figure(2);
plot(Codes0(1,:),Codes0(2,:),'r*',...
   PCodes(1,:),PCodes(2,:),'b*',...
   CCodes(1,:),CCodes(2,:),'g',...
   CCodes(1,:),CCodes(2,:),'g*');


% apprentissage fonction inverse d'estimation de fréquence :
%-----------------------------------------------------------

disp('apprentissage fonction inverse...'); drawnow;

[w1,b1,w2,b2]=mlp2fit(CCodes, Freq, 2, 0.01);
FreqEstim = mlp2fit(w1,b1,w2,b2, CCodes, min(Freq), max(Freq));

figure(3);
plot(Freq,Freq,'g',Freq, FreqEstim,'r',Freq, FreqEstim,'r*');
