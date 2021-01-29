%% EARN = util_sign_2_earn(SignH,Ret)
%
%  SignH: return value sign prediction
%  Ret:   return values
%
%  EARN: total earn
%
function EARN = util_sign_2_earn(SignH,Ret)
EARN = SignH'*Ret;
