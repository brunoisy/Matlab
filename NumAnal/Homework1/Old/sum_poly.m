function coeff_sum = sum_poly(x1, x2)
% little helper function to sum polynoms of different degrees

x1_order = length(x1);
x2_order = length(x2);

if x1_order > x2_order
    max_order = size(x1);
else
    max_order = size(x2);
end

new_x1 = padarray(x1,max_order-size(x1),0,'pre');
new_x2 = padarray(x2,max_order-size(x2),0,'pre');

coeff_sum = new_x1 + new_x2;

return