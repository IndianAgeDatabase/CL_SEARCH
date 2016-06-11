function result = remaining_node_searching(n,n_CH,node,pre_part_set,dist_node_matrix,dist_BS_vector,aleph,beta)
post_part_set = zeros(n_CH,1);
% Ⱥ�׸���������
j = 0;
% ���ڵ�ѡ��Ⱥ����ֵ
threshold_vector = threshold_recording(n,node);
% ��ѡ�ڵ�����
whitelist = whitelisting(n,node);
mean_BS = mean(dist_BS_vector(whitelist,1));
% ���ݽڵ���BS������θ�����ֵ
threshold_vector = threshold_vector .* (mean_BS ./ dist_BS_vector).^beta;

while j < n_CH
    for i = 1:n
        % ����һ��(0,1)֮��������������ֵ�Ƚ�
        random_num = rand;
        
        if threshold_vector(i) > random_num && ...
                node(i).Group_N_CH > 0 && ...
                node(i).energy > 0 && ...
                ~ismember(i,post_part_set) && ...
                ~ismember(i,pre_part_set)
            post_part_set(j+1) = i;
            j = j + 1;
            % �޶�Ⱥ����Ŀ
            if j == n_CH
                break
            end
            
            % ���ݽڵ�--Ⱥ�׾��룬�ڵ�--BS�����ʵ�������ֵ
            if j > 1
                candidate_set = post_part_set(post_part_set ~= 0);
                threshold_vector = fittest_threshold_adjusting(n,node,candidate_set,dist_node_matrix,dist_BS_vector,aleph,beta);
            end
        end
    end
end
result = post_part_set;