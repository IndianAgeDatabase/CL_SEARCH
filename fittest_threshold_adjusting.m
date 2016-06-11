% ���ݽڵ�--Ⱥ�׾��룬�ڵ�--BS�����ʵ�������ֵ
function result = fittest_threshold_adjusting(n,node,candidate_set,dist_node_matrix,dist_BS_vector,aleph,beta)
threshold_vector = zeros(n,1);
% �ڵ㵽��Ⱥ�׾���
node_CH = dist_node_matrix(:,candidate_set);
% �ڵ㵽ĳȺ����̾���
min_node_CH = min(node_CH,[],2);
% ��ѡ�ڵ�����
whitelist = whitelisting(n,node);

mean_node = mean(min_node_CH(whitelist,1));

mean_BS = mean(dist_BS_vector(whitelist,1));

for i = 1:n
    threshold_vector(i) = node(i).threshold * ...
        (min_node_CH(i)/mean_node)^aleph * ...
        (mean_BS/dist_BS_vector(i))^beta;
end
result = threshold_vector;