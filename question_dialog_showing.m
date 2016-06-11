function result = question_dialog_showing(snapshot_period)
% Construct a questdlg with two options
choice = questdlg('Reset snapshot period ?', ...
	'period changing', ...
	'Yes','No','No');
% Handle response
switch choice
    case 'Yes'
        result = snapshot_period_changing(snapshot_period);
    case 'No'
        result = snapshot_period;
    otherwise
        % ����رհ�ť
        result = snapshot_period;
end