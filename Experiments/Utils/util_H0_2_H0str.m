%% H0str = util_H0_2_H0str(H0)
%
%
function  H0str = util_H0_2_H0str(H0,VAL)

%% Initizalization
nl    = size(H0,1);
nc    = size(H0,2);
H0str = cell(nl,nc);
H0val = H0+2;
H0txt ={' (l)' '' ' (g)'};

%% H0 replacing
for i = 1:nl
    for j = 1:nc
        H0str{i,j} = [ num2str(VAL(i,j),'%2.3f') H0txt{H0val(i,j)} ];
    end
end
