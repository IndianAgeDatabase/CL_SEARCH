function termination_dialog_showing(r,dead_num)
% �����ڵ���࣬LEACHֹͣ����
msg = warndlg({'Too much dead nodes !';'';'LEACH terminated.'});
drawnow
waitfor(msg);
disp('Too much dead nodes!')
fprintf('current round:  %d\n', r)
fprintf('%d dead nodes\n', dead_num)