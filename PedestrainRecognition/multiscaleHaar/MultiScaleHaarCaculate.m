%%%%%%%%%%%%%%%
%Extract Haar Feature%%%%%%
function HaarFeature = MultiScaleHaarCaculate(winSize, image, featureFlag, multiScaleFlag)

X=rgb2gray(image);
if strcmp(multiScaleFlag, 'true')

    str_wave = 'db1'; % 小波基类型
    [C, S] = wavedec2(X, 2, str_wave);
    % 得到近似分量
    CA2 = appcoef2(C, S, str_wave, 2);
    % 二层水平分量
    CH2 = detcoef2('h', C, S, 2);
    % 二层垂直分量
    CV2 = detcoef2('v', C, S, 2);
    % 二层对角线分量
    CD2 = detcoef2('d', C, S, 2);
    % 一层水平分量
    CH1_2 = detcoef2('h', C, S, 1);
    % 一层垂直分量
    CV1_2 = detcoef2('v', C, S, 1);
    % 一层对角线分量
    CD1_2 = detcoef2('d', C, S, 1);
    
    process_imgs = {CA2 CH2 CV2 CD2 CH1_2 CV1_2 CD1_2};
else 
    process_imgs = {X};
end

feat_idx = 1;
intImg = IntImg(image);

if strcmp(featureFlag,'haar')
        % There are 5 rectangles associated with haar features
        feature = [1 2; 2 1; 1 3; 3 1; 2 2];
        for i = 1:5
            sizeX = feature(i,1);   % length
            sizeY = feature(i,2);   % width
            % for all pixels inside the boundaries of our feature
            child_idx = 0;
            for x=2:winSize(1)-sizeX
                for y=2:winSize(2)-sizeY
                    % for each width and length possible in frameSize
                    for winWidth = sizeX*4:sizeX*4:winSize(1)-x
                         for winHeight = sizeY*4:sizeY*4: winSize(2)-y;
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
elseif strcmp(featureFlag,'lbp')
        for x=2:winSize(1)
            for y=2:winSize(2)
                for winWidth = 1:1:winSize(1)/3
                    for winHeight = 1:1:winSize(2)/3
                        if(x+winWidth*3 <= winSize(1) && y+winHeight*3 <= winSize(2))
                            HaarFeature(feat_idx) = LBPFeatureCalc(intImg,x,y,winHeight,winWidth);
                            feat_idx = feat_idx + 1;
                        end
                    end
                end
            end
        end
elseif strcmp(featureFlag,'haar_lbp')
         feature = [1 2; 2 1; 1 3; 3 1; 2 2];
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
                                 HaarFeature(feat_idx) = HaarFeatureCalc(intImg,x,y,winHeight,winWidth,i);
                                 feat_idx = feat_idx + 1;
                             end
                        end
                    end
                end
            end
        end
       for x=1:winSize(1)
        for y=1:winSize(2)
            for winWidth = 1:winSize(1)/3
                for winHeight = 1:winSize(2)/3
                    if(x+winWidth*3 <= winSize(1) && y+winSize.height*3 <= winSize(2))
                        HaarFeature(feat_idx) = LBPFeatureCalc(intImg,x,y,winHeight,winWidth);
                        feat_idx = feat_idx + 1;
                    end
                end
            end
        end
    end
end
