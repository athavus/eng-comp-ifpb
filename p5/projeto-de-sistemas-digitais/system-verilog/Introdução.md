
## O que é SystemVerilog?
---
- É uma linguagem de descrição de harware usada para projetar circuitos digitais. Diferente de linguagens convencionais, o código "se transforma" em circuito físico em FPGA ou ASIC, e cada bloco representa componentes como portas lógicas, flip-flops, etc.

## Conceitos Básicos de Eletrônica Digital (para relembrar):
---
### Circuitos Combinacionais:

São circuitos lógicos digitais em que as saídas  dependem apenas do estado atual das entradas, sem qualquer tipo de memória ou armazenamento interno.

- Comportamento: Para cada combinação de valores das entradas naquele instante, a mesma saída será sempre obtida. Alterou a entrada, a saída também será alterada.
- Exemplos: Somadores, mux, demux, codificadores, AND, OR NOT.
- Aplicação: Tabela verdade ou expressões lógicas simples resolve todo o comportamento do circuito. 

É um circuito que se atualiza a cada alteração, como uma calculadore que a cada toque de botão mostra o resultado atual independente do que você fez antes.
### Circuitos Sequenciais:

São circuitos que possuem elementos de memória e, por isso, as saídas dependem tanto das entradas atuais quanto das anteriores.

- Comportamento: Precisa "lembrar" o que veio antes. Isso é feito usando elementos como flip-flops, registradores ou memórias.
- Elementos:
	- Clock: Sinal que define quando o circuito deve ter seus estados atualizados.
	- Flip-Flops: Elementos básicos de memória em hardware digital.
	- Realimentação: Saída pode voltar e influenciar a entrada (realimentação do circuito), o que permite armazenamento de informação.
- Exemplos: Contadores, registradores, máquinas de estado finito, temporizadores, memória RAM.
- Aplicação: Controle de senha, reconhecimento de sequência, controle de processos que dependem de uma ordem.

São como um cofre digital, só liberam a saída correta se a sequência de entradas seguir o padrão correto, não basta informar só os valores atuais, mas também as entradas anteriores.

## Estrutura de Módulos em SystemVerilog

```
module nome_modulo (
	input logic clk,  // Clock
	input logic rst,  // Reset
	input logic [3:0] entrada,
	output logic saida
);

endmodule
```

#### O que é o tipo logic em SystemVerilog?

O tipo logic é o tipo de sinal básico do SystemVerilog, utilizado para representar fios, variáveis, entradas, saídas e barramentos digitais. Ele foi introduzido como uma maneira mais prática de declarar sinais se comparado com o Verilog tradicional, que utilizava os tipos wire (só ligação) e reg (armazenamento).

##### Características:
-  Pode assumir quatro valores principais:
	- 0 nível lógico baixo
	- 1 nível lógico alto
	- z alta impedância (fio desligado ou não conectado)
	- x valor desconhecido, utilizado para depuração
- Utiliza-se logic em todo lugar no SystemVerilog, tanto em entradas quanto em saídas de módulos.
- Ele também pode ser vetorial (servir como um barramento):
	- logic [7:0] dados; // Barramento de 8 bits
	- logic comando; // Um bit só
- Acaba substituindo a confusão que existia entre o wire que era apenas ligação com o reg que era memória temporária.

## Comandos básicos do SystemVerilog

#### Como "printar" em SystemVerilog?

Na simulação (utilizando o EDA playground) 

```
initial begin
	$display("Hello, valor=%d", valor);
	$monitor("Tempo=%0t valor=%d, $time, valor);
end
```
-  $display: imprime apenas uma vez o valor, tal qual o print comum das outras linguagens.
-  $monitor: Imprime toda vez que um valor muda, tal qual um circuito combinacional.

## Como lidar com o Clock?

