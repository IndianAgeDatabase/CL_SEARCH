function result = ...
    node_operating(n,available_node_set,d0_square,signal_bit,Eelec,Efs,Emp,node)
for i = 1:n
    if (node(i).energy > 0) && ~ismember(i,available_node_set)
        % �ڵ���Ⱥ
        node = ...
            node_clustering(i,available_node_set,d0_square,signal_bit,Eelec,Efs,Emp,node);
        
        % ��ע�ڵ�
        node_ploting(i,node)
        
    elseif (node(i).energy <= 0) && ~ismember(i,available_node_set)
        % �ڵ������Ѻľ�������ע
        node_ploting(i,node)
    else
        % ��עȺ��
        cluster_head_ploting(i,node)
    end
end
result = node;