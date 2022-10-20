function u = boundary_repair(v,low,up,str)

[NP, D] = size(v);   
u = v; 

if strcmp(str,'absorb')
    for i = 1:NP    
    for j = 1:D 
        if v(i,j) > up 
            u(i,j) = up;
        elseif  v(i,j) < low
            u(i,j) = low;
        else
            u(i,j) = v(i,j);
        end  
    end
    end   
end
   

if strcmp(str,'random')
    for i = 1:NP    
    for j = 1:D 
        if v(i,j) > up || v(i,j) < low
            u(i,j) = low + rand*(up-low);
        else
            u(i,j) = v(i,j);
        end  
    end
    end   
end


if strcmp(str,'reflect')
    for i = 1:NP
    for j = 1:D 
        if v(i,j) > up
            u(i,j) = max( 2*up-v(i,j), low );
        elseif v(i,j) < low
            u(i,j) = min( 2*low-v(i,j), up );
        else
            u(i,j) = v(i,j);
        end  
    end
    end   
end
