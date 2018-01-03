img=im2double(rgb2gray(imread('ice skating.jpg')));

k=1.31;
sigini=3;
siginisq2=sigini*sqrt(2);

for i=1:10
    sig=sigini*k^(i-1);
    com=2*ceil(sig*2.5)+1;
    filBank{i}=sig^2*fspecial('log',com,sig);
end

tic;

for i=1:10
    filimg(:,:,i)=imfilter(img,filBank{i},'same','replicate').^2;
end

for i=1:10
    msupimg(:,:,i)=ordfilt2(filimg(:,:,i),81,ones(9,9));
end

for i=1:10
    msupimg(:,:,i)=max(msupimg(:,:,max(i-1,1):min(i+1,10)),[],3);
end

msupimg=msupimg.*(msupimg==filimg);
row=[];col=[];rad=[];

for i=1:10
    [r1,c1]=find(msupimg(:,:,i)>=0.011);
    rad1=siginisq2*k^(i-1);
    lr1=length(r1);
    rad2=repmat(rad1,lr1,1);
    row=[row;r1];
    col=[col;c1];
    rad=[rad;rad2];
end

toc;
figure, show_all_circles(img,col,row,rad);
colorbar;

com2=2*ceil(sig*2.5)+1;
filBankd=fspecial('log',com2,sig);
filBankd=sig^2*filBankd;
imgdown=img;

tic;

for i=1:10
    img_down=imfilter(imgdown,filBankd,'same','replicate').^2;
    filimgd(:,:,i)=imresize(imgdown,size(img));
    if i<10
        imgdown=imresize(img,1/(k^i));
    end
end

for i=1:10
    msupimgd(:,:,i)=ordfilt2(filimgd(:,:,i),81,ones(9,9));
end

for i=1:10
    msupimgd(:,:,i)=max(msupimgd(:,:,max(i-1,1):min(i+1,10)),[],3);
end

msupimgd=msupimgd.*(msupimgd==filimgd);
row=[];col=[];rad=[];

for i=1:10
    [r1,c1]=find(msupimgd(:,:,i)>=0.011);
    rad1=siginisq2*k^(i-1);
    lr1=length(r1);
    rad2=repmat(rad1,lr1,1);
    row=[row;r1];
    col=[col;c1];
    rad=[rad;rad2];
end

toc;

figure,show_all_circles(img,col,row,rad);
colorbar;