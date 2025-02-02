lw t0, divisor   # carrega o divisor
lw t1, dividendo # carrega o dividendo
addi t2, x0, 0   # inicializa o resto como 0
addi t3, x0, 32  # n - número de bits

loop:
beq t3, x0, TerminaPrograma # se n == 0, finaliza

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

TerminaPrograma:
halt

# t1 = quociente
# t2 = resto

dividendo: .word 12345
divisor: .word 123