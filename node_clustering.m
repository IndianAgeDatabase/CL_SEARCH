function result = ...
    node_clustering(i,available_node_set,d0_square,signal_bit,Eelec,Efs,Emp,node)
% ���ص�ǰ�ڵ�Ⱥ�ţ��������Ⱥ�׵ľ���
min_distance_cluster_block = ...
    min_distance_cluster_tracing(i,available_node_set,node);

min_distance_cluster_number = min_distance_cluster_block(1);
min_distance_square = min_distance_cluster_block(2);

% �ڵ��������Ⱥ�ţ���Ⱥ�״�����Ϣ
node(i).cluster_number = min_distance_cluster_number;
node(available_node_set(min_distance_cluster_number)).CH_info(node(i).info(1),:) = ...
    node(i).info;
% Ⱥ��ͳ��Ⱥ��Ա��Ŀ
node(available_node_set(min_distance_cluster_number)).member_amount = ...
    node(available_node_set(min_distance_cluster_number)).member_amount + 1;

% �ڵ��ܺ�
node = ...
    node_energy_dissipating(i,min_distance_square,d0_square,signal_bit,Eelec,Efs,Emp,node);
result = node;