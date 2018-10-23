function [ PDF ] = MB_KE(KE_container, Temp, sigma)
%This function calculates the PDF of the kinetic energy distribution from 
% the theoretical Maxwell-Boltzmann distribution, broadened with a 
% Gaussian distribution.
% Inputs: 
% KE_container		[n,1] the Kinetic energy values at which the
%					PDF is calculated
% Temp				scalar, the temperature in the Maxwell-Boltzmann model.
% sigma				scalar, the broadening of the Gaussian distribution
% Outputs:
% PDF				[n, 1] The calculated probability density function at the
%					KE_container points
% 
% written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

if sigma == 0
	% If there is no Gaussian broadening, we can simply calculate the
	% Boltzmann distribution:
    PDF = theory.Boltzmann_PDF_3D(KE_container, Temp);
else
    if KE_container(1) == 0 % The solver cannot deal with PDF(1) = 0
        KE_container          = KE_container(2:end);
        cut         = true;
	else 
		cut			= false;
	end
	% Calculate the unscaled PDF
    PDF_unscaled = theory.Gaussian_broadening(KE_container, theory.Boltzmann_PDF_3D(KE_container, Temp)./(KE_container.^2), sigma);
	% Scale it:
    PDF = PDF_unscaled.*KE_container.^2./trapz(KE_container, PDF_unscaled.*KE_container.^2);
    % Return the first PDF value if it had been removed previously:
    if cut
        PDF = [0; PDF];
    end
end

end

