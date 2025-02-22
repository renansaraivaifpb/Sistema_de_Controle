% Autor: Renan Saraiva dos Santos

% Definir o sistema
A = [0 1 0; 0 0 1; -6 -11 -6];
B = [0; 0; 1];
C = [10 0 0];
D = 0;

% Matriz de ganho do observador
L = [12; 97; 210];

% Verificar os polos do observador
A_obs = A - L*C;
observer_poles_actual = eig(A_obs);
disp('Polos do observador:');
disp(observer_poles_actual);

% Definir o controlador por realimentação de estados
K = [10 5 0];

% Definir o sistema em malha fechada com o observador
A_cl = [A, -B*K; L*C, A - L*C - B*K];
B_cl = [B; B];
C_cl = [C, zeros(1, 3)];
D_cl = 0;

% Simular a resposta do sistema
sys_cl = ss(A_cl, B_cl, C_cl, D_cl);
t = 0:0.01:10;
u = ones(size(t));
[y, t, x] = lsim(sys_cl, u, t);

% Plotar a resposta do sistema
figure;
plot(t, y);
title('Resposta do Sistema com Observador e Controlador');
xlabel('Tempo (s)');
ylabel('Saída y(t)');
grid on;
