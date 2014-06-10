function test
    
    g = [0 0 -9.8].';
    
    L = 1;
    m = 1;
    
    Omega = [0 0 10].';
    Omega_dot = [0 0 0].';
    
    gamma = 0.1;
    gamma2 = 10;
    
    k = 1e4;
    
    rT = [20 0 0].';
    
figure(1), clf, hold on
%figure(2), clf, hold on


    %options = odeset('outputfcn', @outputfcn, 'abstol', 1e-3);    
    options = odeset('reltol', 1e-2);  
    tic
    [~,y] = ode45(@dydt, [0 10], [0;0;-L+0.5; 0;0;-L;   2;0;0; 0;5;0], options);
    toc
    
    plot3(y(:,1),y(:,2),y(:,3));    
    axis equal
    hold on
    
    plot3(y(:,4),y(:,5),y(:,6), 'r');
    

    function dy = dydt(~,y)

        r = reshape(y(1:numel(y)/2), 3,[]);
        v = reshape(y(1+numel(y)/2 : end), 3,[]);

        nr = sqrt(sum(r.^2));
        
        rhat = bsxfun(@rdivide, r, nr);
        
        
        om = bsxfun(@rdivide, [...
            r(2,:).*v(3,:) - r(3,:).*v(2,:)
            r(3,:).*v(1,:) - r(1,:).*v(3,:)
            r(1,:).*v(2,:) - r(2,:).*v(1,:)], nr);
        
        om_x_v = [...
            om(2,:).*v(3,:) - om(3,:).*v(2,:)
            om(3,:).*v(1,:) - om(1,:).*v(3,:)
            om(1,:).*v(2,:) - om(2,:).*v(1,:)];
        
        om_x_r = [...
            om(2,:).*r(3,:) - om(3,:).*r(2,:)
            om(3,:).*r(1,:) - om(1,:).*r(3,:)
            om(1,:).*r(2,:) - om(2,:).*r(1,:)];
            
        Omega_x_rT = [...
            Omega(2)*rT(3) - Omega(3)*rT(2)
            Omega(3)*rT(1) - Omega(1)*rT(3)
            Omega(1)*rT(2) - Omega(2)*rT(1)];
        
        Omega_dot_x_r = [...
            Omega_dot(2)*r(3,:) - Omega_dot(3).*r(2,:)
            Omega_dot(3)*r(1,:) - Omega_dot(1).*r(3,:)
            Omega_dot(1)*r(2,:) - Omega_dot(2).*r(1,:)];
        
        
        Omega_x_r = [...
            Omega(2)*r(3,:) - Omega(3)*r(2,:)
            Omega(3)*r(1,:) - Omega(1)*r(3,:)
            Omega(1)*r(2,:) - Omega(2)*r(1,:)];
        
        Omega_x_v = [...
            Omega(2)*v(3,:) - Omega(3)*v(2,:)
            Omega(3)*v(1,:) - Omega(1)*v(3,:)
            Omega(1)*v(2,:) - Omega(2)*v(1,:)];
        
        
        Omega_x_Omega_x_r = [...
            Omega(2)*Omega_x_r(3,:) - Omega(3)*Omega_x_r(2,:)
            Omega(3)*Omega_x_r(1,:) - Omega(1)*Omega_x_r(3,:)
            Omega(1)*Omega_x_r(2,:) - Omega(2)*Omega_x_r(1,:)];

        
        % string is tight
        F_tight = bsxfun(@times, nr >= L,...
            m*om_x_v - gamma*om_x_r - ...
            k*bsxfun(@times, nr-L, rhat) - gamma2*bsxfun(@times, sum(rhat.*v), rhat));
         
        % ficticious forces
        F_non_inertial = m*(bsxfun(@plus, ...
            Omega_x_rT, Omega_dot_x_r + Omega_x_Omega_x_r + 2*Omega_x_v));
        
        % the accelerations of all the masses
        a = bsxfun(@plus, m*g, F_tight - F_non_inertial);
        
        % the derivative of the state vector
        dy = [v(:); a(:)];

    end
    
    
    function stop = outputfcn(t,y, state)
        stop = false;
        
        persistent gg ii;
        if isempty(gg)
        gg = NaN(2e3,3);
        ii = 1;
        end
        
        if isempty(state)
            gg(ii,:) = [ y(1),y(2),y(3) ];
            t(1)
%         dy = dydt(t,y(:,1));
%         figure(1)
%         plot(t,dy(4),'b.', t,dy(5),'r.', t,dy(6),'k.')
%         figure(2)
clf
        plot3(gg(:,1),gg(:,2),gg(:,3), 'r')
        axis equal
        drawnow
        ii=ii+1;
        end
        
    end

end



