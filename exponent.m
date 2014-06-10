function [mantissa, exponent] = splitnumber(A)
% Extract the exponent from a floating point number
%
% See also mantissa.

clc

    fid = fopen('TMP.TMP', 'w');    
        count = fwrite(fid, A, 'double')    
    fclose(fid);
    
    fid = fopen('TMP.TMP', 'r');
    newA = fread(fid, size(A), '*uint64');    
    fclose(fid);
    
    

    
    delete('TMP.TMP');
    
    B = bitand(newA, uint64(4094))
    
    
end