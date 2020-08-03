
function showmap

%参数基础值的设置参考了，武汉学报“多阶段动态时滞动力学模型的COVID-19传播分析”
Unit = 21;       %设置可视化矩阵的行列数21行21列
N = Unit*Unit;   %计算总共的像素点（总人数）
E = 0;           %初始潜伏者人数
I = 1;           %初始确诊人数
S = N - I;       %初始易感者（正常群众）
R = 0;           %初始康复者人数

r = 5;           %确诊者每天接触群众人数
B = 0.09;        %确诊者对易感人群的感染率
a = 0.14;        %潜伏者变为感染者的概率
r2 = 9;          %潜伏者每天接触群众人数
B2 = 0.055;      %潜伏者对易感人群的感染率
y1 = 0.06;       %确诊者的康复率

speed = 0.3;     %可视化模型的变化速度，一天=0.3s

restart_flag = 0;  %程序重新开始的标志位  

%构建可视化模型的基本框图，按钮，参数设置文本框
fig3=figure( 'Name','扩散可视化模型','Position',[0,0,700,500] ,'NumberTitle','off','toolbar','none','menubar','none','visible','off');
movegui(fig3,[800,200]);
set(fig3,'visible','on');    %将图像放到合适的位置中
fig3_flag = gcf;             %取出fig3的句柄
uicontrol('Style','pushbutton','Position',[50,50,100,30],'String','start','callback',@start);       %设置开始按钮
uicontrol('Style','pushbutton','Position',[180,50,100,30],'String','restart','callback',@restart);  %设置重启按钮
uicontrol('Style','pushbutton','Position',[370,50,100,30],'String','Pause','callback',@btnPause);   %设置暂停按钮
uicontrol('Style','pushbutton','Position',[500,50,100,30],'String','Go on','callback',@btnGoOn);    %设置继续按钮

uicontrol('Style','text','Position',[20,450,80,20],'String','速度:');                                
edit_speed = uicontrol('Style','edit','Position',[100,455,80,20],'String',num2str(speed));          %速度设置框
uicontrol('Style','text','Position',[20,400,80,20],'String','确诊者感染率:');
edit_B = uicontrol('Style','edit','Position',[100,405,80,20],'String',num2str(B));                  %确诊者感染率设置框
uicontrol('Style','text','Position',[20,350,80,30],'String','潜伏者感染率:');
edit_B2 = uicontrol('Style','edit','Position',[100,365,80,20],'String',num2str(B2));                %潜伏者感染率设置框
uicontrol('Style','text','Position',[20,300,80,30],'String','确诊者接触人数:');
edit_r = uicontrol('Style','edit','Position',[100,315,80,20],'String',num2str(r));                  %确诊者接触人数设置框
uicontrol('Style','text','Position',[20,250,80,30],'String','潜伏者接触人数:');
edit_r2 = uicontrol('Style','edit','Position',[100,265,80,20],'String',num2str(r2));                %潜伏者接触人数设置框
uicontrol('Style','text','Position',[20,200,80,30],'String','潜伏者变为确诊者概率:');
edit_a = uicontrol('Style','edit','Position',[100,210,80,20],'String',num2str(a));                  %潜伏者变为感染者的概率设置框
uicontrol('Style','text','Position',[20,150,80,30],'String','康复率:');
edit_y1 = uicontrol('Style','edit','Position',[100,165,80,20],'String',num2str(y1));                %康复率设置框
uicontrol('Style','pushbutton','Position',[50,100,100,30],'String','set','callback',@set_temp);     %设置确认按钮

%重启函数，按下按键后标志位置1，用于后续程序判断
function restart(x,y)   
    restart_flag = 1;
end

%设置确认函数，按下设置按钮后，文本框上的数字会复制到实际参数中
function set_temp(x,y)
    speed = str2num(get(edit_speed,'string'));
    B = str2num(get(edit_B,'string'));
    B2 = str2num(get(edit_B2,'string'));
    r = str2num(get(edit_r,'string'));
    r2 = str2num(get(edit_r2,'string'));
    a = str2num(get(edit_a,'string'));
    y1 = str2num(get(edit_y1,'string'));
end

%开始程序，模型主体程序
function start(x,y)
    restart_flag = 0;
    Day = 140;    %设置仿真天数
    
    %建立基础的SEIR模型，编写每类人的微分方程（变式），方程模型可参考https://zhuanlan.zhihu.com/p/104268573?utm_source=wechat_session
    T = 1:Day;
    for idx = 1:length(T)-1
        S(idx+1) = S(idx) - r*B*S(idx)*I(idx)/N - r2*B2*S(idx)*E(idx)/N;
        E(idx+1) = E(idx) + r*B*S(idx)*I(idx)/N - a*E(idx) + r2*B2*S(idx)*E(idx)/N;
        I(idx+1) = I(idx) + a*E(idx) - y1*I(idx);
        R(idx+1) = R(idx) + y1*I(idx);
    end
    
    %利用上述模型，将得到的数据画到曲线图中，得到数据指标模型
    fig2=figure( 'Name','曲线图','Position',[0,0,600,400] ,'NumberTitle','off','toolbar','none','menubar','none','visible','off');
    movegui(fig2,[200,200]);
    set(fig2,'visible','on');        %将图像放到合适的位置中
    plot(T,S,T,E,T,I,T,R);grid on;
    xlabel('天');ylabel('人数');
    legend('易感者','潜伏者','传染者','康复者');title('SEIR模型');
    
    %利用一开始建立的可视化模型框架，在框架内画出可视化图形
    %可视化矩阵中，数值0-易感者，1-康复者，2-潜伏者，3-感染者
    figure(fig3_flag);
    
    L = zeros(Unit);              %建立图像矩阵
    M = (Unit+1)/2;               %找到图像中间位置
    L(M,M) = 3;                   %设置中心点为黄色
    Temp = L;                     %复制矩阵
    imagesc(L);                   %画图
    set(gca,'pos',[0.4,0.3,0.5,0.6]);   %设置可视化图形的比例和位置
    
    pro_E_I = 1-B;            %易感者接触确诊者的患病概率
    pro_E_E = 1-B2;           %易感者接触潜伏者的患病概率
    pro_III = 1-r/8;          %感染者一天的接触人数（换算成概率）
    pro_EEE = 1-r2/8;         %潜伏者一天的接触人数（换算成概率）
    pro_I = 1-a;              %潜伏者变成确诊者的概率
    pro_R = 1-y1;             %确诊者治愈的概率
    
    %实现动态的可视化模型
    for mbmb = 0 : Day               %天数循环
        if(restart_flag == 1)  %首先判断是否按下了重启按钮，如按下，则不再循环
            break
        end
        for len = 0:mbmb             %扩散距离不断加大
            if(restart_flag == 1)    %判断是否按下了重启按钮，如按下，则不再循环
                break
            end
            for xxx = -len:len       %扩散距离不断加大
                if(restart_flag == 1)%判断是否按下了重启按钮，如按下，则不再循环
                    break
                end
                yyy = len - abs(xxx);
                if (M+abs(xxx)<=Unit-1 && M+abs(yyy)<=Unit-1) %判断坐标是否超出界限
                    if Temp(M+xxx,M+yyy) == 3      %判断是不是确诊者
                        for x = -1:1               %开始判断周围八个人是否感染
                            for y = -1:1
                                if Temp(M+xxx+x,M+yyy+y) == 0 && rand > pro_E_I && rand > pro_III %当某个人满足概率条件且未感染
                                    Temp(M+xxx+x,M+yyy+y) = 2;   %变成潜伏者
                                end
                            end
                        end
                    end
                    if Temp(M+xxx,M+yyy) == 2     %判断是不是潜伏者
                        for x = -1:1              %开始判断周围八个人是否感染
                            for y = -1:1
                                if Temp(M+xxx+x,M+yyy+y) == 0 && rand > pro_E_E && rand > pro_EEE  %当某个人满足概率条件且未感染
                                    Temp(M+xxx+x,M+yyy+y) = 2;   %变成潜伏者
                                end
                            end
                        end
                    end
                end
                if (M+abs(xxx)<=Unit-1 && M+abs(yyy)<=Unit-1)
                    if Temp(M+xxx,M-yyy) == 3   %与上方位置对应，扫描另一对称点的感染情况
                        for x = -1:1            %开始判断周围八个人是否感染
                            for y = -1:1
                                if Temp(M+xxx+x,M-yyy+y) == 0 && rand > pro_E_I && rand > pro_III  %当某个人满足概率条件且未感染
                                    Temp(M+xxx+x,M-yyy+y) = 2;            %变成潜伏者
                                end
                            end
                        end
                    end
                    if Temp(M+xxx,M-yyy) == 2
                        for x = -1:1   %开始判断周围八个人是否感染
                            for y = -1:1
                                if Temp(M+xxx+x,M-yyy+y) == 0 && rand > pro_E_E && rand > pro_EEE  %当某个人满足概率条件且未感染
                                    Temp(M+xxx+x,M-yyy+y) = 2;            %变成潜伏者
                                end
                            end
                        end
                    end
                end
                for rrr = 400   %自拟定的循环次数，来使得可视化仿真天数与数字模型天数吻合
                    temp_x = fix(rand*len*2-len); temp_y = fix(rand*len*2-len);  %随机寻找某一个独立点，进行感染扫描
                    if( 1<temp_x && temp_x<Unit-1 && 1<temp_y && temp_y<Unit-1 )  %判断坐标是否出界
                        if Temp(temp_x,temp_y) == 3   %下面的与前面代码相同
                            for x = -1:1
                                for y = -1:1
                                    if Temp(temp_x+x,temp_y+y) == 0 && rand>pro_E_I && rand > pro_III
                                        Temp(temp_x+x,temp_y+y) = 2;
                                    end
                                end
                            end
                        end
                        if Temp(temp_x,temp_y) == 2
                            for x = -1:1
                                for y = -1:1
                                    if Temp(temp_x+x,temp_y+y) == 0 && rand>pro_E_E && rand > pro_EEE
                                        Temp(temp_x+x,temp_y+y) = 2;
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        for i = 1:Unit   %开始扫描整个矩阵，找出其中的确诊者和潜伏者
            if(restart_flag == 1)  %如果按下重启按钮，跳过循环
                break
            end
            for j = 1: Unit
                if(restart_flag == 1)
                    break
                end
                if Temp(i,j) == 3 && rand > pro_R  %当该感染者达到概率条件，变为康复者
                    Temp(i,j) = 1;
                end
                if Temp(i,j) == 2 && rand > pro_I %当该潜伏者达到概率条件，变为确诊者
                    Temp(i,j) = 3;
                end
            end
        end
        Map = [1 1 1;0.8 0.8 0.8;0.5 0.5 0.5;0 0 0]; %设置图像背景
        colormap(Map);
        Temp(1,1) = 0;
        pause(speed);
        fig3 = imagesc([100,200],[100,200],Temp);   %画图可视化图形
        text(140,90,['天数：',num2str(len)]);       %显示天数
        if(restart_flag == 1)      %如果按下了重启按钮，将数字指标模型删除
            close(fig2);
        end
    end
end

function btnPause(x,y)  %暂停按钮
uiwait();
end

function btnGoOn(x,y)   %继续按钮
uiresume();
end
end