function [k1, k2] = NextPrecedure(k,kind)
%kind==1 is C
%kind == 2 is D
%if 4<i && i<9
if kind==1
%if mod(i,2) == 0
    switch k
        case {1}
            k1 = 2;
            k2 = 13;
        case {2}
            k1 = 3;
            k2 = 13;
        case {3}
            k1 = 4;
            k2 = 13;
        case {4}
            k1 = 6;
            k2 = 13;
        case {6}
            k1 = 8;
            k2 = 13;
        case {8}
            k1 = 9;
            k2 = 13;
        case {9}
            k1 = 10;
            k2 = 13;
        case {10}
            k1 = 11;
            k2 = 13;
        case {11}
            k1 = 12;
            k2 = 13;
        case {12}
            k1 = 13;
            k2 = 13;
    end
%elseif 0<i && i<5
elseif kind==2
%elseif mod(i,2) == 1
    switch k
        case {1}
            k1 = 2;
            k2 = 13;
        case {2}
            k1 = 3;
            k2 = 13;
        case {3}
            k1 = 4;
            k2 = 13;
        case {4}
            k1 = 5;
            k2 = 13;
        case {5}
            k1 = 7;
            k2 = 13;
        case {7}
            k1 = 8;
            k2 = 13;
        case {8}
            k1 = 10;
            k2 = 13;
        case {10}
            k1 = 11;
            k2 = 13;
        case {11}
            k1 = 12;
            k2 = 13;
        case {12}
            k1 = 13;
            k2 = 13;
    end
end
end