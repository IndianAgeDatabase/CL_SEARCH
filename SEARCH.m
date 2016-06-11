% 1275 lines
%% notation
% SEARCH protocol
% normal node:   o
% advanced node: +
% number of CHs changes according to alive node amount:
% n_CH = ceil((n - dead_num) * P)
% update whole Group_N_CH set to 1
% iff.
% 1.all alive normal nodes have become CH one time in current epoch
% 2.all alive advanced nodes have become CH (1+a) times in current epoch

% ÿ����ǰһ��ʣ�����������㵱ǰ�ֽڵ�ƽ��ʣ������
% E_avg = remained_total_energy_array(r-1)/(n-dead_num)
% ����ʱ
% E_avg = E0*(1+a*m)
% WSN��������ȫ���ڵ�����

% ���ѡ��Ⱥ����ֵ����׼��
% �ڵ���Ⱥ�׾�������
% (min_node_CH(i)/mean_node)^aleph
% �ڵ���BS��������
% (mean_BS/dist_BS_vector(i))^beta
% ÿ��ѡ���׸�Ⱥ��ʱ�������ڵ���BS��������

%% thorough cleanup
close all
clear
clc

%% ��������
% ����¼��
prompt = {'field width(height) length:','cell length:'...
    'Cluster Head percent:','number of nodes:','advanced node ratio',...
    'additional energy factor','max number of rounds:'...
    'dimensions of unknown signal:','message bits:','sink.xd:','sink.yd:',...
    'snapshot period(rounds):','Node energy E0:'};
dlg_title = 'Field constructing';
blank_lines_size = [1 38];
def = {'100','50','0.05','100','0.2','3','8000','2','2000','50','175','1000','0.25'};
options.Resize='on';
options.WindowStyle='normal';
options.Interpreter='tex';
answer = inputdlg(prompt,dlg_title,blank_lines_size,def,options);

if sum(size(answer)) == 0
    msg = msgbox('No data input!',...
        'Oops~');
    drawnow
    waitfor(msg);

    % ����м����
    clear
    return
end

width  = str2double(answer{1,1});
height = width;

% ÿ��cell �߳�
cn_cell = str2double(answer{2,1});

% Ⱥ��ռ�ڵ������İٷֱȣ��ڵ㱻ѡΪȺ�׵���Ѹ���
P = str2double(answer{3,1});

% �ڵ����
n = str2double(answer{4,1});

% advanced node ratio
m = str2double(answer{5,1});

% additional energy factor
a = str2double(answer{6,1});

% ���غ���
r_max = str2double(answer{7,1});

% δ֪�ź�ά��
xn_dim = str2double(answer{8,1});

% δ֪�źű�����
signal_bit = str2double(answer{9,1});

% ����λ����Ϣ
sink = struct(...
    'xd', 0,...
    'yd', 0,...
    'info_matrix', zeros((width/cn_cell)^2,xn_dim + 1));

% ���޺�����
sink.xd = str2double(answer{10,1});

% ����������
sink.yd = str2double(answer{11,1});

% snapshot ����
snapshot_period = str2double(answer{12,1});

% ��ʼ����
E0 = str2double(answer{13,1});

%% ������������
% �����ڵ����
dead_num = 0;

% Eelec = Etx = Erx
% �����ڵ㴫��(radio expends����������)�����1 bit�źźķѵ�����
Eelec = 50*0.000000001;

% d < d0, free space model
% Etx = signal_bit * (Eelec + Efs * d^2)
Efs = 10*0.000000000001;

% d > d0, multipath model
% Etx = signal_bit * (Eelec + Emp * d^4)
Emp = 0.0031*0.000000000001;

% ����Ⱥ���ں�1 bit�źźķѵ�����
EDA = 5*0.000000001;

% ����d0^2,�ܺ�ģ�Ͳ��ղ���
d0_square = Efs/Emp;

% δ֪�źţ����е�һ��Ԫ�ر�ʶcell���
xn = [(1:(width/cn_cell)^2)' rand((width/cn_cell)^2,xn_dim)];

% network life time
x_round_array = (1:r_max)';
y_alive_node_array = zeros(r_max,1);

% throughput
y_packets_BS_array = zeros(r_max,1);

% total energy dissipated
initial_total_energy = n*E0*(1+a*m);
remained_total_energy_array = zeros(r_max,1);

% cluster head amount
n_CH_array = zeros(r_max,1);

%%
rng(0)

% �ڵ���Ⱥ�׾���ָ��
aleph = 1.4;

% �ڵ���BS����ָ��
beta  = 2.6;

%% ��ʾ��Ϣ
instruction_showing(snapshot_period)
disp('SEARCH protocol')
fprintf('m = %1.1f\n',m)
fprintf('aleph = %1.1f\n',aleph)
fprintf('beta  = %1.1f\n',beta)
fprintf('\n')

%% ����LEACH����
% ��������ڵ�
% advanced node set
advanced_node_set = randperm(n,floor(m*n))';
node = node_generating(width,height,cn_cell,P,n,a,E0,xn,advanced_node_set);

% ���ڵ�λ��
location_matrix = location_recording(n,node);
% ���ڵ�֮�����
dist_node_matrix = node_ranging(n,location_matrix);
% ���ڵ㵽BS����
dist_BS_vector = BS_ranging(n,location_matrix,sink);

%% LEACH operating
for r = 1:r_max
    %% �����һ�ֲ�����Ϣ
    % �����һ�ֽڵ��¼��Ⱥ�����ͣ�Ⱥ����Ϣ����
    node = clear_node_type(n,node,advanced_node_set);
    % ���������Ϣ����
    sink.info_matrix = zeros((width/cn_cell)^2,xn_dim + 1);
    % �趨Ⱥ�׸���
    n_CH = ceil((n - dead_num) * P);
    
    %% ѡ�����Ÿ��� n_CH = ceil((n - dead_num) * P) ��Ⱥ��
    % ����Ⱥ����ֵ
    node = threshold_deciding(r,P,n,m,a,E0,node,advanced_node_set,remained_total_energy_array,dead_num);
    
    if n_CH > 0
        %         if r < R
        group_counter = group_counting(n,node);
        if group_counter > n_CH
            % ��Ѱ����Ҫ��Ľڵ��ż���
            available_node_set = ...
                available_node_searching(n,n_CH,node,dist_node_matrix,dist_BS_vector,aleph,beta);
        elseif group_counter == n_CH
            available_node_set = ...
                relax_available_node_searching(n,group_counter,node);
        else
            % ���㹻Ⱥ�׽ڵ��ѡ(�ڵ�����δ�ľ�����1/P�غ���������Ⱥ��)
            if group_counter > 0
                % 1/P�غ���δ��Ⱥ�׵Ľڵ��ѡ��Ⱥ��
                pre_part_set = ...
                    relax_available_node_searching(n,group_counter,node);
                
                % ��������Groupֵ
                node = pre_mature_group_updating(n,a,node,pre_part_set);
                
                % �����²���ѡ��ʣ��Ⱥ��
                post_part_set = ...
                    remaining_node_searching(n,n_CH - length(pre_part_set),node,pre_part_set,dist_node_matrix,dist_BS_vector,aleph,beta);
                available_node_set = [pre_part_set;post_part_set];
            else
                % group_counter == 0,��������Groupֵ
                node = pre_mature_group_updating(n,a,node,[]);
                group_counter = group_counting(n,node);
                if group_counter >= n_CH
                    % ��Ѱ����Ҫ��Ľڵ��ż���
                    available_node_set = ...
                        available_node_searching(n,n_CH,node,dist_node_matrix,dist_BS_vector,aleph,beta);
                else
                    % �޺�ѡ�ڵ㣬WSN��ֹ����
                    termination_dialog_showing(r,dead_num)
                    
                    y_alive_node_array(r:end,1) = y_alive_node_array(r-1);
                    y_packets_BS_array(r:end,1) = y_packets_BS_array(r-1);
                    remained_total_energy_array(r:end,1) = remained_total_energy_array(r-1);
                    total_energy_dissipated_array = -diff([initial_total_energy;remained_total_energy_array]);
                    WSN_parameters_plotting(x_round_array,y_alive_node_array,y_packets_BS_array,total_energy_dissipated_array,n_CH_array)
                    
                    % ����м����
                    clearvars -except available_node_set node signal_bit sink xn...
                        x_round_array y_alive_node_array y_packets_BS_array total_energy_dissipated_array n_CH_array
                    return
                end
            end
        end
        %         else
        %             % ʵ��round��������ֵ��ÿ��ƽ���ܺ�E_avg�޷�����
        %             disp('R overloading.')
        %             fprintf('\n')
        %             R_tag = 0;
        %
        %             % ��¼�غ���Ϣ
        %             y_alive_node_array(r:end,1) = y_alive_node_array(r-1);
        %             y_packets_BS_array(r:end,1) = y_packets_BS_array(r-1);
        %             remained_total_energy_array(r:end,1) = remained_total_energy_array(r-1);
        %             break
        %         end
    else
        % �����ڵ���࣬WSNֹͣ����
        termination_dialog_showing(r,dead_num)
        
        y_packets_BS_array(r:end,1) = y_packets_BS_array(r-1);
        total_energy_dissipated_array = -diff([initial_total_energy;remained_total_energy_array]);
        WSN_parameters_plotting(x_round_array,y_alive_node_array,y_packets_BS_array,total_energy_dissipated_array,n_CH_array)
        
        % ����м����
        clearvars -except available_node_set node signal_bit sink xn...
            x_round_array y_alive_node_array y_packets_BS_array total_energy_dissipated_array n_CH_array
        return
    end
    
    % ���·���Ⱥ��Ҫ��Ľڵ���Ϣ
    node = available_node_updating(available_node_set,node);
    
    %% ͼʾ
    figure(1);
    clf
    hold on
    
    % ��cellΪ��λ���ֳ���
    field_ploting(width,height,cn_cell)
    title(['SEARCH round: ' num2str(r) '  nCH: ' num2str(length(available_node_set))],'FontSize',13,'FontName','Times New Roman')
    
    %% Ⱥ������
    cluster_head_partitioning(available_node_set,node)
    
    %% �ڵ�ͽ���Ⱥ����Ⱥ�״�����Ϣ
    node = ...
        node_operating(n,available_node_set,d0_square,signal_bit,Eelec,Efs,Emp,node);
    
    %% Ⱥ�������޴�����Ϣ
    for i = 1:length(available_node_set)
        % ���Ⱥ����Ϣ����0ֵ
        node = cluster_head_info_assembling(i,available_node_set,node);
        
        % Ⱥ�������޴�����Ϣ
        sink = ...
            cluster_head_info_propagating(i,available_node_set,node,sink);
        
        % Ⱥ���ܺ�
        node = ...
            cluster_head_energy_dissipating(i,available_node_set,d0_square,signal_bit,Eelec,EDA,Efs,Emp,node,sink);
        
        % ��Ϣ������ɣ���Ⱥ������������Ա�ע
        if node(available_node_set(i)).energy <= 0
            node_ploting(available_node_set(i),node)
        end
    end
    
    %% ��¼�����ڵ���Ϣ
    for i = 1:n
        % ͨ���ڵ������ж��Ƿ��ֲ����������ڵ㣬��¼�����ڵ�����
        if (node(i).energy <= 0 ) && (strcmp(node(i).type,'Dead') == 0)
            node(i).type = 'Dead';
            node(i).cluster_number = 0;
            node(i).Group_N_CH = -1;
            node(i).info = zeros(1,xn_dim + 1);
            node(i).CH_info = [];
            node(i).member_amount = 0;
            dead_num = dead_num + 1;
            
            % first blood
            if dead_num == 1
                first_dead_node_dialog_showing(r)
            end
        end
    end
    
    %% ��¼�غ���Ϣ
    y_alive_node_array(r) = n - dead_num;
    
    if r > 1
        y_packets_BS_array(r) = y_packets_BS_array(r-1) + length(available_node_set);
    elseif r == 1
        y_packets_BS_array(r) = n_CH;
        % vigil of a sentinel
    else
        y_packets_BS_array(r) = -1;
    end
    
    remained_total_energy_array(r) = total_energy_calculating(n,node);
    n_CH_array(r) = length(available_node_set);
    
    %% snapshot for every snapshot_period rounds
    if mod(r,snapshot_period) == 0
        % �ɸ���snapshot_period�Է���۲�
        snapshot_period = ...
            snapshot_operating(snapshot_period,xn_dim,r,r_max,dead_num,n,node,xn,sink);
    end
end
% ��ע����λ��
% plot(sink.xd,sink.yd,'*',...
%     'LineWidth',2,...
%     'MarkerEdgeColor','b',...
%     'MarkerSize',13);

%% simulation report
total_energy_dissipated_array = -diff([initial_total_energy;remained_total_energy_array]);
WSN_parameters_plotting(x_round_array,y_alive_node_array,y_packets_BS_array,total_energy_dissipated_array,n_CH_array)

fprintf('maximum number of rounds: %d\n', r_max);
fprintf('number of nodes:          %d\n', n);
fprintf('number of Cluster Heads:  %d\n', length(available_node_set));
fprintf('death toll:               %d\n', dead_num);

%% ����м����
clearvars -except E0 advanced_node_set available_node_set a m node signal_bit sink xn...
    x_round_array y_alive_node_array y_packets_BS_array total_energy_dissipated_array n_CH_array