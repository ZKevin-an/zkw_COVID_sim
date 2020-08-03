close;
clear;
clc;

% ���ƾ������ɫ
Map = [1 1 1; 0 0 0];
colormap(Map);

%���Ƹ��ʺͽӴ�����
gap = 0.5;   %��Ⱦ����
test = 2;    %�Ӵ�����

% ���������С
S = 21;        %�����������
L = zeros(S);  %��������

% ���м�һ��������Ϊ1��ΪԪ������
M = (S+1)/2;   %�ҵ��м�λ��
L(M,M) = 1;    %�������ĵ�Ϊ��ɫ
Temp = L;      %���ƾ���
imagesc(L);    %��ͼ

%���������x+y�ľ���
length_max = 2*M;

%��ʼ����Ԫ���Զ�����̬��ʾ����
for length = 1 : length_max    %�����ɴ�С����
    for x = -length : length   %�þ����ÿһ���㶼ɨ��һ��
        y = length - abs(x);
        if M+abs(x)<=S && M+abs(y)<=S  %��֤����δ����
            if(rand>gap)       %�������ﵽ������Ϊ1
                Temp(M+x,M+y) = 1;
            end
            if(rand>gap)       %�ж϶ԳƵ��Ƿ���������
                Temp(M+x,M-y) = 1;
            end
        end
        for z = 1:test          %���ɨ�裬����Ԫ����ɢ�ĸ��ʣ�ʹ��ģ�͸��Ӻ���
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
    for z = 1:100       %��δ��Ⱦ�ĵ����ɨ�裬��ȫ
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