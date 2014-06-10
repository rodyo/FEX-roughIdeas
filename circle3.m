% TODO: documentation on top

function varargout = circle3(N, R, C, u,v)
    
    % Set default values for omitted arguments
    if nargin < 5
        v = [0; 1; 0]; end
    if nargin < 4
        u = [1; 0; 0]; end
    if nargin < 3
        C = [0; 0; 0]; end
    if nargin < 2
        R = 1; end
    if nargin < 1
        N = 20; end
    
    % Cannot plot in more-than-3 dimensions, or in only 1
    if length(u)>3 || length(v)>3 || length(C)>3 || ...
       length(u)<2 || length(v)<2 || length(C)<2
        error('circle:no_hypercircles',...
            'Input arguments ''C'', ''u'' and ''v'' must be at least 2, and at most 3-dimensional.');
    end
    
    % Only vector input
    if ~isvector(C) || ~isvector(u) || ~isvector(v)
        error('circle:only_vectors',...
            'Input arguments ''C'', ''u'' and ''v'' must all be 2D or 3D vectors.');
    end
    
    % Inconsistent sizes
    if length(u)~=length(v) || length(u)~=length(C)        
        error('circle:inconsistent_dimensions',...
            ['Inconsistent dimensions.\n',...
            'Input arguments ''C'', ''u'' and ''v'' must have the same number of elements.']);
    end
    
    % Cannot normalize the zero vector
    if norm(u) < sqrt(eps) || norm(v) < sqrt(eps)
        error('circle:invalid_base',...
            'One of the base vectors ''u'' or ''v'' has zero length.');
    end
    
    % Make everything a columnvector, and make sure u and v are unit vectors    
    C = C(:);
    u = u(:)/norm(u);
    v = v(:)/norm(v);
    
    % u and v are not a valid base 
    if (u.'*v) > sqrt(eps)
        error('circle:invalid_base',...
            'Base vectors ''u'' and ''v'' are not perpendicular.');
    end
    
    % compute all points on the circle
    t = linspace(0, 2*pi, N);
    circ = bsxfun(@plus, C, bsxfun(@times,u,R*cos(t)) + bsxfun(@times,v,R*sin(t)));
       
    % make plot when called without output
    if nargout == 0
        plot3(circ(1,:),circ(2,:),circ(3,:), 'b-');    
        
    % Distribute points over output arguments otherwise
    else        
        varargout{1} = circ(1,:).';
        varargout{2} = circ(2,:).';
        varargout{3} = circ(3,:).';
    end
    
end % function circle


