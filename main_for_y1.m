clc;
clear;
close all;

%% Create Data
N=200;

[x1_train,x2_train,y_train] = generateDatasetY1(round(0.70*N));
[x1_test,x2_test,y_test] = generateDatasetY1(round(0.30*N));


figure('Name','Train Data For Y1');
surf(x1_train,x2_train,y_train, 'EdgeColor', 'none');
view(137, 30)

train_size=round(0.70*N);

i=1;
for p=1:train_size
    for p2=1:train_size
       x1(i)=x1_train(p);
       x2(i)=x2_train(p2);
       y(i)=y_train(p,p2);
       i=i+1;
    end
end

Inputs=[x1' x2'];
Targets=y';


%% Create FIS

nmf=[15 15 10];

mftype={'gaussmf','trimf','trimf'};

fis=CreateFisUsingLookupTable([Inputs Targets],nmf,mftype);

%% Test FIS
fuzzy(fis);

test_size=round(0.30*N);

i=1;
for p=1:test_size
    for p2=1:test_size
       x1_testt(i)=x1_test(p);
       x2_testt(i)=x2_test(p2);
       y_testt(i)=y_test(p,p2);
       i=i+1;
    end
end

Inputs_test=[x1_testt' x2_testt'];
Targets_test=y_testt';

Outputs=evalfis(Inputs_test,fis);

i=1;
for p=1:test_size
    for p2=1:test_size
       y_pred(p,p2)=Outputs(i);
       i=i+1;
    end
end

figure('Name','Test Predict For Y1');
surf(x1_test,x2_test,y_pred, 'EdgeColor', 'none');
view(137, 30)

avrage_y = avrage(x1_test,x2_test,y_test);
avrage_yhat = avrage(x1_test,x2_test,y_pred);

disp("FVU = " + FVU(x1_test,x2_test,y_test,y_pred,avrage_yhat));
disp("CORR = " + CORR(x1_test,x2_test,y_test,y_pred,avrage_y,avrage_yhat));