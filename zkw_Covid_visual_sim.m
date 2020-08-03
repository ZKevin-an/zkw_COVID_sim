
function showmap

%��������ֵ�����òο��ˣ��人ѧ������׶ζ�̬ʱ�Ͷ���ѧģ�͵�COVID-19����������
Unit = 21;       %���ÿ��ӻ������������21��21��
N = Unit*Unit;   %�����ܹ������ص㣨��������
E = 0;           %��ʼǱ��������
I = 1;           %��ʼȷ������
S = N - I;       %��ʼ�׸��ߣ�����Ⱥ�ڣ�
R = 0;           %��ʼ����������

r = 5;           %ȷ����ÿ��Ӵ�Ⱥ������
B = 0.09;        %ȷ���߶��׸���Ⱥ�ĸ�Ⱦ��
a = 0.14;        %Ǳ���߱�Ϊ��Ⱦ�ߵĸ���
r2 = 9;          %Ǳ����ÿ��Ӵ�Ⱥ������
B2 = 0.055;      %Ǳ���߶��׸���Ⱥ�ĸ�Ⱦ��
y1 = 0.06;       %ȷ���ߵĿ�����

speed = 0.3;     %���ӻ�ģ�͵ı仯�ٶȣ�һ��=0.3s

restart_flag = 0;  %�������¿�ʼ�ı�־λ  

%�������ӻ�ģ�͵Ļ�����ͼ����ť�����������ı���
fig3=figure( 'Name','��ɢ���ӻ�ģ��','Position',[0,0,700,500] ,'NumberTitle','off','toolbar','none','menubar','none','visible','off');
movegui(fig3,[800,200]);
set(fig3,'visible','on');    %��ͼ��ŵ����ʵ�λ����
fig3_flag = gcf;             %ȡ��fig3�ľ��
uicontrol('Style','pushbutton','Position',[50,50,100,30],'String','start','callback',@start);       %���ÿ�ʼ��ť
uicontrol('Style','pushbutton','Position',[180,50,100,30],'String','restart','callback',@restart);  %����������ť
uicontrol('Style','pushbutton','Position',[370,50,100,30],'String','Pause','callback',@btnPause);   %������ͣ��ť
uicontrol('Style','pushbutton','Position',[500,50,100,30],'String','Go on','callback',@btnGoOn);    %���ü�����ť

uicontrol('Style','text','Position',[20,450,80,20],'String','�ٶ�:');                                
edit_speed = uicontrol('Style','edit','Position',[100,455,80,20],'String',num2str(speed));          %�ٶ����ÿ�
uicontrol('Style','text','Position',[20,400,80,20],'String','ȷ���߸�Ⱦ��:');
edit_B = uicontrol('Style','edit','Position',[100,405,80,20],'String',num2str(B));                  %ȷ���߸�Ⱦ�����ÿ�
uicontrol('Style','text','Position',[20,350,80,30],'String','Ǳ���߸�Ⱦ��:');
edit_B2 = uicontrol('Style','edit','Position',[100,365,80,20],'String',num2str(B2));                %Ǳ���߸�Ⱦ�����ÿ�
uicontrol('Style','text','Position',[20,300,80,30],'String','ȷ���߽Ӵ�����:');
edit_r = uicontrol('Style','edit','Position',[100,315,80,20],'String',num2str(r));                  %ȷ���߽Ӵ��������ÿ�
uicontrol('Style','text','Position',[20,250,80,30],'String','Ǳ���߽Ӵ�����:');
edit_r2 = uicontrol('Style','edit','Position',[100,265,80,20],'String',num2str(r2));                %Ǳ���߽Ӵ��������ÿ�
uicontrol('Style','text','Position',[20,200,80,30],'String','Ǳ���߱�Ϊȷ���߸���:');
edit_a = uicontrol('Style','edit','Position',[100,210,80,20],'String',num2str(a));                  %Ǳ���߱�Ϊ��Ⱦ�ߵĸ������ÿ�
uicontrol('Style','text','Position',[20,150,80,30],'String','������:');
edit_y1 = uicontrol('Style','edit','Position',[100,165,80,20],'String',num2str(y1));                %���������ÿ�
uicontrol('Style','pushbutton','Position',[50,100,100,30],'String','set','callback',@set_temp);     %����ȷ�ϰ�ť

%�������������°������־λ��1�����ں��������ж�
function restart(x,y)   
    restart_flag = 1;
end

%����ȷ�Ϻ������������ð�ť���ı����ϵ����ֻḴ�Ƶ�ʵ�ʲ�����
function set_temp(x,y)
    speed = str2num(get(edit_speed,'string'));
    B = str2num(get(edit_B,'string'));
    B2 = str2num(get(edit_B2,'string'));
    r = str2num(get(edit_r,'string'));
    r2 = str2num(get(edit_r2,'string'));
    a = str2num(get(edit_a,'string'));
    y1 = str2num(get(edit_y1,'string'));
end

%��ʼ����ģ���������
function start(x,y)
    restart_flag = 0;
    Day = 140;    %���÷�������
    
    %����������SEIRģ�ͣ���дÿ���˵�΢�ַ��̣���ʽ��������ģ�Ϳɲο�https://zhuanlan.zhihu.com/p/104268573?utm_source=wechat_session
    T = 1:Day;
    for idx = 1:length(T)-1
        S(idx+1) = S(idx) - r*B*S(idx)*I(idx)/N - r2*B2*S(idx)*E(idx)/N;
        E(idx+1) = E(idx) + r*B*S(idx)*I(idx)/N - a*E(idx) + r2*B2*S(idx)*E(idx)/N;
        I(idx+1) = I(idx) + a*E(idx) - y1*I(idx);
        R(idx+1) = R(idx) + y1*I(idx);
    end
    
    %��������ģ�ͣ����õ������ݻ�������ͼ�У��õ�����ָ��ģ��
    fig2=figure( 'Name','����ͼ','Position',[0,0,600,400] ,'NumberTitle','off','toolbar','none','menubar','none','visible','off');
    movegui(fig2,[200,200]);
    set(fig2,'visible','on');        %��ͼ��ŵ����ʵ�λ����
    plot(T,S,T,E,T,I,T,R);grid on;
    xlabel('��');ylabel('����');
    legend('�׸���','Ǳ����','��Ⱦ��','������');title('SEIRģ��');
    
    %����һ��ʼ�����Ŀ��ӻ�ģ�Ϳ�ܣ��ڿ���ڻ������ӻ�ͼ��
    %���ӻ������У���ֵ0-�׸��ߣ�1-�����ߣ�2-Ǳ���ߣ�3-��Ⱦ��
    figure(fig3_flag);
    
    L = zeros(Unit);              %����ͼ�����
    M = (Unit+1)/2;               %�ҵ�ͼ���м�λ��
    L(M,M) = 3;                   %�������ĵ�Ϊ��ɫ
    Temp = L;                     %���ƾ���
    imagesc(L);                   %��ͼ
    set(gca,'pos',[0.4,0.3,0.5,0.6]);   %���ÿ��ӻ�ͼ�εı�����λ��
    
    pro_E_I = 1-B;            %�׸��߽Ӵ�ȷ���ߵĻ�������
    pro_E_E = 1-B2;           %�׸��߽Ӵ�Ǳ���ߵĻ�������
    pro_III = 1-r/8;          %��Ⱦ��һ��ĽӴ�����������ɸ��ʣ�
    pro_EEE = 1-r2/8;         %Ǳ����һ��ĽӴ�����������ɸ��ʣ�
    pro_I = 1-a;              %Ǳ���߱��ȷ���ߵĸ���
    pro_R = 1-y1;             %ȷ���������ĸ���
    
    %ʵ�ֶ�̬�Ŀ��ӻ�ģ��
    for mbmb = 0 : Day               %����ѭ��
        if(restart_flag == 1)  %�����ж��Ƿ�����������ť���簴�£�����ѭ��
            break
        end
        for len = 0:mbmb             %��ɢ���벻�ϼӴ�
            if(restart_flag == 1)    %�ж��Ƿ�����������ť���簴�£�����ѭ��
                break
            end
            for xxx = -len:len       %��ɢ���벻�ϼӴ�
                if(restart_flag == 1)%�ж��Ƿ�����������ť���簴�£�����ѭ��
                    break
                end
                yyy = len - abs(xxx);
                if (M+abs(xxx)<=Unit-1 && M+abs(yyy)<=Unit-1) %�ж������Ƿ񳬳�����
                    if Temp(M+xxx,M+yyy) == 3      %�ж��ǲ���ȷ����
                        for x = -1:1               %��ʼ�ж���Χ�˸����Ƿ��Ⱦ
                            for y = -1:1
                                if Temp(M+xxx+x,M+yyy+y) == 0 && rand > pro_E_I && rand > pro_III %��ĳ�����������������δ��Ⱦ
                                    Temp(M+xxx+x,M+yyy+y) = 2;   %���Ǳ����
                                end
                            end
                        end
                    end
                    if Temp(M+xxx,M+yyy) == 2     %�ж��ǲ���Ǳ����
                        for x = -1:1              %��ʼ�ж���Χ�˸����Ƿ��Ⱦ
                            for y = -1:1
                                if Temp(M+xxx+x,M+yyy+y) == 0 && rand > pro_E_E && rand > pro_EEE  %��ĳ�����������������δ��Ⱦ
                                    Temp(M+xxx+x,M+yyy+y) = 2;   %���Ǳ����
                                end
                            end
                        end
                    end
                end
                if (M+abs(xxx)<=Unit-1 && M+abs(yyy)<=Unit-1)
                    if Temp(M+xxx,M-yyy) == 3   %���Ϸ�λ�ö�Ӧ��ɨ����һ�ԳƵ�ĸ�Ⱦ���
                        for x = -1:1            %��ʼ�ж���Χ�˸����Ƿ��Ⱦ
                            for y = -1:1
                                if Temp(M+xxx+x,M-yyy+y) == 0 && rand > pro_E_I && rand > pro_III  %��ĳ�����������������δ��Ⱦ
                                    Temp(M+xxx+x,M-yyy+y) = 2;            %���Ǳ����
                                end
                            end
                        end
                    end
                    if Temp(M+xxx,M-yyy) == 2
                        for x = -1:1   %��ʼ�ж���Χ�˸����Ƿ��Ⱦ
                            for y = -1:1
                                if Temp(M+xxx+x,M-yyy+y) == 0 && rand > pro_E_E && rand > pro_EEE  %��ĳ�����������������δ��Ⱦ
                                    Temp(M+xxx+x,M-yyy+y) = 2;            %���Ǳ����
                                end
                            end
                        end
                    end
                end
                for rrr = 400   %���ⶨ��ѭ����������ʹ�ÿ��ӻ���������������ģ�������Ǻ�
                    temp_x = fix(rand*len*2-len); temp_y = fix(rand*len*2-len);  %���Ѱ��ĳһ�������㣬���и�Ⱦɨ��
                    if( 1<temp_x && temp_x<Unit-1 && 1<temp_y && temp_y<Unit-1 )  %�ж������Ƿ����
                        if Temp(temp_x,temp_y) == 3   %�������ǰ�������ͬ
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
        for i = 1:Unit   %��ʼɨ�����������ҳ����е�ȷ���ߺ�Ǳ����
            if(restart_flag == 1)  %�������������ť������ѭ��
                break
            end
            for j = 1: Unit
                if(restart_flag == 1)
                    break
                end
                if Temp(i,j) == 3 && rand > pro_R  %���ø�Ⱦ�ߴﵽ������������Ϊ������
                    Temp(i,j) = 1;
                end
                if Temp(i,j) == 2 && rand > pro_I %����Ǳ���ߴﵽ������������Ϊȷ����
                    Temp(i,j) = 3;
                end
            end
        end
        Map = [1 1 1;0.8 0.8 0.8;0.5 0.5 0.5;0 0 0]; %����ͼ�񱳾�
        colormap(Map);
        Temp(1,1) = 0;
        pause(speed);
        fig3 = imagesc([100,200],[100,200],Temp);   %��ͼ���ӻ�ͼ��
        text(140,90,['������',num2str(len)]);       %��ʾ����
        if(restart_flag == 1)      %���������������ť��������ָ��ģ��ɾ��
            close(fig2);
        end
    end
end

function btnPause(x,y)  %��ͣ��ť
uiwait();
end

function btnGoOn(x,y)   %������ť
uiresume();
end
end