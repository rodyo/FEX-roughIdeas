function yn = isnumber(N)
    % True for all scalars of numeric or logical class, that are not INF or
    % NAN.
    
    yn =  isscalar(N) && isfinite(N) && ...
        ( isa(N, 'numeric') || islogical(N) );
    
end