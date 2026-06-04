.data

msg_entrada:  .asciiz "Digite um numero binario (1 < n < 1000000000): "
msg_invalido: .asciiz "Numero invalido! Tente novamente.\n"
msg_nao_bin:  .asciiz "Nao e um binario valido! Use apenas 0 e 1.\n"
msg_result1:  .asciiz "O decimal de "
msg_result2:  .asciiz " e: "
msg_quebra:   .asciiz "\n"

.text
main:

leitura:
	li   $v0, 4
	la   $a0, msg_entrada
	syscall

	li   $v0, 5
	syscall
	move $t0, $v0        # numero lido

	# rejeita negativos e zeros (inclui caso n <= 1)
	li   $t4, 1
	li   $t5, 1000000000
	ble  $t0, $t4, invalido
	bge  $t0, $t5, invalido

	# verifica se todos os digitos sao 0 ou 1
	move $t7, $t0

valida:
	beqz $t7, converte

	move $a0, $t7
	li   $v0, 10
	div  $a0, $v0
	mfhi $t6             # digito atual
	mflo $t7             # restante

	bgt  $t6, 1, nao_binario

	j valida

invalido:
	li   $v0, 4
	la   $a0, msg_invalido
	syscall
	j leitura

nao_binario:
	li   $v0, 4
	la   $a0, msg_nao_bin
	syscall
	j leitura

converte:
	li   $t3, 0          # resultado decimal
	li   $t2, 1          # potencia de 2 atual
	move $t7, $t0

conv_loop:
	beqz $t7, resultado

	move $a0, $t7
	li   $v0, 10
	div  $a0, $v0
	mfhi $t1             # digito (0 ou 1)
	mflo $t7

	mul  $t6, $t1, $t2
	add  $t3, $t3, $t6

	sll  $t2, $t2, 1     # proxima potencia de 2

	j conv_loop

resultado:
	li   $v0, 4
	la   $a0, msg_result1
	syscall

	li   $v0, 1
	move $a0, $t0           # imprime o numero binario digitado
	syscall

	li   $v0, 4
	la   $a0, msg_result2
	syscall

	li   $v0, 1
	move $a0, $t3           # imprime o resultado decimal
	syscall

	li   $v0, 4
	la   $a0, msg_quebra
	syscall

	li   $v0, 10
	syscall
