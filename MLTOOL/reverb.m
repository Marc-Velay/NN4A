function rvsignal = reverb(signal, reverb, gain);
%
% REVERB
%
% SYNTAXE :
%
%   rvsignal = reverb(signal, delay, gain);
%   rep_impulsionnelle  = reverb;
%
%	Effet de r�verb�ration appliqu� � un signal audio mono.
%	R�ponse impulsionnelle tir�e du cours Multim�dia de 
%	Sylvain Machel.
%
%   Sans arguments, retourne la r�ponse impulsionnelle du filtre
%
% ARGUMENTS :
%
% signal 	: le signal original, mono ou st�r�o
% delay     : le d�lais de r�verb�ration (>=1, petite pi�ce � grand local, 1 -> ~12)
% gain      : gain du signal d'�cho (signal = signal d'origine + gain*r�verb�ration; ex:de 0.01 � 1) 
%
% VALEURS DE RETOUR :
%
% rvsignal	: signal r�verb�r�
%
% VOIR AUSSI :
%
%   -
%
% COMPATIBILITE : 
%   >= matlab 5.1, octave 2.0
%

% Bruno Gas - LISIF/PARC UPMC
% Cr�ation : 8 octobre 2001
% version : 1.1
% Derniere r�vision :
% - B. Gas (13/11/2001) : modif. help
%