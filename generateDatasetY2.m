function [x1_train,x2_train,y_train] = generateDatasetY2(P)
    data = linspace(1,10,P);

    x1_train = data;
    x2_train = data';

    y_train =(x1_train-6*sin(x2_train)).^2;
end