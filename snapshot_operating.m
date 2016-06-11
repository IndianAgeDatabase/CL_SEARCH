function result = snapshot_operating(snapshot_period,xn_dim,r,r_max,dead_num,n,node,xn,sink)
keydown = waitforbuttonpress;
% ������
if (keydown == 0)
    % ��ʾ��Ϣ
    msg = msgbox('Mouse button was pressed for snapshot shooting.');
    drawnow
    waitfor(msg);
    
    % ��ͼ
    snapshot_pic_saving(r)
    
    % ��������
    snapshot_data_saving(xn_dim,r,n,node,xn,sink);
    
    % simulation report
    fprintf('round:  %d\n', r)
    fprintf('%d dead nodes\n', dead_num)
    sink.info_matrix; % dummy line
    eval('sink_info = sink.info_matrix')
    disp('--------------------------------')
    
    % ����snapshot_period������۲�
    if (r < r_max) && (snapshot_period ~= 1)
        result = question_dialog_showing(snapshot_period);
    else
        result = snapshot_period;
    end
else
    % �����������
    % ����snapshot_period������۲�
    if r < r_max
        result = question_dialog_showing(snapshot_period);
    else
        result = snapshot_period;
    end
end