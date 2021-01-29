%% Last Working Day of the Month (Date_Vector,BH,Shift)
%
% function LWDM = util_LAST_wdm(Date_Vector,BH,Shift)
%
% Inputs
% - Date vector
% - BH: Brazilian Holidays Vector
% - Shift: -10:1:10
% Output
% - LWDM: Last Working of the month (Shift) vector
%
function LWDM = util_LAST_wdm(Date_Vector,BH,Shift)
%
%% Years
YInit  = year(Date_Vector(1));
YFinal = year(Date_Vector(end));
NDays  = ((YFinal-YInit)+1)*12;
LWDM   = zeros(NDays,1);

%% Shift
if nargin < 3
    Shift = 0;
end

%% For all years
idx = 1;

for y = YInit:YFinal
    ldm = eomday(y,1:12);
    %% For all twelve months
    for m = 1:12
        d = [y m ldm(m)];
        while ~isbusday(datenum(d),BH)
            d(3) = d(3)-1;
        end
        dt = datenum(d);
        if Shift < 0
            dShifts      = (dt:-1:dt-19)';
            busy_dShifts = isbusday(datenum(dShifts),BH);
            idx_busy   = find(busy_dShifts);
            dt = dShifts(idx_busy(abs(Shift)+1));
        elseif Shift > 0
            dShifts      = (dt:1:dt+19)';
            busy_dShifts = isbusday(datenum(dShifts),BH);
            idx_busy   = find(busy_dShifts);
            dt = dShifts(idx_busy(Shift+1));
        end
        LWDM(idx) = dt;
        idx = idx+1;
    end
end