function output = FindRef()

figure;
I = imshow('boxCropped.jpg')
output = ginput(3);
end
