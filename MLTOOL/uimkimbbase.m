function Base = uimkimbbase
%
% MKIMBBASE
%
% SYNTAXE :
%
% Base = UIMKIMBBASE
%
% Construit une base de donn�es labelis�e � partir
% des bases disponibles (base de lettres Kangourou,
% base de chiffres).
%
%
% ARGUMENTS :
%
% VALEURS DE RETOUR :
%
% Base : matrice des vecteurs images.
%        Les images sont rang�es en ligne. Le dernier
%        �l�ment de chaque ligne code le label. 
%        Pour g�n�rer une base avec ses vecteurs cibles,
%        utiliser BASE2TARGET ou BASE2LABEL.
%
%
% VOIR AUSSI :
%
%   MKIMBBASE  IMBGET  BASE2TARGET  BASE2LABEL
% 

% UIMKIMBBASE
% Bruno Gas - LIS/P&C UPMC <gas@ccr.jussieu.fr>
% Cr�ation : 8/02/2001
% Version : 1.2
% Derniere r�vision : 
%  - B. Gas (21/11/2001) : r��criture compl�te de la fonction 
%  - B. Gas (12/11/2002) : bug corrig� (lignes 54 et 55 invers�es)


msgbox(['Pour constituer une base, vous pouvez choisir autant de lettres diff�rentes que vous le souhaitez '...
        '(de la lettre "B" � la lettre "Z") et autant d''occurences par lettre.']);

Base = [];
i = 1;
titre = 'Choix : 25 lettres de B � Z';
termine = 0;
while termine==0
    if i==1
        [filename pathname] = uigetfile('*.imb','Choisissez une lettre (fichier <<.imb>>) ');
    else
        filename = uigetfile([pathname '\*.imb'], 'Choisissez une lettre (fichier <<.imb>>)');
    end
    if (filename==0), errordlg('Aucune base saisie !','Erreur dans uimkimbbase');  error;  end;

    Lettre(i) = filename(1);
    filename = [pathname filename];
  
    if Lettre(i) <'A' | Lettre(i) > 'Z'
        errordlg('Nom de fichier inconnu : probablement un fichier autre que <.imb>',...
            'Erreur dans uimkimbbase'); error; 
    end;
    Nbim = imbsize(filename);
    
    prompt={['Combien d''exemples pour cette classe (' num2str(Nbim) ' AU MAXIMUM) : '],...
      	'rang de la premi�re lettre' };
    default={'10', '1'};
    answer=inputdlg(prompt,titre,1,default);
    if isempty(answer)
        errordlg('Pas de r�ponse : Base vide en retour!','Erreur de dialogue dans uimkimbbase');        
    end;
    Nbr(i) = str2num(char(answer(1)));
    Rang(i) = str2num(char(answer(2)));

    if Rang(i)+Nbr(i)-1 > Nbim
        errordlg('Trop de lettres demand�es ou rang trop �lev�',...
            'Erreur dans uimkimbbase');         
    end;      
 
    choix=questdlg('Voulez vous extraire une nouvelle lettre ?', ...
                       'Extraction de lettres', ...
                       'Oui','Non','Oui');
    switch choix,
    case 'Oui', 
        i = i + 1;
    case 'Non',
        termine = 1;
        ClassNbr = i;
    end
end;

   
    
% Extraction de la base :
Base = [];
Labels = [];
 
for i=1:ClassNbr
   filename = [pathname Lettre(i) '.imb'];
   B = imbget(filename, i, Rang(i), Rang(i)+ Nbr(i)-1);
   Base = [Base; B];
end;



