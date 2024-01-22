function [m_C, m_H, m_O, m_S, m_N] = Prospector_element_masses_used()

% Calculating the mass of single atoms used by prospector:
% Calculated from the example RWG2MG5 peptide.
A = [4, 8, 0, 0, 1; 
     2, 6, 2, 0, 1;
     4, 11,0, 0, 2;
     4, 10,0, 0, 3;
     27,41,5, 1,10;
     34,50,9, 1,13;
     36,55,11,1, 14];
 
 b = [70.0651; 76.0393; 87.0917; 100.0869; 617.2977; 816.3570; 891.3890];
 
 x = linsolve(A, b);
 m_C = x(1); m_H = x(2); m_O = x(3); m_S = x(4); m_N = x(5);

end