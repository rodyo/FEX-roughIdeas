% TODO: documentation on top

function varargout = circle(N, R, C)
    
    % Set default values for omitted arguments    
    if nargin < 3 || isempty(C)
        C = [0; 0]; end
    if nargin < 2 || isempty(R)
        R = 1; end
    if nargin < 1 || isempty(N)
        N = 50; end
      
    % Number of points must be a scalar
    if ~isnumeric(N) || ~isscalar(N) || round(N)~=N || N < 4
        error('circle:N_error',...
            'Input argument N must be a scalar integer, greater than 3.');
    end
       
    % Radius must be a scalar
    if ~isnumeric(R) || ~isscalar(R)
        error('circle:nonscalar_radius',...
            'The radius ''R'' must be a scalar.');
    end
    
    % Circle center must be a 2D vector
    if ~isnumeric(C) || ~isvector(C) || numel(C) ~= 2
        error('circle:nonvector_offset',...
            'Input argument ''C'' must be a 2D vector.');
    end
               
    % compute all points on the circle
    t = linspace(0, 2*pi, N);
    circ = bsxfun(@plus, C(:), R*[sin(t); cos(t)]);
       
    % make plot when called without output
    if nargout == 0
        plot(circ(1,:),circ(2,:), 'b-');    
        
    % Distribute points over output arguments otherwise
    else        
        varargout{1} = circ(1,:).';
        varargout{2} = circ(2,:).';        
    end
    
end % function circle


