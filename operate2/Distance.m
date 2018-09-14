function d = Distance(k1,k2)

if(k1==k2)
    d = 0;
else
    if(k1>=3 && k1<=10 && k2>=3 && k2<=10)
        if(k2>k1)
            d = k2-k1;
        else
            d = 7-(k1-k2);
        end
    else
        if(k2>k1)
            if(k2-k1>7)
                d = k2-k1-7;
            else
                d = k2-k1;
            end
        else
            if(k1-k2>7)
                d = 4-(k1-k2-7);
            else
                d = 4-(k1-k2);
            end
        end
    end
end

end