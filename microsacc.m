function [sac, radius] = microsacc(x,vel,VFAC,MINDUR, blink)
%-------------------------------------------------------------------
%
%  FUNCTION microsacc.m
%
%  (Version 1.0, 22 FEB 01)
%  (Version 2.0, 18 JUL 05)
%  (Version 2.1, 03 OCT 05)
%
%-------------------------------------------------------------------
%
%  INPUT:
%
%  x(:,1:2)         position vector
%  vel(:,1:2)       velocity vector
%  VFAC             relative velocity threshold
%  MINDUR           minimal saccade duration
%
%  OUTPUT:
%
%  sac(1:num,1)   onset of saccade
%  sac(1:num,2)   end of saccade
%  sac(1:num,3)   peak velocity of saccade (vpeak)
%  sac(1:num,4)   horizontal component     (dx)
%  sac(1:num,5)   vertical component       (dy)
%  sac(1:num,6)   horizontal amplitude     (dX)
%  sac(1:num,7)   vertical amplitude       (dY)
%  ADDED BY JORGE OTERO-MILLAN
%  sac(1:num,8)   mean velocity of the saccade
%
%---------------------------------------------------------------------


% compute threshold (modified by Jorge Otero-Millan to ignore blinks)

vel2 = vel(~blink,:);warning off MATLAB:divideByZero
msdx = sqrt( median(vel2(:,1).^2) - (median(vel2(:,1)))^2 );
msdy = sqrt( median(vel2(:,2).^2) - (median(vel2(:,2)))^2 );
%if msdx<realmin
if msdx<.01
        disp(['msdx was ' num2str(msdx) '!'])
    msdx = sqrt( mean(vel2(:,1).^2) - (mean(vel2(:,1)))^2 );
end
%if msdy<realmin
if msdy<.01
            disp(['msdy was ' num2str(msdy) '!'])

    msdy = sqrt( mean(vel2(:,2).^2) - (mean(vel2(:,2)))^2 );
end
radiusx = VFAC*msdx;
radiusy = VFAC*msdy;
radius	= [radiusx radiusy];

% compute test criterion: ellipse equation
if ( radiusy == 0 )
	test = (vel(:,1)/radiusx).^2 ;
elseif ( radiusx == 0 )
	test =  (vel(:,2)/radiusy).^2;
else
	test = (vel(:,1)/radiusx).^2 + (vel(:,2)/radiusy).^2;
end
	
indx = find(test>1);

% determine saccades
N = length(indx); 
sac = [];
nsac = 0;
dur = 1;
a = 1;
k = 1;
while k<N
    if indx(k+1)-indx(k)==1
        dur = dur + 1;
    else
        if dur>=MINDUR
            nsac = nsac + 1;
            b = k;
            sac(nsac,:) = [indx(a) indx(b)];
        end
        a = k+1;
        dur = 1;
    end
    k = k + 1;
end

% check for minimum duration
if dur>=MINDUR
    nsac = nsac + 1;
    b = k;
    sac(nsac,:) = [indx(a) indx(b)];
end

% compute peak velocity, horizonal and vertical components
for s=1:nsac
    % onset and offset
    a = sac(s,1); 
    b = sac(s,2); 
    % saccade peak velocity (vpeak)
    vpeak = max( sqrt( vel(a:b,1).^2 + vel(a:b,2).^2 ) );
    sac(s,3) = vpeak;
    % saccade vector (dx,dy)
    dx = x(b,1)-x(a,1); 
    dy = x(b,2)-x(a,2); 
    sac(s,4) = dx;
    sac(s,5) = dy;
    % saccade amplitude (dX,dY)
    i = sac(s,1):sac(s,2);
    [minx, ix1] = min(x(i,1));
    [maxx, ix2] = max(x(i,1));
    [miny, iy1] = min(x(i,2));
    [maxy, iy2] = max(x(i,2));
    dX = sign(ix2-ix1)*(maxx-minx);
    dY = sign(iy2-iy1)*(maxy-miny);
    sac(s,6:7) = [dX dY];
	
	sac(s, 8)= mean( sqrt( vel(a:b,1).^2 + vel(a:b,2).^2 ) );
end
end
