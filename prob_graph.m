function [G_adj,points] = prob_graph(Z,S,P,D)

% The function defines the probability of links for nodes in the
% network.
% The function contains the parameters
% Z defines the mean of the Gaussian Random Variable
% S defines the covariance for the Gaussian Random Variable
% P defines the sampled Standard Gaussian Random Variable
% D defines the coverage range based on the communication technology

% The function returns
% G_adj defines the graph for the nodes in the network
% points defines the points for the node in the network

size_graph = size(Z);
N = size_graph(1);
Weight = zeros(N,N);
points = zeros(length(P),2,length(Z));
for i=1:length(Z)
    points(:,:,i) = Z(i,:)+P*reshape(S(i,:),[2,2]);
end

for i=1:N-1
    for j=i+1:N
        for k=1:length(P)
            for l=1:length(P)
                temp(k,l) = sqrt((points(k,1,i)-points(l,1,j)).^2 + (points(k,2,i)-points(l,2,j)).^2) < D;  
            end
        end
        Weight(i,j) = -log10(sum(temp, 'all')/(length(P)*length(P)));
        Weight(j,i) = Weight(i,j);
    end
end
% G_adj = zeros(N,N);
% for i=1:N
%     for j=1:N
%         if (Weight(i,j)<1)
%             G_adj(i,j) =  Weight(i,j);
%         end
%     end
% end
G_adj = graph(Weight);
end
