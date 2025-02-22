% Autor: Renan Saraiva dos Santos

% Definir o sistema
A = [0 1 0; 0 0 1; -6 -11 -6];
B = [0; 0; 1];
C = [10 0 0];
D = 0;

% Matriz de ganho do observador
L = [12; 97; 210];

% Definir o sistema aumentado para rastreamento
A_a = [A, zeros(3,1); -C, 0];
B_a = [B; 0];
C_a = [C, 0];

% Escolher polos desejados para o sistema aumentado
% Polos do controlador: s = -2 ± j2, s = -2
% Polos do integrador: s = -5 (escolhido para ser mais rápido que os polos do controlador)
desired_poles = [-2+2j, -2-2j, -2, -5];

% Calcular a matriz de ganho K usando a função place
K = place(A_a, B_a, desired_poles);

% Separar K em K_x e K_i
K_x = K(1:3);
K_i = K(4);

% Definir o sistema em malha fechada com o observador e o controlador de rastreamento
A_cl = [A, -B*K_x, -B*K_i; L*C, A-L*C-B*K_x, -B*K_i; -C, zeros(1,3), 0];
B_cl = [zeros(3,1); zeros(3,1); 1];
C_cl = [C, zeros(1,3), 0];
D_cl = 0;

% Simular a resposta do sistema
sys_cl = ss(A_cl, B_cl, C_cl, D_cl);
t = 0:0.01:10;
r = ones(size(t)); % Referência degrau unitário
[y, t, x] = lsim(sys_cl, r, t);

% Plotar a resposta do sistema
figure;
plot(t, y);
title('Resposta do Sistema com Observador e Controlador de Rastreamento');
xlabel('Tempo (s)');
ylabel('Saída y(t)');
grid on;
