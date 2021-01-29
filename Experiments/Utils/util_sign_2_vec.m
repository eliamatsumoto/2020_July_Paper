%% VC = util_sign_2_vec(sg)
%
function VC = util_sign_2_vec(sg)
aux = (sg+2)';
ind = find(aux==3);
aux(ind) = 2;
VC = full(ind2vec(aux));