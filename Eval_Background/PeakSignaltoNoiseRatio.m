function PSNR = PeakSignaltoNoiseRatio(origImg, distImg,max)

if nargin<3
    max=255;
end

origImg = double(origImg);
distImg = double(distImg);

[M N] = size(origImg);
error = origImg - distImg;
MSE = sum(sum(error .* error)) / (M * N);

if(MSE > 0)
    PSNR = 10*log10(max*max/MSE);
else
    PSNR = 99;
end