clear;clc;
N = 441;    %������
E = 0;      %��ʼǱ��������
I = 1;      %��ʼȷ������
S = N - I;  %��ʼ�׸��ߣ�����Ⱥ�ڣ�
R = 0;      %��ʼ����������

r = 5;      %ȷ����ÿ��Ӵ�Ⱥ������
B = 0.09;   %ȷ���߶��׸���Ⱥ�ĸ�Ⱦ��
a = 0.14;   %Ǳ���߱�Ϊ��Ⱦ�ߵĸ���
r2 = 9;     %Ǳ����ÿ��Ӵ�Ⱥ������
B2 = 0.055; %Ǳ���߶��׸���Ⱥ�ĸ�Ⱦ��
y = 0.07;   %ȷ���ߵĿ�����

%����������SEIRģ�ͣ���дÿ���˵�΢�ַ��̣���ʽ��������ģ�Ϳɲο�https://zhuanlan.zhihu.com/p/104268573?utm_source=wechat_session
T = 1:140;
for idx = 1:length(T)-1
    S(idx+1) = S(idx) - r*B*S(idx)*I(idx)/N(1) - r2*B2*S(idx)*E(idx)/N;
    E(idx+1) = E(idx) + r*B*S(idx)*I(idx)/N(1) - a*E(idx) + r2*B2*S(idx)*E(idx)/N(1);
    I(idx+1) = I(idx) + a*E(idx) - y*I(idx);
    R(idx+1) = R(idx) + y*I(idx);
end 

plot(T,S,T,E,T,I,T,R);grid on;
xlabel('��');ylabel('����');
legend('�׸���','Ǳ����','��Ⱦ��','������');title('SEIRģ��');