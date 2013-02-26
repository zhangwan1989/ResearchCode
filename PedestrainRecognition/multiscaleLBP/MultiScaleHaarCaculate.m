%%%%%%%%%%%%%%%
%Extract Haar Feature%%%%%%
function HaarFeature = MultiScaleHaarCaculate(winSize, image, multiScaleFlag)

X=rgb2gray(image);
if strcmp(multiScaleFlag, 'true')

    str_wave = 'db1'; % С��������
    [C, S] = wavedec2(X, 2, str_wave);
    % �õ����Ʒ���
    CA2 = appcoef2(C, S, str_wave, 2);
    % ����ˮƽ����
    CH2 = detcoef2('h', C, S, 2);
    % ���㴹ֱ����
    CV2 = detcoef2('v', C, S, 2);
    % ����Խ��߷���
    CD2 = detcoef2('d', C, S, 2);
    % һ��ˮƽ����
    CH1_2 = detcoef2('h', C, S, 1);
    % һ�㴹ֱ����
    CV1_2 = detcoef2('v', C, S, 1);
    % һ��Խ��߷���
    CD1_2 = detcoef2('d', C, S, 1);
    
    process_imgs = {CA2 CH2 CV2 CD2 CH1_2 CV1_2 CD1_2};
else 
    process_imgs = {X};
end

% There are 5 rectangles associated with haar features
feature = [1 2; 2 1; 1 3; 3 1; 2 2];
feat_idx = 1;
intImg = IntImg(image);
for i = 1:5
    sizeX = feature(i,1);   % length
    sizeY = feature(i,2);   % width
    % for all pixels inside the boundaries of our feature
    child_idx = 0;
    for x=2:winSize(1)-sizeX
        for y=2:winSize(2)-sizeY
            % for each width and length possible in frameSize
            for winWidth = sizeX*4:sizeX*2:winSize(1)-x
                 for winHeight = sizeY*4:sizeY*2: winSize(2)-y;
                     if (x+winWidth<=winSize(1)&&y+winHeight<=winSize(2))
                         child_idx = child_idx + 1;
                         disp('parent feature');
                         i
                         disp('child feature');
                         child_idx
                         HaarFeature(feat_idx) = HaarFeatureCalc(intImg,x,y,winHeight,winWidth,i);
                         feat_idx = feat_idx + 1;
                     end
                end
            end
        end
    end
end

