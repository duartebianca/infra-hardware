# ENTRADA: dois números inteiros positivos com 5 dígitos cada
# separe os números por um espaço e coloque espaço no final
# exemplo: "01024 00002 "
# SAÍDA: quociente da divisão dos dois números

# auxiliar para conversão de ascii para decimal
addi s1, x0, 48 # ascii para '0'
addi s7, x0, 32 # ascii para ' '

# auxiliares para divisão e conversão
lw s2, dezmil # 10^4
lw s3, mil # 10^3
lw s4, cem # 10^2
lw s5, dez # 10^1
lw s6, um # 10^0

# -------------------------------- MAIN --------------------------------- #

# --- recebe os números em ascii --- #
# --- e converte para decimal --- #

jal ra, ProcessarNumero # converte o dividendo
addi t1, t6, 0			# armazena o resultado do dividendo

jal ra, ProcessarNumero # converte o divisor
addi t0, t6, 0			# armazena o resultado do divisor

# --- realiza a divisão --- #

jal ra, divisao 

# --- converte o resultado para ascii --- #
# --- e exibe no vídeo --- #

# extrai o 5° dígito
add t0, x0, s2 # atualiza o divisor
jal ra, divisao# divisão
add s0, x0, t1 # guarda o 5° dígito

# extrai o 4° dígito
add t1, x0, t2 # atualiza o dividendo
add t0, x0, s3 # atualiza o divisor
jal ra, divisao# divisao
add s8, x0, t1 # guarda o 4° dígito

# extrai o 3° dígito
add t1, x0, t2 # atualiza o dividendo
add t0, x0, s4 # atualiza o divisor
jal ra, divisao# divisao
add s9, x0, t1 # guarda o 3° dígito

# extrai o 2° dígito
add t1, x0, t2 # atualiza o dividendo
add t0, x0, s5 # atualiza o divisor
jal ra, divisao# divisao
add x26, x0, t1# guarda o 2° dígito

# extrai o 1° dígito
add x27, x0, t2# guarda o 1° dígito

# ascii '0'(48) + dígito = ascii do dígito
# exibe no vídeo

add s0, s0, s1
sb s0, 1024(x0)

add s8, s8, s1
sb s8, 1024(x0)

add s9, s9, s1
sb s9, 1024(x0)

add x26, x26, s1
sb x26, 1024(x0)

add x27, x27, s1
sb x27, 1024(x0)

jal x0, TerminaPrograma

# -------------------------------- FUNÇÕES --------------------------------- #

# --- função de conversão de dígitos --- #

ProcessarNumero:
addi t6, x0, 0 # acumulador = 0

ProcessarDigito:
lb t5, 1025(x0) # carrega dígito em ascii
beq t5, s1, Milhar
beq t5, s7, ProcessarFim # se encontrar espaço, termina
sub t5, t5, s1 # converte dígito para decimal 

# t5 = dígito
# t6 = acumula a soma

# acumulador += (dígito * 10^n) 
# n = 4, 3, 2, 1, 0

somaDezMil:
add t6, t6, s2 
addi t5, t5, -1
bne t5, x0, somaDezMil

Milhar:
lb t5, 1025(x0)
beq t5, s1, Centena
sub t5, t5, s1

somaMil:
add t6, t6, s3
addi t5, t5, -1
bne t5, x0, somaMil

Centena:
lb t5, 1025(x0)
beq t5, s1, Dezena
sub t5, t5, s1

somaCem:
add t6, t6, s4
addi t5, t5, -1
bne t5, x0, somaCem

Dezena:
lb t5, 1025(x0)
beq t5, s1, Unidade
sub t5, t5, s1

somaDez:
add t6, t6, s5
addi t5, t5, -1
bne t5, x0, somaDez

Unidade:
lb t5, 1025(x0)
beq t5, t6, ProcessarDigito
sub t5, t5, s1

somaUm:
add t6, t6, s6
addi t5, t5, -1
bne t5, x0, somaUm

jal x0, ProcessarDigito

ProcessarFim:
jalr x0, 0(ra)

# --- função de divisão --- #

divisao:
addi t2, x0, 0   # inicializa o resto como 0
addi t3, x0, 32  # n - número de bits

loop:
beq t3, x0, divisaoFim # se n == 0, finaliza

slli t2, t2, 1  # desloca o resto
srli t4, t1, 31 # extrai o msb do dividendo
or t2, t2, t4   # adiciona o msb ao resto
slli t1, t1, 1  # desloca o quociente

sub t2, t2, t0 	# subtrai o divisor do resto

bge t2, x0, RestoPositivo # se o resto >= 0
jal x0, RestoNegativo # se o resto < 0

RestoPositivo:
ori t1, t1, 1    # define o bit menos significativo do quociente como 1
jal x0, Atualiza # segue para a próxima iteração
	
RestoNegativo:	
add t2, t2, t0 	 # restaura o resto
jal x0, Atualiza # segue para a próxima iteração

Atualiza:
addi t3, t3, -1 # decrementa n
jal x0, loop 	# segue para a próxima iteração

divisaoFim:
jalr x0, 0(ra)

TerminaPrograma:
halt

# constantes
dezmil: .word 10000
mil: .word 1000
cem: .word 100
dez: .word 10
um: .word 1