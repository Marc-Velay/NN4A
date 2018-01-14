% Toolbox RdF 3.1.10 (21/11/2004)
% LIS/PARC - UPMC
% ----------------------------
% Help RdF
%
% ----------- BUGS -------------
%
%  SPEECHGET 1.7 : plantage pour des valeurs de trames et entrelacement :
%                  ex : 129,128
%
%
% --------- MODIFS -------------
%
% Nouveaut�s / version 3.1.8 et 3.1.9
%
%  SPLITBASE        - correction
%  PROBMLPCLASS     - import specrdf-> rdf 
%  PROBMLP2DEF      - import specrdf-> rdf
%  PROBMLP2RUN      - import specrdf-> rdf
%  PROBMLP2ACRVTRAIN- import specrdf-> rdf
%  PROBMLP2TRAIN    - import specrdf-> rdf
%  SOFTMAX          - import specrdf-> rdf
%  SOFTMAXP         - import specrdf-> rdf
%  LVQIFRONT        - nouvelle fonction
%  MLP2ACRVTRAIN 1.3- correction
%
% Nouveaut�s / version 3.1.6 et 3.1.7 :
%
%  AUDIOGET         - modification 
%  ZEROSIG          - nouvelle fonction
%  VARSIG           - nouvelle fonction
%  SPLITBASE        - nouvelle fonction
%  SHOWBASE         - nouvelle fonction
%  SIGHAMMING       - nouvelle fonction
%  CODFFT           - nouvelle fonction
%  CODLPC           - modification
%
% Nouveaut�s / version 3.1.4 :
%
%  GENBASE          - nouvelle fonction
%  MLP2TRAIN        - modification
%  MLP2FRONT        - nouvell fonction
%  MLP1FRONT        - nouvelle fonction
%
% Liste des fonctions disponibles :
%
%  ACPN 1.2         - analyse en composantes principales norm�e
%  AD 1.4           - analyse discriminante
%  AUDIOGET 1.1     - acquisition en ligne de signaux audio (n�cessite la tbx data acquisition) 
%  BASE2TARGET 1.0  - Formatage d'une base pour la RdF : g�n�ration des vecteurs cible
%  BASE2LABEL 1.1   - Formatage d'une base pour la RdF : extraction des labels
%  BASENORM 1.4     - normalisation des exemples d'une base RdF
%  BASESIZE 1.1     - Dimension d'une base RdF d'exemples 
%  BASEUNIT 1.1     - norme les exemples d'une base RdF qui deviennent vecteurs unitaires
%  BELDIST 1.5      - Distance de Bellman : algorithme de comparaison dynamique
%  CHARBASEDRAW 1.4 - Construction d'une base de formes (RdF caract�res dynamiques - online)
%  CHIFGET 1.4      - Extraction d'une base RdF de chiffres � partir du fichier 'basechif'
%  CODFFT 1.0       - codage FFT (Fast Fourier Transform) d'une trame de parole
%  CODFREEMAN 1.2   - codage de Fremann d'une base RdF de caract�res dynamiques
%  CODLPC 1.3       - codage LPC (Linear Predictive Coding) d'une base de trames de parole 
%  CODLPCC 1.5      - codage LPCC (Linear Predictiv Cepstrum Coding) d'une base de trames de parole 
%  CODMFCC 1.4      - codage MFCC (Mel Frequency Cepstrum Coding) d'une trame de parole
%  CODPLP 1.0       - codage PLP (Perceptual Linear Predictiv coding) d'une base de trames de parole
%  CODPROJ 1.0      - codage d'images binaires par projection vectorielle
%  CODRET 1.0       - codage r�tinien d'images binaires
%  COMP_CODEUR 1.0  - comparaison par analyse discriminante des codages LPC et MFCC sur des signaux de parole
%  CONFUSION 1.1    - Calcul de la matrice de confusion pour une classification donn�e
%  DISTEDIT 1.2     - Distance d'�dition (algorithme de Wagner et Fisher)
%  DISTEDITNUM 1.2  - Distance d'�dition avec attributs num�riques
%  DTW 1.3          - Algorithme DTW (algo. de comparaison dynamique de deux cha�nes vectorielles)
%  GCADRE 1.2       - Recadrage d'une image binaire sur son centre de gravit�
%  GENBASE 1.1      - G�n�ration automatique d'une base de prototypes 2D (distribution multi-gaussiennes)
%  GENSIG 1.1       - g�n�ration d'une base de signaux 1D
%  IMBGET 1.5       - Extraction d'une classe d'images � partir de fichiers images Kangourou (.imb)
%  IMBSIZE 1.1      - Nombre d'images dans un fichier Kangourou .imb 
%  IMGVIEW          - affichage rapide d'une image (appartient � la toolbox Image)
%  IS_MATRIX 1.1    - bool�en, pour compatibilit� avec octave
%  IS_OCTAVE 1.0    - retourne 1 si octave, 0 sinon
%  IS_SCALAR 1.1    - bool�en, pour compatibilit� avec octave
%  IS_VECTOR 1.1    - bool�en, pour compatibilit� avec octave
%  KHNCLASS 1.1     - Classification des donn�es issues d'une carte de Kohonen 1D ou 2D
%  KHN1DEF 1.1      - d�finition d'une carte de Kohonen 1D
%  KHN1RUN 1.2      - utilisation d'une carte de Kohonen 1D 
%  KHN1TRAIN 1.1    - apprentissage d'une carte de Kohonen 1D
%  KHN2DEF 1.1      - d�finition d'une carte de Kohonen 2D 
%  KHN2RUN 1.1      - utilisation d'une carte de Kohonen 2D 
%  KHN2TRAIN 1.1    - apprentissage d'une carte de Kohonen 2D
%  KPPV 1.5         - Classification par la m�thode des kppv
%  LABEL2TARGET 1.2 - Transformation de labels scalaires en vecteurs cibles pour classifieur 
%  LIDARGET 1.1     - Extraction de signaux Lidar
%  LPCFILTER 1.0    - Filtre LPC
%  LVQIDEF 1.3      - d�finition de la structure d'un r�seau LVQ de type I
%  LVQIFRONT 1.0    - visualisation des fronti�res de d�cision pour des probl�mes 2D
%  LVQITRAIN 1.4    - apprentissage d'un LVQ de type I
%  LVQIRUN 1.3      - utilisation d'un r�seau LVQ de type I
%  MAHALANOBIS    (en cours) - distance de Mahalanobis 
%  MAKEYGLASS 1.0   - g�n�ration de signaux process. non lin�aire : s�rie de Mackey-Glass
%  MAT2VEC 1.0      - transformation d'une matrice en vecteur
%  MKIMBBASE 1.2    - Extraction d'une base RdF � partir de fichiers images Kangourou (.imb)
%  MLP1DEF 1.1      - d�finition de la structure d'un r�seau neuronal MLP � une couche
%  MLP1FRONT 1.0    - Trac� des fronti�res de d�cision sur des probl�mes 2D 
%  MLP1RUN 1.1      - utilisation d'un r�seau MLP � 1 couche
%  MLP1TRAIN 1.3    - apprentissage d'un r�seau MLP 1 couche
%  MLP1ATRAIN 1.2   - apprentissage avec pas adaptatif d'un r�seau MLP 1 couche
%  MLP2DEF 1.1      - d�finition de la structure d'un r�seau neuronal MLP � deux couches
%  MLP2FRONT 1.0    - Trac� des fronti�res de d�cision sur des probl�mes 2D 
%  MLP2TRAIN 1.5    - apprentissage d'un r�seau MLP 2 couches
%  MLP2ATRAIN 1.6   - apprentissage avec pas adaptatif d'un r�seau MLP 2 couches
%  MLP2ACRVTRAIN 1.3- apprentissage avec pas adaptatif et cross-validation d'un MLP 2 couches
%  MLP2FIT 1.0      - regression par r�seau MLP 2 couches
%  MLP2MTRAIN 1.0 (en cours) - apprentissage avec momentum d'un r�seau MLP 2 couches
%  MLP2RUN 1.1      - utilisation d'un r�seau MLP � 2 couches
%  MLPCLASS 1.1     - classification des donn�es issues d'un r�seau MLP
%  PROBMLPCLASS 1.1 - classification des donn�es issues d'un r�seau MLP � sorties probabilit�s
%  PROBMLP2DEF 1.0  - d�finition d'un r�seau MLP 2 couches � sorties probablit�s � post�riori
%  PROBMLP2RUN 1.0  - utilisation d'un r�seau MLP 2 couches � sorties probabilit�s
%  PROBMLP2ACRVTRAIN 1.3- apprentissage adaptatif avec cross-validation d'un r�seau MLP 2 � sorties probabilit�s  
%  PROBMLP2TRAIN 1.0- apprentissage d'un r�seau MLP 2 � sorties probabilit�s
%  RANDWEIGHTS 1.2  - g�n�ration al�atoire d'une couche de poids (r�seaux MLP)
%  RDF              - Liste des fonctions RdF	
%  REDUC 1.4        - R�duction de la taille d'une image
%  REVERB 1.1       - Filtre r�verb�ration pour signal audio mono ou st�r�o
%  ROWS 1.1         - nombre de lignes d'une matrice (pour compatibilit� avec octave) 
%  SCANMOUSE 1.2    - saisie d'une liste de points trac�s avec la souris
%  SCORE 1.3        - calcul du taux de reconnaissance et de rejet sur une classification
%  SHOWBASE 1.0     - Affiche des bases de formes 2D
%  SIGMO 1.2        - fonction sigmo�de
%  SIGMOP 1.2       - fonction sigmo�de d�riv�e
%  SIGMOS 1.0       - fonction sigmoide d�riv�e seconde
%  SIGNORM 1.1      - normalisation d'un signal
%  SIGPREACC 1.2    - pr�accentuation d'un signal (rehaussement des hautes fr�quences)
%  SIGHAMMING 1.0   - fen�trage de Hamming d'un signal ou d'une matrice de signaux
%  SPATIAL 1.0      - spatialisation st�r�o 2D d'un son mono
%  SPEECHDETECT 1.0 - Detection signal de parole / bruit � partir d'un fichier parole
%  SPEECHGET 1.7    - Extraction d'une base de trames parole � partir d'un fichier parole
%  SPEECHGET2 1.0   - Extraction d'une base de mots � partir d'un fichier parole
%  SPLITBASE 1.1    - D�compose une base en 2 bases (test et apprentissage) 
%  SUMSQR 1.0       - Somme des composantes au carr� d'un vecteur ou d'une matrice de vecteurs
%  TARGET2LABEL 1.2 - Transformation de vecteurs cibles pour classifieurs en labels scalaires 
%  TAB2VEC 1.3      - construit un trac� on line isometrique dense de N points
%  TIMIT2BASE 1.1   - Conversion Base Timit - Base compatible � la ToolBox 
%  UICHARBASEDRAW 1.0 - GUI de la fonction charbasedraw
%  UICHIFGET 1.0    - GUI de la fonction chifget
%  UIIMBGET 1.0     - GUI de la fonction imbget
%  UIKHN1TRAIN      - GUI de la fonction khn1train
%  UIKHN2TRAIN      - GUI de la fonction khn2train
%  UIMKIMBBASE 1.2  - GUI de la fonction mkimbbase
%  UIMLP1DEF 1.0    - GUI de la fonction mlp1def
%  UIMLP1ATRAIN 1.0 - GUI de la fonction mlp1atrain
%  UIMLP2DEF 1.0    - GUI de la fonction mlp2def
%  UIMLP2ATRAIN 1.0 (� faire)
%  UISPEECHDETECT 1.0 GUI de la fonction speechdetect
%  UISPEECHGET 1.0  - GUI de la fonction speechget
%  UITIMIT2BASE 1.3 - construction d'une base de phon�mes TIMIT 
%  VARSIG 1.0       - Estimation de la variance et de son �volution sur un signal
%  VISUSTROKE       - trac� de points 
%  WARPDTW 1.0      - estimation des distances cumul�es. Utilis� par DTW.
%  ZEROSIG 1.0      - estimation du nombre moyen de passages par z�ro et de son �volution sur un signal
%  
%
%
