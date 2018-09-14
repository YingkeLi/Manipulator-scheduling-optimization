function d = ProcedureTime(k)

switch k
    case {1,3,10,12}
        d = 0;
    case {2}
        d = 60;
    case {4,5}
        d = 500;
    case {6,7}
        d = 660;
    case {8,9}
        d = 570;
    case {11}
        d = 100;
end

end
    