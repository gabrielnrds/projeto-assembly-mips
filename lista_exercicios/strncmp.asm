#Similar à função strcmp, exceto por especificar um número máximo de caracteres que devem ser comparados ao invés da string completa.
#Compara até um número num de caracteres da string apontada por str1 com a string apontada por str2. 
#Esta função começa comparando o primeiro caractere de cada string. 
#Se eles forem iguais entre si, ele continua com os pares seguintes até que os caracteres sejam diferentes, 
#até que um caractere nulo de terminação seja alcançado ou até que um número num de caracteres sejam iguais em ambas as 
#strings (o que acontecer primeiro). O retorno da função é análogo ao da função strcmp. 
#Implemente esta função de modo que o parâmetro str1 deve ser passado em $a0, srt2 em $a1 e num em $a3. 
#O retorno deve ser colocado em $v0. 
#Referência adicional: https://man.archlinux.org/man/strcmp.

.data
    pergunta1: .asciiz "Digite a primeira palavra: "
    str1: .space 30
    pergunta2: .asciiz "Digite a segunda palavra: "
    str2: .space 30
    pergunta3: .asciiz "Digite o número máximo de caracteres a comparar: "
    resultado: .asciiz "O resultado é "

.text
.globl main

#--------Função Principal----------#
main:
    # Imprime pergunta1
    li $v0, 4
    la $a0, pergunta1
    syscall

    # Lê de str1
    li $v0, 8
    la $a0, str1
    li $a1, 30
    syscall

    la $a0, str1
    jal remove_linha

    # Imprime pergunta2
    li $v0, 4
    la $a0, pergunta2
    syscall

    # Lê de str2
    li $v0, 8
    la $a0, str2
    li $a1, 30
    syscall

    la $a0, str2
    jal remove_linha

    # Imprime pergunta3
    li $v0, 4
    la $a0, pergunta3
    syscall

    # Lê inteiro
    li $v0, 5
    syscall
    move $a3, $v0   # $a3 recebe resultado pergunta3

   # Chama a função strcmp entre str1 e str2
    la $a0, str1
    la $a1, str2
    jal strncmp     # resultado retornado em $v0
    move $t1, $v0   # salva retorno antes de sobrescrever

    # Imprime "O resultado é "
    li $v0, 4
    la $a0, resultado
    syscall

    # Imprime valor inteiro
    li $v0, 1
    move $a0, $t1
    syscall

    # Fim do programa
    li $v0, 10
    syscall

# ----------Função Strcmp----------#
# Entrada: $a0 = str1, $a1 = str2, $a3 = num
# Saída: $v0 = resultado

strncmp:
	li $t0, 0              # contador = 0

	strncmp_loop:
	beq $t0, $a3, igual    # comparou num caracteres
	lb $t1, 0($a0)         # caractere str1
	lb $t2, 0($a1)         # caractere str2

	beq $t1, $t2, verifica_fim
	sub $v0, $t1, $t2
	jr $ra

	verifica_fim:
	beq $t1, $zero, igual
	addi $a0, $a0, 1
	addi $a1, $a1, 1
	addi $t0, $t0, 1
	j strncmp_loop

	igual:
	li $v0, 0
	jr $ra

# ---------- Função Remove_linha ----------#
# Substitui '\n' por '\0'
remove_linha:
    analise_loop:
        lb $t3, 0($a0)
        beq $t3, 10, found   # '\n'
        beqz $t3, done       # fim da string
        addi $a0, $a0, 1
        j analise_loop
    found:
        sb $zero, 0($a0)     # substitui por '\0'
    done:
        jr $ra