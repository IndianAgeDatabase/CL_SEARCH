function result = node_generating(width,height,cn_cell,P,n,a,E0,xn,advanced_node_set)
for i=1:n
    % �ڵ㣨������ɣ�
    xd = rand * width;
    yd = rand * height;
    cell_location = [ floor(xd/cn_cell)*cn_cell floor(yd/cn_cell)*cn_cell ];
    cell_number = location2cellnum(width,height,cn_cell,cell_location);
    
    node(i) = struct(...
        'xd', xd,...% ������
        'yd', yd,...% ������
        'energy', E0,...% �ڵ�����
        'type', 'N',...% �ڵ�����(Ⱥ�� or ��ͨ�ڵ� or �����ڵ�)
        'cluster_number', 1,...% �ڵ�Ⱥ��
        'Group_N_CH', 1,...% ��Ⱥ�׼���(0: �����ڷ�Ⱥ�׼���; ��0: ���ڷ�Ⱥ�׼���)
        'info', xn(cell_number,:),...% �ڵ���Ϣ���飬��һ��Ԫ�ر�ʾ�ڵ�����cell�ı��
        'CH_info', [],...% �ڵ㱻ѡ��Ⱥ�׵���Ϣ����
        'member_amount', 1,...% Ⱥ�ڽڵ���Ŀ
        'threshold', P);
end

% ���� advanced node ��ʼ�������ڵ�����
for i = 1:length(advanced_node_set)
    node(advanced_node_set(i)).energy = (1+a)*E0;
    node(advanced_node_set(i)).type = 'AD';
    % �� advanced node �� 1 epoch �ڽ�(1+a)�γ�ΪȺ��
    node(advanced_node_set(i)).Group_N_CH = 1+a;
end
result = node';