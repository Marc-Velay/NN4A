clear;

[trames, cutsig, sig] = speechget;
trames = signorm(trames,1);
trames = sigpreacc(trames,0.9);

[sig_nbr sig_size] = size(trames);

%fenetre = ones(sig_nbr,1)*hamming(sig_size)';

%trames = trames.*fenetre;

%save -V4 egypte trames;

%load bonjour.mat;

size(trames)
Base = trames';

code_size = 12;
win_size = 20;
DimX = 4;
DimY = 4;

[W1, B1, Centres] = npcK2def (DimX, DimY, code_size, win_size, 1);


nb_it = 100;
lr0 = 0.0001;
v0 = 4;
freqplot = 10;

%Base = Base(:,1:25);

[NW1, NB1, NCentres, L] = npcK2param (Base, W1, B1, Centres, DimX, DimY, nb_it, lr0, v0, freqplot);
plot(L);
L

[Winers, L] = npcK2run (Base, NW1, NB1, NCentres, DimX, DimY);


