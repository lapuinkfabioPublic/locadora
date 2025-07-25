//Fabio Leandro Lapuinka 
#include "inkey.ch"
#include "clbc.ch"

STATIC cTela := SaveScreen(0, 0, 24, 79)

PROCEDURE Main()
   LOCAL nOpcao := 0
   LOCAL lSair := .F.
   
   DO WHILE !lSair
      CLS
      @ 02, 10 SAY "SISTEMA DE EMISSÃO DE NOTAS FISCAIS"
      @ 04, 10 SAY "1. Cadastro de Clientes"
      @ 05, 10 SAY "2. Cadastro de Produtos"
      @ 06, 10 SAY "3. Emitir Nota Fiscal"
      @ 07, 10 SAY "4. Consultar Notas"
      @ 08, 10 SAY "5. Reimprimir Nota"
      @ 09, 10 SAY "0. Sair"
      @ 11, 10 SAY "Opção: " GET nOpcao PICTURE "9"
      READ
      
      DO CASE
         CASE nOpcao == 1
            CadClientes()
         CASE nOpcao == 2
            CadProdutos()
         CASE nOpcao == 3
            EmitirNota()
         CASE nOpcao == 4
            ConsultarNotas()
         CASE nOpcao == 5
            ReimprimirNota()
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
   LOCAL cCpf := SPACE(14)
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
      @ 08, 10 SAY "CPF......: " GET cCpf PICTURE "999.999.999-99"
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
         cCpf := SPACE(14)
         cFone := SPACE(15)
      ENDIF
   ENDDO
   USE
RETURN

PROCEDURE CadProdutos()
   LOCAL cDescricao := SPACE(50)
   LOCAL cCodigo := SPACE(10)
   LOCAL nPreco := 0
   LOCAL lContinua := .T.
   
   USE produtos NEW
   DO WHILE lContinua
      CLS
      @ 02, 10 SAY "CADASTRO DE PRODUTOS"
      
      @ 04, 10 SAY "Código......: " GET cCodigo
      @ 05, 10 SAY "Descrição...: " GET cDescricao
      @ 06, 10 SAY "Preço.......: " GET nPreco PICTURE "@E 9,999.99"
      READ
      
      IF LastKey() == K_ESC
         lContinua := .F.
      ELSE
         APPEND BLANK
         REPLACE codigo WITH AllTrim(cCodigo)
         REPLACE descricao WITH AllTrim(cDescricao)
         REPLACE preco WITH nPreco
         
         cCodigo := SPACE(10)
         cDescricao := SPACE(50)
         nPreco := 0
      ENDIF
   ENDDO
   USE
RETURN

PROCEDURE EmitirNota()
   LOCAL cCodCliente := SPACE(6)
   LOCAL cNomeCli := SPACE(50)
   LOCAL dData := Date()
   LOCAL aItens := {}
   LOCAL nTotal := 0
   LOCAL nItem := 1
   LOCAL lContinua := .T.
   LOCAL cCodProd := SPACE(10)
   LOCAL cDescProd := SPACE(50)
   LOCAL nQuant := 0
   LOCAL nPreco := 0
   LOCAL nSubTotal := 0
   LOCAL nNumNota := ProximoNumeroNota()
   
   // Selecionar cliente
   USE clientes NEW
   CLS
   @ 02, 10 SAY "EMISSÃO DE NOTA FISCAL - Nº: " + StrZero(nNumNota, 6)
   @ 04, 10 SAY "Código do Cliente: " GET cCodCliente
   READ
   
   IF !Empty(cCodCliente)
      SEEK cCodCliente
      IF Found()
         cNomeCli := clientes->nome
      ELSE
         Alert("Cliente não encontrado!")
         USE
         RETURN
      ENDIF
   ELSE
      USE
      RETURN
   ENDIF
   USE
   
   // Adicionar itens
   USE produtos NEW
   DO WHILE lContinua
      CLS
      @ 02, 10 SAY "EMISSÃO DE NOTA FISCAL - Nº: " + StrZero(nNumNota, 6)
      @ 03, 10 SAY "Cliente: " + cNomeCli
      @ 04, 10 SAY "Data...: " + DToC(dData)
      @ 06, 10 SAY "ITENS DA NOTA:"
      @ 07, 10 SAY "------------------------------------------------------------"
      @ 08, 10 SAY "ITEM | CÓDIGO  | DESCRIÇÃO               | QTD | PREÇO | TOTAL"
      
      FOR nI := 1 TO Len(aItens)
         @ 9+nI, 10 SAY StrZero(nI, 4) + " | " + ;
                       aItens[nI][1] + " | " + ;
                       PadR(aItens[nI][2], 22) + " | " + ;
                       StrZero(aItens[nI][3], 3) + " | " + ;
                       Transform(aItens[nI][4], "@E 9,999.99") + " | " + ;
                       Transform(aItens[nI][5], "@E 9,999.99")
      NEXT
      
      @ 20, 10 SAY "TOTAL DA NOTA: " + Transform(nTotal, "@E 999,999.99")
      @ 22, 10 SAY "[F2] Adicionar Item | [F3] Remover Item | [ESC] Finalizar"
      
      nTecla := Inkey(0)
      
      DO CASE
         CASE nTecla == K_F2
            CLS
            @ 02, 10 SAY "ADICIONAR ITEM À NOTA"
            @ 04, 10 SAY "Código do Produto: " GET cCodProd
            READ
            
            IF !Empty(cCodProd)
               SEEK cCodProd
               IF Found()
                  cDescProd := produtos->descricao
                  nPreco := produtos->preco
                  
                  @ 05, 10 SAY "Descrição.: " + cDescProd
                  @ 06, 10 SAY "Preço.....: " + Transform(nPreco, "@E 9,999.99")
                  @ 07, 10 SAY "Quantidade: " GET nQuant PICTURE "999"
                  READ
                  
                  IF nQuant > 0
                     nSubTotal := nPreco * nQuant
                     nTotal += nSubTotal
                     AAdd(aItens, {cCodProd, cDescProd, nQuant, nPreco, nSubTotal})
                  ENDIF
               ELSE
                  Alert("Produto não encontrado!")
               ENDIF
            ENDIF
            
            cCodProd := SPACE(10)
            nQuant := 0
            
         CASE nTecla == K_F3
            IF Len(aItens) > 0
               nItem := 0
               @ 23, 10 SAY "Digite o número do item a remover: " GET nItem PICTURE "99"
               READ
               
               IF nItem > 0 .AND. nItem <= Len(aItens)
                  nTotal -= aItens[nItem][5]
                  ADel(aItens, nItem)
                  ASize(aItens, Len(aItens)-1)
               ENDIF
            ENDIF
            
         CASE nTecla == K_ESC
            lContinua := .F.
      ENDCASE
   ENDDO
   USE
   
   // Gravar nota fiscal e imprimir
   IF Len(aItens) > 0
      USE notas NEW
      APPEND BLANK
      REPLACE numero WITH nNumNota
      REPLACE data WITH dData
      REPLACE cod_cliente WITH cCodCliente
      REPLACE nome_cliente WITH cNomeCli
      REPLACE total WITH nTotal
      USE
      
      USE itens_nota NEW
      FOR nI := 1 TO Len(aItens)
         APPEND BLANK
         REPLACE numero_nota WITH nNumNota
         REPLACE item WITH nI
         REPLACE cod_produto WITH aItens[nI][1]
         REPLACE descricao WITH aItens[nI][2]
         REPLACE quantidade WITH aItens[nI][3]
         REPLACE preco WITH aItens[nI][4]
         REPLACE total WITH aItens[nI][5]
      NEXT
      USE
      
      ImprimirNota(nNumNota)
      Alert("Nota fiscal emitida com sucesso!")
   ENDIF
RETURN

PROCEDURE ImprimirNota(nNumNota)
   LOCAL cCabecalho1 := "LOJA XYZ LTDA"
   LOCAL cCabecalho2 := "Rua Principal, 123 - Centro"
   LOCAL cCabecalho3 := "Cidade/UF - CEP: 00000-000"
   LOCAL cCabecalho4 := "CNPJ: 12.345.678/0001-99 - IE: 123.456.789.111"
   LOCAL nLinha := 0
   
   // Configurar impressora
   PRINTER INIT "NOTA FISCAL"
   PRINTER SET MARGIN TOP 3
   PRINTER SET MARGIN BOTTOM 3
   
   // Imprimir cabeçalho
   PRINTER LINE AT nLinha++ CENTER cCabecalho1 FONT "Arial" SIZE 12 BOLD
   PRINTER LINE AT nLinha++ CENTER cCabecalho2 FONT "Arial" SIZE 10
   PRINTER LINE AT nLinha++ CENTER cCabecalho3 FONT "Arial" SIZE 10
   PRINTER LINE AT nLinha++ CENTER cCabecalho4 FONT "Arial" SIZE 10
   PRINTER LINE AT nLinha++ CENTER "NOTA FISCAL" FONT "Arial" SIZE 12 BOLD
   
   // Dados da nota
   USE notas NEW
   SEEK nNumNota
   IF Found()
      PRINTER LINE AT nLinha++ CENTER "Nº: " + StrZero(notas->numero, 6) + " - Data: " + DToC(notas->data)
      PRINTER LINE AT nLinha++ CENTER "Cliente: " + notas->nome_cliente
   ENDIF
   USE
   
   PRINTER LINE AT nLinha++ CENTER "------------------------------------------------"
   PRINTER LINE AT nLinha++ CENTER "ITEM | DESCRIÇÃO               | QTD | PREÇO | TOTAL"
   PRINTER LINE AT nLinha++ CENTER "------------------------------------------------"
   
   // Itens da nota
   USE itens_nota NEW
   SET FILTER TO numero_nota == nNumNota
   GO TOP
   nItem := 1
   DO WHILE !Eof()
      PRINTER LINE AT nLinha++ CENTER ;
         StrZero(nItem, 4) + " | " + ;
         PadR(itens_nota->descricao, 22) + " | " + ;
         StrZero(itens_nota->quantidade, 3) + " | " + ;
         Transform(itens_nota->preco, "@E 9,999.99") + " | " + ;
         Transform(itens_nota->total, "@E 9,999.99")
      
      nItem++
      SKIP
   ENDDO
   USE
   
   PRINTER LINE AT nLinha++ CENTER "------------------------------------------------"
   
   // Total da nota
   USE notas NEW
   SEEK nNumNota
   IF Found()
      PRINTER LINE AT nLinha++ CENTER "TOTAL: " + Transform(notas->total, "@E 999,999.99")
   ENDIF
   USE
   
   PRINTER LINE AT nLinha++ CENTER "------------------------------------------------"
   PRINTER LINE AT nLinha++ CENTER "Obrigado pela preferência!"
   PRINTER LINE AT nLinha++ CENTER "Volte sempre!"
   
   // Finalizar impressão
   PRINTER END
RETURN

FUNCTION ProximoNumeroNota()
   LOCAL nUltimo := 0
   
   USE notas NEW
   IF LastRec() > 0
      GO BOTTOM
      nUltimo := notas->numero
   ENDIF
   USE
   
RETURN nUltimo + 1

PROCEDURE ConsultarNotas()
   // Implementar consulta de notas
RETURN

PROCEDURE ReimprimirNota()
   LOCAL nNumNota := 0
   
   CLS
   @ 02, 10 SAY "REIMPRESSÃO DE NOTA FISCAL"
   @ 04, 10 SAY "Número da Nota: " GET nNumNota PICTURE "999999"
   READ
   
   IF nNumNota > 0
      USE notas NEW
      SEEK nNumNota
      IF Found()
         ImprimirNota(nNumNota)
         Alert("Nota reimpressa com sucesso!")
      ELSE
         Alert("Nota fiscal não encontrada!")
      ENDIF
      USE
   ENDIF
RETURN
