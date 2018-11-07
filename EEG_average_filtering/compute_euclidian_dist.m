function [D] = compute_euclidian_dist( yk, yavg )
D = 0;
for k = 1:size(yk, 1)
    D1=0;
    for n = 1:size(yk, 2)
      D1 = D1 + (yk(k,n) - yavg(n))^2;
    end

    D = D+D1^(1/2); 
end

D = D/size(yk, 1);

end

