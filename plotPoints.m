function h = plotPoints(varargin)
    
   
        
        varargin = cellfun(@(x)x(:), varargin, 'UniformOutput', false);
    
    P = [varargin{:}];
    
    plot(P(1,:), P(2,:))
    
end
