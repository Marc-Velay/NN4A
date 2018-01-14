% codprojtest

clear all;

BaseApp = uiimbget;
[ExNbrApp, ExSizeApp, ClassNbrApp] = basesize(BaseApp);
[BaseApp, TargetApp] = base2target(BaseApp);

CodeApp = codproj(BaseApp,60,60,'horz');
figure(1);
imgview(reshape(BaseApp(:,1),60,60));
figure(2);
bar(CodeApp,'r');
 return;
