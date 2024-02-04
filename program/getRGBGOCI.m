function rgb = getRGBGOCI(path, En, loc)

[img, R] = readgeoraster(path);
img = img(:, :, 1:8);
img(isnan(img) == 1) = 0;

rgb = zeros(size(En, 1), size(En, 2), 3);
rgb(:, :, 1) = img(loc(1):loc(2), loc(3):loc(4), 7);
rgb(:, :, 2) = img(loc(1):loc(2), loc(3):loc(4), 5);
rgb(:, :, 3) = img(loc(1):loc(2), loc(3):loc(4), 2);
% normalize
for ii = 1:size(rgb, 3)
    rgb(:, :, ii) = decorrstretch(rgb(:, :, ii), 'Tol', 0.1);
end
% show green algae as green
tmp = rgb(:, :, 1);
tmp(En > 0) = 0;
rgb(:, :, 1) = tmp;
tmp = rgb(:, :, 2);
tmp(En > 0) = 1;
rgb(:, :, 2) = tmp;
tmp = rgb(:, :, 3);
tmp(En > 0) = 0;
rgb(:, :, 3) = tmp;