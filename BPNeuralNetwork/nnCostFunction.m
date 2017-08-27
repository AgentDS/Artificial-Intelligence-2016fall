% AI_EX3.m
function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%
% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% Part 1: Feedforward the neural network and return the cost in the
yi= zeros(num_labels,1);

for  i= 1:m
    a_1= (X(i,:))';     a_1= [1;a_1];
    z_2= Theta1*a_1;    a_2= [1;sigmoid(z_2)];
    z_3= Theta2*a_2;    a_3= sigmoid(z_3);
    hx= a_3;
   
    yi= zeros(num_labels,1);
    labels= y(i);
    yi(labels,1)= 1;
    J= J - yi'*log(hx) - (1-yi)'*log(1-hx);
    
    delta_3= a_3-yi;
    delta_2= Theta2'*delta_3.*a_2.*(1-a_2);
    delta_2= delta_2(2:end);
    Theta1_grad= Theta1_grad + delta_2*a_1';
    Theta2_grad= Theta2_grad + delta_3*a_2';
end

J= J/m;


% Part 2: Implement the backpropagation algorithm to compute the gradients
Theta1_grad= Theta1_grad/m;
Theta2_grad= Theta2_grad/m;

% Part 3: Implement regularization with the cost function and gradients.
regulTerm= sum(sum(Theta1(:,2:input_layer_size+1).^2)) + sum(sum(Theta2(:,2:hidden_layer_size + 1).^2));
J= J + lambda*regulTerm/(2*m);

regulTerm1= lambda*[zeros(hidden_layer_size,1) Theta1(:,2:input_layer_size+1)]/m;
regulTerm2= lambda*[zeros(num_labels,1) Theta2(:,2:hidden_layer_size+1)]/m;
Theta1_grad= Theta1_grad + regulTerm1;
Theta2_grad= Theta2_grad + regulTerm2;

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
