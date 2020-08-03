clear;clc;
N = 441;    %总人数
E = 0;      %初始潜伏者人数
I = 1;      %初始确诊人数
S = N - I;  %初始易感者（正常群众）
R = 0;      %初始康复者人数

r = 5;      %确诊者每天接触群众人数
B = 0.09;   %确诊者对易感人群的感染率
a = 0.14;   %潜伏者变为感染者的概率
r2 = 9;     %潜伏者每天接触群众人数
B2 = 0.055; %潜伏者对易感人群的感染率
y = 0.07;   %确诊者的康复率

%建立基础的SEIR模型，编写每类人的微分方程（变式），方程模型可参考https://zhuanlan.zhihu.com/p/104268573?utm_source=wechat_session
T = 1:140;
for idx = 1:length(T)-1
    S(idx+1) = S(idx) - r*B*S(idx)*I(idx)/N(1) - r2*B2*S(idx)*E(idx)/N;
    E(idx+1) = E(idx) + r*B*S(idx)*I(idx)/N(1) - a*E(idx) + r2*B2*S(idx)*E(idx)/N(1);
    I(idx+1) = I(idx) + a*E(idx) - y*I(idx);
    R(idx+1) = R(idx) + y*I(idx);
end 

plot(T,S,T,E,T,I,T,R);grid on;
xlabel('天');ylabel('人数');
legend('易感者','潜伏者','传染者','康复者');title('SEIR模型');