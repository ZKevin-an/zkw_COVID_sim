clear;clc;
N = 1300000000;   %总人数
E = 600;          %潜伏期感染者
I = 400;          %确诊感染者
S = N - I;        %易感者
R = 2;            %治愈者

B_11 = 0.09;    %确诊者每天接触群众人数
B_21 = 0.055;   %确诊者对易感人群的感染率
B_12 = 0.015;   %潜伏者变为感染者的概率
B_22 = 0.022;   %潜伏者每天接触群众人数
r_11 = 5.29     %潜伏者对易感人群的感染率
r_21 = 8.11     %确诊者的康复率

%第一阶段，爆发初期：未实现全面隔离，感染概率较大，建立最基本的SEIR模型
T_1 = 1:14;
for idx = 1:length(T_1)-1
    S(idx+1) = S(idx) - B_11*r_11*I(idx) - B_21*r_21*E(idx);
    E(idx+1) = E(idx) + B_11*r_11*I(idx) + B_21*r_21*E(idx) - B_11*r_11*I(max(idx-7,1))*(idx-7>0) - B_21*r_21*E(max(idx-7,1))*(idx-7>0);
    I(idx+1) = I(idx) + B_11*r_11*I(max(idx-7,1)) + B_21*r_21*E(max(idx-7,1)) - B_11*r_11*I(max(idx-21,1))*(idx-21>0) - B_21*r_21*E(max(idx-21,1))*(idx-21>0);
    R(idx+1) = R(idx) + B_11*r_11*I(max(idx-21,1))*(idx-21>0) + B_21*r_21*E(max(idx-21,1))*(idx-21>0);
end 

%第二阶段，快速爆发期：开始采取强制隔离措施，但是医疗物资不足，S与E表达式因时滞期而改变，接触人数也因为隔离开始变化
%T_2 = 15:21;
for idx = 14:20
    r_12 = (5.29-1.91)*exp(-0.96*idx-15)+1.91;
    r_22 = (8.11-1.88)*exp(-1.61*idx-15)+1.88;
    S(idx+1) = S(idx) - B_11*r_12*I(idx) - B_21*r_22*E(idx);
    E(idx+1) = E(idx) + B_11*r_12*I(idx) + B_21*r_22*E(idx) - B_11*r_11*I(idx-7) - B_21*r_21*E(idx-7);
    I(idx+1) = I(idx) + B_11*r_11*I(max(idx-7,1)) + B_21*r_21*E(max(idx-7,1)) - B_11*r_11*I(max(idx-21,1))*(idx-21>0) - B_21*r_21*E(max(idx-21,1))*(idx-21>0);
    R(idx+1) = R(idx) + B_11*r_11*I(max(idx-21,1))*(idx-21>0) + B_21*r_21*E(max(idx-21,1))*(idx-21>0);
end 

%第三阶段，紧急防御期：加大隔离力度，物资短缺情况好转，感染率下降，接触人数因为隔离力度加大使得接触人数再减少，S,E,I公式因时滞期改变
for idx = 21:27
    r_12 = (5.29-1.91)*exp(-0.96*idx-15)+1.91;
    r_22 = (8.11-1.88)*exp(-1.61*idx-15)+1.88;
    r_13 = (1.91-0.47)*exp(-1.86*idx-22)+0.47;
    r_23 = (1.88-0.96)*exp(-1.89*idx-22)+0.96;
    S(idx+1) = S(idx) - B_12*r_13*I(idx) - B_22*r_23*E(idx);
    E(idx+1) = E(idx) + B_12*r_13*I(idx) + B_22*r_23*E(idx) - B_11*r_12*I(idx-7) - B_21*r_22*E(idx-7);
    I(idx+1) = I(idx) + B_11*r_12*I(max(idx-7,1)) + B_21*r_22*E(max(idx-7,1)) - B_11*r_11*I(max(idx-21,1)) - B_21*r_21*E(max(idx-21,1));
    R(idx+1) = R(idx) + B_11*r_11*I(max(idx-21,1))*(idx-21>0) + B_21*r_21*E(max(idx-21,1))*(idx-21>0);
end 

%第四阶段，强烈干预控制期：出现峰值，潜伏期感染人数下降，E,I公式因时滞期改变
for idx = 28:34
    r_12 = (5.29-1.91)*exp(-0.96*idx-15)+1.91;
    r_22 = (8.11-1.88)*exp(-1.61*idx-15)+1.88;
    r_13 = (1.91-0.47)*exp(-1.86*idx-22)+0.47;
    r_23 = (1.88-0.96)*exp(-1.89*idx-22)+0.96;
    S(idx+1) = S(idx) - B_12*r_13*I(idx) - B_22*r_23*E(idx);
    E(idx+1) = E(idx) + B_12*r_13*I(idx) + B_22*r_23*E(idx) - B_12*r_13*I(idx-7) - B_22*r_23*E(idx-7);
    I(idx+1) = I(idx) + B_12*r_13*I(idx-7) + B_22*r_23*E(idx-7) - B_11*r_11*I(idx-21) - B_21*r_21*E(idx-21);
    R(idx+1) = R(idx) + B_11*r_11*I(idx-21) + B_21*r_21*E(idx-21);
end 

%第五阶段，转归期：医疗资源充足，感染者得到精准隔离治疗，I,R公式因时滞期改变
for idx = 35:59
    r_12 = (5.29-1.91)*exp(-0.96*idx-15)+1.91;
    r_22 = (8.11-1.88)*exp(-1.61*idx-15)+1.88;
    r_13 = (1.91-0.47)*exp(-1.86*idx-22)+0.47;
    r_23 = (1.88-0.96)*exp(-1.89*idx-22)+0.96;
    S(idx+1) = S(idx) - B_12*r_13*I(idx) - B_22*r_23*E(idx);
    E(idx+1) = E(idx) + B_12*r_13*I(idx) + B_22*r_23*E(idx) - B_12*r_13*I(idx-7) - B_22*r_23*E(idx-7);
    I(idx+1) = I(idx) + B_12*r_13*I(idx-7) + B_22*r_23*E(idx-7) - B_12*r_12*I(idx-21) - B_22*r_22*E(idx-21);
    R(idx+1) = R(idx) + B_12*r_12*I(idx-21) + B_22*r_22*E(idx-21);
end 

%第六阶段，想持期：COVID-19感染人数快速下降，I,R公式因时滞期改变
for idx = 60:79
    r_12 = (5.29-1.91)*exp(-0.96*idx-15)+1.91;
    r_22 = (8.11-1.88)*exp(-1.61*idx-15)+1.88;
    r_13 = (1.91-0.47)*exp(-1.86*idx-22)+0.47;
    r_23 = (1.88-0.96)*exp(-1.89*idx-22)+0.96;
    S(idx+1) = S(idx) - B_12*r_13*I(idx) - B_22*r_23*E(idx);
    E(idx+1) = E(idx) + B_12*r_13*I(idx) + B_22*r_23*E(idx) - B_12*r_13*I(idx-7) - B_22*r_23*E(idx-7);
    I(idx+1) = I(idx) + B_12*r_13*I(idx-7) + B_22*r_23*E(idx-7) - B_12*r_13*I(idx-21) - B_22*r_23*E(idx-21);
    R(idx+1) = R(idx) + B_12*r_13*I(idx-21) + B_22*r_23*E(idx-21);
end 

T = 1:80;
plot(T,E,T,I,T,R);grid on;
xlabel('天');ylabel('人数');
legend('潜伏者','传染者','康复者');title('SEIR模型');