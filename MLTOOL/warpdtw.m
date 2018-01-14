% WARPTW
%
% SYNTAXE :
%
%   WARPDTW
%
% Algorithme DTW (Dynamic Time Warping) pour la reconnaissance
% de la parole. (utilise 'warpdtw.m')
%
%
%
% VOIR AUSSI :
%
%   DTW
%
%
% COMPATIBILITE :
%
%  Matlab 5+
%

% Création :
%------------------------------------------------------------------------- 
%DTW warp_section
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
% Version : 1.0
% Derniere révision :
%  - Stagiaires IST 2000 : import dans tbx RdF  



%update_sums:
intermediate_sum_buffer(1,1)=very_big;
intermediate_sum_buffer(1,2)=3;
intermediate_sum_buffer(2,1)=very_big;
intermediate_sum_buffer(2,2)=3;

y_offset=y_min-old_y_min;
if (y_offset>1)    offset=0;  end;
if (y_offset==1)   offset=1;  end;
if (y_offset<1)    offset=2;  end;
for i=1:y_range
   intermediate_sum_buffer(offset+i,:)=vector_distance_buffer(i,:);
end;

intermediate_sum_buffer(offset+i+1,:)=[very_big,3];
intermediate_sum_buffer(offset+i+2,:)=[very_big,3];

%calc_y_range:
y_range=y_max-y_min+1;

%build_vd_buff:
for i=1:y_range
   vector_distance_buffer(i,1)=norm(template(y_min+i,:)-unknown(x_vector_pntr,:));
end;

%compute_warp:
for i=1:y_range   
   Top = intermediate_sum_buffer(i,1);         %D(x-1,y-2)   
   Mid = intermediate_sum_buffer(i+1,1);       %D(x-1,y-1)   
   if ( intermediate_sum_buffer(i+2,2)~=0 )      
      Bot = intermediate_sum_buffer(i+2,1);    %D(x-1,y)      
   else      
      Bot = very_big;      
   end;
   
   %s=min( D(x-1,y-2),D(x-1,y-1),D(x-1,y) );   
   if ((Top < Mid) & (Top < Bot))      
      warp_value=2;      
      s = Top;      
   elseif (Mid < Bot)      
      warp_value=1;      
      s = Mid;      
   else      
      warp_value=0;      
      s = Bot;      
   end
   
   %compute sum of d(x,y) and mininum(D(x-1,y),D(x-1,y-1),D(x-1,y-2));   
   s=s+vector_distance_buffer(i,1);  
   vector_distance_buffer(i,1)=s;   
   vector_distance_buffer(i,2)=warp_value;   
end;  %end of for

x_vector_pntr=2+x;
x_coordinate=x_coordinate+1;
