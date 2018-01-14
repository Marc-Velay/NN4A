%% relaxation point matching
%%
%% X,Y=listes de pts 2d (vect lignes)
%% recherche le matching F:X-->Y qui maximise somme Compa(x,F(x),x',F(x'))
%%
ouinon=input('voulez vous entrer X et Y ? (O/1)');
angulaire=input(' taper 1 si compa par cosinus sinon métrique   ');
if ouinon==1,
   figure;axis;[X1,X2]=ginput;
   X1=X1-mean(X1);
   X2=X2-mean(X2);
   X=[X1,X2]';
   figure;axis;[X1,X2]=ginput;
   X1=X1-mean(X1);
   X2=X2-mean(X2);
   Y=[X1,X2]';

end

rec=[];recSQ=[];recH=[];
NbIter=input('nb iterations');
[bidon,Nx]=size(X);
[bidon,Ny]=size(Y);
figure;plot(X(1,:),X(2,:),'r+',Y(1,:),Y(2,:),'go')
pause
disp('debut calcul compa')
NxNy=Nx*Ny;
for x=1:Nx,
   for y=1:Ny,
      for x1=1:Nx,
         for y1=1:Ny,
            %%[x,y,x1,y1]
            DX=X(:,x)-X(:,x1);
            DY=Y(:,y)-Y(:,y1);
            nDX=norm(DX);
            nDY=norm(DY);
            %% compatibilité angulaire
            if angulaire==1,
               compa(x,y,x1,y1)=(DX'*DY)/((nDX+eps)*(nDY+eps))/(NxNy);
            else
               compa(x,y,x1,y1)=abs(nDX-nDY)/(max(nDX+eps,nDY+eps)*NxNy);
            end
            
                        
         end
      end
   end
end
disp('fin')
%%% init %%%
P=zeros(Nx,Ny);
for x=1:Nx,
   for y=1:Ny,
      P(x,y)=1/Ny;
   end
end

%%% iterations %%%
for iter=1:NbIter,
   iter
   SQ=0;
   for x=1:Nx,
      for y=1:Ny,
         Q(x,y)=0;
      for x1=1:Nx,
         for y1=1:Ny,
            %%il faut que Q > -1
            Q(x,y)=Q(x,y)+compa(x,y,x1,y1)*P(x1,y1);
         end
      end
      SQ=SQ+Q(x,y)*P(x,y);
      end
	end %for x=
recSQ=[recSQ,SQ];
	for x=1:Nx,
   S=0;
      for y=1:Ny,
         P1(x,y)=(1+Q(x,y))^4*P(x,y);
         S=S+P1(x,y);
      end
      P1(x,:)=P1(x,:)/S;
   end
   
   P=P1;
   
   %%calcul de l'entropie de P
   H=0;
   for x=1:Nx,for y=1:Ny, H=H-P(x,y)*log(P(x,y)); end; end; 
   H=H/(Nx*log(2));
   recH=[recH,H];
   
   rec=[rec,P(1,1)];
   

end %iter