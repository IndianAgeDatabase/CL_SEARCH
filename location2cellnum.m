% input : cell���꣬��(0,0)�����ؿ��ߣ�cell�߳�
% output: cell��ţ��� 1
% cell��Ŵ�1��ʼ
function result = location2cellnum(width,height,cn_cell,cell_location)
% cell�������λ��
cell_xd = 0;
cell_yd = 0;
% horizontal cell ������
k = 1;
% ���cell���
max_cell_number = width*height/(cn_cell^2);

for i = 1:max_cell_number
    
    if isequal(cell_location,[cell_xd cell_yd]) == 1
        % ƥ�䵽��ǰlocation��ţ����ر��ֵ
        result = i;
        break
    end
    
    if k < width/cn_cell
        if cell_xd < width
            % ���º�����λ�ã�ƥ��forѭ����i��ŵ�����
            cell_xd = cell_xd + cn_cell;
            k = k + 1;
        else
            disp('Invalid cell_xd!')
            return
        end
    else
        % �ѵ�horizontal end,cell��Ŵ���һ����������¿�ʼ
        k = 1;
        if cell_yd < height
            cell_yd = cell_yd + cn_cell;
            cell_xd = 0;
        else
            disp('Invalid cell_yd!')
            return
        end
    end
end
end