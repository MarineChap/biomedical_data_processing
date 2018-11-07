function var_noise = compute_noise_power(yk, yavg)
    var_noise = 0;
    for k = 1:size(yk, 1)
      for n = 1:size(yk, 2)
        var_noise = var_noise + (yk(k,n) - yavg(n))^2;
      end
    end
    var_noise = var_noise./(size(yk, 2)*(size(yk, 1)-1));
end