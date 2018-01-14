function  [Xred, Yred,tabflagred] = mouseBase(action , titre);
% mouse1.m (VERSION 3)
% function  [Xred, Yred,tabflagred] = mouseBase(action, titre);
% Les coordonnees sont stockes automatiquement
% dans des variables Xred et Yred. Donc attention aux conflits
% de noms de variables.
%    X, Y - Cordonnees des points successifs
%    tabflagred - Vecteur de detection de levees
% 
% Exemple de lancement :
%    [X, Y, tab] = mouseBase('depart','Acquistion');
%


% F. Andrianasy, Jeudi 20 Juin 1996, Non-affichage des levees de stylo.
% F. Andrianasy, Mercredi 19  Juin 1996, Numeros de STROKES
% J. Devars & F. Andrianasy, Juin 96
% Laboratoire PARC, UPMC, Paris 6, France
% Chetouani Mohamed
% Sandoz Eric

global flagdessin
global tabflag
global tabflagred

global Fig
global Axes

global X
global Y
global S
global NoStroke

global Xred
global Yred

global Xs
global Ys

global hline
global hbouton
global EnCours
global bDown

global tempsstart
global duree
global seuiltemps
global levee

global OldButtonDown
global OldButtonUp
global OldButtonMotion
global OldPointer



% Appel initial, sans arguments
% ---------------------------------------------------------------
%
% ---------------------------------------------------------------
if nargin == 0,
	action = 'depart';
end;

warning off
% Demarrage
% ---------------------------------------------------------------
%
% ---------------------------------------------------------------
if strcmp(action, 'depart') == 1,
   disp('...depart')

%clc
close
   figure;
   Fig = gcf; % Handle de la figure
   figure(Fig);
%   set(Fig, 'position', [50 50 900 600])
   Axes = gca;% Handle des axes de la figure
   title(titre)

  xlabel('Pour commencer : Ecrivez sur la tablette');
      
   % Sauvegarde des parametres actuels de figure
   OldPointer      = get(Fig,'pointer');
   OldButtonDown   = get(Fig,'windowbuttondownfcn');
   OldButtonUp     = get(Fig,'windowbuttonupfcn');
   OldButtonMotion = get(Fig,'windowbuttonmotionfcn');


   % Annulation des anciens call-backs
   % et changement de la forme du pointeur
   set(Fig, 'windowbuttondownfcn', '',...
            'windowbuttonupfcn',   '',...
            'pointer', 'crosshair');



% Initialisation de quelques appels CallBack
% Iniatilisation des fonctions d'ecoutes d'evenements
	% Evenement Mouvement
   set(Fig, 'windowbuttonmotionfcn', ' mouseBase(''recup'',''titre''); ' );
 	% Evenement Contact "Haut"
   set(Fig, 'windowbuttonupfcn', 'mouseBase(''NewStroke'',''titre''); ' );
  	% Evenement Contact "Bas"
   set(Fig, 'windowbuttondownfcn', 'mouseBase(''Dessin'',''titre''); ' );

   % Pour que ca soit plus joli
   set(Fig,  'NumberTitle', 'off', ...                           
		     'Name', 'Saisie de Tracé', ...         % Nom de la  fenetre
		     'MenuBar', 'none');            			% Pas de barre de Menus
        
   set(Axes, 'Box', 'on', ...                     % Axes sous forme de boite
		     'Xgrid', 'on', 'XColor', 'w', ...        % Grilles
             'Ygrid', 'on', 'YColor', 'w',...                  
             'color', [.8 .8 .8]);                              % Couleur du fond de la boite
   set(Axes, 'XTickLabelMode', 'manual', 'XTickLabels',  [] );  % Pas de labels suivant X
   set(Axes, 'YTickLabelMode', 'manual', 'YTickLabels',  [] );  % Pas de labels suivant Y
   set(Axes, 'DrawMode', 'fast');                               % Mode de tracage RAPIDE
%   set(Axes,'position',[0.3  .3  .4  .5]);							 % Taille de la fenetre
    set(Axes,'position',[0 0 1 1]);							 % Taille de la fenetre
  																				 % de saisie
 % Position  [left, bottom, width, height]
 
  % Les Menus :
 	% Nouvel Essai
    f = uimenu('Label',' Nouvel Essai  ','Accelerator','M' ,'Callback','[X, Y,tabflag] = mouseBase(''depart'',''Nouvel essai '');');
 	% Validation de trace      
    f1 =  uimenu('Label','Validation','Callback','mouseBase(''Validation'',''  '');',...
           'Separator','on','Accelerator','V');                                                      

   % Premier point (un vide)
   X = [];                                                      % Abscisses 
   Y = [];                                                      % Ordonnees
   S = [];                                                      % Vecteur des Strokes
   tabflag = [];																 % Vecteur flag de detection levee 
   NoStroke = 1;                                                % No de Stroke


   Xs = [];                                                     % Abscisses
   Ys = [];                                                     % Ordonnees
   hline = line('color', 'k', ...                               % Objet LIGNE : couleur noire
             'linestyle', '-', ...                              % Ligne continue
             'erase', 'none', ...                               % Ne pas effacer ce qui est trace
             'xdata', Xs, ...                                   % Affichage dnas l'espace
             'ydata', Ys, ...                                   %
             'zdata', []);                                      % Plan XY seul


   
   % BOUCLE D'ATTENTE                                           %
   EnCours = 1;    
   while EnCours,  
      uiwait(Fig);    
      % Attente de la fin du programme
   end;                                                          %
   

   % SINON SORTIE DU PROGRAMME AVEC LES VALEURS DE X, Y et S
 break;
   %
   % fin de action == 'depart'



% ---------------------------------------------------------------
% LECTURE DE LA POSITION DE LA SOURIS (RECUPERATION DES POINTS)
% Effectuee autom. des que la souris (bout. gauche pressee) bouge
% Mouvement de la souris
% ---------------------------------------------------------------
elseif strcmp(action, 'recup')  == 1,                            %
    if gcf == Fig,                                               % Pour eviter les points en-dehors
       axes(Axes);                                               %
			
       if flagdessin == 0, 
        % condition de dessin Contact du Stylet avec la tablette   
       Point = get(Axes, 'currentpoint');                        % Point courant
       X = [X  Point(1, 1)];                                     % Met a jour les coordonnees
       Y = [Y  Point(1, 2)];                                     %
       S = [S  NoStroke];
%       tabflag = [tabflag 0];
        tabflag = [tabflag 1];
  
       Xs = [Xs  Point(1, 1)];                                   % Met a jour les coordonnees
       Ys = [Ys  Point(1, 2)];                                   % de ce STROKE
       set(hline, ...                                            % Met a jour le TRACE
            'xdata', Xs, ...                                    %
           'ydata', Ys, ...                                    %
         'zdata', []);                                       %
      drawnow;                                                  % Force MatLab a mettre a jour fenetre
   	
   end;
   end;
	% fin de action == 'recup'




% ---------------------------------------------------------------
% Effet d'un lever de stylo. Bouton relache
% Detection d'un contact "Haut"
% ---------------------------------------------------------------
elseif strcmp(action, 'NewStroke')  == 1,                       
    flagdessin = 1;	
    NoStroke = NoStroke + 1;
    
%    tabflag = [tabflag 1];			% Detection d'un discontinuite
	 tabflag(length(tabflag)) = 0;		
	 Xs = [];                     % Abscisses new stroke
    Ys = [];                     % Ordonnees new stroke
    % fin de action == 'NewStroke'

% ---------------------------------------------------------------
% Dessin Appui du bouton
% Detection d'un Contact "Bas"
% ---------------------------------------------------------------
elseif strcmp(action, 'Dessin')  == 1,                       
   flagdessin = 0; % Autorisation de dessinner
   levee = 0;
   
% ---------------------------------------------------------------
% Correction d'un tracé
% ---------------------------------------------------------------
elseif strcmp(action, 'Validation')  == 1,                       
   % Demande de validation d'un trace 
%   flagv = validation;
%   if flagv == 0, [X,Y,tabflag] = mouseBase('depart',' Correction ');
%   else
   	mouseBase('quit',' Fin ');   
%  end; 
% ---------------------------------------------------------------
% EXIT
% ---------------------------------------------------------------
elseif strcmp(action,  'quit')  == 1,
   		% Elimination des derniers points ( effet levee)
         Xred = X(1:length(X) - 3);
         Yred = Y(1:length(Y) - 3);
			tabflagred = tabflag(1:length(tabflag) - 3);
			tabflagred(length(tabflag)-3) = 0;
	   
   % Dessine chaque stroke separement
   line('color', 'b', ...
        'linestyle', 'o', ...
        'erase', 'none', ...
        'xdata', X, ...
        'ydata', Y, ...
        'zdata', []);


    % Dessine chaque stroke separement
    for i = 1: NoStroke,
        idxstrk = find(S == i);
        line('color', 'k', ...
             'linestyle', '-', ...
             'erase', 'none', ...
             'xdata', X(idxstrk), ...
             'ydata', Y(idxstrk), ...
             'zdata', []);
    end;



    % Retour aux parametres d'origines de figure
    set(Fig, 'windowbuttondownfcn', OldButtonDown,...
             'windowbuttonupfcn', OldButtonUp, ...
             'windowbuttonmotionfcn', OldButtonMotion,...
             'pointer', OldPointer);

    % Effacement du bouton
    %set(hbouton,'visible', 'off',  'Callback', '');

   % Signaler a tout le monde que c'est FINI
    %pause off;
    EnCours = 0;                                    % Variable GLOBAL
    close
    
    % fin de action == 'quit'

end; % GENERAL

