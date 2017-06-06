function [InputXY, InputTheta] = InputDataset(Input, p1, p2)

n = size(Input, 2);

InputXY = [ones(1, n)];
InputTheta = [ones(1, n)];

for i=1:p1
    InputTemp = [Input.^i; Input(1,:).^i.*Input(2,:).^i];
    InputXY = [InputXY; InputTemp];
end

for i=1:p2
    InputTemp = [Input.^i; Input(1,:).^i.*Input(2,:).^i];
    InputTheta = [InputTheta; InputTemp];
end

end