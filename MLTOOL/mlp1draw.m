function mlp1draw(W1, B1)
%
% SYNTAXE :
%
% mlp1draw(W1,B1);
%
%
% ARGUMENTS :
%
% W1,B1 = poids et biais couche cach�e
%
% MLP1DRAW ffiche les fronti�res entre classes
%

[X Y] = meshgrid(-1:.05:1, -1:.05:1) ;
[s1 s2] = size(X) ;
data = [reshape(X, 1, s1*s2) ; reshape(Y, 1, s1*s2)] ;
[dim max_ex] = size(data) ;
%propagation
out = mlp1run(data, W1, B1) ;
label = target2label(out) ;

%affichage
color = 'krbgcm' ;
for nb_ex = 1 : max_ex
    plot(data(1,nb_ex), data(2,nb_ex), [color(label(nb_ex)) '+']) ;
end
