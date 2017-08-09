function [OK] = check_GEM_file(settings)
% check_GEM_file
% this function aims to predict when a geometry file is incorrectly filled
% in, for example when the outer radius is larger than the maximum allowed.
    GEM_data = settings.GEM.data;
    
    if max(GEM_data.xmax) > settings.GEM.pa_define_nx || max(GEM_data.ymax) > settings.GEM.pa_define_ny;
        error('the size requested is larger than is possible to build into the vacuum chamber see GEM_parameters.m for pa_define value')
    end
    coordinate = 'x';
    for h = 1:length(coordinate)
    for i = 1:length(GEM_data.el_nr)
        for j = 1:length(GEM_data.el_nr)
            if GEM_data.([coordinate(h) 'max'])(i) > GEM_data.([coordinate(h) 'min'])(j) && ...
                    GEM_data.([coordinate(h) 'min'])(i) < GEM_data.([coordinate(h) 'min'])(j)
                warning('your electrodes overlap, mate! check your geometries')
            end
            if GEM_data.([coordinate(h) 'max'])(i) < GEM_data.([coordinate(h) 'min'])(i);
                error('you specified a larger minimum value than your maximum value in %s direction for elektrode %.0f. \n This leads to electodes in parallel universes. We do not experiment in those environments.', coordinate(h), i);
            end

        end
    end
    end
    OK = true;
end

    