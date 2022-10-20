clear all; 
close all; 
clc
% mov = VideoReader('D:\Rahal\face\YawDD dataset\Dash\Female\13-FemaleGlasses.avi.avi'); % give the path to the video here
mov = VideoReader('C:\Users\TUBITAK_5210056\Desktop\Drowsiness\DataSet\Yawning\Female\HDTV720\P1042779_720.mp4'); % give the path to the video here
nF = mov.NumberOfFrames; 
faceDetector = vision.CascadeObjectDetector();
mouthDetector = vision.CascadeObjectDetector('Mouth');
rr2 = [];
rr1 = [];
i=0;
j=0;
Y_1=0;
labbel = [];
for k=1:4:nF
    k
i=i+1
%To detect Face
co=int2str(k);
%Iorg=capturecode;
movie(k).cdata = read(mov,k);
Iorg=movie(k).cdata;%the frame no. k of the video
try
Iorg=rgb2gray(Iorg);
BB = step(faceDetector, Iorg);
face=imcrop(Iorg,BB);

centerx=size(face,1)/3+size(face,1)/3;
centery1=size(face,2)/4;
centery2=size(face,2)-(size(face,2)/4);
mouth =face(centerx:end,centery1:centery2);
% BB = step(mouthDetector, face(centerx:end,:));
% [~,ind] = max(BB(:,2));
mouth=imresize(mouth,[96 96]);
imshow(mouth); 
% imshow(mouth)
%GLCM feature extraction
[glcms1,SI1]=graycomatrix(mouth,'Offset', [0 1]);
%GLCM feature extraction
GLCM22_feature = cad_glcm_features(glcms1)';
GLCM22_features(:,i)=cell2mat(struct2cell(GLCM22_feature));

% close 
%pause(1);
inp = input('press <0, 1, 2>: ');

while isempty(inp) || (inp > 2)
    inp = input('press <0, 1, 2>: ');
end

labbel = [labbel inp];

catch ME
    rr2=[rr2 k];
    rr1=[rr1 i];
end
end
GLCM22_features=GLCM22_features';
GLCM22_features(rr1(1:end),:)=[];
V2_F = [GLCM22_features labbel'];
