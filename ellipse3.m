% TODO: documentation on top
% TODO: support variations on the way it can be callled:
% 
function varargout = ellipse3(N, a,b, C, u,v)
    
    if nargin > 6 || nargout > 2
        error('ellipse:nargerror',...
            'ELLIPSE accepts maximum 6 input arguments, and 3 output aguments.');
    end
    
    % Set default values for omitted arguments   
    if nargin < 6 || isempty(v)
        v = [0; 1; 0]; end
    if nargin < 5 || isempty(u)
        u = [1; 0; 0]; end
    if nargin < 4 || isempty(C)
        C = [0; 0; 0]; end
    if nargin < 3 || isempty(b)
        b = 1; end
    if nargin < 2 || isempty(a)
        a = 2; end
    if nargin < 1 || isempty(N)
        N = 50; end
         
    
    % Only vector input
    if ~isnumeric(N) || ~isvector(N) || round(N)~=N || N < 4
        error('ellipse:N_error',...
            'Input argument N must be a scalar integer, greater than 3.');
    end
    
    % Semimajor axis must be a scalar
    if ~isnumeric(a) || ~isscalar(a)
        error('ellipse:nonscalar_semimajor',...
            'The semi-major axis ''a'' must be a scalar.');
    end
    
    % Semiminor axis must be a scalar
    if ~isnumeric(b) || ~isscalar(b)
        error('ellipse:nonscalar_radius',...
            'The semi-minor axis ''b'' must be a scalar.');
    end
    
    % Circle center must be a 3D vector
    if ~isnumeric(C) || ~isvector(C) || numel(C) ~= 3
        error('ellipse:nonvector_offset',...
            'Input argument ''C'' must be a 3D vector.');
    end
    
    % Basis vectors must be 3D vectors
    if ~isnumeric(u) || ~isvector(u) || numel(u) ~= 3 || ...
       ~isnumeric(v) || ~isvector(v) || numel(v) ~= 3
        error('ellipse:nonvector_basevectors',...
            'Input arguments ''u'' and ''v'' must be 3D vectors.');
    end
    
    C = C(:);
    u = u(:)/norm(u);
    v = v(:)/norm(v);
    
    % Basis vectors must form a valid basis
    if abs(u.'*v) > sqrt(eps)
        error('ellipse:invalid_basis',...
            'Input arguments ''u'' and ''v'' do not form a valid basis.');
    end     
                
    % compute all points on the ellipse
    t = linspace(0, 2*pi, N);
    ell = bsxfun(@plus, C, ...
        bsxfun(@times, a*u, cos(t)) + bsxfun(@times, b*v, sin(t)));
       
    % make plot when called without output
    if nargout == 0
        plot3(ell(1,:),ell(2,:),ell(3,:), 'b-');    
        
    % Distribute points over output arguments otherwise
    else        
        varargout{1} = ell(1,:).';
        varargout{2} = ell(2,:).';       
        varargout{3} = ell(3,:).';       
    end
    
end % function ellipse


