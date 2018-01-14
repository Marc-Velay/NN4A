function imgview(ImData,Col,Fig,Map)
%
% IMGVIEW(IMDATA,COLOR,FIG,MAP) ==>  affichage rapide image IMDATA
%
% - creation nouvelle figure si FIG=0 ou par defaut, sinon en FIG existante
% - 16,32 ou 64 niveaux de gris si COLOR='GRIS' ou par defaut
% - pseudo-couleurs si COLOR='CONT' (codes contours) ou 'REG' (regions)
% - image indexee et couleurs specifiees par palette MAP si COLOR='PAL'

% Test des arguments  -  J.Devars (rev.15/02/96) utilise IMGCOLOR.M

if nargin == 1,      Fig=0;  Col='g';  % Parametres par defaut
elseif nargin == 2,  Fig=0;
end
if ~isstr(Col),      error('Pb de type palette'),  end
Col=lower(Col(1:1));
Cont=Col == 'c';  Reg=Col == 'r';  Gris=Col == 'g';  Pal=Col == 'p';
if ~(Gris|Cont|Reg|Pal),  error('Pb type palette'),     end
if Pal & (nargin ~= 4),   error('Pb palette absente'),  end
Max=max(ImData(:));       Min=min(ImData(:));
if Max-Min > 255,         error('Pb dynamique > 256'),  end

% Parametres affichage image brute de gris ou binaire : mise a l'echelle

if (Max == 1)|Gris,
  if (Max > 63)&(Max < 128),  ImData=fix(ImData*.5)+1;
  elseif Max > 127,           ImData=fix(ImData*.25)+1;
  else,                       ImData=ImData+1;  end
  Map=gray(64);
  if Max < 2,       Map=[0 0 0;1 1 1];  % image binaire
  elseif Max < 16,  Map=gray(16);       % image de faible dynamique
  elseif Max < 32,  Map=gray(32);  end  %    (16 ou 32 niveaux)
else

% Parametres d'affichage couleurs : contours, region, palette ?

  if Cont,
    if (Min==0)&(Max <= 8),       CodPi=4;
    elseif (Min==0)&(Max <= 12),  CodPi=6;
    elseif (Min==0)&(Max <= 24),  CodPi=12;
    else,                         error('Pb codage contours'),  end
    Map=imgcolor(CodPi);
    SupPi=find(ImData > CodPi);   ImData(SupPi)=ImData(SupPi)-CodPi;
    ImData=ImData+1;
  elseif Reg,         % Region: duplication de palette de base + indexation
    Map=imgcolor(0);
    Niv=16;
    while Max > Niv,  Map=[Map; Map];   Niv=Niv*2;         end
    if Min == 0,      ImData=ImData+1;  Map=[0 0 0; Map];  end
  elseif Pal,
    [Ncol,Rgb]=size(Map);
    if (Rgb ~= 3)|(Ncol < Max),  error('Pb format palette'),  end
  end
end
if Fig == 0,
  AllFigs=get(0,'Children');
  if length(AllFigs) == 0,  Fig=1;  else,  Fig=AllFigs(1)+1;  end
end
figure(Fig);  clf;  image(ImData);  colormap(Map);  drawnow;

