function Write_parabola(settings)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
defaults.ymin =              0; %[mm]
defaults.ymax =              40; %[mm]
defaults.gu =                           1; %[mm]

% Overwrite defaults with specified settings (if any)
if exist('settings', 'var')
    settings = setstructfields(defaults,settings);
else
    settings = defaults;
end

% x = y^2* (Xmax - Xmin)./y_max^2 * y^2 + Xmin
dummy_x_min =  round(settings.xmin./settings.gu)*settings.gu; 
dummy_x_max = round(settings.xmax./settings.gu)*settings.gu; 
dummy_y_min =  round(settings.ymin./settings.gu)*settings.gu;
dummy_y_max = round(settings.ymax./settings.gu)*settings.gu; 

y = dummy_y_min:settings.gu:dummy_y_max;
dummy_x = y.^2 * (dummy_x_max - dummy_x_min) ./ (dummy_y_max^2) + dummy_x_min;
x = round(dummy_x./settings.gu)*settings.gu;

fprintf(settings.fid, '\t electrode(%.0f) \r\n', settings.el_nr);
fprintf(settings.fid, '\t { \r\n');
for i = 1:length(x)-1;
    fprintf(settings.fid, '\t \t fill{within{box(%.2f, %.2f, %.2f, %.2f)}} \r\n', x(i), y(i), x(i), y(i+1));
    fprintf(settings.fid, '\t \t fill{within{box(%.2f, %.2f, %.2f, %.2f)}} \r\n', x(i), y(i+1), x(i+1), y(i+1));
end
fprintf(settings.fid, '\t \t \t ;Potential(%.2f) \r\n', settings.pot);
fprintf(settings.fid, '\t } \r\n');
end

