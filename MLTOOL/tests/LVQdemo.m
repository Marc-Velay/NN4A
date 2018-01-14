% script sur LVQ
% ---> appelle kppv1.m
% Centre1=[4,4]';
% Centre2=[2,2]';
% Tirage aléatoire uniforme 
% Le paramètre Disp règle l'enchevêtrement des data
% Interactif=0 ==> tous les pts testés

disp('LVQ 2 classes et K sous-classes')
NbEx=input('Nb Exemples par classe=  ');%7;
K=input('Nb de sous-classes par classe= '); 
Disp=input('Dispersion autour des centres des sous-classes (1=max, 0=Min)   ');
NC=input(' Nb de centres en tout:  ');
NbIter=input('nb d iterations  ');
A=10; %ds modif centres

Centre1=rand(2,K);%%vrais centres des sous classes pour la classe 1
for i=1:K, %les centres de la classe 2 ne doivent pas etre trop pres de ceux de la classe 1
   encore=1;
   while encore,
   essai=rand(2,1);
   flag=0;
   for j=1:K,
      dist_essai=norm(Centre1(:,j)-essai);
      if dist_essai<1.5*Disp, flag=1; end
   end
   if flag==0, Centre2(:,i)=essai; end
   encore=flag;
	end %while
end %for i
   



Data1=zeros(2,NbEx);
Data2=zeros(2,NbEx);
Data=zeros(2,2*NbEx);


% génération des données
% on choisit aléatoirement une sous classe + bruit centré d'amplitude disp
for i=1:NbEx
Data1(:,i)=Centre1(:,ceil(K*rand))+(2*rand(2,1)-1)*Disp;
Data2(:,i)=Centre2(:,ceil(K*rand))+(2*rand(2,1)-1)*Disp;
end
Data=[Data1,Data2];
VraiLabel=((1:2*NbEx)>NbEx);
pause
% initialisation des centres    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Centre=zeros(2,NC);
Label=zeros(1,NC);
for n=1:NC,
   num=ceil(2*NbEx*rand);
   Centre(:,n)=Data(:,num);
   Label(n)=(num>NbEx); % label = 0 pour la classe 1 et 1 pour la classe 2
end
Ind1=(Label==0);
Ind2=(Label==1);

figure;plot(Data1(1,:),Data1(2,:),'r+',...
Data2(1,:),Data2(2,:),'gx',Centre(1,Ind1),Centre(2,Ind1),'bo',Centre(1,Ind2),Centre(2,Ind2),'yo');
pause;


% grande boucle de modification des centres
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for iter=1:NbIter,
   NbErr=0;
for i=1:2*NbEx,
   test=Data(:,i);
   %calcul distance
   dist=100*ones(1,NC);%%init dist
	for j=1:NC
	dist(j)=norm(Centre(:,j)-test);
	end
	%tri de dist
	[sdist,index]=sort(dist);
	%indices des k-ppv
	ikppv=index(1);
   
   %% modif du centre
   if Label(ikppv)==VraiLabel(i), 
      Coef=1/(A+NbIter);
   else
      Coef=-1/(A+NbIter);
      NbErr=NbErr+1;
   end
   %%modif du centre
   old_centre=Centre(:,ikppv);
   Centre(:,ikppv)=old_centre+Coef*(test-old_centre);
   
end %for i
disp(' taux d erreur=  ');NbErr/(2*NbEx)
figure;plot(Data1(1,:),Data1(2,:),'r+',...
Data2(1,:),Data2(2,:),'gx',Centre(1,Ind1),Centre(2,Ind1),'bo',Centre(1,Ind2),Centre(2,Ind2),'yo');
pause;

end %iter


