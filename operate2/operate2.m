tic

% ��i��������λ��
A = ones(8,1);
% ��i�������ӹ�ʣ��ʱ��
T = zeros(8,1);
% ��i��������ǰʱ���Ƿ���ƶ��������ƶ����ƶ�����һ����̨�����ʱ��
M = zeros(8,1);
% ��i����������ʱ��
tt = {[0],[0],[0],[0],[0],[0],[0],[0]};

% ��j����е�۵�λ��
B = [1; 3];
% ��j����е���ƶ�ʣ��ʱ��
S = zeros(2,1);
% ��j����е�۶���ʱ��
s1 = [0];
s2 = [0];

% ��k������̨�Ƿ�ռ��
C = zeros(13,1);
C(13)=1;

% ��ʱ��
t = 0; 
record1 = [-1;-1];
record2 = [-1;-1];

while(sum(A~=12*ones(8,1))~=0)
    % ��������ۿ������������
    if(S(1)==0||S(2)==0)
        
        % ��鵱ǰʱ�̵�i�������ܷ��ƶ�
        M = zeros(8,1);
        w1 = [];        %������1�����ƶ��Ĺ�������
        w2 = [];        %������2�����ƶ��Ĺ�������
        m1 = [];        %������1�����ƶ��Ĺ�����Ӧ����һ������
        m2 = [];        %������2�����ƶ��Ĺ�����Ӧ����һ������
        for i = 1:8
            if(A(i)~=12)
                k = A(i);
                [k1, k2] = NextPrecedure(k);
                
                % ��������2�����ռ���6������̨�Ƿ񶼱�ռ��
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

                % �����һ��ѡ��λ����
                if(T(i)==0 && C(k1)==0)
                    M(i) = Distance(k,k1)+2;
                    % ����ڲ�����1�����ռ䣬����������1��ѡ�ƶ�����
                    if(k==1|| k==2 || k==10 || k==11)
                        w1 = [w1;i];
                        m1 = [m1;k1];
                    % ����ڲ�����2�����ռ䣬����������2��ѡ�ƶ�����
                    else
                        w2 = [w2;i];
                        m2 = [m2;k1];
                    end
                else
                    % ����ڶ���ѡ��λ����
                    if(T(i)==0 && C(k2)==0)
                        M(i) = Distance(k,k2)+2;
                        % ����ڲ�����1�����ռ䣬����������1��ѡ�ƶ�����
                        if(k==1 || k==2 || k==10 || k==11)
                            w1 = [w1;i];
                            m1 = [m1;k2];
                        % ����ڲ�����2�����ռ䣬����������2��ѡ�ƶ�����
                        else
                            w2 = [w2;i];
                            m2 = [m2;k2];
                        end
                    end
                end
            end
        end
        
        % ���һ�е���ƶ������ѡ��
        pmin1 = 0;           % ������1�ƶ�ʱ����̵Ĺ������
        pmin2 = 0;           % ������2�ƶ�ʱ����̵Ĺ������
        kmin1 = 0;           % ������1�ƶ�ʱ����̵Ĺ�����Ӧ����һ������
        kmin2 = 0;           % ������2�ƶ�ʱ����̵Ĺ�����Ӧ����һ������
        % ����1����е��
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
        % ����2����е��
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
        
        % �ƶ�
        if(pmin1~=0)
            % ����ռ��ʱ��
            S(1) = M(pmin1);
            T(pmin1) = S(1)+ProcedureTime(kmin1);
            %����ؼ�ʱ���
            if(t-s1(length(s1))<Distance(B(1),A(pmin1)))
                temp = s1(length(s1))+Distance(B(1),A(pmin1));
                s1 = [s1;temp; t+S(1)];
                tt{pmin1}=[tt{pmin1};temp;t+S(1)];
                record1 = [temp;A(pmin1)];
                % ����ռ��λ��
                C(kmin1)=1;
                if(kmin1==3 || kmin1==10)
                    C(3)=1;
                    C(10)=1;
                end
            else
                s1 = [s1;t;t+S(1)];
                tt{pmin1}=[tt{pmin1};t;t+S(1)];
                % ����ռ��λ��
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
            % ����λ��
            A(pmin1) = kmin1;
            B(1) = kmin1;
        end
        if(pmin2~=0)
            % ����ռ��ʱ��
            S(2) = M(pmin2);
            T(pmin2) = S(2)+ProcedureTime(kmin2);
            % ����ؼ�ʱ���
            if(t-s2(length(s2))<Distance(B(2),A(pmin2)))
                temp = s2(length(s2))+Distance(B(2),A(pmin2));
                s2 = [s2;temp; t+S(2)];
                tt{pmin2}=[tt{pmin2};temp;t+S(2)];
                record2 = [temp;A(pmin2)];
                % ����ռ��λ��
                C(kmin2)=1;
                if(kmin2==3 || kmin2==10)
                    C(3)=1;
                    C(10)=1;
                end
            else
                s2 = [s2;t;t+S(2)];
                tt{pmin2}=[tt{pmin2};t;t+S(2)];
                % ����ռ��λ��
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
            % ����λ��
            A(pmin2) = kmin2;
            B(2) = kmin2;
        end
    end
    
    % ����ʱ��
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
disp(['����ʱ��: ',num2str(toc)]);
            
        
           
            
        
