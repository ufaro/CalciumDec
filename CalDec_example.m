
load('20140827_1_7_GAD_H2B_6d_spon_20140827_121957_cell_64934.mat')
%load('20140827_1_7_GAD_H2B_6d_spon_20140827_121957_cell_65341.mat')


Fluo = resp;
fpsec = 1.81;
rise =.25;                
decay= .8/log(2);
typ = 'block';   %'spike'



[Denoised,Deconvolved] = CalDeconv(Fluo,fpsec,rise,decay,typ);



figure(1)

AX = axes;  
plot(resp,'color',[0 0.45 0.74],'linewidth',1); 


TR=1/fpsec;
AX.XTick(1)=[];
vv = AX.XTick*TR;
AX.XTickLabel = floor(vv/60);


hXLabel = xlabel('{Time\,(minutes)}','interpreter','latex'  );

legend('Deconvolved signal','Location','northoutside'); legend boxoff 





figure(2)

AX = axes;  
plot(Deconvolved,'color',[0 0.45 0.74],'linewidth',1); 


TR=1/fpsec;
AX.XTick(1)=[];
vv = AX.XTick*TR;
AX.XTickLabel = floor(vv/60);


hXLabel = xlabel('{Time\,(minutes)}','interpreter','latex'  );

legend('Deconvolved signal','Location','northoutside'); legend boxoff 



