// Definição dos pinos
const int sensorPin = A0; // Pino analógico para leitura da tensão no capacitor
const int controlPin = 9; // Pino PWM para controle da tensão de entrada

// Parâmetros do PID
float Kp = 1.0; // Ganho proporcional
float Ki = 0.1; // Ganho integral
float Kd = 0.01; // Ganho derivativo

float referencia = 2.5; // Tensão de referência desejada no capacitor

// Variáveis para o PID
float erro_anterior = 0;
float integral = 0;

void setup() {
  Serial.begin(9600);
  pinMode(controlPin, OUTPUT);
}

void loop() {
  // Leitura da tensão no capacitor
  float y = analogRead(sensorPin) * (5.0 / 1023.0);
  
  // Cálculo do erro
  float erro = referencia - y;
  
  // Cálculo da integral
  integral += erro;
  
  // Cálculo da derivada
  float derivada = erro - erro_anterior;
  
  // Cálculo da saída do controlador PID
  float u = Kp * erro + Ki * integral + Kd * derivada;
  
  // Atualização do erro anterior
  erro_anterior = erro;
  
  // Ajuste da saída PWM
  int pwm = map(u, 0, 5, 0, 255);
  pwm = constrain(pwm, 0, 255);
  
  // Aplicação da saída
  analogWrite(controlPin, pwm);
  
  // Plotagem dos dados
  //Serial.print("Tensão no capacitor: ");
  Serial.println(y);
  //Serial.print(", Saída PWM: ");
  //Serial.println(pwm);
  
  delay(500); // Ajuste conforme necessário para a frequência de controle
}
