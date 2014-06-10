% PLOTVECTOR       Plot an arrow

classdef vector < handle
        
    
    % private properties
    properties (Hidden, Access = private)
        X, Y, Z
        h, c
    end % private properties
    
    
    % public methods
    methods
        
        % Constructor
        function obj = vector(X,Y, varargin)
            
            % We have to allow for empties in order to construct
            % multi-dimensional object
            if nargin == 0, return; end
            
            % Make XY consistent sizes
            if isvector(X), X = X(:); end
            if isvector(Y), Y = Y(:); end
            
            % Parse other arguments
            Z = zeros(size(X)); %#ok
            pvPairs = {};
            
            if nargin > 2                
                if isnumeric(varargin{1})
                    if numel(varargin{1}) == numel(X)
                        Z = varargin{1}; %#ok
                        varargin = varargin(2:end);
                        
                    else
                        error('vector:invalid_input',...
                            ['Input argument ''Z'' has inconsistent ',...
                            'dimensions with input argument ''X''.']);                        
                    end
                end
                
                pvPairs = varargin;
                
            end
            
            % Now also make Z conform to sizes of X and Y
            if isvector(Z), Z = Z(:); end %#ok
            
            % Distribvute the X,Y and Z data over multi-dimensional array
            % This is needed, because we want to give the user direct
            % access to individual vectors
            obj(size(X,2)) = vector();
            for ii = 1:size(X,2)                
                obj(ii).X = X(:,ii);
                obj(ii).Y = Y(:,ii);
                obj(ii).Z = Z(:,ii); %#ok
            end
            
            % Now plot the initial vectors
            obj.updatePlot(pvPairs{:});
            
        end % Constructor
        
        
        % -----------------------------------------------------------------
        % Overloaded functions
        % -----------------------------------------------------------------
        
        % Get; forward request only to the line objects        
        function val = get(obj, varargin)            
            if nargin == 1
                get([obj.h])
                return;
            else
                val = get(obj.h, varargin{:});
            end
        end % function get
        
        % Set: forward request only to the line objects, but changes to any
        % of the properties 'color' and 'linewidth' also affect the arrow
        % objects
        function set(obj, varargin)
            if nargin == 1
                set([obj.h])              
                return;
            else                
                set([obj.h], varargin{:});
                
                % TODO: linewidth changes should also re-scale the arrow
                
%                 lineWidth = find(strcmpi(varargin(1:2:end), 'linewidth'), 1,'first');
%                 if ~isempty(lineWidth)
%                     lineWidth = varargin{lineWidth+1};
%                     
%                     currentScale = get([obj.c], 'UserData');
%                     
%                     Xc = get([obj.c], 'Xdata'); if ~iscell(Xc), Xc = {Xc}; end
%                     Yc = get([obj.c], 'Ydata'); if ~iscell(Yc), Yc = {Yc}; end
%                     Zc = get([obj.c], 'Zdata'); if ~iscell(Zc), Zc = {Zc}; end
%                     
%                     rescale = lineWidth;
%                                         
%                     Xc = cellfun(@(x) [x(1,:); rescale*diff(x)], Xc, 'UniformOutput', false);
%                     Yc = cellfun(@(y) [y(1,:); rescale*diff(y)], Yc, 'UniformOutput', false);
%                     Zc = cellfun(@(z) [z(1,:); rescale*diff(z)], Zc, 'UniformOutput', false);
%                                         
%                     cellfun(@(a,b,c,d) set(a, ...
%                         'Xdata', b, ...
%                         'Ydata', c, ...
%                         'Zdata', d), {obj.c}, Xc,Yc,Zc)
%                 end
                
                % Changes to the 'color' property should also be applied
                % to the arrow
                color = find(strcmpi(varargin(1:2:end), 'color'), 1,'first');
                if ~isempty(color)
                    set([obj.c], ...
                        'facecolor', varargin{color+1},...
                        'edgecolor', varargin{color+1});
                end
                
                
            end
        end % function set
        
        % Disp: show *only* the line handles
        function disp(obj)
            for ii = 1:numel(obj)
                disp(obj(ii).h); end
        end % function disp
            
        
        % -----------------------------------------------------------------
        % Extra functionality
        % -----------------------------------------------------------------
        
        % Normalize a given vector in the plot
        function val = normalize(obj)
        % TODO: perfect this
            
            mag = sqrt(diff([obj.X]).^2 + diff([obj.Y]).^2 + diff([obj.Z]).^2);
            
            new_X = [obj.X];
            new_X = [...
                new_X(1,:); 
                new_X(1,:) + bsxfun(@rdivide, diff([obj.X]), mag)];
            
            new_Y = [obj.Y];
            new_Y = [...
                new_Y(1,:); 
                new_Y(1,:) + bsxfun(@rdivide, diff([obj.Y]), mag)];
            
            new_Z = [obj.Z];
            new_Z = [...
                new_Z(1,:); 
                new_Z(1,:) + bsxfun(@rdivide, diff([obj.Z]), mag)];
            
            
            for ii = 1:size(new_X,2) 
                
                prop_h(ii) = get(obj(ii).h);
                prop_c(ii) = get(obj(ii).c);
                
                obj(ii).X = new_X(:,ii);
                obj(ii).Y = new_Y(:,ii);
                obj(ii).Z = new_Z(:,ii);  
                
                delete([obj(ii).h   obj(ii).c]);
            end
            
            obj.updatePlot();
            
            val = [obj.h];
            
        end % function normalize
                        
    end % public methods
     
    
    % private methods
    methods (Hidden, Access = private)
        
        % Draw all vectors embedded in all objects
        function updatePlot(obj, varargin)
            
            % Coordinates for cone
            [Xc, Yc, Zc] = cylinder([0 1]);
                    
            % Draw all line objects
            M = num2cell( line([obj.X], [obj.Y], [obj.Z], varargin{:}) );
            [obj.h] = deal(M{:});                        
            [obj.c] = deal(NaN);
            
            % We have to set 'hold' to 'on'; the current state should be
            % reset after we're done
            holdstate = get(gcf, 'NextPlot');
            hold on
            
            % The line colors might be set by property
            colors = get([obj.h], 'color');
            if ~iscell(colors)
                colors = {colors}; end
            
            % Set appropriate scales for the length and opening angle of
            % the arrow
            x = diff([obj.X]);
            y = diff([obj.Y]);
            z = diff([obj.Z]);
            
            maxLength  = max( sqrt(x.^2+y.^2+z.^2) );
            tipScale   = maxLength/5;
            angleScale = maxLength/10;
            
            % Find proper rotation angles
            azS  = atan2(y, x) - pi/2;
            decS = pi/2 + atan2(z, sqrt(x.^2+y.^2));
            
            % Apply the rotations and plot the arrows
            for ii = 1:numel(azS)
                
                az  = azS(ii);
                dec = decS(ii);
                
                R1 = [...
                    +cos(az) -sin(az)   0
                    +sin(az) +cos(az)   0
                    0         0         1];
                
                R2 = [...
                    1   0         0
                    0   +cos(dec) -sin(dec)
                    0   +sin(dec) +cos(dec)];
                
                XYZc = R1*R2*[...
                    angleScale * Xc(2,:)
                    angleScale * Yc(2,:) 
                    tipScale   * Zc(2,:)];
                
                Xcc = Xc;   Xcc(2,:) = XYZc(1,:);
                Ycc = Yc;   Ycc(2,:) = XYZc(2,:);
                Zcc = Zc;   Zcc(2,:) = XYZc(3,:);
                
                obj(ii).c = mesh(Xcc+obj(ii).X(2), Ycc+obj(ii).Y(2), Zcc+obj(ii).Z(2),...
                    'facecolor', colors{ii},...
                    'edgecolor', colors{ii});
                
            end
            
            % Re-set the hold state, and we're done!
            set(gcf, 'NextPlot', holdstate);
            
        end % function updateplot
        
    end % private methods
    
    
end % classdef vector



