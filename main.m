clc;clear;

% Berkant Tuğberk Demirtaş 2315232
% Sabahattin Yiğit Günaştı 2315281


path="C:\Users\tugberk\Desktop\Courses\CNG483\Project1\CNG 483 - Project\Dataset";
filePattern = fullfile(path, '*.jpg');
jpegFiles = dir(filePattern);

%determine the number of size of each classes
numberOfCloudy=0;
numberOfShine=0;
numberOfSunrise=0;

%read all images
for k = 1:907
  baseFileName = jpegFiles(k).name;
  fullFileName = fullfile(path, baseFileName);
  imageArray = imread(fullFileName);
  images{k}=imageArray;
  
  % Checks the number of classes by their name
  
   if contains(baseFileName,'cloudy')
        numberOfCloudy=numberOfCloudy+1;
   

    elseif contains(baseFileName,'shine')
        numberOfShine=numberOfShine+1;
    
    
    elseif contains(baseFileName,'sun')
        numberOfSunrise = numberOfSunrise+1;
   end
    
end

% Splits data 

%Splits Cloudy images 
for i=1:numberOfCloudy
    if i<=fix(numberOfCloudy/4)*2       
        train{1,i} = images{i};
        train{2,i} = jpegFiles(i).name;
    elseif i<=fix(numberOfCloudy/4)*3       
        test{1,i-150} = images{i};
        test{2,i-150} = jpegFiles(i).name;
    else
        validation{1,i-225} = images{i};
        validation{2,i-225} = jpegFiles(i).name;
    end
end

%Dummy variables for storing the index of last elements in each arrays

x=length(test);
y=length(train);
z=length(validation);

%Splits Shine images 
for j=1:numberOfShine
    if j<=fix(numberOfShine/4)*2       
        train{1,j+y} = images{i+j};
        train{2,j+y} = jpegFiles(i+j).name;
    elseif j<=fix(numberOfShine/4)*3       
        test{1,j+(x-fix(numberOfShine/4)*2)} = images{i+j};
        test{2,j+(x-fix(numberOfShine/4)*2)} = jpegFiles(j+i).name;
    else
        validation{1,j+(z-fix(numberOfShine/4)*3)} = images{i+j};
        validation{2,j+(z-fix(numberOfShine/4)*3)} = jpegFiles(i+j).name;
    end
end
%Dummy variables for storing the index of last elements in each arrays
t=length(test);
u=length(train);
v=length(validation);

%Splits Sunrise images 
for k=1:numberOfSunrise
    if k<=fix(numberOfSunrise/4)*2       
        train{1,k+u} = images{i+j+k};
        train{2,k+u} = jpegFiles(i+k+j).name;
    elseif k<=fix(numberOfSunrise/4)*3       
        test{1,k+(t-fix(numberOfSunrise/4)*2)} = images{i+j+k};
        test{2,k+(t-fix(numberOfSunrise/4)*2)} = jpegFiles(j+i+k).name;
    else 
        validation{1,k+(v-fix(numberOfSunrise/4)*3)} = images{i+j+k};
        validation{2,k+(v-fix(numberOfSunrise/4)*3)} = jpegFiles(i+j+k).name;
    end
end

% Simple menu starts here for operating the code easier

% Take the histogram choice
choice = input('Enter the choice RGB(1),Grayscale(2),Exit(3): ');

%Menu loop
while(choice~=3)

    % Takes parameters for calculating everything
bin_number=input('Enter the quantization level: ');
k=input('Enter the KNN(K value):' );
level=input('Enter the level: ');
test_result = input('Press 1 for testing and 0 for training: ');

if test_result==0
    if choice==1
        train_histogram_values=ln_rgb_intensity_histogram(train(1,:),bin_number,level);
        validation_histogram_values=ln_rgb_intensity_histogram(validation(1,:),bin_number,level);
        labels = knn(k,train_histogram_values, validation_histogram_values,level,bin_number);
        acc=performance(labels,train,validation,k);
    elseif choice==2
        train_histogram_values=ln_grayscale_intensity_histogram(train(1,:),bin_number,level);
        validation_histogram_values=ln_grayscale_intensity_histogram(validation(1,:),bin_number,level);
        labels = knn(k,train_histogram_values, validation_histogram_values,level,bin_number);
        acc=performance(labels,train,validation,k);
    end

else
    if choice==1
        train_histogram_values=ln_rgb_intensity_histogram(train(1,:),bin_number,level);
        test_histogram_values=ln_rgb_intensity_histogram(test(1,:),bin_number,level);
        labels = knn(k,train_histogram_values, test_histogram_values,level,bin_number);
        acc=performance(labels,train,validation,k);
    elseif choice==2
        train_histogram_values=ln_grayscale_intensity_histogram(train(1,:),bin_number,level);
        test_histogram_values=ln_grayscale_intensity_histogram(test(1,:),bin_number,level);
        labels = knn(k,train_histogram_values, test_histogram_values,level,bin_number);
        acc=performance(labels,train,validation,k);
    end
    

end

choice = input('Enter the choice RGB(1),Grayscale(2),Exit(3): ');

end

% Helper function for concatenating rgb histogram values

function temp = helper_rgb(rgb,x,bin_number,n)

% rgb : Image itself
% x   : Counter for storing values in an array
% bin_number : Number of bins (quantization level)
% n : The level number (1,2,3)


if n~=1
    for k=1:length(rgb)
        
        image=rgb{k};
       
        %Split into RGB Channels
        Red = image(:,:,1);
        Green = image(:,:,2);
        Blue = image(:,:,3);
        %Get histValues for each channel
        yRed = imhist(Red,bin_number);
        yGreen = imhist(Green,bin_number);
        yBlue = imhist(Blue,bin_number);

        redlist{k}=yRed;
        bluelist{k}=yBlue;
        greenlist{k}=yGreen;

    end
    
    % Take combination of each 
    for k=1:length(rgb)
        counter=0;  
     for i=1:bin_number

        for j=1:bin_number

              for m=1:bin_number
                  if(counter==bin_number*bin_number*bin_number)
                      counter=0;
                  end


                  counter=counter+1;
                  colorcomputed{k}(counter)=redlist{k}(i)+bluelist{k}(j)+greenlist{k}(m);

              end



        end

    

    end
    end

temp{x} = cat(2, colorcomputed{:});
elseif n==1
    
     %Split into RGB Channels
      Red = rgb(:,:,1);
      Green = rgb(:,:,2);
      Blue = rgb(:,:,3);
     
      %Get histValues for each channel
      yRed = imhist(Red,bin_number);
      yGreen = imhist(Green,bin_number);
      yBlue = imhist(Blue,bin_number);
      
  
     % Take the combination of histogram values
     counter=0;  
     for i=1:bin_number

     for j=1:bin_number

              for m=1:bin_number
                  if(counter==bin_number*bin_number*bin_number)
                      counter=0;
                  end


                  counter=counter+1;
                  colorcomputed{1}(counter)=yRed(i)+yGreen(j)+yBlue(m);

              end



        end

    

     end
    % Store the values into array
    temp{x} = cat(2, colorcomputed{:});
end
   

end

% Feature Extraction based on grid with RGB histogram values function

function ln_hist = ln_rgb_intensity_histogram(images,bin_number,n)
% images : Array of images itself
% bin_number : Number of bins (quantization level)
% n : The level number (1,2,3)

    % Checks the whether images in RGB form or not, if not convert them.
   for i=1:length(images)
        if size(images{i},3)==3
                rgb{i} = images{i};
        else
                rgb{i}=cat(3, images{i}, images{i}, images{i});
        end
   end
    
   % Grid dividing algorithm starts here
     for i=1:length(rgb)
        I=rgb{i};
        counter=0;
        
         % Grid dividing algorithm starts here
        if n~=1
            I1=I(1:size(I,1)/2,1:size(I,2)/2,:);% Up-left
            I2=I(size(I,1)/2+1:size(I,1),1:size(I,2)/2,:);%Down-left
            I3=I(1:size(I,1)/2,size(I,2)/2+1:size(I,2),:);%Rıght-Up
            I4=I(size(I,1)/2+1:size(I,1),size(I,2)/2+1:size(I,2),:);%Right-Down
            
            grid2{1}=I1;
            grid2{2}=I2;
            grid2{3}=I3;
            grid2{4}=I4;

            
            
           if n==3
            for k=1:4
                I=grid2{k};
                I1=I(1:size(I,1)/2,1:size(I,2)/2,:);% Up-left
                I2=I(size(I,1)/2+1:size(I,1),1:size(I,2)/2,:);%%Down-left
                I3=I(1:size(I,1)/2,size(I,2)/2+1:size(I,2),:);%Rıght-Up
                I4=I(size(I,1)/2+1:size(I,1),size(I,2)/2+1:size(I,2),:);%Right-Down  

                grid4{k+counter}=I1;
                grid4{k+1+counter}=I2;
                grid4{k+2+counter}=I3;
                grid4{k+3+counter}=I4;
                counter=counter+3;
            end

           end
           
        % After dividing images into grids, send them to the helper
        % function to concatenate 
        
        if n==2
            x=1;
            for j=1:length(grid2)
                temp = helper_rgb(grid2,x,bin_number,n);
                x=x+1;
            end
            ln_hist{i} = cat(1, temp{:});
        elseif n==3
             x=1;
            for j=1:length(grid4)
                temp = helper_rgb(grid4,x,bin_number,n);
                x=x+1;
            end
            ln_hist{i} = cat(1, temp{:});  

        end
        end

        if n==1
            x=1;
            temp = helper_rgb(I,x,bin_number,n);
            ln_hist{i} = cat(1, temp{:});
            x=x+1;
    end


     end

end


% Feature Extraction based on grid with Grayscale Histogram values function
function ln_hist = ln_grayscale_intensity_histogram(images,bin_number,n)
    
    % Checks the whether images in grayscale form or not, if not convert them.
    for i=1:length(images)

        if size(images{i},3)==3
            gray{i} = rgb2gray(images{i});
        else
            gray{i}=images{i};
        end
    end

    % Grid dividing algorithm starts here 
    for i=1:length(gray)
        I=gray{i};
        counter=0;
        
        if n~=1
            I1=I(1:size(I,1)/2,1:size(I,2)/2,:);%left-up
            I2=I(size(I,1)/2+1:size(I,1),1:size(I,2)/2,:);%left-down
            I3=I(1:size(I,1)/2,size(I,2)/2+1:size(I,2),:);%right-up
            I4=I(size(I,1)/2+1:size(I,1),size(I,2)/2+1:size(I,2),:);%right-down
            
            grid2{1}=I1;
            grid2{2}=I2;
            grid2{3}=I3;
            grid2{4}=I4;

            
            
           if n==3
            for k=1:4
                I=grid2{k};
                I1=I(1:size(I,1)/2,1:size(I,2)/2,:);%sol yukarı
                I2=I(size(I,1)/2+1:size(I,1),1:size(I,2)/2,:);%sol alt
                I3=I(1:size(I,1)/2,size(I,2)/2+1:size(I,2),:);%sağ yukarı
                I4=I(size(I,1)/2+1:size(I,1),size(I,2)/2+1:size(I,2),:);%sağ aşağı    

                grid4{k+counter}=I1;
                grid4{k+1+counter}=I2;
                grid4{k+2+counter}=I3;
                grid4{k+3+counter}=I4;
                counter=counter+3;
            end

           end
           
        % After dividing images into grids, send them to the helper
        % function to concatenate 
        if n==2
            x=1;
            for j=1:length(grid2)
                temp{j} = imhist(grid2{j},bin_number);
                x=x+1;
            end
            ln_hist{i} = cat(1, temp{:});
        elseif n==3
            x=1;
            for j=1:length(grid4)
                temp{j} = imhist(grid4{j},bin_number);
                x=x+1;
            end
            ln_hist{i} = cat(1, temp{:});


       
        
    end
        end
        
        if n==1
            x=1;
            ln_hist{i} = imhist(I,bin_number);
            x=x+1;
        end
        
    end
end

% KNN algorithm

function [neighbors] = knn(k,trains, tests,level,bin)


distances = zeros(length(trains),1);

for i=1:length(tests)
    for j=1:length(trains)
        if level==2 | level==3
            distances(j) = distancemeasure(tests{i},trains{j},length(tests{1}));
        else
            distances(j) = distancemeasure(tests{i},trains{j},bin);
        end
    end
    
    for l=1:k
        [of,minindex] = min(distances);
        distances(minindex)=[1/0];
        neighbors(i,l)=minindex;
    end
    
    
end
end

function distance = distancemeasure(a,b,bin_number)

sum = 0;
for i = 1:bin_number
 sum = sum + (a(i)-b(i)).^2;
end
distance = sum.^0.5;
end


function acc = performance(label,train,test,k)
cloudy=150;
shine=276;

num_cloudy=0;
num_shine=0;
num_sun=0;
true_label=0
for i=1:length(label)
    for j=1:k
        
        if label(i,k)<=cloudy
            num_cloudy=num_cloudy+1;
        elseif label(i,k)<=num_shine
            num_shine=num_shine+1;
        else
            num_sun=num_sun+1;
        end
        
    end
    
    x=MAX(num_cloudy,num_shine,num_sun);
    x
    if x==num_cloudy
        if contains(test{2,i},'cloudy')
            true_label=true_label+1;
        end
            
    elseif x==num_shine
          if contains(test{2,i},'shine')
            true_label=true_label+1;
        end  
    else
         if contains(test{2,i},'sun')
            true_label=true_label+1;
        end    
    end


end

acc = (true_label/length(test))*100

end

function [p] = MAX(g,h,j)
if g>h && g>j
    p=g;
elseif h>g && h>j
    p=h;
else
    p=j;
end
end
