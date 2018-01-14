function rvsignal = reverb(signal, reverb, gain);
%
% REVERB
%
% SYNTAXE :
%
%   rvsignal = reverb(signal, delay, gain);
%   rep_impulsionnelle  = reverb;
%
%	Effet de réverbération appliqué à un signal audio mono.
%	Réponse impulsionnelle tirée du cours Multimédia de 
%	Sylvain Machel.
%
%   Sans arguments, retourne la réponse impulsionnelle du filtre
%
% ARGUMENTS :
%
% signal 	: le signal original, mono ou stéréo
% delay     : le délais de réverbération (>=1, petite pièce à grand local, 1 -> ~12)
% gain      : gain du signal d'écho (signal = signal d'origine + gain*réverbération; ex:de 0.01 à 1) 
%
% VALEURS DE RETOUR :
%
% rvsignal	: signal réverbéré
%
% VOIR AUSSI :
%
%   -
%
% COMPATIBILITE : 
%   >= matlab 5.1, octave 2.0
%

% Bruno Gas - LISIF/PARC UPMC
% Création : 8 octobre 2001
% version : 1.1
% Derniere révision :
% - B. Gas (13/11/2001) : modif. help
%