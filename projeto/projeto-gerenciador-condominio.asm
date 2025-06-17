.data

shell: .asciiz "GL-shell>> "
linha: .asciiz "\n"
input_buffer: .space 100

# Configuração de espaço na memória
apartamentos: .space 6400  # 40 apartamentos × 5 moradores × 32 (para o nome). 160 bytes cada apt
nome_buffer: .space 32
veiculos: .space 2560	# 1 tipo + 7 placa + 24 modelo = 32. 32 * 2 veiculos = 64. 64 * 40 apt = 2560

#comandos disponiveis
cmd_1: .asciiz "ad_morador"
cmd_2: .asciiz "rm_morador"
cmd_3: .asciiz "ad_auto"
cmd_4: .asciiz "rm_auto"
cmd_5: .asciiz "limpar_ap"
cmd_6: .asciiz "info_ap"
cmd_7: .asciiz "info_geral"
cmd_8: .asciiz "salvar"
cmd_9: .asciiz "recarregar"
cmd_10: .asciiz "formatar"
cmd_11: .asciiz "sair"

# mendagens
cmd_invalido: .asciiz "Comando invalido"
ap_invalido: .asciiz "Falha: AP invalido"
ap_cheio: .asciiz "Falha: AP com numero max de moradores"
morador_add: .asciiz "Morador adicionado com sucesso!"

.macro print_line
	li $v0, 4
	la $a0, linha
	syscall
.end_macro

.macro print_string %string
	li $v0, 4
	la $a0, %string
	syscall
.end_macro 

.text
input_loop:
	print_string(shell)

	li $v0, 8
	la $a0, input_buffer
	la $a1, 100
	syscall

	jal interpretador_cmd

	j input_loop

li $v0, 10
syscall

# Função responsável por interpretar o input digitado pelo usuário, identificando os comandos do sistema ou retornando
# uma mensagem de erro.
interpretador_cmd:
	# cmd_1
	la $a0, input_buffer
	la $a1, cmd_1
	la $a3, 10
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal strncmp
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	beq $v0, $zero, opcoes_ad_morador
	
	# cmd_2
	la $a0, input_buffer
	la $a1, cmd_2
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal strncmp
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	beq $v0, $zero, rm_morador
	
	# cmd_3
	la $a0, input_buffer
	la $a1, cmd_3
	la $a3, 7
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal strncmp
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	beq $v0, $zero, ad_auto
	
	# cmd_4
	la $a0, input_buffer
	la $a1, cmd_4
	la $a3, 7
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal strncmp
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	beq $v0, $zero, rm_auto
	
	# cmd_5
	la $a0, input_buffer
	la $a1, cmd_5
	la $a3, 9
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal strncmp
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	beq $v0, $zero, limpar_ap
	
	# cmd_6
	la $a0, input_buffer
	la $a1, cmd_6
	la $a3, 7
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal strncmp
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	beq $v0, $zero, info_ap
	
	# cmd_7
	la $a0, input_buffer
	la $a1, cmd_7
	la $a3, 10
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal strncmp
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	beq $v0, $zero, info_geral
	
	# cmd_8
	la $a0, input_buffer
	la $a1, cmd_8
	la $a3, 6
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal strncmp
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	beq $v0, $zero, salvar
	
	# cmd_9
	la $a0, input_buffer
	la $a1, cmd_9
	la $a3, 10
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal strncmp
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	beq $v0, $zero, recarregar
	
	# cmd_10
	la $a0, input_buffer
	la $a1, cmd_10
	la $a3, 8
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal strncmp
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	beq $v0, $zero, formatar
	
	# cmd_11
	la $a0, input_buffer
	la $a1, cmd_11
	la $a3, 4
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal strncmp
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	beq $v0, $zero, sair
	
	# Não detectou um comando válido
	comando_invalido:
		print_string(cmd_invalido)
		print_line
		jr $ra
	
	apt_invalido:
    	print_string(ap_invalido)
    	print_line
    	jr $ra
    	
    apt_cheio:
		print_string(ap_cheio)
		print_line
    	jr $ra   	
	
opcoes_ad_morador:
	# ler número do apartamento
	la $t0, input_buffer	# carrega o endereço do input inserido
	addi $t0, $t0, 10		# pula para a parte do comando deve estar o '-'
	
	lb $t2, 0($t0)
	bne $t2, 45, comando_invalido	# verifica se o '-' está presente
	addi $t0, $t0, 1				# vai para o próximo endereço, contendo o número de apt
	
    li $s0, 0            # $s0 armazenará o número final do apartamento
	 
	read_ap_loop:

    	lb $t2, 0($t0)       # lê próximo caractere
    	beq $t2, 45, verificar_num  # se for '-', terminou o número (ASCII 45 = '-')
    	beq $t2, 10, comando_invalido # verifica se o usuário digitou o comando errado

    	li $t3, 10
    	mul $s0, $s0, $t3    # multiplica número atual por 10

    	li $t3, 48
    	sub $t2, $t2, $t3    # converte de ASCII para inteiro (ex: '5' → 5)
    	add $s0, $s0, $t2    # acumula no número do apto
		
		
    	addi $t0, $t0, 1     # avança para próximo caractere	 

    	j read_ap_loop
    	
    verificar_num:
    	blt $s0, $zero, apt_invalido	# o num de apt deve ser entre 0 e 39
    	bgt $s0, 39, apt_invalido
    	
    	# verifica se após o num e apt aparece '-'
    	lb $t2, 0($t0)
    	bne $t2, 45, comando_invalido
    	addi $t0, $t0, 1 # vai para o proxímo endereço, onde se inicia o nome do morador
    	
    	la $a0, nome_buffer	# carrega o endereço do buffer de nome
    	add $a1, $zero, $t0	# carrega o endereço do nome contido no input digitado pelo usuário
    	
    	addi $sp, $sp, -4
		sw $ra, 0($sp)
		jal strcpy		
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		
		add $s1, $zero, $v0 # guarda o nome em $s1.
		
		addi $t0, $zero, 160 # cada apartamento ocupa 160 bytes
		mul $s0, $s0, 160	 # calcula o endereço do apt
		la $s2, apartamentos
		add $s2, $s2, $s0
		li $t1, 0			 # contador de moradores
		verificar_num_moradores:
			bgt $t1, 5, apt_cheio
			lb $t0, 0($s2)
			beq $t0, $zero, adicionar_morador
			addi $t1, $t1, 1
				
			addi $s2, $s2, 32	# vai para o próximo endereço de morador do apartamento (32 por morador)
			j verificar_num_moradores
			
		adicionar_morador:
			la $a1, nome_buffer # carrega o endereço do nome digitado no arg a1
			add $a0, $zero, $s2 # carrega o endereço do morador no arg a0
	
			addi $sp, $sp, -4
			sw $ra, 0($sp)
			jal strcpy		
			lw $ra, 0($sp)
			addi $sp, $sp, 4
			
			print_string(morador_add)
			print_line
	j input_loop
		
rm_morador:
	print_string(cmd_2)
	j input_loop
ad_auto:
	print_string(cmd_3)
	j input_loop
rm_auto:
	print_string(cmd_4)
	j input_loop
limpar_ap:
	print_string(cmd_5)
	j input_loop
info_ap:
	print_string(cmd_6)
	j input_loop
info_geral:
	print_string(cmd_7)
	j input_loop
salvar:
	print_string(cmd_8)
	j input_loop
recarregar:
	print_string(cmd_9)
	j input_loop
formatar:
	print_string(cmd_10)	
	j input_loop
sair:
	print_string(cmd_11)
	j input_loop
	
strncmp:	
	strncmp_loop:
		#finaliza a comparação quando num ($a3) chega em 0.
		slti $t0, $a3, 1					#verifica se num ($a3) é menor que 1.
		bne $t0, $zero, strn1_strn2_equal		#caso sim, finaliza o looping de comparações.
			  		
		lb $t0, 0($a0)	#carrega o char do endereço base de str1.
		lb $t1, 0($a1)	#carrega o char do endereço base de str2.
			
		beq $t0, $zero, strn1_null	#verifica se o char em str1 é '\0' (NULL).
		beq $t1, $zero, strn2_less	#verifica se o char em str2 é '\0' (NULL).
	
		j is_equal_strn #nenhum dos char é '\0' (NULL).
			
		strn1_null:
			beq $t1, $zero, strn1_strn2_equal #verifica se o char em str2 também é '\0' (NULL).
			j strn1_less 
			
		is_equal_strn:
			beq $t0, $t1, equal_strn	#verifica se os dois char são iguais.	
			
			#verifica se o char em str1 tem valor decimal menor que o char de str2, ou o contrário.	
			slt $t2, $t0, $t1
			bne $t2, $zero, strn1_less	#str1 < str2
			j strn2_less				#str2 < str1
			
		equal_strn:
			addi $a0, $a0, 1	#incrementa a0 para acessar o próximo endereço de byte.
			addi $a1, $a1, 1	#incrementa a1 para acessar o próximo endereço de byte.
			addi $a3, $a3, -1	#decrementa num ($a3).
			j strncmp_loop
		
	#retorna -1 quando encontrado uma diferença, sendo o char de str1 com valor decimal menor que str2.	
	strn1_less:
		addi $v0, $zero, -1
		j end_strncmp
			
	#retorna 1 quando encontrado uma diferença, sendo o char de str2 com valor decimal menor que str1.		
	strn2_less:
		addi $v0, $zero, 1
		j end_strncmp
			
	#retorna 0 se str1 e str2 forem iguais.	
	strn1_strn2_equal:
		add $v0, $zero, $zero
		j end_strncmp
			
	end_strncmp:
		jr $ra	#retorna para a instrução seguinte do caller.


strcmp:
	strcmp_loop:
		lb $t0, 0($a0)	#carrega o char do endereço base de str1.
		lb $t1, 0($a1)	#carrega o char do endereço base de str2.
			
		beq $t0, $zero, str1_null	#verifica se o char em str1 é '\0' (NULL).
		beq $t1, $zero, str2_less	#verifica se o char em str2 é '\0' (NULL).
	
		j is_equal #nenhum dos char é '\0' (NULL).
			
		str1_null:
			beq $t1, $zero, str1_str2_equal #verifica se o char em str2 também é '\0' (NULL).
			j str1_less 
			
		is_equal:
			beq $t0, $t1, equal	#verifica se os dois char são iguais.	
			
			#verifica se o char em str1 tem valor decimal menor que o char de str2, ou o contrário.	
			slt $t2, $t0, $t1
			bne $t2, $zero, str1_less	#str1 < str2
			j str2_less					#str2 < str1
			
		equal:
			addi $a0, $a0, 1	#incrementa a0 para acessar o próximo endereço de byte.
			addi $a1, $a1, 1	#incrementa a1 para acessar o próximo endereço de byte.
			j strcmp_loop
		
	#retorna -1 quando encontrado uma diferença, sendo o char de str1 com valor decimal menor que str2.	
	str1_less:
		addi $v0, $zero, -1
		j end_strcmp
			
	#retorna 1 quando encontrado uma diferença, sendo o char de str2 com valor decimal menor que str1.		
	str2_less:
		addi $v0, $zero, 1
		j end_strcmp
			
	#retorna 0 se str1 e str2 forem iguais.
	str1_str2_equal:
		add $v0, $zero, $zero
		j end_strcmp
			
	end_strcmp:
		jr $ra	#retorna para a instrução seguinte do caller.

strcpy:
	add $v0, $zero, $a0	#guarda o endereço de destino em v0.
		
	strcpy_loop:
		lb $t0, 0($a1) 				#carrega um byte (caractere) da string apontada pelo endereço de origem.
		beq $t0, $zero, end_strcpy 	#verifica se o byte representa o caractere NULL '\0' = 0b(0000 0000) = 0.
			
		sb $t0, 0($a0) 		#copia o byte para a posição correspondente do endereço de destino.
		addi $a1, $a1, 1 	#incrementa a1 para acessar o próximo endereço de byte.
		addi $a0, $a0, 1 	#incrementa a0 para acessar o próximo endereço de byte.
			
		j strcpy_loop
	end_strcpy:
		sb $t0, 0($a0) 	#insere o caractere '\0'.
		jr $ra 			#retorna para a instrução seguinte do caller.
