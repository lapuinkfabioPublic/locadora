#include "inkey.ch"

STATIC cTela := SaveScreen(0, 0, 24, 79)

PROCEDURE Main()
   LOCAL nOpcao := 0
   LOCAL lSair := .F.
   
   DO WHILE !lSair
      CLS
      @ 02, 10 SAY "SISTEMA DE LOCADORA DE VEÍCULOS"
      @ 04, 10 SAY "1. Cadastro de Clientes"
      @ 05, 10 SAY "2. Cadastro de Veículos"
      @ 06, 10 SAY "3. Locação"
      @ 07, 10 SAY "4. Devolução"
      @ 08, 10 SAY "5. Relatórios"
      @ 09, 10 SAY "0. Sair"
      @ 11, 10 SAY "Opção: " GET nOpcao PICTURE "9"
      READ
      
      DO CASE
         CASE nOpcao == 1
            CadClientes()
         CASE nOpcao == 2
            CadVeiculos()
         CASE nOpcao == 3
            Locacao()
         CASE nOpcao == 4
            Devolucao()
         CASE nOpcao == 5
            Relatorios()
         CASE nOpcao == 0
            lSair := .T.
      ENDCASE
   ENDDO
   
   RestScreen(0, 0, 24, 79, cTela)
RETURN

PROCEDURE CadClientes()
   LOCAL cNome := SPACE(50)
   LOCAL cEndereco := SPACE(60)
   LOCAL cCidade := SPACE(30)
   LOCAL cEstado := SPACE(2)
   LOCAL cCpf := SPACE(11)
   LOCAL cFone := SPACE(15)
   LOCAL lContinua := .T.
   
   USE clientes NEW
   DO WHILE lContinua
      CLS
      @ 02, 10 SAY "CADASTRO DE CLIENTES"
      
      @ 04, 10 SAY "Nome.....: " GET cNome
      @ 05, 10 SAY "Endereço.: " GET cEndereco
      @ 06, 10 SAY "Cidade...: " GET cCidade
      @ 07, 10 SAY "Estado...: " GET cEstado
      @ 08, 10 SAY "CPF......: " GET cCpf PICTURE "99999999999"
      @ 09, 10 SAY "Telefone.: " GET cFone PICTURE "(99)9999-9999"
      READ
      
      IF LastKey() == K_ESC
         lContinua := .F.
      ELSE
         APPEND BLANK
         REPLACE nome WITH AllTrim(cNome)
         REPLACE endereco WITH AllTrim(cEndereco)
         REPLACE cidade WITH AllTrim(cCidade)
         REPLACE estado WITH AllTrim(cEstado)
         REPLACE cpf WITH AllTrim(cCpf)
         REPLACE telefone WITH AllTrim(cFone)
         
         cNome := SPACE(50)
         cEndereco := SPACE(60)
         cCidade := SPACE(30)
         cEstado := SPACE(2)
         cCpf := SPACE(11)
         cFone := SPACE(15)
      ENDIF
   ENDDO
   USE
RETURN

PROCEDURE CadVeiculos()
   LOCAL cModelo := SPACE(30)
   LOCAL cMarca := SPACE(20)
   LOCAL cPlaca := SPACE(8)
   LOCAL cCor := SPACE(15)
   LOCAL nAno := 0
   LOCAL nValorDiaria := 0
   LOCAL lDisponivel := .T.
   LOCAL lContinua := .T.
   
   USE veiculos NEW
   DO WHILE lContinua
      CLS
      @ 02, 10 SAY "CADASTRO DE VEÍCULOS"
      
      @ 04, 10 SAY "Modelo........: " GET cModelo
      @ 05, 10 SAY "Marca.........: " GET cMarca
      @ 06, 10 SAY "Placa.........: " GET cPlaca
      @ 07, 10 SAY "Cor...........: " GET cCor
      @ 08, 10 SAY "Ano...........: " GET nAno PICTURE "9999"
      @ 09, 10 SAY "Valor Diária..: " GET nValorDiaria PICTURE "@E 9,999.99"
      @ 10, 10 SAY "Disponível....: " GET lDisponivel PICTURE "L"
      READ
      
      IF LastKey() == K_ESC
         lContinua := .F.
      ELSE
         APPEND BLANK
         REPLACE modelo WITH AllTrim(cModelo)
         REPLACE marca WITH AllTrim(cMarca)
         REPLACE placa WITH AllTrim(cPlaca)
         REPLACE cor WITH AllTrim(cCor)
         REPLACE ano WITH nAno
         REPLACE valor_diaria WITH nValorDiaria
         REPLACE disponivel WITH lDisponivel
         
         cModelo := SPACE(30)
         cMarca := SPACE(20)
         cPlaca := SPACE(8)
         cCor := SPACE(15)
         nAno := 0
         nValorDiaria := 0
         lDisponivel := .T.
      ENDIF
   ENDDO
   USE
RETURN

PROCEDURE Locacao()
   // Implementar lógica de locação
RETURN

PROCEDURE Devolucao()
   // Implementar lógica de devolução
RETURN

PROCEDURE Relatorios()
   // Implementar relatórios
RETURN
