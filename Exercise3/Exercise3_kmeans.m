function Exercise3_kmeans(gesture_l, gesture_o, gesture_x, ... 
    init_cluster_l, init_cluster_o, init_cluster_x)
%% 
label_gesture_l = zeros(size(gesture_l, 1), size(gesture_l, 2));
label_gesture_o = zeros(size(gesture_o, 1), size(gesture_o, 2));
label_gesture_x = zeros(size(gesture_x, 1), size(gesture_x, 2));
cluster_l_update = init_cluster_l;
cluster_o_update = init_cluster_o;
cluster_x_update = init_cluster_x;
end_condition = 10^(-6);
distortion_l_vector = 0;
distortion_o_vector = 0;
distortion_x_vector = 0;
decrement_of_distortion_l = 1;
decrement_of_distortion_o = 1;
decrement_of_distortion_x = 1;

while decrement_of_distortion_l > end_condition || decrement_of_distortion_o > end_condition || ...
        decrement_of_distortion_x > end_condition
    % init distortion
    distortion_l = 0;
    distortion_o = 0;
    distortion_x = 0;
    % E-step
    for i = 1:size(gesture_l, 1)
        for j = 1:size(gesture_l, 2)
            [nouse, label_gesture_l(i, j)] = min(sqrt(sum((repmat(cat(2, gesture_l(i, j, 1), ... 
                gesture_l(i, j, 2), gesture_l(i, j, 3)), 7, 1) - cluster_l_update).^2, 2)));
            [nouse, label_gesture_o(i, j)] = min(sqrt(sum((repmat(cat(2, gesture_o(i, j, 1), ... 
                gesture_o(i, j, 2), gesture_o(i, j, 3)), 7, 1) - cluster_o_update).^2, 2)));
            [nouse, label_gesture_x(i, j)] = min(sqrt(sum((repmat(cat(2, gesture_x(i, j, 1), ... 
                gesture_x(i, j, 2), gesture_x(i, j, 3)), 7, 1) - cluster_x_update).^2, 2)));

        end
    end

    % M-step
    for i = 1:7
        for j = 1:3
            % if the end condition for gesture_l hold, than do nothing
            if(decrement_of_distortion_l > end_condition)
                % all x positon data with label i
                % temp = vector of the first / second / third layer of gesture with the
                % same label
                temp = gesture_l(:, :, j); temp = temp(label_gesture_l == i); 
                % update cluster
                cluster_l_update(i, j) = double(mean(temp)); 
                % update distortion
                distortion_l = distortion_l + sum((temp - repmat(cluster_l_update(i, j), size(temp, 1), 1)).^2);
            end
            
            if(decrement_of_distortion_o > end_condition)
                % o gesture
                temp = gesture_o(:, :, j); temp = temp(label_gesture_o == i); 
                cluster_o_update(i, j) = double(mean(temp)); 
                distortion_o = distortion_o + sum((temp - repmat(cluster_o_update(i, j), size(temp, 1), 1)).^2);
            end
            
            if(decrement_of_distortion_x > end_condition)
                % x gesture
                temp = gesture_x(:, :, j); temp = temp(label_gesture_x == i); 
                cluster_x_update(i, j) = double(mean(temp)); 
                distortion_x = distortion_x + sum((temp - repmat(cluster_x_update(i, j), size(temp, 1), 1)).^2);
            end
            
        end
    end
    if(decrement_of_distortion_l > end_condition)
    distortion_l_vector = [distortion_l_vector, distortion_l];
    end
    decrement_of_distortion_l = double(abs(distortion_l_vector(end-1)-distortion_l_vector(end)));
    if(decrement_of_distortion_o > end_condition)
    distortion_o_vector = [distortion_o_vector, distortion_o];
    end
    decrement_of_distortion_o = double(abs(distortion_o_vector(end-1)-distortion_o_vector(end)));
    if(decrement_of_distortion_x > end_condition)
    distortion_x_vector = [distortion_x_vector, distortion_x];
    end
    decrement_of_distortion_x = double(abs(distortion_x_vector(end-1)-distortion_x_vector(end)));

%% plot
% 1st cluster with blue
figure (1);
color = {'bx', 'kx', 'rx', 'gx', 'mx', 'yx', 'cx'};
for i = 1:7
    temp_x = gesture_l(:, :, 1); temp_x = temp_x(label_gesture_l == i); 
    temp_y = gesture_l(:, :, 2); temp_y = temp_y(label_gesture_l == i); 
    plot(temp_x, temp_y, color{i}); hold on;
end

figure (2);
for i = 1:7
    temp_x = gesture_o(:, :, 1); temp_x = temp_x(label_gesture_o == i); 
    temp_y = gesture_o(:, :, 2); temp_y = temp_y(label_gesture_o == i); 
    plot(temp_x, temp_y, color{i}); hold on;
end

figure (3);
for i = 1:7
    temp_x = gesture_x(:, :, 1); temp_x = temp_x(label_gesture_x == i); 
    temp_y = gesture_x(:, :, 2); temp_y = temp_y(label_gesture_x == i); 
    plot(temp_x, temp_y, color{i}); hold on;
end




end