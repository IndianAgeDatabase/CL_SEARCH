% �������أ����ֵ�λcell
function field_ploting(width,height,cn_cell)
% ���������᷶Χ
axis([0 width 0 height]);

% ����������̶�
label_scale = cn_cell:cn_cell:width;
set(gca,'xtick',[0 label_scale])
set(gca,'ytick',label_scale)

box on
grid on

% ���ñ���ɫΪ��ɫ
% set(gcf,'color',[1 1 1])