mRand = rand(1e6,5);
ve1 = linspace(0,1,5);
ve2 = linspace(0,1,6);
ve3 = linspace(0,1,7);
ve4 = linspace(0,1,8);
ve5 = linspace(0,1,9);
% 
% tic
% mndHistc = hist.ndhistc.ndHistc(mRand, ve1, ve2, ve3, ve4, ve5);
% b = toc

tic
hist.ndhistc.ndhist(mRand, ve1, ve2, ve3, ve4, ve5);
a = toc
% all(mndHist(:) == mndHistc(:))

