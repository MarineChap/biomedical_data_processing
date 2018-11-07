function [ B,A ] = Comb_filter( omega)

Re = cos(omega);
im = sin(omega);
z = [Re + im*1i; Re - im*1i] ;
z(end+1) = -1;

B = zp2tf(z,zeros(size(z)),1);
A = sum(B) ; % Gain to normalize the filter 


end

