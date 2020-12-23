<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file ="lib/conexao.asp"-->
<!--#include file="fpdf/fpdf.asp"-->
<%
'// criando o pdf
dim IdPrimeiraEscala, IdSegundaEscala, idBarreira, mesRef, regionaldesc, mesEsc
IdPrimeiraEscala = request("ide1")
IdSegundaEscala = request("ide2")
idBarreira = request("idb")
mesRef = request("mesRef")
ano = request("Ano")

function RetornaIdEscalas()
	  Set objSql =  conn.Execute("SELECT * FROM SEBV_EscalaParcial WHERE MesRef='"&mesRef&"' AND YEAR(DataInicio)='"&ano&"' and Status='1'")
	  do while not objSql.EOF
		  if objSql("EscalaDesc") = "1" Then
			  IdPrimeiraEscala = objSql("Id")
        anoEsc = YEAR(objSql("DataInicio"))
		  elseIf objSql("EscalaDesc") = "2" Then
			  IdSegundaEscala = objSql("Id")
		  else
			  response.write("Escala não cadastrada")
		  End If
	  objSql.movenext()
	  loop
	  objSql.Close
	  Set objSql = Nothing
      end function


if IdPrimeiraEscala = "" and IdSegundaEscala ="" then 
    mesRef = request("mesRef")
    RetornaIdEscalas()
else
end if

strSQL = "SELECT DiaEscala, Re.Id, HoraSaida, HoraChegada, Ro.Descricao, M.MunicipioDesc FROM SEBV_RotaEscala AS Re INNER JOIN SEBV_Rota AS Ro ON Re.IdRota=Ro.Id INNER JOIN Municipio AS M ON Ro.MunicipioId=M.MunicipioId INNER JOIN SEBV_EscalaParcial AS Ep On Re.IdEscalaParcial = Ep.Id INNER JOIN Regional AS R ON M.MunicipioRegionalId=R.RegionalId WHERE Re.IdEscalaParcial = '"&IdPrimeiraEscala&"' AND IdBarreiraVol = '"&idBarreira&"'  AND Situacao = 'Fechado'  ORDER BY DiaEscala"
set ObjRst = conn.Execute(strSQL)
strSQL2 = "SELECT DiaEscala, Re.Id, HoraSaida, HoraChegada, Ro.Descricao, M.MunicipioDesc FROM SEBV_RotaEscala AS Re INNER JOIN SEBV_Rota AS Ro ON Re.IdRota=Ro.Id INNER JOIN Municipio AS M ON Ro.MunicipioId=M.MunicipioId INNER JOIN SEBV_EscalaParcial AS Ep On Re.IdEscalaParcial = Ep.Id INNER JOIN Regional AS R ON M.MunicipioRegionalId=R.RegionalId WHERE Re.IdEscalaParcial = '"&IdSegundaEscala&"' AND IdBarreiraVol = '"&idBarreira&"' AND Situacao = 'Fechado'  ORDER BY DiaEscala"
set ObjRst2 = conn.Execute(strSQL2)
strSql1 = "SELECT sb.Id, sb.Matricula, sb.VinculoMat, sb.Situacao, f.Nome, r.RegionalDesc FROM SEBV_ServidoresEsc as sb INNER JOIN CadFunc as f on sb.Matricula = f.MatriculaNova INNER JOIN Municipio as M ON f.LotacaoOrigem = M.MunicipioId INNER JOIN Regional AS R ON M.MunicipioRegionalId=R.RegionalId  WHERE IdEscalaParcial='"&IdPrimeiraEscala&"' AND IdBarreira ='"&idBarreira&"'"
set rs1 = conn.Execute(strSql1)
strSql2 = "SELECT sb.Id, sb.Matricula, sb.VinculoMat, sb.Situacao, f.Nome, r.RegionalDesc FROM SEBV_ServidoresEsc as sb INNER JOIN CadFunc as f on sb.Matricula = f.MatriculaNova INNER JOIN Municipio as M ON f.LotacaoOrigem = M.MunicipioId INNER JOIN Regional AS R ON M.MunicipioRegionalId=R.RegionalId  WHERE IdEscalaParcial='"&IdSegundaEscala&"' AND IdBarreira ='"&idBarreira&"'"
set rs2 = conn.Execute(strSql2)
strSql3 = "SELECT * FROM SEBV_VeiculoEscala AS Ve INNER JOIN SEBV_Veiculo AS V ON Ve.IdVeiculo = V.Id WHERE IdEscalaParcial='"&IdPrimeiraEscala&"' AND IdBarreiraVol='"&idBarreira&"'"
set rs3 = conn.Execute(strSql3)
veiculo = trim(rs3("Modelo"))&" / "&trim(rs3("Placa"))


DIM existeJusPrim, existeJusSeg
function verificaJus()
  set rs4 = conn.execute("SELECT COUNT (*) AS qt FROM SEBV_Justificativa WHERE IdEscalaParcial = '"&IdPrimeiraEscala& "'AND IdBarreira = '"&IdBarreira&"'")
  set rs5 = conn.execute("SELECT COUNT (*) AS qt FROM SEBV_Justificativa WHERE IdEscalaParcial = '"&IdSegundaEscala& "'AND IdBarreira = '"&IdBarreira&"'")
    if rs4("qt") > 0 then
      existeJusPrim = true
    elseIf rs4("qt") = 0 then
      existeJusPrim = false
    elseIf rs5("qt") > 0 then
      existeJusSeg = true
    elseIf rs5("qt") = 0 then
      existeJusSeg = false
    else
    end if    
    rs4.close
    rs5.close
    set rs4 = Nothing
    set rs5 = Nothing
end function
verificaJus()

DIM jusPrim, jusSeg, rsPrim, rsSeg
function retornaJus()
  set rsPrim = conn.execute("SELECT TOP 1 * FROM SEBV_Justificativa WHERE IdEscalaParcial = '"&IdPrimeiraEscala&"' AND IdBarreira = '"&idBarreira&"'")
  set rsSeg = conn.execute("SELECT TOP 1 * FROM SEBV_Justificativa WHERE IdEscalaParcial = '"&IdSegundaEscala&"' AND IdBarreira = '"&idBarreira&"'")
  jusPrim = false
  jusSeg = false
  if not rsPrim.EOF then
    if rsPrim("IdBarreira") <> "" then
      jusPrim = true
    end if
  end if
  if not rsSeg.EOF then
    if rsSeg("IdBarreira") <> "" then
      jusSeg = true
    else 
    end if
  end if
end function
retornaJus()


set pdf=CreateJsObject("FPDF")
logoTo = "img/logo-to.jpg"
logoAdapec = "img/logo_adapec.jpg"
Set pdf=CreateJsObject("FPDF")

'// aki poderemos adcionar várias funções como titulos padroes para todas as páginasm numeração de páginas e etc.

'// montando o corpo do pdf, setando o tipo da folha, tipo de medida e o tamanho da folha
pdf.CreatePDF "P","mm","A4"
pdf.SetPath("fpdf/")
pdf.Open()

'// adcionando página
pdf.AddPage()



'// setando grossura da linha
pdf.SetLineWidth(0.3)

pdf.Image logoTo, 105, 5, 45, 20, "JPG"
pdf.Image logoAdapec, 60, 5, 40, 20, "JPG"

'// setando linhas, reapare que, as medidas são feitas em x1, y1, x2 e y2, començando no ponto inicial de x e y e finalizando nos mesmo.
'pdf.Line "7","50","201","50"
'// criamos aki uma linha horizontal, a linha pode ser feita de qualquer jeito, vertical, diagonal e td mais, somente setando os valores de x e y.

'// escrevendo um texto
'// setando fonte e tamanho
pdf.SetFont "Helvetica","B",12
pdf.Text "58","32","ESCALA DE TRABALHO DA BARREIRA VOLANTE"
pdf.Text "83","37","MÊS DE "&UCASE(trim(mesRef))&" DE "&ano&""

'// na linha acima setamos primeiro a função Text, depois aonde começamos a escrever apartir do x e y e por fim o texto a ser adcionado
'// presta-se atenção aki, pois quem precisa fazer uma leitura de banco de dados ou resgatar uma session para ser impressa no pdf, n se pode usar as ' ' na função de texto
'Create Header Cells
pdf.SetFont "Helvetica","B",10
pdf.Text 10, 45, "1° ESCALA DE BARREIRA VOLANTE"
pdf.Text 135, 45,  "VEÍCULO: "
pdf.SetFont "Helvetica","",10
pdf.Text 152, 45, veiculo

'JUSTIFICATIVA 
pdf.SetFont "Helvetica","",10
if jusPrim = true then
pdf.SetXY 10, 47
pdf.SetFont "Helvetica","B",10
pdf.setfillcolor 235
pdf.Cell 190,4,"JUSTIFICATIVA",1,0,"C",1
pdf.SetFont "Helvetica","",9
pdf.Ln()
pdf.MultiCell 190,5,""&rsPrim("Descricao")&"",1,0,"L"
     
else
'BLOCO 01 SERVIDORES 1 -------------------------------------------------------------------------------------
pdf.SetXY 10, 47
pdf.SetFont "Helvetica","B",10
pdf.setfillcolor 235
pdf.Cell 150,4,"SERVIDOR",1,0,"C",1
pdf.Cell 40,4,"MATRÍCULA",1,0,"C",1
pdf.SetFont "Helvetica","",9
pdf.Ln()

'Create results loop
while not rs1.EOF
'Example Data 
fun1 = rs1("Nome")
mat1 = rs1("Matricula")
vinc1 = rs1("VinculoMat")

pdf.Cell 150,5,""&fun1&"",1,0,"L"
pdf.Cell 40,5,""&trim(mat1)&"-"&trim(vinc1)&"",1,0,"L"
'Add Line Break
pdf.Ln() 
rs1.movenext
wend
END IF
'BLOCO 02 ESCALA 1  -------------------------------------------------------------------------------------

pdf.SetXY 10, 63
pdf.SetFont "Helvetica","B",10
pdf.setfillcolor 235
pdf.Cell 20,4,"Data",1,0,"C",1
pdf.Cell 20,4,"Saída",1,0,"C",1
pdf.Cell 20,4,"Chegada",1,0,"C",1
pdf.Cell 90,4,"INTINERÁRIO/SERVIÇO",1,0,"C",1
pdf.Cell 40,4,"MUNICÍPIO",1,0,"C",1
pdf.SetFont "Helvetica","",9
pdf.Ln()
'Create results loop
while not ObjRst.EOF
'Example Data 

If Len(Day(ObjRst("DiaEscala"))) <= 1 and Len(Month(ObjRst("DiaEscala"))) <= 1 then
    dt1="0"&(Day(ObjRst("DiaEscala")))&"/0"&(Month(ObjRst("DiaEscala")))
elseIf Len(Day(ObjRst("DiaEscala"))) <= 1 and Len(Month(ObjRst("DiaEscala"))) <> 1 then
    dt1="0"&(Day(ObjRst("DiaEscala")))&"/"&(Month(ObjRst("DiaEscala")))
elseIf Len(Day(ObjRst("DiaEscala"))) > 1 and Len(Month(ObjRst("DiaEscala"))) <= 1 then
    dt1=(Day(ObjRst("DiaEscala")))&"/0"&(Month(ObjRst("DiaEscala")))
else
    dt1=(Day(ObjRst("DiaEscala")))&"/"&(Month(ObjRst("DiaEscala")))
end if 

hs1=ObjRst("HoraSaida")
ch1=ObjRst("HoraChegada")
it1=ObjRst("Descricao")
mu1=ObjRst("MunicipioDesc")

pdf.Cell 20,4,""&dt1&"",1,0,"L"
pdf.Cell 20,4,""&hs1&"",1,0,"L"
pdf.Cell 20,4,""&ch1&"",1,0,"L"
pdf.Cell 90,4,""&left(it1,52)&"",1,0,"L"
pdf.Cell 40,4,""&left(mu1,20)&"",1,0,"L"
'Add Line Break
pdf.Ln() 
ObjRst.movenext
wend


data =  Request.QueryString("Data")
data = cdate (data) 

Function apData(data)
  dia_semana = WeekDay(data)
  Select Case dia_semana
  Case 1 : dia_semana = "Domingo"
  Case 2 : dia_semana = "Segunda-Feira"
  Case 3 : dia_semana = "Terça-Feira"
  Case 4 : dia_semana = "Quarta-Feira"
  Case 5 : dia_semana = "Quinta-Feira"
  Case 6 : dia_semana = "Sexta-Feira"
  Case 7 : dia_semana = "Sábado"
  End Select
  mes = Month(data)
  Select Case mes
  Case 1 : mes = "Janeiro"
  Case 2 : mes = "Fevereiro"
  Case 3 : mes = "Março"
  Case 4 : mes = "Abril"
  Case 5 : mes = "Maio"
  Case 6 : mes = "Junho"
  Case 7 : mes = "Julho"
  Case 8 : mes = "Agosto"
  Case 9 : mes = "Setembro"
  Case 10 : mes = "Outubro"
  Case 11 : mes = "Novembro"
  Case 12 : mes = "Dezembro"
  End Select
  apData = Day(data) & " de " & mes & " de " & Year(data)
End Function

pdf.Text 120, 280, session("regionalFunc")&" - TO, "& apData(DATE)


'// adcionando página
pdf.AddPage()



'// setando grossura da linha
pdf.SetLineWidth(0.3)

pdf.Image logoTo, 105, 5, 45, 20, "JPG"
pdf.Image logoAdapec, 60, 5, 40, 20, "JPG"

'// setando linhas, reapare que, as medidas são feitas em x1, y1, x2 e y2, començando no ponto inicial de x e y e finalizando nos mesmo.
'pdf.Line "7","50","201","50"
'// criamos aki uma linha horizontal, a linha pode ser feita de qualquer jeito, vertical, diagonal e td mais, somente setando os valores de x e y.

'// escrevendo um texto
'// setando fonte e tamanho
pdf.SetFont "Helvetica","B",12
pdf.Text "58","32","ESCALA DE TRABALHO DA BARREIRA VOLANTE"
pdf.Text "83","37","MÊS DE "&UCASE(trim(mesRef))&" DE "&ano&""

'BLOCO 03 SERVIDORES 2 ---------------------------------------------------------------------'
pdf.SetFont "Helvetica","B",10
pdf.Text 10, 45, "2° ESCALA DE BARREIRA VOLANTE"
pdf.SetXY 10, 47
'JUSTIFICATIVA 2
if jusSeg = true then
pdf.setfillcolor 235
pdf.Cell 190,4,"JUSTIFICATIVA",1,0,"C",1
pdf.SetFont "Helvetica","",10
pdf.Ln()
pdf.MultiCell 190,5,""&rsSeg("Descricao")&"",1,0,"L"
else
pdf.setfillcolor 235
pdf.Cell 150,4,"SERVIDOR",1,0,"C",1
pdf.Cell 40,4,"MATRÍCULA",1,0,"C",1
pdf.SetFont "Helvetica","",10
pdf.Ln()

while not rs2.EOF
'Example Data 
fun2 = rs2("Nome")
mat2 = rs2("Matricula")
vinc2 = rs2("VinculoMat")
regionaldesc= rs2("RegionalDesc")

pdf.Cell 150,5,""&fun2&"",1,0,"L"
pdf.Cell 40,5,""&trim(mat2)&"-"&trim(vinc2)&"",1,0,"L"
'Add Line Break
pdf.Ln() 
rs2.movenext
wend
end if
' BLOCO 04 ESCALA 2 ----------------------------------------------------------------------------

pdf.SetXY 10, 63
pdf.SetFont "Helvetica","B",10
pdf.setfillcolor 235
pdf.Cell 20,4,"Data",1,0,"C",1
pdf.Cell 20,4,"Saída",1,0,"C",1
pdf.Cell 20,4,"Chegada",1,0,"C",1
pdf.Cell 90,4,"INTINERÁRIO/SERVIÇO",1,0,"C",1
pdf.Cell 40,4,"MUNICÍPIO",1,0,"C",1
pdf.SetFont "Helvetica","",9
pdf.Ln()
while not ObjRst2.EOF
'Example Data 

If Len(Day(ObjRst2("DiaEscala"))) <= 1 and Len(Month(ObjRst2("DiaEscala"))) <= 1 then
    dt2="0"&(Day(ObjRst2("DiaEscala")))&"/0"&(Month(ObjRst2("DiaEscala")))
elseIf Len(Day(ObjRst2("DiaEscala"))) <= 1 and Len(Month(ObjRst2("DiaEscala"))) <> 1 then
    dt2="0"&(Day(ObjRst2("DiaEscala")))&"/"&(Month(ObjRst2("DiaEscala")))
elseIf Len(Day(ObjRst2("DiaEscala"))) > 1 and Len(Month(ObjRst2("DiaEscala"))) <= 1 then
    dt2=(Day(ObjRst2("DiaEscala")))&"/0"&(Month(ObjRst2("DiaEscala")))
else
    dt2=(Day(ObjRst2("DiaEscala")))&"/"&(Month(ObjRst2("DiaEscala")))
end if 

hs2=ObjRst2("HoraSaida")
ch2=ObjRst2("HoraChegada")
it2=ObjRst2("Descricao")
mu2=ObjRst2("MunicipioDesc")

pdf.Cell 20,4,""&dt2&"",1,0,"L"
pdf.Cell 20,4,""&hs2&"",1,0,"L"
pdf.Cell 20,4,""&ch2&"",1,0,"L"
pdf.Cell 90,4,""&left(it2,52)&"",1,0,"L"
pdf.Cell 40,4,""&left(mu2,20)&"",1,0,"L"
'Add Line Break
pdf.Ln() 
ObjRst2.movenext
wend

pdf.SetXY 10, 250
pdf.Line 70,250,150,250
pdf.Text 95, 255, "RESPONSÁVEL"

pdf.Text 120, 280, session("regionalFunc")&" - TO, "& apData(DATE)

'// fechando o pdf
pdf.Close()
pdf.Output()
%>