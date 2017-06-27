function Exercise3_nubs(gesture_l, gesture_o, gesture_x, K)
%% init part
% init v vector
v = [0.08; 0.05; 0.02];
% init center cells
center_l = cell(K);
center_o = cell(K);
center_x = cell(K);
% for each center calculateion a temp vector, also for distortion
% calculation to store temp distortion for each x / y / z
temp_center = zeros(3, 1);
% label temp vector, near which center, 1 or 2
label_temp_l = zeros(size(gesture_l, 1)*size(gesture_l, 2), 1);
label_temp_o = zeros(size(gesture_o, 1)*size(gesture_o, 2), 1);
label_temp_x = zeros(size(gesture_x, 1)*size(gesture_x, 2), 1);
% distance to center
distance_to_center_l = zeros(K, 1);
distance_to_center_o = zeros(K, 1);
distance_to_center_x = zeros(K, 1);
% distortion to two new centers
distortion_to_center_l = zeros(K, 1);
distortion_to_center_o = zeros(K, 1);
distortion_to_center_x = zeros(K, 1);
% index to show which center to split
index_temp_l = 1;
index_temp_o = 1;
index_temp_x = 1;

% reshape gesture 3D to 2D
gesture_l_reshape_temp = zeros(size(gesture_l, 1)* size(gesture_l, 2), 3);
gesture_o_reshape_temp = zeros(size(gesture_o, 1)* size(gesture_o, 2), 3);
gesture_x_reshape_temp = zeros(size(gesture_x, 1)* size(gesture_x, 2), 3);
for i = 1:3
    gesture_l_reshape_temp(:, i) = reshape(gesture_l(:, :, i), size(gesture_l, 1)* size(gesture_l, 2), 1);
    gesture_o_reshape_temp(:, i) = reshape(gesture_o(:, :, i), size(gesture_o, 1)* size(gesture_o, 2), 1);
    gesture_x_reshape_temp(:, i) = reshape(gesture_x(:, :, i), size(gesture_x, 1)* size(gesture_x, 2), 1);
end
gesture_l_reshape = gesture_l_reshape_temp;
gesture_o_reshape = gesture_o_reshape_temp;
gesture_x_reshape = gesture_x_reshape_temp;


%% loop part
% 1. calculate init center
center_l{1, 1} = mean(gesture_l_reshape);
center_o{1, 1} = mean(gesture_o_reshape);
center_x{1, 1} = mean(gesture_x_reshape);

% loop K times
for k = 1:K-1
    % loop n, n means at this step n centers
    % 2. choose which class to split
    if k > 1
        % init again to make sure no influence from last loop
        distortion_to_center = zeros(K, 1);
        for m = 1:k
%             for i = 1:3
%                 temp = gesture_l_reshape(:, i); temp = temp(label_temp == m); 
%                 temp_center_l(i) = sqrt(sum((temp - repmat(center_l{m, k}(i), size(temp, 1), 1)).^2));
%             end
            temp_center = sqrt(sum((gesture_l_reshape(label_temp_l == m, :) - ... 
                repmat(center_l{m, k}, size(gesture_l_reshape(label_temp_l == m, :), 1), 1)).^2));
            distortion_to_center_l(m) = sqrt(sum(temp_center.^2));
            temp_center = sqrt(sum((gesture_o_reshape(label_temp_o == m, :) - ... 
                repmat(center_o{m, k}, size(gesture_o_reshape(label_temp_o == m, :), 1), 1)).^2));
            distortion_to_center_o(m) = sqrt(sum(temp_center.^2));
            temp_center = sqrt(sum((gesture_x_reshape(label_temp_x == m, :) - ... 
                repmat(center_x{m, k}, size(gesture_x_reshape(label_temp_x == m, :), 1), 1)).^2));
            distortion_to_center_x(m) = sqrt(sum(temp_center.^2));
        end
        % update index_temp
        [nouse, index_temp_l] = max(distortion_to_center_l);
        [nouse, index_temp_o] = max(distortion_to_center_o);
        [nouse, index_temp_x] = max(distortion_to_center_x);
      
    end
    
    % 3. split one more center, there is also a condition to be added
    for i = 1:k
        center_l{i, k+1} = center_l{i, k};
        center_o{i, k+1} = center_o{i, k};
        center_x{i, k+1} = center_x{i, k};
    end
    temp = center_l{index_temp_l, k};
    center_l{index_temp_l, k+1} = temp+v';
    center_l{k+1, k+1} = temp-v';
    
    temp = center_o{index_temp_o, k};
    center_o{index_temp_o, k+1} = temp+v';
    center_o{k+1, k+1} = temp-v';
    
    temp = center_x{index_temp_x, k};
    center_x{index_temp_x, k+1} = temp+v';
    center_x{k+1, k+1} = temp-v';

    
    % find points near center1 / center2
    for i = 1:size(gesture_l_reshape, 1)
        for m = 1:k+1
            distance_to_center_l(m) = norm(gesture_l_reshape(i, :)-center_l{m, k+1});
            distance_to_center_o(m) = norm(gesture_o_reshape(i, :)-center_o{m, k+1});
            distance_to_center_x(m) = norm(gesture_x_reshape(i, :)-center_x{m, k+1});
        end
        [nouse, label_temp_l(i)] = min(distance_to_center_l(1:k+1));
        [nouse, label_temp_o(i)] = min(distance_to_center_o(1:k+1));
        [nouse, label_temp_x(i)] = min(distance_to_center_x(1:k+1));
    end
    % 4. update the code vector
    % loop i for each x / y / z
    % loop m for two centers
    for m = 1:k
        temp = gesture_l_reshape(label_temp_l == m, :); 
        center_l{m, k+1} = mean(temp);
        temp = gesture_o_reshape(label_temp_o == m, :); 
        center_o{m, k+1} = mean(temp);
        temp = gesture_x_reshape(label_temp_x == m, :); 
        center_x{m, k+1} = mean(temp);
    end

end
%% plot part
figure (4);
color = {'bx', 'kx', 'rx', 'gx', 'mx', 'yx', 'cx'};
for i = 1:7
    temp_x = gesture_l_reshape(label_temp_l == i, 1); 
    temp_y = gesture_l_reshape(label_temp_l == i, 2); 
    plot(temp_x, temp_y, color{i}); hold on;
end

figure (5);
for i = 1:7
    temp_x = gesture_o_reshape(label_temp_o == i, 1); 
    temp_y = gesture_o_reshape(label_temp_o == i, 2); 
    plot(temp_x, temp_y, color{i}); hold on;
end

figure (6);
for i = 1:7
    temp_x = gesture_x_reshape(label_temp_x == i, 1); 
    temp_y = gesture_x_reshape(label_temp_x == i, 2); 
    plot(temp_x, temp_y, color{i}); hold on;
end



end