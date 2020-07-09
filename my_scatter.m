%====== code =====
function [Z,S,P] = my_scatter(N, L, coverage_range)
% ref input 50,50,20
% non-overlap distance > 5
% coverage_range ; % the shorter, the deeper tree
% == random coordination ==
% distinct_BOUND = 2;
% Z = zeros(N,2);
% X = rand(1,1)*L;
% Y = rand(1,1)*L;
% X = poissrnd(L);
% Y = poissrnd(L);
% s1 = rand(2);
% % s1 = s*s';
% T = [X Y];
% Z(1,:) = T;
% S(1,:) = reshape(s1,[1,4]);
% for i = 2:N
%     u = true;
%     v = false;
%     s2 = rand(2);
% %     s2 = s*s';
%     while u || v
%         %         X = rand(1,1)*L;
%         %         Y = rand(1,1)*L;
%         X = poissrnd(L);
%         Y = poissrnd(L);
%         U = [X Y];
%         % u is true if new added node is too far to all node
%         u = true;
%         for j = 1:i-1
%             if pdist([U;Z(j,:)],'euclidean') < coverage_range
%                 u = false;
%             end
%         end
%         % v is true if if new added node is too near to one node
%         v = false;
%         for j = 1:i-1
%             if pdist([U;Z(j,:)],'euclidean') < distinct_BOUND
%                 v = true;
%             end
%         end
%     end
%     Z(i,:) = U;
%     S(i,:) = reshape(s2,[1,4]);
% end

% == figure raw nodes ==
% figure;
% scatter(Z(:,1),Z(:,2));
% s = sprintf('N-%d,L-%d, cr-%d nodes', N, L, coverage_range);
% title(s);

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