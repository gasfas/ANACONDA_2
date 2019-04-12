function [figure_handle] = show_info_window(dlt, figure_handle)
% Create or update a figure window that shows info about the DLT instance
% and its data.
%
% This was initially implemented for CovarianceAnalysis.m but moved here
% since it could be independently useful.
%
% PARAMETERS
%  figure_handle  (default: open a new figure) which figure to put the GUI items in
% RETURNRS
%  figure_handle
%
% AUTHOR
%  Erik Månsson, 2010--2015, erik.mansson@sljus.lu.se, erik.mansson@ifn.cnr.it

if nargin < 2
  figure_handle = -1;
end

if ~ishandle(figure_handle) % launch a new info window
  width = 500; height = 270;
  figure_handle = figure('Position', [100 100 width height]);
else
  pos = get(figure_handle, 'Position');
  width = pos(3); height = pos(4);
  % To use the same code for new and updated window, remove all old controls first
  info_handles = guidata(figure_handle);
  controls = fieldnames(info_handles);
  for i = 1:length(controls)
    if ishandle(info_handles.(controls{i}))
      delete(info_handles.(controls{i}));
    end
  end
  figure(figure_handle);
end
set(figure_handle, 'NumberTitle','off', 'Name', sprintf('DLT info: %s', dlt.filename), 'MenuBar','none');

% s = 2; % separator spacing
% lineheight = 20;
s = 0.008; % separator spacing
lineheight = 0.068; width = 1; height = 1;
set(figure_handle,'Units','normalized');

x = lineheight/2; width = width - lineheight;
y = height;
info_handles = struct();
y = y - s - lineheight;
info_handles.filepath = uicontrol(figure_handle, 'Style','text', 'HorizontalAlignment','left', 'Units','normalized', ...
      'String', ['Filename: ' dlt.directory dlt.filename], 'Position', [x,y,width,lineheight-s]);

y = y-lineheight;
if isempty(dlt.acquisition_end_num) % footer not read
  end_str = '<footer not read>';
else
  end_str = datestr(dlt.acquisition_end_num, 'yyyy-mm-dd HH:MM');
end
info_handles.start = uicontrol(figure_handle, 'Style','text', 'HorizontalAlignment','left', 'Units','normalized', ...
      'String', sprintf('Acquired: %s   to   %s,      duration %.0fh:%02.0fmin:%02.0fs   (%.3f s)', ...
          datestr(dlt.acquisition_start_num, 'yyyy-mm-dd HH:MM'), end_str, ...
          floor(dlt.acquisition_duration/3600), mod(floor(dlt.acquisition_duration/60),60), mod(dlt.acquisition_duration,60), dlt.acquisition_duration), ...
      'Position', [x,y,width,lineheight-s]);

if dlt.readoption__keep_empty
  if dlt.discarded_kept
    kept = '(may be discarded, not empty)';
  else
    kept = '(neither empty nor discarded)';
  end
else
  if dlt.discarded_kept
    kept = '(may be empty or discarded)';
  else
    kept = '(may be empty, not discarded)';
  end
end
y = y-lineheight;
info_handles.counts = uicontrol(figure_handle, 'Style','text', 'HorizontalAlignment','left', 'Units','normalized', ...
      'String', sprintf('Loaded events %s: %d out of %d groups in file.', kept, dlt.event_count, dlt.counters_foot.number_of_groups), ...
      'Position', [x,y,width,lineheight-s]);
y = y-lineheight;
info_handles.counts = uicontrol(figure_handle, 'Style','text', 'HorizontalAlignment','left', 'Units','normalized', ...
      'String', sprintf('Loaded hits per detector: %s. Max %d hits/ch, range %.0f to %.0f ns.', mat2str(dlt.get_hit_count(':')'), ...
      dlt.hardware_settings.max_hits_per_channel, dlt.hardware_settings.group_range_start/1E-9, dlt.hardware_settings.group_range_end/1E-9), ...
      'Position', [x,y,width,lineheight-s]);

detector_str = '';
for d = 1:length(dlt.detectors)
  detector_str = sprintf('%s,  #%d:%s', detector_str, d, dlt.detectors{d}.char);
end
if ~isempty(detector_str)
  detector_str = detector_str(4:end); % skip initial comma and spaces
end
y = y-lineheight*2;
info_handles.detectors = uicontrol(figure_handle, 'Style','text', 'HorizontalAlignment','left', 'Units','normalized', ...
      'String', ['Detector ' detector_str '.'], 'Position', [x,y,width,lineheight*2-s]);

if dlt.has_read_foot
  y = y-lineheight*7+s;
  info_handles.comment = uicontrol(figure_handle, 'Style','edit', 'Max',7, 'Enable','on', 'HorizontalAlignment','left', 'Units','normalized', ...
        'Tooltip','Comment', 'String', dlt.comment, 'Position', [x,y,width*0.7,lineheight*7-s]);
  info_handles.classes_saved = uicontrol(figure_handle, 'Style','text', 'HorizontalAlignment','left', 'Units','normalized', ...
        'String', ['Classes saved: ' strrep(dlt.description_of_event_classes_saved, ', ', sprintf(', \n'))], 'Position', [x+width*0.7+s,y,width*0.3-s,lineheight*7-s]);
else
  y = y-lineheight;
  if isempty(dlt.has_read_foot)
    status = '<Incomplete info, since file footer has not been read>';
  else
    status = '<Incomplete info, since reading of file footer failed>';
  end
  info_handles.comment = uicontrol(figure_handle, 'Style','text', 'HorizontalAlignment','left', 'Units','normalized', ...
        'String', status, 'Position', [x,y,width*0.7,lineheight-s], 'FontWeight','bold');
  info_handles.classes_saved = [];
end

% The last line has buttons
y = y-lineheight-s*2;
if ~dlt.is_loaded_data_current
  info_handles.read = uicontrol(figure_handle, 'Style','pushbutton', 'HorizontalAlignment','left', 'Units','normalized', ...
        'Tooltip', 'Read the body of the file into memory now', 'String', 'Load', 'Position', [x,y,width*0.14,lineheight+s], 'Callback', @(o,e,h) [dlt.read(), dlt.show_info_window(figure_handle)]);
  x = x + width*0.15;
end
info_handles.export = uicontrol(figure_handle, 'Style','pushbutton', 'HorizontalAlignment','left', 'Units','normalized', ...
      'Tooltip', 'Export as variable "dlt" in workspace', 'String', 'To workspace', 'Position', [x,y,width*0.24,lineheight+s], 'Callback', @(o,e,h) assignin('base','dlt', dlt) );
      % Because assignin has no output, it doesn't seem possible to append a second second command evalin('base','dlt.char') -- without making a named function that contains the two statements.
x = x + width*0.25;
if dlt.log_anomaly_histogram
  for d = 1:length(dlt.detectors)
    if isa(dlt.detectors{d}, 'DetDLD80') % the class with a show_TOF_anomaly_histogram method
      info_handles.(sprintf('anomaly%d',d)) = uicontrol(figure_handle, 'Style','pushbutton', 'HorizontalAlignment','left', 'Units','normalized', ...
        'Tooltip', sprintf('View TOF anomaly histogram for detector #%d', d), 'String', sprintf('View anomaly #%d', d), 'Position', [x,y,width*0.24,lineheight+s], 'Callback', @(o,e,h) [figure; dlt.detectors{d}.show_TOF_anomaly_histogram(dlt)] );
      x = x + width*0.25;
    end
  end
end
% Use the "Windows"-shade of gray for background also for figure
set(figure_handle, 'Color', get(info_handles.filepath,'BackgroundColor'))

guidata(figure_handle, info_handles); % store the handles of controls within the window
