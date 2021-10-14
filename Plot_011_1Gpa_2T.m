clc;
clear all;
%% ��������
load('C:\Users\Fan Hua\OneDrive\001_MBG_transport\S20_tri and bi layer G\1Gpa\011_2GM_2T_212648.mat')

%% ����߱任
rate_RxxMax=3.5;     
rate_RxxMin=1;     %��ʾRxx��ߴ�10^rateRxxMin��10^rateRxxMax 

rate_RxxMax_2=2;     
rate_RxxMin_2=-2;     %��ʾRxx��ߴ�10^rateRxxMin��10^rateRxxMax 
ACcurrent=100   %��λnA


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
title ('S20 Rxx @T=1.6K  B=0T I=100nA_1Gpa')           %����
colorbar



subplot (1,2,2);
% subplot���Խ���ǰ��ͼ���ڻ���Ϊ���б�ŵľ��δ���
% ����ͼ���������ǰ���񡣱���subplot��m��n��p��
% m ������ n ������ p ��������ͼ�λ��ڵڼ��С��ڼ��С� 
% ���������subplot���ִ���Ȼ������plot��ͼ��     ������������ͼ�Ϳ�����ʾ��ͬһ������
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
title ('S20 Rxx2 @T=1.6K  B=0T I=100nA')           %����
colorbar
