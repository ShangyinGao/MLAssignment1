function par = Exercise1(k)

load('Data.mat');
Output = Output';
n = size(Input, 2);
p1 = 6; p2 = 6;
ErrorPosition = zeros(p1, 1);
ErrorOrientation = zeros(p2, 1);
parXYFinal = cell(1, p1);
parThetaFinal = cell(1, p2);

% find the optimal value for p1
for j=1:p1
    for m=1:k

        % init parXY
        parXYSum = zeros(1+3*j, 2);

        % select training and validation input / output
        InputXYEvl = Input(:, 1+(m-1)*n/k : m*n/k);
        InputXYTra = [Input(:, 1 : (m-1)*n/k), Input(:, 1+m*n/k : n)];
%         OutputXYEvl = Output(1+(m-1)*n/k : m*n/k, 1:2);
        OutputXYTra = [Output(1 : (m-1)*n/k, 1:2); Output(1+m*n/k : n, 1:2)];

        % expand Inputdata w.r.t p1 and p2 (Input 4*20000 or 7*20000)
        [InputXYTra, InputThetaTra] = InputDataset(InputXYTra, j, 1);
        [InputXYEvl, InputThetaEvl] = InputDataset(InputXYEvl, j, 1);

        % regulate input data and output data (Input 20000*4 Output 20000*3)
        InputXYTra = InputXYTra';
        InputXYEvl = InputXYEvl';

        % calcuate optimal parameter
        parXY = inv(InputXYTra'*InputXYTra)*InputXYTra'*OutputXYTra;

        % calcuate evaluate output
        estXY(1+(m-1)*n/k : m*n/k, :) = InputXYEvl*parXY;
        
        % parXY sum
        parXYSum = parXYSum + parXY;
    end
    % calcuate average parXY
    parXYFinal{j} = parXYSum/(k-1);

    % calcuate positon error
    ErrorPosition(j) = sumsqr(Output(:, 1:2)-estXY)/n;
end

[noMean, minIndex] = min(ErrorPosition);
parXYOpt = parXYFinal{minIndex};

% find the optimal value for p2
for l=1:p2
    for m=1:k
        % init parXYSum
        parThetaSum = zeros(1+3*l, 1);

        % select training and validation input / output
        InputThetaEvl = Input(:, 1+(m-1)*n/k : m*n/k);
        InputThetaTra = [Input(:, 1 : (m-1)*n/k), Input(:, 1+m*n/k : n)];
%         OutputThetaEvl = Output(1+(m-1)*n/k : m*n/k, 3);
        OutputThetaTra = [Output(1 : (m-1)*n/k, 3); Output(1+m*n/k : n, 3)];
     
        % expand Inputdata w.r.t p1 and p2 (Input 4*20000 or 7*20000)
        [InputXYTra, InputThetaTra] = InputDataset(InputThetaTra, 1, l);
        [InputXYEvl, InputThetaEvl] = InputDataset(InputThetaEvl, 1, l);

        % regulate input data and output data (Input 20000*4 Output 20000*3)
        InputThetaTra = InputThetaTra';
        InputThetaEvl = InputThetaEvl';
        
        % calcuate optimal parameter
        parTheta = inv(InputThetaTra'*InputThetaTra)*InputThetaTra'* ... 
            OutputThetaTra;
        
        % calcuate predict output
        estTheta(1+(m-1)*n/k : m*n/k, :) = InputThetaEvl*parTheta;

        % parTehta sum
        parThetaSum = parThetaSum + parTheta;
    end
    
    parThetaFinal{l} = parThetaSum/(k-1);

    % calcuate orientation error
    ErrorOrientation(l) = sumsqr(Output(:, 3)-estTheta)/n;
    
end

[noMean, minIndex] = min(ErrorOrientation);
parThetaOpt = parThetaFinal{minIndex};

par = {parXYOpt(:, 1), parXYOpt(:, 2), parThetaOpt};
% par = {ErrorPosition, ErrorOrientation};
end