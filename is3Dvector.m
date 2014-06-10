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