
% mkrepimpulse

clear all;

[fid err_msg] = fopen('repimpulse.txt','rt');
if (fid==0)
    disp(err_msg);
end;

NbLig = str2num(fscanf(fid,'%s',1));
NbCol = str2num(fscanf(fid,'%s',1));
XOrig = str2num(fscanf(fid,'%s',1));
YOrig = str2num(fscanf(fid,'%s',1));

data = zeros(NbLig, NbCol);
for (i=1:NbLig)
    for (j=1:NbCol)
        data(i,j) = str2num(fscanf(fid,'%s',1));
    end;
end;
fclose(fid);

x = floor(data(:,1)*100 - XOrig*100 + 1);
RepImpulseNbCol = max(x);
RepImpulse = zeros(1,RepImpulseNbCol);
RepImpulse(x) = YOrig - data(:,2);
RepImpulse = RepImpulse/max(RepImpulse);

plot(RepImpulse);
save repimpulse RepImpulse


