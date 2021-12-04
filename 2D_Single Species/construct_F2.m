function F = construct_F2(solution, variableLocation, Dx)
%--- This function returnes the value of the F2 component of ODE vector field. The ordering is in x1 direction.

global D 
sigma_squared = D(2,2);

N = reshape(solution(:,:,1), [], 1);

solution_minusTwo = circshift(solution,[0 2 0]); % solution(i,j-2)  circshift also applies the periodic boundary condition
solution_minusOne = circshift(solution,[0 1 0]); % solution(i,j-1)  
solution_plusOne = circshift(solution,[0 -1 0]); % solution(i,j+1)  
solution_plusTwo = circshift(solution,[0 -2 0]); % solution(i,j+2)

dS = ( -solution_plusTwo + 8*solution_plusOne - 8*solution_minusOne + solution_minusTwo ) / (12 * Dx);
dN = reshape(dS(:,:,1), [], 1);
dQ = reshape(dS(:,:,2), [], 1);
dV = reshape(dS(:,:,3), [], 1);

d2S = ( -solution_plusTwo + 16*solution_plusOne - 30*solution + 16*solution_minusOne - solution_minusTwo ) / (12 * Dx^2);
d2S = permute(d2S,[3,1,2]); % reorders 3-dim array d2S so that linear indexing d2S(:) corresponds to current ordeing in U

F = d2S(:);
F(variableLocation(1,:)) = F(variableLocation(1,:)) * sigma_squared;
F(variableLocation(2,:)) = ( F(variableLocation(2,:)) + 2 * dN .* dQ ./ N ) * sigma_squared;
F(variableLocation(3,:)) = ( F(variableLocation(3,:)) + 2 * dN .* dV ./ N + 2 * dQ.^2 ) * sigma_squared;

end