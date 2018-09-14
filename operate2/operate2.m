tic

% 第i个工件的位置
A = ones(8,1);
% 第i个工件加工剩余时间
T = zeros(8,1);
% 第i个工件当前时刻是否可移动，若可移动，移动到下一工作台的最短时间
M = zeros(8,1);
% 第i个工件动作时刻
tt = {[0],[0],[0],[0],[0],[0],[0],[0]};

% 第j个机械臂的位置
B = [1; 3];
% 第j个机械臂移动剩余时间
S = zeros(2,1);
% 第j个机械臂动作时刻
s1 = [0];
s2 = [0];

% 第k个工作台是否被占用
C = zeros(13,1);
C(13)=1;

% 总时刻
t = 0; 
record1 = [-1;-1];
record2 = [-1;-1];

while(sum(A~=12*ones(8,1))~=0)
    % 如果操作臂空闲则进行搜索
    if(S(1)==0||S(2)==0)
        
        % 检查当前时刻第i个工件能否移动
        M = zeros(8,1);
        w1 = [];        %操作臂1可以移动的工件序列
        w2 = [];        %操作臂2可以移动的工件序列
        m1 = [];        %操作臂1可以移动的工件对应的下一道工序
        m2 = [];        %操作臂2可以移动的工件对应的下一道工序
        for i = 1:8
            if(A(i)~=12)
                k = A(i);
                [k1, k2] = NextPrecedure(k);
                
                % 检查操作臂2工作空间内6个工作台是否都被占用
                num=0;
                if A(i)==2 && i>6
                    for j=1:i-1
                        if 3<A(j) && A(j)<10
                            num=num+1;
                        end
                    end
                end
                if num==6
                    k1=k;
                    k2=k;
                end

                % 如果第一候选工位空闲
                if(T(i)==0 && C(k1)==0)
                    M(i) = Distance(k,k1)+2;
                    % 如果在操作臂1操作空间，则加入操作臂1候选移动序列
                    if(k==1|| k==2 || k==10 || k==11)
                        w1 = [w1;i];
                        m1 = [m1;k1];
                    % 如果在操作臂2操作空间，则加入操作臂2候选移动序列
                    else
                        w2 = [w2;i];
                        m2 = [m2;k1];
                    end
                else
                    % 如果第二候选工位空闲
                    if(T(i)==0 && C(k2)==0)
                        M(i) = Distance(k,k2)+2;
                        % 如果在操作臂1操作空间，则加入操作臂1候选移动序列
                        if(k==1 || k==2 || k==10 || k==11)
                            w1 = [w1;i];
                            m1 = [m1;k2];
                        % 如果在操作臂2操作空间，则加入操作臂2候选移动序列
                        else
                            w2 = [w2;i];
                            m2 = [m2;k2];
                        end
                    end
                end
            end
        end
        
        % 查找机械臂移动的最佳选择
        pmin1 = 0;           % 操作臂1移动时间最短的工件序号
        pmin2 = 0;           % 操作臂2移动时间最短的工件序号
        kmin1 = 0;           % 操作臂1移动时间最短的工件对应的下一道工序
        kmin2 = 0;           % 操作臂2移动时间最短的工件对应的下一道工序
        % 检查第1个机械臂
        if((~isempty(w1)) && (S(1)==0))
            for n = 1:length(w1)
                i = w1(n);
                if(t-s1(length(s1))<Distance(B(1),A(i)))
                    M(i) = M(i)+Distance(B(1),A(i))-(t-s1(length(s1)));
                end
            end
            min1 = 999999999;
            for n = 1:length(w1)
                i = w1(n);
                if(M(i)<min1)
                    min1 = M(i);
                    pmin1 = i;
                    kmin1 = m1(n);
                end
            end
        end
        % 检查第2个机械臂
        if((~isempty(w2)) && (S(2)==0))
            for n = 1:length(w2)
                i = w2(n);
                if(t-s2(length(s2))<Distance(B(2),A(i)))
                    M(i) = M(i)+Distance(B(2),A(i))-(t-s2(length(s2)));
                end
            end
            min2 = 999999999;
            for n = 1:length(w2)
                i = w2(n);
                if(M(i)<min2)
                    min2 = M(i);
                    pmin2 = i;
                    kmin2 = m2(n);
                end
            end
        end
        
        % 移动
        if(pmin1~=0)
            % 更新占用时间
            S(1) = M(pmin1);
            T(pmin1) = S(1)+ProcedureTime(kmin1);
            %插入关键时间点
            if(t-s1(length(s1))<Distance(B(1),A(pmin1)))
                temp = s1(length(s1))+Distance(B(1),A(pmin1));
                s1 = [s1;temp; t+S(1)];
                tt{pmin1}=[tt{pmin1};temp;t+S(1)];
                record1 = [temp;A(pmin1)];
                % 更新占用位置
                C(kmin1)=1;
                if(kmin1==3 || kmin1==10)
                    C(3)=1;
                    C(10)=1;
                end
            else
                s1 = [s1;t;t+S(1)];
                tt{pmin1}=[tt{pmin1};t;t+S(1)];
                % 更新占用位置
                C(A(pmin1))=0;
                if(A(pmin1)==3 || A(pmin1)==10)
                    C(3)=0;
                    C(10)=0;
                end
                C(kmin1)=1;
                if(kmin1==3 || kmin1==10)
                    C(3)=1;
                    C(10)=1;
                end
            end
            % 更新位置
            A(pmin1) = kmin1;
            B(1) = kmin1;
        end
        if(pmin2~=0)
            % 更新占用时间
            S(2) = M(pmin2);
            T(pmin2) = S(2)+ProcedureTime(kmin2);
            % 插入关键时间点
            if(t-s2(length(s2))<Distance(B(2),A(pmin2)))
                temp = s2(length(s2))+Distance(B(2),A(pmin2));
                s2 = [s2;temp; t+S(2)];
                tt{pmin2}=[tt{pmin2};temp;t+S(2)];
                record2 = [temp;A(pmin2)];
                % 更新占用位置
                C(kmin2)=1;
                if(kmin2==3 || kmin2==10)
                    C(3)=1;
                    C(10)=1;
                end
            else
                s2 = [s2;t;t+S(2)];
                tt{pmin2}=[tt{pmin2};t;t+S(2)];
                % 更新占用位置
                C(A(pmin2))=0;
                if(A(pmin2)==3 || A(pmin2)==10)
                    C(3)=0;
                    C(10)=0;
                end
                C(kmin2)=1;
                if(kmin2==3 || kmin2==10)
                    C(3)=1;
                    C(10)=1;
                end
            end
            % 更新位置
            A(pmin2) = kmin2;
            B(2) = kmin2;
        end
    end
    
    % 更新时间
    C(12)=0;
    t = t+1;
    T = T-1;
    T(T<0) = 0;
    S = S-1;
    S(S<0) = 0;
    if(t==(record1(1)+1))
        C(record1(2))=0;
        if(record1(2)==3 || record1(2)==10)
            C(3)=0;
            C(10)=0;
        end
    end
    if(t==(record2(1)+1))
        C(record2(2))=0;
        if(record2(2)==3 || record2(2)==10)
            C(3)=0;
            C(10)=0;
        end
    end
end

toc
disp(['运行时间: ',num2str(toc)]);
            
        
           
            
        
