function result = available_node_updating(available_node_set,node)
for i = 1:length(available_node_set)
    % Ϊ���������Ľڵ�����Ⱥ�ײ���
    node(available_node_set(i)).type = 'CH';
    node(available_node_set(i)).Group_N_CH = ...
        node(available_node_set(i)).Group_N_CH - 1;
    node(available_node_set(i)).cluster_number = i;
    % �ڵ�Ⱥ����Ϣ�����¼������Ϣ�����ܺģ�
    node(available_node_set(i)).CH_info(node(available_node_set(i)).info(1),:) = ...
        node(available_node_set(i)).info;
end
result = node;