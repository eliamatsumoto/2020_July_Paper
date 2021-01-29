%% First Working Day of the Month (Date_Vector,BH,Lag)
%
% function FWDM = util_FIRST_wdm(Date_Vector,BH,Lag)
%
% Inputs
% - Date vector
% - BH: Brazilian Holidays Vector
% Output
% - FWDM: First Working of the month vector
%
function FWDM = util_FIRST_wdm(Date_Vector,BH,Lag)
%
%% Years
YInit  = year(Date_Vector(1));
YFinal = year(Date_Vector(end));
NDays  = ((YFinal-YInit)+1)*12;
FWDM   = zeros(NDays,1);

%% Lag
if nargin < 3
    Lag = 0;
end
    
%% For all years
idx = 1;
for y = YInit:YFinal
    %% For all twelve months
    for m = 1:12
        d = [y m 1];
        while ~isbusday(datenum(d),BH)
            d(3) = d(3)+1;
        end
        dt = datenum(d);
        if Lag
            dLags      = (dt:1:dt+19)';
            busy_dLags = isbusday(datenum(dLags),BH);
            idx_busy   = find(busy_dLags);
            dt = dLags(idx_busy(Lag+1));
        end
        FWDM(idx) = dt;
        idx = idx+1;
    end
end
