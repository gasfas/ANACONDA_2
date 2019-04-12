% Displays an annoted diagram of TOF anomaly, if its logging was enabled while reading.
%
% The "TOF anomaly" TOF_y - TOF-x, where TOF_x = (T_X1+T_X2)/2
% and TOF_y = (T_y1+T_y2)/2, is used to decide whether a hit is valid
% (i.e. for setting the discarded status and within event rescuing algorithms).
% 
% The good TOF anomaly range is usually about 2 ns wide but the center
% varies betwen set-ups. A calibration/choice should be made (e.g. using
% this method) after each time the DLD detector has been reconnected to
% the TDC card. There is a small XY-dependance in the anomaly, so a very
% tight range will skew the analyzed distributions, while a too wide range
% will permit false "hits" with non-physical coordinates instead.
%
% PARAMETERS
%  dlt  (optional) The DLT instance where this detector was used
%       to load a file recently. If no dlt instance is given,
%       some statistics will be omitted from the diagram.
% RETURNS
%  legend_handle handle to the symbol legend object
% SEE ALSO
%  set_TOF_anomaly_range min_TOF_anomaly TOF_anomaly_histogram DLT.log_anomaly_histogram
%
% AUTHOR
%  Erik Månsson, 2010--2015, erik.mansson@sljus.lu.se, erik.mansson@ifn.cnr.it

function legend_handle = show_TOF_anomaly_histogram(det, dlt) 
% clf;
hold off;
if isempty(det.TOF_anomaly_histogram_abscissa)
  error('Creation of a histogram for TOF anomaly was not enabled when loading the file.')
end
bar(det.TOF_anomaly_histogram_abscissa / 1E-9, det.TOF_anomaly_histogram, 1);
xlim(det.TOF_anomaly_histogram_abscissa([1 end]) / 1E-9);
xlabel('TOF_y - TOF_x anomaly / ns');
ylabel('Count');

hold on;
% Show the TOF anomaly limits
h_lim = plot(det.min_TOF_anomaly*[1 1]/1E-9, ylim().*[0 0.5], '-r');
plot(det.max_TOF_anomaly*[1 1]/1E-9, ylim().*[0 0.5], '-r');

med = IO.DLT2ANA.quantilei(det.TOF_anomaly_histogram_abscissa', det.TOF_anomaly_histogram', [0.5]);
h_m = plot([med med]/1E-9, ylim(), ':g');

main_histogram = det.TOF_anomaly_histogram; main_histogram([1 end]) = 0; % ignore the outliers for the percentile computation
avg = sum(det.TOF_anomaly_histogram_abscissa .* main_histogram) / sum(main_histogram); % average, ignoring bins that collect outliers
h_a = plot([avg avg]/1E-9, ylim().*[0 0.5], '-g');
% Determine median and 2% & 98% percentiles by interpolation from histogram
% (NOTE: No Matlab built-in for this purpose is known, IO.DLT2ANA.quantilei is among Erik's set of utility functions.)
%q = IO.DLT2ANA.quantilei(det.TOF_anomaly_histogram_abscissa', main_histogram', [0.05 0.95]);
q = IO.DLT2ANA.quantilei(det.TOF_anomaly_histogram_abscissa', main_histogram', [0.02 0.98]);
h_q = plot([q; q]/1E-9, ylim()', ':b');

handles = [h_a; h_m; h_q(1); h_lim];
legends = {sprintf('Median incl. outliers\n%.2f ns', med/1E-9)
           sprintf('Average\n%.2f ns', avg/1E-9)
           sprintf('2%% & 98%% percentiles\n%.2f & %.2f ns', q(1)/1E-9, q(2)/1E-9)
           sprintf('Active limits\n%.2f & %.2f ns', det.min_TOF_anomaly/1E-9, det.max_TOF_anomaly/1E-9)};

if nargin >= 2 % If reference to DLT instance given, show also limits saved in file (i.e. used when acquiring)
  ylabel(sprintf('Count in "%s"', dlt.filename), 'Interpreter','none');
  from_file = [dlt.get('Min timing anomaly') dlt.get('Max timing anomaly')];
  if length(from_file) == 2
    h_lim_file = plot(from_file(1)*[1 1], ylim(), ':.r');
    plot(from_file(2)*[1 1], ylim(), ':.r');
    handles(end+1) =  h_lim_file;
    legends{end+1} = sprintf('Limits when acquired\n%.2f & %.2f ns', from_file(1), from_file(2));
  end
end
legend_handle = legend(handles, legends, 'Location','SO', 'Orientation','Horizontal');

if nargin < 2
  disp('Notice: No DLT instance given. Skipping statistics.');
  title(sprintf('TOF anomaly for %d complete DLD hits', sum(det.TOF_anomaly_histogram)));
  return;
end

% Show statistics
d = NaN; % detector_index
for detector_index = 1:length(dlt.detectors)
  if dlt.detectors{detector_index} == det
    if isnan(d)
      d = detector_index;
    else
      warning('This detector is used more than once in the DLT instance.')
    end
  end
end
events_discarded_due_to_TOF_or_R_anomaly = sum(bitand(bitor(dlt.rescued(d,:), dlt.discarded(d,:)),DLT.GROUP_STATUS_BIT.discarded_but_complete)~=0);
hits_included_rough = sum(det.TOF_anomaly_histogram(det.TOF_anomaly_histogram_abscissa >= det.min_TOF_anomaly & det.TOF_anomaly_histogram_abscissa <= det.max_TOF_anomaly)); % should be a slight overestimate, as bins may include also some hits outside exact limits
total_hits = sum(det.TOF_anomaly_histogram);
loaded_hits = double(dlt.get_hit_count(d));
hits_discarded_due_to_TOF_rough = total_hits - hits_included_rough;
hits_discarded_due_to_R_rough = total_hits - loaded_hits - hits_discarded_due_to_TOF_rough;
accepted_events = double(dlt.event_count) - sum(dlt.rescued(d,:)~=0) - sum(dlt.discarded(d,:)~=0);
%title(sprintf('TOF anomaly for %d complete hits: ~%d(%.1f%%) in range. %d(%.1f%%) in accepted events.', ...
%  total_hits, hits_included_rough, 100*hits_included_rough/total_hits, loaded_hits, 100*loaded_hits/total_hits));
title(sprintf('TOF anomaly for %d complete DLD hits: \\approx%.2f%% outside range. %.2f%% not in accepted events.', ...
  total_hits, 100*hits_discarded_due_to_TOF_rough/total_hits, 100-100*loaded_hits/total_hits), 'Interpreter','TeX');

if ~strcmp(det.rescue_mode_names{det.rescue_mode}, 'make empty')
  disp('Info: When another rescue mode than ''make empty'' is used, statistics about the discarded event count is not available.');
else
  text(0.01, 0.99, sprintf('Hits/event among discarded: %.3f, accepted: %.3f.', ...
    (hits_discarded_due_to_TOF_rough+hits_discarded_due_to_R_rough)/events_discarded_due_to_TOF_or_R_anomaly, ...
    double(loaded_hits)/accepted_events ), 'units','normalized', 'VerticalAlignment','top');

  % DEBUG: why is loaded_hits > total_hits for '..\examples\TOF\20110921_n028.dlt', even when only DLT detector is used (there are two TOF channels too in the file) -- maybe because 'abort' rather than 'make empty'?
end

p = get(gcf,'Position');
p(3) = max(p(3), 850); % increase width for increased visibility
set(gcf,'Position',p);
