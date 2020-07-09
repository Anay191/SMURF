function [Z,S,P] = my_scatter(N, L, coverage_range)

% Defines the randomised number and positions for the nodes in
% the graph based on a Poisson Point Process

% N defines the lambda for Poisson Point Process
% L defines the length of the side of the sqaure Area
% coverage_range defines the length of the communication based
% on the communication technology

% The return values contain,
% Z defines the means for the Gaussian Random Variable for the nodes in the network
% S defines the covariance i.e. the uncertainty regarding positions based on Kalman
% filtering based tracking systems
% P defines the sampled Standard Gaussian Random Variable

npoints = poissrnd(N);
Z = rand(npoints, 2)*L;
for i=1:npoints
    s = rand(1,3);
    S(i,1) = s(1);
    S(i,2) = s(2);
    S(i,3) = s(2);
    S(i,4) = s(3);
end
P = mvnrnd([0,0],eye(2),1000);
end
