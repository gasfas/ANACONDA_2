function make_patch_es

es_range1 = [240;246.7]; %P1 
es_range2 = [246.8;252.8]; %P2
es_range3 = [253.0;258.1]; %P3 
es_range4 = [258.2;261.1]; %P4
es_range5 = [261.2;264.8]; %P5 
es_range6 = [264.9;266.9]; %P6
es_range7 = [267.0;270.0]; %P7
c =[0.8 0.8 0.8];
yl= ylim;
    patch([es_range1(1),es_range1(1),es_range1(2),es_range1(2)],[yl(1),yl(2),yl(2),yl(1)],[0.5 0.5 0.5],'FaceAlpha',0.5,'FaceColor',c)
    patch([es_range2(1),es_range2(1),es_range2(2),es_range2(2)],[yl(1),yl(2),yl(2),yl(1)],[0.5 0.5 0.5],'FaceAlpha',0.5,'FaceColor',c)
    patch([es_range3(1),es_range3(1),es_range3(2),es_range3(2)],[yl(1),yl(2),yl(2),yl(1)],[0.5 0.5 0.5],'FaceAlpha',0.5,'FaceColor',c)
    patch([es_range4(1),es_range4(1),es_range4(2),es_range4(2)],[yl(1),yl(2),yl(2),yl(1)],[0.5 0.5 0.5],'FaceAlpha',0.5,'FaceColor',c)
    patch([es_range5(1),es_range5(1),es_range5(2),es_range5(2)],[yl(1),yl(2),yl(2),yl(1)],[0.5 0.5 0.5],'FaceAlpha',0.5,'FaceColor',c)
    patch([es_range6(1),es_range6(1),es_range6(2),es_range6(2)],[yl(1),yl(2),yl(2),yl(1)],[0.5 0.5 0.5],'FaceAlpha',0.5,'FaceColor',c)
    patch([es_range7(1),es_range7(1),es_range7(2),es_range7(2)],[yl(1),yl(2),yl(2),yl(1)],[0.5 0.5 0.5],'FaceAlpha',0.5,'FaceColor',c)
end
