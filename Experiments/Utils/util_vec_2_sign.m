%% VC = util_vec_2_sign(vc)
%
function SG = util_vec_2_sign(vc)
SG  = (vec2ind(vc)-1)';
ind = find(SG == 0);
SG(ind) = -1;
