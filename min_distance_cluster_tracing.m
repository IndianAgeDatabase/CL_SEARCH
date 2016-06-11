% ���ص�ǰ�ڵ�Ⱥ�ţ��������Ⱥ�׵ľ���^2
function result = min_distance_cluster_tracing(i,available_node_set,node)
    % ��С�����ֵ
    min_distance_square = ...
        ( node(i).xd - node(available_node_set(1)).xd )^2 + ( node(i).yd - node(available_node_set(1)).yd )^2;
    min_distance_cluster_number = 1;
    % �Ƚϸýڵ㵽��Ⱥ�׾��룬��¼��С���롢Ⱥ��
    for j = 2:size(available_node_set,1)
        temp = min( min_distance_square,...
            ( node(i).xd - node(available_node_set(j)).xd )^2 + ( node(i).yd - node(available_node_set(j)).yd )^2 );
        if (temp < min_distance_square)
            min_distance_square = temp;
            min_distance_cluster_number = j;
        end
    end
    result = [min_distance_cluster_number min_distance_square];