function [T,dist,prev] = spanning_tree_prob(G,Z,points,source,D)

% The function defines the spanning tree based on the probability of existence 
% of links

% The function parameters are
% G defines the graph of the nodes in the network
% Z defines the mean of the Gaussian Random Variable
% points defines the points for all the nodes in the network
% source defines the source of the spanning tree
% D defines the communication range based on the communication
% technology
Q = [];
dist = zeros(1,height(G.Nodes));
prev = zeros(1,height(G.Nodes));
for i=1:height(G.Nodes)
    dist(i) = inf;
    prev(i) = 0;
    Q(i) = i;
end
dist(source) = 0;

while ~isempty(Q)
    temp = zeros(1,length(Q));
    for i=1:length(Q)
        temp(i) = dist(Q(i));
    end
    [min_dist,ind] = min(temp);
    node = Q(ind);
    Q(Q==node) = [];
    neighbours = neighbors(G,node)';
    for i=1:length(neighbours)
        if node == source
            val = G.Edges.Weight(findedge(G,node,neighbours(i)));
            %             val = -log10(sum(sqrt((points(:,1,i)-points(:,1,j)).^2 + (points(:,2,i)-points(:,2,j)).^2) < D)/length(P));
        else
            prev_node = prev(node);
            temp=0;
            if (prev_node~=0)
                for k=1:length(points)
                    for l=1:length(points)
                        if (sqrt((points(k,1,prev_node)-points(l,1,node)).^2 + (points(k,2,prev_node)-points(l,2,node)).^2) < D)
                            if(sqrt((points(k,1,neighbours(i))-points(l,1,node)).^2 + (points(k,2,neighbours(i))-points(l,2,node)).^2) < D)
                                temp = temp+1;
                            end
                        end
                    end
                end
                val = -log10(temp/(length(points)*length(points)));
            else
                val = inf;
            end
            %             val = conditional_link_probability(p1,p2,p3,Z(prev_node,:),cov1,Z(node,:),cov2,Z(neighbours(i),:),cov3);
        end
        alt = min_dist + val;
        if alt < dist(neighbours(i))
            dist(neighbours(i)) = alt;
            prev(neighbours(i)) = node;
        end
    end
end
a = zeros(length(Z),length(prev));
for i=1:length(Z)
    for j=1:length(prev)
        if(j~=0)
            if(prev(j)==i)
                a(i,j) = dist(j)-dist(i);
                a(j,i) = dist(j)-dist(i);
            end
        end
    end
end
T = graph(a);
end

