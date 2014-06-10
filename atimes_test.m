clc

A = rand(2,2,3);
B = rand(2,1,3);

AB = atimes(A, B)

for ii = 1:size(B,3)
    A*B(:,:,ii)
end



