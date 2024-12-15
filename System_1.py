'''
O objetivo desse código é projetar e simular um controlador PI para um sistema dinâmico de terceira ordem. O código fornece uma base para projetar e validar o desempenho do controlador PI, 
verificando se os requisitos de estabilidade e resposta transitória são atendidos.
Autor: Renan Saraiva dos Santos
'''
import numpy as np
import scipy.signal as signal
import matplotlib.pyplot as plt

# Parâmetros do sistema
numerator = [1.2]
denominator = [0.36, 1.86, 2.5, 1]
G = signal.TransferFunction(numerator, denominator)

# Polos desejados
zeta = 0.591  # Fator de amortecimento
wn = 1        # Frequência natural
p1_real = -zeta * wn
p1_imag = wn * np.sqrt(1 - zeta**2)
p1 = complex(p1_real, p1_imag)  # Polo no semiplano direito
p2 = complex(p1_real, -p1_imag) # Polo no semiplano esquerdo

print(f"Polos desejados: {p1:.2f}, {p2:.2f}")

# Controlador PI (ajuste inicial)
Kp = 1       # Ganho proporcional (ajustar conforme necessário)
Ki = 1       # Ganho integral (ajustar conforme necessário)
C = signal.TransferFunction([Kp, Ki], [1, 0])  # Controlador PI

# Sistema em malha fechada
sys_open = signal.TransferFunction(np.polymul(C.num, G.num), np.polymul(C.den, G.den))
sys_closed = signal.TransferFunction(sys_open.num, np.polyadd(sys_open.den, sys_open.num))

# Resposta ao degrau
time = np.linspace(0, 10, 1000)
t, y = signal.step(sys_closed, T=time)

# Plotando os resultados
plt.figure(figsize=(10, 6))
plt.plot(t, y, label="Resposta ao degrau")
plt.axhline(1.1, color='r', linestyle='--', label="Limite de Sobressinal (10%)")
plt.axhline(0.9, color='r', linestyle='--')
plt.title("Resposta ao Degrau do Sistema em Malha Fechada")
plt.xlabel("Tempo (s)")
plt.ylabel("Amplitude")
plt.grid()
plt.legend()
plt.show()
