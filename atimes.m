function AB = atimes(A, B)
    
    % multiplies array A with array B
    % uses smart indexing A(:,:) etc. so that matrix/scalar, matrix/vector
    % and matrix/matrix operations are supported for N-d arrays A and B
    
    
    
    %% Initialize
        
    ndA = ndims(A);               ndB = ndims(B);
    sz0 = ones(1,max(ndA,ndB));   % (makes sure the trailing dimes are 1)
    szA = sz0;                    szB = sz0;
    szA(1:ndA) = size(A);         szB(1:ndB) = size(B);
    
    
    %% Trivial cases
        
    try
        % Scalar multiplication
        if prod(szB)==1 || prod(szA)==1            
            AB = A*B;
            return;
            
        % Element-wise multiplication
        elseif ndA==ndB && all(szB==szA)
            AB = A.*B;
            return;            
            
        % Normal mtimes
        elseif ndA==2 && ndB==2
            AB = A*B;
            return;
            
        end
    catch ME
        throwAsCaller(ME);
    end
    
    %% Non-trivial cases
    
    % Error thrown on incorrect dims 
    ME = MException(...
        'MATLAB:innerdim',...
        'Inner matrix dimensions must agree.');
            
    % A is multi-D, B is 2D
    if ndB==2 || all(szB(3:end)==1)
        
        if szA(2)~=szB(1)
            throwAsCaller(ME); end
    
        A  = permute(A, [2 1 3:ndA]);        
        AB = reshape(A(:,:).',[],szA(2)) * B;        
        AB = reshape(AB.', [size(B,2) szA(1) szA(3:end)]);
        AB = permute(AB, [2 1 3:ndA]);
        
    % A is 2D, B is multi-D
    elseif ndA==2 || all(szA(3:end)==1)        
        
        if szA(2)~=szB(1)
            throwAsCaller(ME); end
    
        AB = reshape(A*B(:,:), [szA(1) szB(2), szB(3:end)]);
        
    % General case: A is multi-D, B is multi-D. 
    % Use singleton expansion
    else
        % TODO
        %{
        A  = permute(A, [2 1 3:ndA]); 
        A  = reshape(A(:,:).',[],szA(2));
        B  = B(:,:,:);
        
         AB = zeros(size(A,1), szB(2), prod(szB(3:end)));
         PP = size(AB)
        for ii = 1:prod(szB(3:end))
            AB(:,:,ii) = A*B(:,:,ii); end
        
        [szA(1), szB(2), szA(3:end)]
        
        size(AB)
        
        AB = reshape(AB, szA(1), szB(2), szA(3:end));
        %}
        
    end
    
end
