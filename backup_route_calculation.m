function [B,dist] = backup_route_calculation(T,G,Z,points, source, dest,D)

% The function defines backup route for the primary route defined by the 
% spanning tree.

% The function parameters are
% T defines the spanning tree for the nodes in the network
% G defines the graph for the nodes in the network
% Z defines the mean for the Gaussian Random Variable
% points define the points for the nodes in the network
% source defines the source for the spanning tree
% dest defines the destination for the routing path
% D defines the communication range based on the communication technology

% The function returns
% B defines the backup routes for the primary route defined by the spanning tree
% dist defines the distance for the routes

[path,d] = shortestpath(T,source,dest);
B{1} = path;
dist = d;
for i=2:length(path)
    for k=1:length(points)
        for l=1:length(points)
            temp(k,l) = sqrt((points(k,1,path(i-1))-points(l,1,path(i))).^2 + (points(k,2,path(i-1))-points(l,2,path(i))).^2) > D;
        end
    end
    prob = -log10(sum(temp, 'all')/(length(points)*length(points)));
    F = rmedge(G,path(i-1),path(i));
    [eid, nid] = outedges(G,path(i));
    nid(nid==path(i-1)) = [];
    eid(nid==path(i-1)) = [];
    temp=0;
    for j=1:length(nid)
        for k=1:length(points)
            for l=1:length(points)
                if (sqrt((points(k,1,path(i-1))-points(l,1,path(i))).^2 + (points(k,2,path(i-1))-points(l,2,path(i))).^2) > D)
                    if(sqrt((points(k,1,path(i-1))-points(l,1,nid(j))).^2 + (points(k,2,path(i-1))-points(l,2,nid(j))).^2) < D)
                        temp = temp+1;
                    end
                end
            end
        end
        F.Edges.Weight(eid(j)) = -log10(sum(temp, 'all')/(length(points)*length(points)));
    end
    T=spanning_tree_prob(F,Z,points,source,D);
    [altpath,alt_d] = shortestpath(T,source,dest);
    B{i} = altpath; 
    dist = [dist,alt_d+prob];
end
end
