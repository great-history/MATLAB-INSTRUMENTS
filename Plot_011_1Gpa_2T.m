clc;
clear all;
%% 载入数据
load('C:\Users\Fan Hua\OneDrive\001_MBG_transport\S20_tri and bi layer G\1Gpa\011_2GM_2T_212648.mat')

%% 坐标尺变换
rate_RxxMax=3.5;     
rate_RxxMin=1;     %表示Rxx标尺从10^rateRxxMin至10^rateRxxMax 

rate_RxxMax_2=2;     
rate_RxxMin_2=-2;     %表示Rxx标尺从10^rateRxxMin至10^rateRxxMax 
ACcurrent=100   %单位nA


%% Plot
rate1=1000;
rate0=64;  
ACCurrent1=ACcurrent/1000000000;


Rxx1=lockin_1x/ACCurrent1;
Rxx2=lockin_2x/ACCurrent1;
logRxx=log10(abs(Rxx1)).*sign(Rxx1);
logRxx2=log10(abs(Rxx2)).*sign(Rxx2);



subplot (1,2,1);
Rxx=(logRxx-rate_RxxMin)*rate0/(rate_RxxMax-rate_RxxMin);
image(loop2,loop1,Rxx);
box on
shading interp 
colormap jet
set(gca,'FontSize',16,'Fontname','Georgia');
set(gca, 'XMinorTick', 'on');
set(gca, 'YMinorTick', 'on');
set(gca, 'XGrid', 'on');
set(gca, 'YGrid', 'on');
xlabel('Back Gate $[V]$','interpret','latex','FontSize',16);
ylabel('Top Gate $[V]$','interpret','latex','FontSize',16);
zlabel('Resistance $[\Omega]$','interpret','latex','FontSize',16);
%title('Device 16, Temperature = $20mK$, [-40V 40V]','interpret','latex','FontSize',16)
view (0,90);
title ('S20 Rxx @T=1.6K  B=0T I=100nA_1Gpa')           %标题
colorbar



subplot (1,2,2);
% subplot可以将当前绘图窗口划分为按行编号的矩形窗格。
% 随后的图被输出到当前窗格。比如subplot（m，n，p）
% m 代表行 n 代表列 p 代表的这个图形画在第几行、第几列。 
% 你可以先用subplot划分窗格，然后再用plot画图，     这样画出来的图就可以显示在同一窗口了
subplot (1,2,2);
Rxx_2=(logRxx2-rate_RxxMin_2)*rate0/(rate_RxxMax_2-rate_RxxMin_2);
image(loop2,loop1,Rxx_2);
box on
shading interp 
colormap jet
set(gca,'FontSize',16,'Fontname','Georgia');
set(gca, 'XMinorTick', 'on');
set(gca, 'YMinorTick', 'on');
set(gca, 'XGrid', 'on');
set(gca, 'YGrid', 'on');
xlabel('Back Gate $[V]$','interpret','latex','FontSize',16);
ylabel('Top Gate $[V]$','interpret','latex','FontSize',16);
zlabel('Resistance $[\Omega]$','interpret','latex','FontSize',16);
%title('Device 16, Temperature = $20mK$, [-40V 40V]','interpret','latex','FontSize',16)
view (0,90);
title ('S20 Rxx2 @T=1.6K  B=0T I=100nA')           %标题
colorbar
