function snapshot_pic_saving(r)
%% ��ȡͼ��
% ��ȡ�����������ݵ�ͼ��
% gcf: get current figure
% F_window=getframe(gcf);

%% ��ָ���
file_name = ...
    sprintf('round %d',r);
% imwrite(F_window.cdata,strcat(eval('file_name'),'.fig'))
saveas(gcf,strcat(eval('file_name'),'.fig'))