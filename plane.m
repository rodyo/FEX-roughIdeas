function varargout = plane(varargin)
    
    % two non-parallel vectors
    % normal vector and point
    
    % DONE: three non-colinear points
    % DONE: explicit a,b,c,d
    
    argc = nargin;
            
    % plane('xy', [xmin xmax ymin ymax zmin zmax])    
    if argc >= 0 && argc <= 2
        
        if argc == 0 || argc == 1 || (argc == 2 && isempty(varargin{2}))
            lims = [-1 +1 -1 +1 -1 +1];
        else
            lims = varargin{2};
            if ~is6Dvector(lims)
                error('',...
                    '');
            end
        end
        
        if argc == 1        
            type = varargin{1};
        else
            type = 'xy';
        end
        
        if ~ischar(type)
            if ~isnumeric(N) || (numel(N)>1 && ~isvector(N))
                error('plane:n', '');
            end
            
            
            
        else
            
            % Plane given by name
            
            switch type
                case {'xy' 'yx'}
                    a = 0;
                    b = 0;
                    c = 1;
                    d = 0;
                    
                case {'zy' 'yz'}
                    a = 1;
                    b = 0;
                    c = 0;
                    d = 0;
                    
                case {'zx' 'xz'}
                    a = 0;
                    b = 1;
                    c = 0;
                    d = 0;
                                        
                otherwise
                    error('plane:unsupported_name',...
                        'Unknown plane: ''%s''.', type);
            end
            
            clear type
            
        end
        
    
    % plane(N, P, [xmin xmax ymin ymax zmin zmax])
    elseif argc >= 2 && argc < 4 && ...
        (argc == 3 && numel(varargin{3}) > numel(varargin{1}) || argc == 2)
        
        if argc == 2 || (argc == 3 && isempty(varargin{3}))
            lims = [-1 +1 -1 +1 -1 +1];
        else
            lims = varargin{3};
            if ~is6Dvector(lims)
                error('',...
                    '');
            end            
        end
        
        N = varargin{1};
        P = varargin{2};
        
        if ~isnumeric(N) || ~isnumeric(P) || ~isvector(N) || ~isvector(P) || ...
           numel(N)~=numel(P) || numel(N)~=3
            error('',...
                'Input arguments ''N'' and ''P'' must both be 3D vectors.');
        end
        
        
        
             
    % plane(a, b, c, d, [xmin xmax ymin ymax zmin zmax]
    elseif argc >= 4 && argc < 6 && isscalar(varargin{1})
                
        if argc == 4 || (argc == 5 && isempty(varargin{5}))
            lims = [-1 +1 -1 +1 -1 +1];
        else
            lims = varargin{5};
            if ~is6Dvector(lims)
                error('',...
                    '');
            end            
        end
        
        if argc < 4 || isempty(varargin{4})
            d = 0; end
        if argc < 3 || isempty(varargin{3})
            c = 0; end
        if argc < 2 || isempty(varargin{2})
            b = 0; end
        if argc < 1 || isempty(varargin{1})
            a = 0; end
            
    % plane(P1, P2, P3, [xmin xmax ymin ymax zmin zmax]
    elseif argc >= 3 && argc < 6
                        
        if argc == 3 || (argc == 4 && isempty(varargin{4}))
            lims = [-1 +1 -1 +1 -1 +1];
        else
            lims = varargin{4};
            if ~is6Dvector(lims)
                error('',...
                    '');
            end
        end
        
        P1 = varargin{1};
        P2 = varargin{2};
        P3 = varargin{3};
                       
        if ~is3Dvector(P1,P2,P3); 
           error('',...
               '');
        end
                
        P   = [P1(:) P2(:) P3(:)].';
        one = ones(3,1);        
        D   = det(P);
        
        if abs(D) < sqrt(eps)
            % points lie on a line
            error('',...
                '');
        end
        
        d = 1;
        a = -det([one    P(:,2) P(:,2)])/D;     
        b = -det([P(:,1)    one P(:,2)])/D;
        c = -det([P(:,1) P(:,2) one   ])/D;
        
        clear one P P1 P2 P3
        
    else
        % too many arguments
        
    end
    
    
    if ~isnumber(a,b,c,d)
        error('',...
            '');
    end
    
    lims = lims(:);
    
    a
    b
    c
    d
    
    
    
    [x,y] = meshgrid(lims(1:2), lims(3:4))
    
    z = (-d - a*x - b*y)
    
    surf(x,y,z)
    
    
    
    if nargout == 0
        
        
    else
        
    end
end


function yn = isnumber(varargin)    
    yn = true;
    for ii = 1:nargin
        n = varargin{ii};
        if ~isnumeric(n) || ~isscalar(n) || ~isfinite(n)~=3
            yn = false;
            return;
        end
    end    
end

function yn = is3Dvector(varargin)
    
    yn = true;
    for ii = 1:nargin
        V = varargin{ii};
        if ~isnumeric(V) || ~isvector(V) || numel(V)~=3
            yn = false;
            return;
        end
    end    
end


function yn = is6Dvector(varargin)
    
    yn = true;
    for ii = 1:nargin
        V = varargin{ii};
        if ~isnumeric(V) || ~isvector(V) || numel(V)~=3
            yn = false;
            return;
        end
    end    
end