function [y] = voigt( wavenumberArray,centerLine,widthGauss, widthLorentz )
% voigt  Calculation of the VOIGT profile 
%
%   [y] = voigt( wavenumberArray,centerLine,widthGauss, widthLorentz )
%
%   INPUT ARGUMENTS
%       wavenumberArray - array 1*N of wavenumbers 
%       centerLine - position of the band center
%       widthGauss - parameter of the width of the Gaussian component (Full-width at half maximum)
%       widthLorentz - parameter of the width of the Lorentzian component (Full-width at half maximum)
%
% 	OUTPUT
%       y - array 1*N of intensities
%

% converting to dimensionless coordinates
xin=sqrt(log(2)).*(wavenumberArray-centerLine)./(widthGauss/2);
yin=sqrt(log(2)).*(widthLorentz./widthGauss);
% preparing it to insert into complexErrorFunction:
xin_size        = size(xin);
xin             = reshape(xin, [numel(xin), 1]);
w               = complexErrorFunction(xin,yin);
% reshaping it to original shape:
w               = reshape(w, xin_size);
y               = sqrt(log(2)/pi)/widthGauss*2.*real(w);
end

