% ����δ�����ڵ�Group_N_CH(set�����ڽڵ㲻����)
function result = pre_mature_group_updating(n,a,node,set)
for i = 1:n
    if (node(i).energy > 0) && ~ismember(i,set) && strcmp(node(i).type,'N')
        node(i).Group_N_CH = 1;
    elseif (node(i).energy > 0) && ~ismember(i,set) && strcmp(node(i).type,'AD')
        node(i).Group_N_CH = 1+a;
    end
end
result = node;