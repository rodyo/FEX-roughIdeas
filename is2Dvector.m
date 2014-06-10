function yn = is2Dvector(varargin)
    
    yn = true;
    for ii = 1:nargin
        V = varargin{ii};
        if ~isnumeric(V) || ~isvector(V) || numel(V)~=2
            yn = false;
            return;
        end
    end    
end