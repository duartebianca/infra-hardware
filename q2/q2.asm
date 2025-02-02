# ENTRADA: duas palavras separadas por um espaço e terminadas por um espaço
# exemplo: "PALAVRA1 PALAVRA2 "
# SAÍDA: "PLAYER x WINS!" ou "DRAW" em caso de empate

# auxiliar para processar palavras
addi s3, x0, 65  # ascii para 'A'
addi s4, x0, 32  # ascii para ' '
addi s5, x0, 268 # endereço inicial da tabela

# -------------------------------- MAIN --------------------------------- #

jal ra, ProcessarPalavra # processa palavra do jogador 1
addi s1, a1, 0           # guarda pontuação do jogador 1

jal ra, ProcessarPalavra # armazena pontuação do jogador 2
addi s2, a1, 0           # guarda pontuação do jogador 2

jal x0, Resultado        # determina o vencedor e escreve resultado

# --------------------------- FUNÇÕES ---------------------------- #

# calcula a pontuação das letras de uma palavra
ProcessarPalavra:
addi a1, x0, 0    # a1 = 0

ProcessarLetra:
lb t0, 1025(x0)            # carrrega letra
beq t0, s4, ProcessarFim   # se encontrar espaço, termina

# verifica se é letra minúscula
addi t1, x0, 97
blt t0, t1, ContinuaProcessar # se ASCII < 'a', fluxo normal
addi t1, x0, 123
bge t0, t1, ContinuaProcessar # se ASCII > 'z', fluxo normal

# converte letra, se necessário
sub t0, t0, s4

ContinuaProcessar:
sub t0, t0, s3   # ASCII da letra - 'A'(65)
add t0, t0, s5	  # desloca para a pontuação correspondente na tabela
lb t0, 0(t0)     # obtem pontuação
add a1, a1, t0   # atualiza soma
jal x0, ProcessarLetra

ProcessarFim:
jalr x0, 0(ra)    # retorna

# determina o vencedor e escreve resultado
Resultado:
bne s1, s2, NaoEmpate
jal x0, Empate

# se as pontuações forem diferentes
NaoEmpate:
blt s1, s2, JogadorDois # score 1 < score 2 : ?
addi a0, x0, 49
jal x0, Vencedor

JogadorDois:
addi a0, x0, 50
jal x0, Vencedor

# escreve 'PLAYER x WINS!' no vídeo
Vencedor:
addi t0, x0, 80     # 'P'
sb t0, 1024(x0)
addi t0, x0, 76     # 'L'
sb t0, 1024(x0)
addi t0, x0, 65     # 'A'
sb t0, 1024(x0)
addi t0, x0, 89     # 'Y'
sb t0, 1024(x0)
addi t0, x0, 69     # 'E'
sb t0, 1024(x0)
addi t0, x0, 82     # 'R'
sb t0, 1024(x0)
addi t0, x0, 32     # ' '
sb t0, 1024(x0)
sb a0, 1024(x0)
addi t0, x0, 32     # ' '
sb t0, 1024(x0)
addi t0, x0, 87     # 'W'
sb t0, 1024(x0)
addi t0, x0, 73     # 'I'
sb t0, 1024(x0)
addi t0, x0, 78     # 'N'
sb t0, 1024(x0)
addi t0, x0, 83     # 'S'
sb t0, 1024(x0)
addi t0, x0, 33     # '!'
sb t0, 1024(x0)
jal x0, TerminaPrograma

# escreve 'DRAW' no vídeo, em caso de empate
Empate: 
addi t0, x0, 68     # 'D'
sb t0, 1024(x0)
addi t0, x0, 82     # 'R'
sb t0, 1024(x0)
addi t0, x0, 65     # 'A'
sb t0, 1024(x0)
addi t0, x0, 87     # 'W'
sb t0, 1024(x0)
jal x0, TerminaPrograma

TerminaPrograma:
halt

# tabela de pontuação
tabela: .byte 3, 4, 4, 1, 3, 2, 1, 2, 3, 8, 5, 8, 4, 4, 3, 4, 6, 5, 5, 1, 3, 2, 2, 8, 2, 6