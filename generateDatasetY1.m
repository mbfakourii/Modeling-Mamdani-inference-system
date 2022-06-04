function [x1_train,x2_train,y_train] = generateDatasetY1(P)
    data = linspace(1,10,P);

    x1_train = data;
    x2_train = data';

    y_train =(1+(x1_train.^-2) + (x2_train .^ -1.5)).^2;
end