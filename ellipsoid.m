% TODO: documentation on top
% TODO: support variations on the way it can be callled:
% 
function varargout = ellipsoid(N, a,b,c, C, u,v)
    
    if nargin > 7 || nargout > 2
        error('ellipsoid:nargerror',...
            'ELLIPSOID accepts maximum 7 input arguments, and 3 output aguments.');
    end
    
    % Set default values for omitted arguments   
    if nargin < 7 || isempty(v)
        v = [0; 1; 0]; end
    if nargin < 6 || isempty(u)
        u = [1; 0; 0]; end
    if nargin < 5 || isempty(C)
        C = [0; 0; 0]; end
    if nargin < 4 || isempty(c)
        c = 1; end
    if nargin < 3 || isempty(b)
        b = 2; end
    if nargin < 2 || isempty(a)
        a = 3; end
    if nargin < 1 || isempty(N)
        N = 50; end
         
    % Only vector input
    if ~isnumeric(N) || ~isvector(N) || round(N)~=N || N < 4
        error('ellipsoid:N_error',...
            'Input argument N must be a scalar integer, greater than 3.');
    end
    
    % Semimajor axis must be a scalar
    if ~isnumeric(a) || ~isscalar(a)
        error('ellipsoid:nonscalar_semimajor',...
            'The semi-major axis ''a'' must be a scalar.');
    end
    
    % Semiminor axis must be a scalar
    if ~isnumeric(b) || ~isscalar(b)
        error('ellipsoid:nonscalar_radius',...
            'The semi-minor axis ''b'' must be a scalar.');
    end
    
    % Circle center must be a 3D vector
    if ~isnumeric(C) || ~isvector(C) || numel(C) ~= 3
        error('ellipsoid:nonvector_offset',...
            'Input argument ''C'' must be a 3D vector.');
    end
    
    % Basis vectors must be 3D vectors
    if ~isnumeric(u) || ~isvector(u) || numel(u) ~= 3 || ...
       ~isnumeric(v) || ~isvector(v) || numel(v) ~= 3
        error('ellipsoid:nonvector_basevectors',...
            'Input arguments ''u'' and ''v'' must be 3D vectors.');
    end
    
    C = C(:).';
    u = u(:).'/norm(u);
    v = v(:).'/norm(v);
            
    % Basis vectors must form a valid basis
    if abs(u.'*v) > sqrt(eps)
        error('ellipsoid:invalid_basis',...
            'Input arguments ''u'' and ''v'' do not form a valid basis.');
    end   
    
    w = [...
        u(2)*v(3) - u(3)*v(2),...
        u(3)*v(1) - u(1)*v(3),...
        u(1)*v(2) - u(2)*v(1)];
                    
    % compute all points on the ellipsoid
    th  = (-N:2:N)  *pi/N;
    phi = (-N:2:N).'*pi/2/N;
        
    x = cos(phi)*cos(th);
    y = cos(phi)*sin(th);
    z = repmat(sin(phi), 1,N+1);
    
    ell = repmat(C,(N+1)^2,1) + x(:)*a*u + y(:)*b*v + z(:)*c*w;
        
    x = reshape(ell(:,1), N+1,N+1); 
    y = reshape(ell(:,2), N+1,N+1); 
    z = reshape(ell(:,3), N+1,N+1); 
   
      
    % make plot when called without output
    if nargout == 0
        surf(x,y,z, 'edgecolor', 'none');  
        axis equal
        
    % Distribute points over output arguments otherwise
    else        
        varargout{1} = x;
        varargout{2} = y;
        varargout{3} = z;
    end
    
end % function ellipsoid


