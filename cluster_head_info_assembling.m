function result = cluster_head_info_assembling(i,available_node_set,node)
% ���Ⱥ����Ϣ�����е�ȫ0��
zero_index = sum(node(available_node_set(i)).CH_info,2) == 0;
% ɾ��ȫ0��
node(available_node_set(i)).CH_info(zero_index,:) = [];
result = node;