close;
clear;
clc;

% 控制矩阵的颜色
Map = [1 1 1; 0 0 0];
colormap(Map);

%控制概率和接触次数
gap = 0.5;   %感染概率
test = 2;    %接触次数

% 设置网格大小
S = 21;        %网格的行列数
L = zeros(S);  %构建矩阵

% 把中间一个数设置为1作为元胞种子
M = (S+1)/2;   %找到中间位置
L(M,M) = 1;    %设置中心点为黑色
Temp = L;      %复制矩阵
imagesc(L);    %画图

%计算坐标点x+y的距离
length_max = 2*M;

%开始进行元胞自动机动态显示程序
for length = 1 : length_max    %距离由大到小依次
    for x = -length : length   %该距离的每一个点都扫描一次
        y = length - abs(x);
        if M+abs(x)<=S && M+abs(y)<=S  %保证坐标未出线
            if(rand>gap)       %当条件达到，被置为1
                Temp(M+x,M+y) = 1;
            end
            if(rand>gap)       %判断对称点是否满足条件
                Temp(M+x,M-y) = 1;
            end
        end
        for z = 1:test          %随机扫描，增加元胞扩散的概率，使得模型更加合理
            x_1 = fix(rand*length*2-length); y_1 = fix(rand*length*2-length);
            if(M+abs(x_1)<=S && M+abs(y_1)<=S && abs(x_1)+abs(y_1)<length)
                if(rand > gap && Temp(M+x_1,M+y_1) == 0 )
                    Temp(M+x_1,M+y_1) = 1;
                end
            end
        end
    end
    pause(0.5);
    imagesc(Temp);
end
while 1
    for z = 1:100       %将未感染的点随机扫描，补全
        x = fix(rand*S+1);y=fix(rand*S+1);
        if(x >0 && y>0 && Temp(x,y) == 0)
            if(rand > gap)
                Temp(x,y) = 1;
            end
        end
    end
    pause(0.1);
    imagesc(Temp);
end