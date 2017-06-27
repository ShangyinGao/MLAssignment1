%%
% load gestrue dataset
clear; clc; close all;
load('gesture_dataset');

%% 
% K-means
Exercise3_kmeans(gesture_l, gesture_o, gesture_x, ... 
    init_cluster_l, init_cluster_o, init_cluster_x);

%% 
% Non-Uniform Binary Split algorithm
K = 7; 
Exercise3_nubs(gesture_l, gesture_o, gesture_x, K);
