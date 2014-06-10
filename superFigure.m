classdef superFigure < dynamicprops
    
    
    
    % better mouse interaction with axes objects
    
    % - on-screen anti-aliasing
    % - select renderer
    % - set current settings as system default
    % ...more items in the menu
    
    % setting the center of figure coordinates to any other corner other
    % than just lower-left (or, negatives are relative coordinates)
    
    % Multiple UserData fields
    
    
    
    
    
    
    
    %% Events
    
    events
    end
    
    %% Properties
    
    properties
        h
    end
    
    %% Methods
    
    methods 
        
        % constructor
        function obj = superFigure(varargin)
            
            % empty argument list will just 
            if nargin == 0
            end
            
            
            addlistener(obj, 'PropertyAdded'  , @eventPR);
            addlistener(obj, 'PropertyRemoved', @eventPR);
            
            function eventPR(src,evnt)
                mc = metaclass(src);
                fprintf(1,'%s %s \n',mc.Name,'object');
                fprintf(1,'%s %s \n','Event triggered:',evnt.EventName);
            end
            
        end
        
    end
 
    
 
end
