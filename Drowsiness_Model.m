clear all; 
close all; 
clc
load('results1_with_DFSABC_ds.mat')
% mov = VideoReader('D:\Rahal\face\YawDD dataset\Dash\Female\13-FemaleGlasses.avi.avi'); % give the path to the video here
mov = VideoReader('C:\Users\Desktop\Drowsiness\DataSet\Yawning\Female\HDTV720\P1042779_720.mp4'); % give the path to the video here
nF = mov.NumberOfFrames; 
faceDetector = vision.CascadeObjectDetector();
mouthDetector = vision.CascadeObjectDetector('Mouth');
rr2 = [];
rr1 = [];
i=0;
j=0;
Y_1=0;
labbel = [];
mem = zeros(1,36);%Shift left Memory
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
mouth=imresize(mouth,[96 96]);
%GLCM feature extraction
[glcms1,SI1]=graycomatrix(mouth,'Offset', [0 1]);
%GLCM feature extraction
GLCM22_feature = cad_glcm_features(glcms1)';
GLCM22_features(:,i)=cell2mat(struct2cell(GLCM22_feature));
N_Features = normalize(GLCM22_features,'range');%Normalize features between [0 1]
idx = 1;
% Temporal
mem(1:end-1) =  mem(2:end);
net = setwb(net,GlobalParamsBest); % initialize ANN using the weights found by DFSABC\ds
predicted = net(N_Features(:,i));
if (actualvalue>=0.53)
    mem(end) = 1;
else
    mem(end) = 0;
end
if sum(mem)>17
    print('Yawning')
end

catch ME
    rr2=[rr2 k];
    rr1=[rr1 i];
end
end
