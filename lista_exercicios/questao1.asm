# Universidade Federal Rural de Pernambuco - UFRPE
# Arquitetura e Organização de Computadores - 2025.1
# Projeto 01 - Assembly MIPS e Simulador MARS

# Grupo: Gabriel Nascimento e Lucas Pontes

# Questão 1
# Esse arquivo contém a implementação em assembly MIPS das 
# seguintes funções da biblioteca "string.io" da linguagem C:
		
# strcpy, memcpy, strcmp, strncmp e strcat.


.data
end_origem: .asciiz "String de teste" 		#aloca um espaço na mémoria para a origem, contendo uma string
end_destino: .space 100 					#aloca um espaço na mémora para o destino
	
.text	
main:
	la $a1, end_origem 						#carrega o endereço de memória da origem que aponta para a string de teste
		li $a0, end_destino 					#endereço de destino para teste
		jal strcpy 								#chamada da função
		
		add $a0, $zero, $v0 					#guarda o retorno da função em $a0 para que sua string seja impressa
		li $v0, 4 								#carrega o service number de impressão de string
		syscall
	
	# Função a - strcpy	
	strcpy:
		add $v0, $zero, $a0 					#guarda o endereço de destino em v0
		
		loop:
			lb $t0, 0($a1) 						#carrega um byte (caractere) da string apontada pelo endereço de origem
			beq $t0, $zero, end_copy 			#verifica se o byte representa o caractere NULL '\0' = 0b(0000 0000) = 0
			
			sb $t0, 0($a0) 						#copia o byte para a posição correspondente do endereço de destino.
			addi $a1, $a1, 1 					#incrementa a1 para acessar o próximo endereço de byte.
			addi $a0, $a0, 1 					#incrementa a0 para acessar o próximo endereço de byte.
			
			j loop
		end_copy:
			sb $t0, 0($a0) 						#insere o caractere '\0'
			jr $ra 								#retorna para a instrução seguinte do caller
			
	# Função b - memcpy
			