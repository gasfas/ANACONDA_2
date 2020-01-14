function [ factor, t0 ] = TOF_2_m2q (exp, calib_md)
% This macro semi-automizes the calibration procedure for the TOF to m2q
% conversion factor.
% Input:
% exp		The experimental data
% calib_md	The calibration metadata.
% Output:
% factor	The conversion factor
% t0		The time-zero shift [ns].
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

disp('This macro semi-automizes the calibration procedure for the TOF to m2q conversion factor.')

search_radius		= calib_md.findpeak.search_radius;
satisfied           = false;
TOF_signal			= eval(['exp.' calib_md.TOF.hist.pointer{:}]);
% Fetch the data and metadata that are relevant:

while ~satisfied
    % First plot the full TOF spectrum:
	[h_TOFfig, h_TOFax, h_TOFGrO] = macro.plot.create.plot(exp, calib_md.TOF);
    
            nof_points          = inputdlg('Please give the number of identified peaks in the spectrum: ');
            nof_points          = str2double(nof_points{1});
            TOF_cs              = zeros(nof_points, 1);
            m2q_points          = zeros(nof_points, 1);
            m2q_names           = cell(nof_points, 1);
            click_msg           = 'please click on an identified peak';
            rescale_msg         = 'please rescale the figure if needed';



            for i = 1:nof_points
               msgbox_handle_rescale= msgbox(rescale_msg);
                pause;
                msgbox_handle_click=msgbox(click_msg);
                title(click_msg);
                % Ask for x-value for peak:
                axes(h_TOFax)
                [TOF_c, ~]      = ginput(1);
                %TOF_peaks_click = TOF_peaks_click(1,:);
                %plot.vline ([TOF_c-search_radius TOF_c TOF_c+search_radius], {'k--', 'k-', 'k--'}, {'.', 'TOF peak', '.'})

                TOF_cs(i)       = TOF_c;
                m2q_point = inputdlg('Please give the corresponding m/q value: ');               
                m2q_points(i,1) = str2double(m2q_point);
                m2q_names{i}     = m2q_point{:};
                  % calculate the factors from these inputs:
           
            end
            delete(msgbox_handle_rescale)
            delete(msgbox_handle_click)
            Hist.Count = h_TOFGrO.YData'; Hist.midpoints = h_TOFGrO.XData';
            [ TOF_peaks ]   = calibrate.find_TOF_peaks (Hist, TOF_cs, search_radius);
           
            [ factor, t0 ]  = calibrate.TOF_2_m2q (TOF_peaks, m2q_points)
%         case 'electron'
%           
    % calculate the factors from these inputs:
	Hist.Count = h_TOFGrO.YData'; Hist.midpoints = h_TOFGrO.XData';
    [ TOF_peaks ]   = calibrate.find_TOF_peaks (Hist, TOF_cs, search_radius);
    [ factor, t0 ]  = calibrate.TOF_2_m2q (TOF_peaks, m2q_points)
    
    % show them in a plot:
	calib_md.m2q.axes.XLim(2) = max([calib_md.m2q.axes.XLim(2), 1.2*m2q_points(i)]);
    m2q = convert.TOF_2_m2q(TOF_signal, factor, t0);% show them in a plot:
    [h_m2qfig, h_m2qax, h_m2qGrO] = plot.quickhist(m2q, 'plot_md', calib_md.m2q);
    plot.vline(m2q_points, repmat({'k'},1,nof_points), m2q_names)
    grid minor
    
    % Is the user satsfied?
    satisfied       = input('Is this conversion as pleased (1 means yes, 0 means no)');
    try close(h_TOFfig); close(h_m2qfig); catch; end
	
end
