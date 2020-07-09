function [B,dist] = backup_route_calculation(T,G,Z,points, source, dest,D)

[path,d] = shortestpath(T,source,dest);
B{1} = path;
dist = d;
% Calculate the probability of all the links for the nodes question in the
% path. Introduce a weighting metric which balances the probability of the
% route existing with the probability of the link existing.
% To do final evaluation. Gather 100 points on the from the distribution
% and check if the path exists for such. The probability of path existing
% is calculated by gathering the possibilities of path existing for each of
% the 100 points. Similarly for backup routes as well.
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