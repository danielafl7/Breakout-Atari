# Programa para criar uma versão do jogo Breakout do Atari
# Para executar, primeiro configure o bitmap display:
# Largura da Unidade Gráfica = 8
# Altura da Unidade Gráfica = 8
# Largura da tela em pixels = 512
# Altura da tela em pixels = 256
# Endereço de memória inicial que será associado à tela: manter o padrão (0x10010000)
#
# L (largura da tela em unidades gráficas) -> 512 / 8 = 64
# l (linha; varia de zero a 31)
# c (coluna; varia de zero a 63)
# Cada linha da tela ocupa 256 posiçoes de memória (64 x 4)

.data 
		

.text
main:	lui $16,0x1001  # Carrega em $16 o endereço correspondente à primeira posição da tela
			# que corresponde à constante deslocada 16 bits para a esquerda, ou seja 0x10010000
	addi $6,$0,64	# L (largura da tela em unidades gráficas) -> 512 / 8 = 64
	add $12,$0,$0	# $12 = 1 quando um retângulo for atingido pela bola
	add $20,$0,$0	# Vai armazenar o número de retângulos destruídos (o total é 4 x 13 = 52)
	addi $21,$0,256	# $21 armazena a constante 256
	
# Imprime a bola em sua posição inicial na tela
	addi $5,$0,27 	# l (linha da bola)
	addi $7,$0,30	# c (coluna da bola)
# Cálculo do endereço do ponto correspondente a (l,c) na tela, que será armazenado em $11
	mul $8,$5,$6	# $8 = l * L
	add $8,$8,$7	# $8 = l * L + c
	sll $8,$8,2	# $8 = (l * L + c) * 4
	add $11,$8,$16	
	addi $8,$0,0x00ffffff	# Hexadecimal 0x00ffffff armazenado em $8, ou seja (00, R=ff, G=ff, B=ff) -> branco
	sw $8,0($11)	# O conteúdo de $8 vai para a memória indicada por $11, ou seja, pro ponto da tela correspondente a (l,c)


# Imprime a barra em sua posição inicial na penúltima linha da tela
	addi $5,$0,30	# l (linha)
	addi $7,$0,25	# c (coluna)
# Calculo do endereço do ponto correspondente a (l,c) do primeiro elemento da barra na tela, que será armazenado em $25
	mul $8,$5,$6	# $8 = l * L
	add $8,$8,$7	# $8 = l * L + c
	sll $8,$8,2	# $8 = (l * L + c) * 4
	add $25,$8,$16
	addi $8,$0,0x0000ffff	# Hexadecimal 0x0000ffff armazenado em $8, ou seja (00, R=00, G=ff, B=ff) -> azul claro
	sw $8,0($25)	# O conteúdo de $8 vai para a memória indicada por $25, ou seja, pro ponto da tela correspondente a (l,c)
	sw $8,4($25)	# Segundo elemento da barra, 4 posiçoes de memória à frente
	sw $8,8($25)
	sw $8,12($25)
	sw $8,16($25)
	sw $8,20($25)
	sw $8,24($25)
	sw $8,28($25)


# Impressão dos retângulos na parte superior da tela (4 linhas com 13 retângulos cada, totalizando 52)
# Imprime primeira linha 				
	addi $5,$0,0	# l (linha)
	addi $7,$0,0	# c (coluna)
	addi $9,$0,0x00ff007f	# Hexadecimal 0x00ff007f armazenado em $9, ou seja (00, R=ff, G=00, B=7f) -> rosa	
LoopLinha1:
	beq $7,65,FimLoopLinha1		# Verifica se ultrapassou a coluna correspondente ao último retângulo da linha
	jal retang
	addi $7,$7,5
	j LoopLinha1
FimLoopLinha1:			

# Imprime segunda linha
	addi $5,$0,2	# l (linha)
	addi $7,$0,0	# c (coluna)
	addi $9,$0,0x00ff7f00	 # Hexadecimal 0x00ff7f00 armazenado em $9, ou seja (00, R=ff, G=7f, B=00) -> laranja
LoopLinha2:
	beq $7,65,FimLoopLinha2		# Verifica se ultrapassou a coluna correspondente ao último retângulo da linha		
	jal retang
	addi $7,$7,5
	j LoopLinha2
FimLoopLinha2:

# Imprime terceira linha		
	addi $5,$0,4	# l (linha)
	addi $7,$0,0	# c (coluna)
	addi $9,$0,0x00ffff00	# Hexadecimal 0x00ffff00 armazenado em $9, ou seja (00, R=ff, G=ff, B=00) -> amarelo
LoopLinha3:
	beq $7,65,FimLoopLinha3		# Verifica se ultrapassou a coluna correspondente ao último retângulo da linha			
	jal retang
	addi $7,$7,5
	j LoopLinha3
FimLoopLinha3:

# Imprime quarta linha
	addi $5,$0,6	# l (linha)
	addi $7,$0,0	# c (coluna)
	addi $9,$0,0x0000f400	# Hexadecimal 0x0000f400 armazenado em $9, ou seja (00, R=00, G=f4, B=00) -> verde
LoopLinha4:
	beq $7,65,FimLoopLinha4		# Verifica se ultrapassou a coluna correspondente ao último retângulo da linha
	jal retang								
	addi $7,$7,5
	j LoopLinha4
FimLoopLinha4:

# Aguarda que uma tecla seja pressionada para iniciar o jogo
	lui $9,0xffff		# Armazena em $9 0xffff0000 (O conteúdo dessa memória será 1 se uma tecla foi digitada; senão, será 0)
	addi $17,$0,0x00ffffff # Branco 
	addi $18,$0,0x0000ffff # Azul Claro
	addi $24,$0,0x00000000 # Rosa claro (cor nova)	0x00ff6f9c
espera:	lw $8,0($9)	# Se uma tecla foi digitada, joga 1 em $8
	# Uma pausa	
	addi $2,$0,32    
	addi $4,$0,100	#  A velocidade do jogo depende desse parâmetro, que é o tempo de espera em milissegundos)
	syscall
	sw $24,0($11)	# Muda a cor da bola
	sw $24,0($25)	# Muda a cor da barra
	sw $24,4($25)	
	sw $24,8($25)
	sw $24,12($25)
	sw $24,16($25)
	sw $24,20($25)
	sw $24,24($25)
	sw $24,28($25)		
	# Uma pausa	
	addi $2,$0,32    
	addi $4,$0,100	#  A velocidade do jogo depende desse parâmetro, que é o tempo de espera em milissegundos)
	syscall
	sw $17,0($11)	# Muda a cor da bola
	sw $18,0($25)	# Muda a cor da barra
	sw $18,4($25)	
	sw $18,8($25)
	sw $18,12($25)
	sw $18,16($25)
	sw $18,20($25)
	sw $18,24($25)
	sw $18,28($25)			
	bne $8,1,espera # Se $8 não for igual a 1

###################  COMEÇA O JOGO  ###################

	addi $13,$0,4		# Incremento na posição de memória para o deslocamento da bola (Esquerda -> -4, Direita -> +4)
	addi $14,$0,-256	# Incremento na posição de memória para o deslocamento da bola (Ascendente -> -256, Descendente -> +256)
	# Os parâmetros iniciais acima são para a bola se deslocando na diagonal ascendente direita
jogo:
	lui $9,0xffff		# Armazena em $9 0xffff0000 (O conteúdo dessa memória será 1 se uma tecla foi digitada; senão, será 0)
	lw $8,0($9)	# Se uma tecla foi digitada, joga 1 em $8
	bne $8,1,naoDigi	# Se $8 não é igual a 1, nada foi digitado	
	lw $23,4($9)	# Se houve digitação, armazena em $23 (z = 122 = barra se move para esquerda; 
			# x = 120 = barra se move para direita)
naoDigi:	
	jal moveBarra 	# Chama a rotina que faz a movimentação da barra	
	jal bolaAnda	# Chama a rotina que faz a movimentação da bola	
	# Uma pausa
	addi $2,$0,32    
	addi $4,$0,100	#  A velocidade do jogo depende desse parâmetro, que é o tempo de espera em milissegundos)
	syscall
	jal varreRetang	# Chama a rotina que verifica se algum retângulo foi atingido
	beq $20,52,objetivoAtingido	# $20 armazena o número de retângulos destruídos. Se o número é 52, todos foram destruídos

# Verifica se uma lateral da tela foi atingida pela bola. Se foi, muda o sentido da bola.
	div $11,$21	# Divide a posição de memória da bola por 256. Se o resto for zero, é a primeira coluna da tela
	mfhi $8		# O resto da divisão vai pra $8
	bne $8,$0,nao_lateral_E
	addi $13,$0,4	# Vira a bola para a direita
nao_lateral_E:
	addi $8,$11,4
	div $8,$21	# Divide a posição de memória seguinte à da bola por 256. Se o resto for zero, é a última coluna da tela
	mfhi $8		# O resto da divisão vai pra $8
	bne $8,$0,nao_lateral_D
	addi $13,$0,-4	# Vira a bola para a esquerda
nao_lateral_D:


# Verifica se a linha superior foi atingida pela bola. Se foi, muda o sentido da bola.
	addi $9,$16,256		# O endereço da primeira posição da tela + 256 = início da segunda linha 
	slt $8,$11,$9		# Se a posição da bola ($11) é menor que a posição inicial da segunda linha, $8=1. Senão, $8=0
	bne $8,1,naoMudaSentido	# Se $8 não é 1, a bola não está na primeira linha; então, continua normalmente
	addi $14,$0,256 	# Vira a bola pra baixo e continua
naoMudaSentido:	

# Verifica se a barra foi atingida. Se foi, muda de sentido
	addi $9,$16,7424	# O endereço da primeira posição da tela + 7.424 (29*256) = início da linha 29 (linha acima da barra)
	slt $8,$11,$9		# Se a posição da bola ($11) é menor que a posição inicial da linha 29 ($9), $8=1. Senão, $8=0
	beq $8,1,continua	# Se $8=1, a bola está acima da linha que está acima da barra; então, continua normalmente
	addi $9,$25,-256 	# Uma coluna acima do primeiro elemento da barra
	slt $8,$11,$9		# Se a posição da bola ($11) é menor que a posição acima do primeiro elemento da barra, $8=1. Senão, $8=0
	beq $8,1,deslocaBola_eAcaba	# Se $8=1, a bola não está acima da barra	
	addi $9,$25,-228 	# Uma coluna acima do último elemento da barra	
	slt $8,$9,$11		# Se a posição acima do último elemento da barra é menor que a posição da bola ($11), $8=1. Senão, $8=0
	beq $8,1,deslocaBola_eAcaba	# Se $8=1, a bola não está acima da barra	
	addi $14,$0,-256	# Vira a bola pra cima e continua
	j continua
deslocaBola_eAcaba:
	addi $14,$14,256
	jal bolaAnda		
	# Uma pausa
	addi $2,$0,32    
	addi $4,$0,100
	syscall
	addi $14,$14,256
	jal bolaAnda		
	# Uma pausa
	addi $2,$0,32    
	addi $4,$0,100	
	syscall
	j Fim_jogo
continua:
	j jogo 
objetivoAtingido:
# Todos os retângulos foram destruídos
	jal parabens
Fim_jogo:

						
	addi $2,$0,10
fim:	syscall	
############################## FIM DO MÓDULO PRINCIPAL ################################
	
	
# Rotina para imprimir um retângulo na posição da tela especificada pela linha e coluna
# Entrada: $16 - &p0 (endereço do ponto inicial na tela)
#	   $6 -> L (largura da tela em unidades gráficas)
#	   $9 -> Cor do retângulo
retang:	
# Calculo do endereço do ponto correspondente a (l,c) na tela, que será armazenado em $15
	mul $8,$5,$6	# $8 = l * L
	add $8,$8,$7	# $8 = l * L + c
	sll $8,$8,2	# $8 = (l * L + c) * 4
	add $15,$8,$16
	sw $9,0($15)	# O conteúdo de $9 vai para a memória indicada por $15, ou seja, pro ponto da tela correspondente a (l,c)
	sw $9,4($15)
	sw $9,8($15)
	sw $9,12($15)	
	sw $9,256($15)
	sw $9,260($15)
	sw $9,264($15)
	sw $9,268($15)
fimRetang:
	jr $31
	
	
# Rotina para apagar a bola de sua posição atual e imprimir numa nova posição
# Entrada: $11 -> Posição de memória correspondente à posição atual da bola
#	   $13 -> Incremento na posição de memória (Esquerda -> -4, Direita -> +4)
# 	   $14 -> Incremento na posição de memória (Ascendente -> -256, Descendente -> +256)

bolaAnda:	
	# Apaga a bola na posição atual
	addi $8,$0,0x00000000	# Hexadecimal 0x00000000 armazenado em $8, ou seja (00, R=00, G=00, B=00) -> preto
	sw $8,0($11)	# O conteúdo de $8 vai para a memória indicada por $11, ou seja, pra posição atual da bola
	# Faz a alteração na posiçao de memória correspondente à posição da bola
	add $11,$11,$13	# Posição atual + o incremento horizontal
	add $11,$11,$14	# Posição atual + o incremento horizontal + o incremento vertical
	addi $8,$0,0x00ffffff	# Hexadecimal 0x00ffffff armazenado em $8, ou seja (00, R=ff, G=ff, B=ff) -> branco
	sw $8,0($11)	# O conteúdo de $8 vai para a memória indicada por $11, ou seja, pro ponto da tela correspondente à nova posição	
fimBolaAnda:
	jr $31
	
	
	
# Rotina para fazer a barra se mover para esquerda ou direita
# Entrada: $23 -> Valor correspondente ao que foi teclado para o movimento da barra
#	   $25 -> Posiçao do início da barra na tela 
# O valor mínimo para a posição inicial da barra, correspondente à coluna 0, é 268508672
# O valor máximo para a posição inicial da barra, correspondente à coluna 56, é 268508896
moveBarra:	
	addi $9,$0,0x00000000	# Hexadecimal 0x00000000 armazenado em $9, ou seja (00, R=00, G=00, B=00) -> preto			
	bne $23,122,verificaDir		# Se não foi teclado z (esquerda), verifica direita
	sw $9,28($25)	# O conteúdo de $9 vai para a memória indicada por $25 + 28, ou seja, limpa o último elemento da barra
	addi $25,$25,-4		# Decrementa para a posição anterior
	bne $25,268508668,verificaDir
	addi $25,$25,4	# Se estourou o limite de posição à direita, incrementa uma posição (para 268508672)
verificaDir:
	bne $23,120,naoEdireita		# Se não foi teclado x (direita), vai para nãoEdireita
	sw $9,0($25)	# O conteúdo de $9 vai para a memória indicada por $25, ou seja, limpa o primeiro elemento da barra
	addi $25,$25,4		# Incrementa para a posição seguinte
	bne $25,268508900,naoEdireita
	addi $25,$25,-4	# Se estourou o limite de posição à esquerda, decrementa uma posição (para 268508896)	
naoEdireita:
	addi $8,$0,0x0000ffff	# Hexadecimal 0x0000ffff armazenado em $8, ou seja (00, R=00, G=ff, B=ff) -> azul claro
	sw $8,0($25)	# O conteúdo de $8 vai para a memória indicada por $15, ou seja, pro ponto da tela correspondente a (l,c)#	sw $8,4($25)
	sw $8,8($25)
	sw $8,12($25)
	sw $8,16($25)
	sw $8,20($25)
	sw $8,24($25)
	sw $8,28($25)
fimMoveBarra:
	jr $31	
	

	
# Rotina para fazer uma varredura nos retângulos e verificar se algum deles foi atingido pela bola
# Entrada: $16 - &p0 (endereço do ponto inicial na tela)
#	   $6 -> L (largura da tela em unidades gráficas)
#	   $11 -> Posição de memória correspondente à posição atual da bola
varreRetang:
	addi $22,$0,1	# Ao final, será 0 se algum retângulo foi apagado. Senão, será 1.
# Imprime primeira linha na tela				
	addi $5,$0,0	# l (linha)
	addi $7,$0,0	# c (coluna)
	addi $9,$0,0x00000000	# Hexadecimal 0x00000000 armazenado em $9, ou seja (00, R=00, G=00, B=00) -> preto	
For_i:
	beq $7,65,FimFor_i	# Verifica se ultrapassou a coluna correspondente ao último retângulo da linha
	beq $5,8,fimVarreRetang	# Verifica se ultrapassou a última linha de retângulos
			
	mul $8,$5,$6	# $8 = l * L
	add $8,$8,$7	# $8 = l * L + c
	sll $8,$8,2	# $8 = (l * L + c) * 4
	add $15,$8,$16

	addi $3,$0,1
	addi $12,$0,0	# Em $12, iremos contar quantos elementos do retângulo são pretos:
			# $12 = 0 -> O retângulo não foi atingido
			# $12 = 1 -> O retângulo foi atingido
			# $12 = 8 -> O retângulo já havia sido atingido anteriormente	
	lw $8,0($15)	# O conteúdo da memória indicada por $15 é armazenado em 8 (poderá ser a cor normal do retângulo ou a cor preta)
	bne $8,$9,r2
	addi $12,$12,1
r2:	lw $8,4($15)
	bne $8,$9,r3 	# Se a cor do elemento não é preta, passa para o elemento seguinte do retângulo sem incrementar $12
	addi $12,$12,1
r3:	lw $8,8($15)
	bne $8,$9,r4
	addi $12,$12,1
r4:	lw $8,12($15)	
	bne $8,$9,r5
	addi $12,$12,1
r5:	lw $8,256($15)
	bne $8,$9,r6
	addi $12,$12,1
r6:	lw $8,260($15)
	bne $8,$9,r7
	addi $12,$12,1
r7:	lw $8,264($15)
	bne $8,$9,r8
	addi $12,$12,1
r8:	lw $8,268($15)
	bne $8,$9,testa12
	addi $12,$12,1
testa12:
	beq $12,$3,apagaRetang	# Se $12 = 1, o retângulo foi atingido => Apaga o retângulo
	j fim_apagaRetang
		
apagaRetang:	
	sw $9,0($15)	# O conteúdo de $9 vai para a memória indicada por $15, preenchendo com preto o primeiro elemento do retângulo
	sw $9,4($15)
	sw $9,8($15)
	sw $9,12($15)	
	sw $9,256($15)
	sw $9,260($15)
	sw $9,264($15)
	sw $9,268($15)
	addi $20,$20,1	# Incrementa o número de retângulos destruídos
	add $22,$0,$0	# $22 = 0 irá sinalizar que houve destruição de retângulo
	addi $14,$0,256	# Muda o sentido da bola para descendente
fim_apagaRetang:	
	addi $7,$7,5
	j For_i
FimFor_i:
	addi $5,$5,2	# Vai para próxima linha de retângulos
	addi $7,$0,0	# Vai pro primeiro retângulo da nova linha
	j For_i

fimVarreRetang:
	jr $31
	
	
# Rotina para encerrar o jogo com vitória
parabens:
	addi $9,$0,0x00000000	# Hexadecimal 0x00000000 armazenado em $9, ou seja (00, R=00, G=00, B=00) -> preto
	add $15,$16,$0		# Joga em $15 a primeira posição da tela
	addi $8,$16,8192
limpaTela:	
	beq $15,$8,fimParabens
	sw $9,0($15)		# joga o conteúdo de $9 (preto) na respectiva posição da tela
	addi $15,$15,4		# incrementa para a posição seguinte
	j limpaTela	
fimParabens:
	jr $31
