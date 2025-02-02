# ENTRADA: número em binário de 4 bits
# entradas do arduino: a 2, b 3, c 4, d 5, e 6, f 7, g 8

# carrega os bits em ascii
lb s1, 1025(x0) # b4
lb s2, 1025(x0) # b3
lb s3, 1025(x0) # b2
lb s4, 1025(x0) # b1

# converte de ascii para binário
addi s1, s1, -48     
addi s2, s2, -48     
addi s3, s3, -48     
addi s4, s4, -48  

# converte de binário para decimal
addi t0, x0, 0

slli s1, s1, 3
slli s2, s2, 2       
slli s3, s3, 1 
      
add t0, t0, s1
add t0, t0, s2
add t0, t0, s3
add t0, t0, s4 

# endereço base para as tabelas
addi t6, x0, 96

add t1, t0, t6 
addi t2, t1, 15

# exibe no display
lb t3, 0(t1)
lb t4, 0(t2)
sb t3, 1029(x0)
sb t4, 1027(x0)

halt
  
abcdef: .byte 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F, 0x0, 0x0, 0x0, 0x0, 0x0
g:      .byte 0,    0,    1,    1,    1,    1,    1,    0,    1,    1,    0,   0,   0,   0,   0
