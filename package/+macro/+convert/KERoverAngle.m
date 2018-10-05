


function [data_out] = KERoverAngle(data_in, metadata_in, detname)


data_out = data_in;
if exist('detname', 'var')
    detnames = {detname};
else % No detector name is given, so we fetch all detector names:
    detnames = fieldnames(metadata_in.det);
end

for i = 1:length(detnames)
    [histogram] = macro.hist.create.hist(data_in, metadata_in.plot.(detname).KER_polarxz.hist);
    data = histogram.Count;
    Ylim = [ 1.082 2.129; 4.223 5.2];
     Ylim = round(Ylim./0.0349);
     Int1 =  sum( data(Ylim(1,1):Ylim(1,2) , :) );
     Int1 = Int1./max(Int1);
     Int2 =  sum( data(Ylim(2,1):Ylim(2,2) , :) );
     Int2 = Int2./max(Int2);

     data_out.h.(detname).KERoverAngleUp = Int1;
     data_out.h.(detname).KERoverAngleDown = Int2;
end

end