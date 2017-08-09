function [] = write_elektrode_to_GEM_file(GEM_data, fid)
%This function writes the electrode information to the GEMfile specified by
%its file-identifier 'fid'. The electrode information is written in
%GEM_data.
[el_nr_uni, el_nr_locations] = unique(GEM_data.el.el_nr);
el_name = unique(GEM_data.el.el_nr);
for n = 1:GEM_data.nof_el
    fprintf(fid, '\t electrode(%.0f) \r\n',el_nr_uni(n));
    fprintf(fid, '\t { \r\n');
        for k = find(GEM_data.el.el_nr == el_nr_uni(n)) % the locations where the current electrode of interest is located
            fprintf(fid, '\t \t fill{within{box(%.2f, %.2f, %.2f, %.2f)}} \r\n', GEM_data.el.xmin(k), GEM_data.el.ymin(k), GEM_data.el.xmax(k), GEM_data.el.ymax(k));
        end
    fprintf(fid, '\t \t \t ;Potential(%.2f) \r\n', GEM_data.el.pot(el_nr_locations(n)));
        if isfield(GEM_data,'el_nr_det') && GEM_data.el_nr_det == el_nr_uni(n)% so if we are writing the detector electrode:
        fprintf(fid, '\t \t \t ;(detector) \r\n'); 
        end
    fprintf(fid, '\t } \r\n');
end

end

