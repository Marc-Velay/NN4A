function score=dtw(unknown,template);
%
% SYNTAXE :
%
% score = DTW(A, B);
%
% Algorithme DTW (Dynamic Time Warping) pour la reconnaissance
% de la parole. (utilise 'warpdtw.m')
%
%
% ARGUMENTS :
%
% A, B : Les deux séquences vectorielles à comparer.
%        exemple :
%
%        A = [a1 a2 a3 ... an  :   symbole 1 (vecteur de dimension n)
%             b1 b2 b3 ... bn  :   symbole 2            "
%                  ...               ... 
%            ]
%					
%
% VALEURS DE RETOUR :
%
% score : dissemblance estimée par DTW entre A et B
%
%
% VOIR AUSSI :
%
%   DISTEDIT,  BELDIST
%
%
% COMPATIBILITE :
%
%  Matlab 5+
%

%-------------------------------------------------------------------------
%This program is ported from ADSP21xx assemble file of Analog Devices Inc.
%Ported by  :     Wang Xiaodong
%Modified by:     He Qiang
%Orgnization:     Department of Electronic Engineering
%                 Beijing University of Aeronautics and Astronautics
%                 P.R.China
%Email      :     qhe@technologist.com
%-------------------------------------------------------------------------
%
% Récupération : ? IST 2000
% Version : 1.3
% Derniere révision :
%  - B. Gas (2/11/2000) portage dans toolbox RdF
%  - B. Gas (27/1/2001) mise à jour tbx RdF
%  - B. Gas (31/3/2001) mise en commentaire du warning 'cannot warp' L. 67

if nargin~=2, error('[DTW] usage: score = dtw(A, B)'); end;

very_big=1e9;
N=size(unknown,1)-1;                  %starts from 0
M=size(template,1)-1;

%vector_distance_buffer=zeros(60,2);    
%intermediate_sum_buffer=zeros(64,2);    
% These two arries needed no initialization in MATLAB
% To port into C, array size must be specified

%warp_words:
if ( (2*M-N<3)|(2*N-M<2) )   
   score=very_big;               %cannot warp;
   score = min(N+1,M+1);
   %warning('[DTW] : cannot warp');
else
   Xa=fix((2*M-N)/3);
   Xb=fix((2*N-M)*2/3);
   y_min=0;                             %set the original value;
   y_range=1;
   x_coordinate=1;
   vector_distance_buffer(1,1)=norm(template(1,:)-unknown(1,:));
   vector_distance_buffer(1,2)=3;       %warp value;
   x_vector_pntr=2;   
%Xb_gt_Xa:
   if (Xb>Xa)   
                %warping section:
                %        0:Xa;
                %        Xa+1:Xb
                %        Xb+1:N
      for x=1:Xa
          old_y_min=y_min;
          y_max=2*x_coordinate;
          y_min=fix(0.5*x_coordinate);
          warpdtw;
      end;   
      for x=(Xa+1):Xb
          old_y_min=y_min;
          y_max=fix(0.5*(x_coordinate-N)+M);
          y_min=fix(0.5*x_coordinate);
          warpdtw;
      end;
      for x=(Xb+1):N
          old_y_min=y_min;
          y_max=fix(0.5*(x_coordinate-N)+M);
          y_min=fix(2*(x_coordinate-N)+M);
          warpdtw;
      end;
   end;  
%Xa_gt_Xb:
   if (Xa>Xb)   
                %warping section:
                %        0:Xb;
                %        Xb+1:Xa
                %        Xa+1:N
      for x=1:Xb
          old_y_min=y_min;
          y_max=2*x_coordinate;
          y_min=fix(0.5*x_coordinate);
          warpdtw;
      end;   
      for x=(Xb+1):Xa
          old_y_min=y_min;
          y_max=2*x_coordinate;
          y_min=fix(2*(x_coordinate-N)+M);
          warpdtw;
      end;
      for x=(Xa+1):N
          old_y_min=y_min;
          y_max=fix(0.5*(x_coordinate-N)+M);
          y_min=fix(2*(x_coordinate-N)+M);
          warpdtw;
      end;
   end;  
%Xa_eq_Xb:
   if (Xa==Xb)
      for x=1:Xa
          old_y_min=y_min;
          y_max=2*x_coordinate;
          y_min=fix(0.5*x_coordinate);
          warpdtw;
      end;
      for x=(Xa+1):N
          old_y_min=y_min;
          y_max=fix(0.5*(x_coordinate-N)+M);
          y_min=fix(2*(x_coordinate-N)+M);
          warpdtw;
      end;
   end;

score=vector_distance_buffer(1,1);
score=score/min(N+1,M+1);

end
