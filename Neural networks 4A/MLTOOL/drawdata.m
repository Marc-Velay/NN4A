function drawdata(data, label, type)
%
% SYNTAXE :
%
% drawdata(data, label);
%
%
% ARGUMENTS :
%
% data = données
% label = étiquette
% type = 'all' toute la base
%        'app' base d'apprentissage
% DRAWDATA affiche les données
%

color = 'krbgcm' ;
[dim max_ex] = size(data) ;
for nb_ex = 1 : max_ex
    if type == 'all'
        plot(data(1,nb_ex), data(2,nb_ex), [color(label(nb_ex)) '.']) ;
    else
        plot(data(1,nb_ex), data(2,nb_ex), [color(label(nb_ex)) 'v']) ;
    end
end
