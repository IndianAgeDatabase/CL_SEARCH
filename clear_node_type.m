function result = clear_node_type(n,node,advanced_node_set)
for i = 1:n
    % �����һ�ֽڵ��¼��Ⱥ�����ͣ�Ⱥ����Ϣ����Ⱥ��Ա��Ŀ
    if strcmp(node(i).type,'CH') == 1
        if ismember(i,advanced_node_set)
            node(i).type = 'AD';
        else
            node(i).type = 'N';
        end
        node(i).CH_info = [];
        node(i).member_amount = 1;
    end
end

% ÿ1/Pnrm�ָ���Group_N_CH
% if mod(r,(1+a*m)/P) == 1
%     for i = 1:n
%         if (node(i).energy > 0) && strcmp(node(i).type,'N')
%             node(i).Group_N_CH = 1;
%         elseif (node(i).energy > 0) && strcmp(node(i).type,'AD')
%             node(i).Group_N_CH = 1+a;
%         end
%     end
% end
result = node;