function [ PDF ] = MB_KE(KE_container, Temp, sigma)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
if sigma == 0
    PDF = theory.Boltzmann_PDF_3D(KE_container, Temp);
else
    if KE_container(1) == 0
        KE_container          = KE_container(2:end);
        cut         = true;
	else 
		cut			= false;
	end
    PDF_unscaled = theory.Gaussian_broadening(KE_container, theory.Boltzmann_PDF_3D(KE_container, Temp)./(KE_container.^2), sigma);

    PDF = PDF_unscaled.*KE_container.^2./trapz(KE_container, PDF_unscaled.*KE_container.^2);
    
    if cut
        PDF = [0; PDF];
    end
end

end

