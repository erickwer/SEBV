<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001" %>
<!--#include file ="lib/conexao.asp"--> 

<%
dim autorizado, dataAtual, mesAtual, mesRef, dias, anoRef, dataLimite, diferenca
session("idUsu") = request("idUsu")

function comparaData()
	dataAtual = Date()
	mesAtual = MonthName(Month(dataAtual))
	strSql = "SELECT * FROM EBF_Calendario"
	
	set rs2 = conn.Execute(strSql)	
	if not rs2.EOF then			
		do while not rs2.EOF
			diferenca = DateDiff("d",date,rs2("DataLimite"))
			if dataAtual <= rs2("DataLimite") and dataAtual >= rs2("DataInicio") then
				dias = diferenca
				session("mesRef") = rs2("Mes")
				session("anoRef") = rs2("Ano")
				dataLimite = rs2("DataLimite")
			else
				end if	
		rs2.Movenext()
		loop 
		set rs2 =  Nothing
	else	
		end if
	end function
	comparaData()

if session("idUsu") = "1162756-2" OR session("idUsu") = "11186178-1" OR session("idUsu") = "834272-5" OR session("idUsu") = "6238081" then
	autorizado = true
else
  autorizado = false
end if

if autorizado = true then%>
  <!--#include file="base.asp"-->
<%elseIf autorizado = false then %>
  <!--#include file="base2.asp"-->
<%end if%>

<div class="col-lg-10">
  <!-- Dropdown Basics -->
  <div class="card mb-4">
    <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
      <h6 class="m-0 font-weight-bold text-primary">Sistema de Escala de Barreira Volante</h6>
    </div>
    <div class="card-body text-center">
      <p>Seja bem-vindo ao módulo de cadastro de Escalas de Barreiras Volante. Aqui você pode definir os servidores para as escalas das Barreiras Volantes da sua regional.</p>
      <p style="color:#17A2B8"> Data limite para a Escala de <%=UCASE(session("mesRef"))%>: <%=dataLimite%> <br> Dias restantes: <%=dias%> </p>
      <p>Clique no botão abaixo para iniciar o processo de cadastro.</p>
      <a href="passo1.asp" class="btn btn-primary btn-icon-split">
        <span class="icon text-white-50">
          <i class="fas fa-flag"></i>
        </span>
        <span class="text">Selecionar Barreira Volante</span>
      </a>
    </div>
  </div>
</div>