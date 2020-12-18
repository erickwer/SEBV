  <%@LANGUAGE="VBSCRIPT" CODEPAGE="65001" %>
  <!--#include file ="lib/conexao.asp"-->
  <% 	
	dim descricao, idMun, op, idRota, idBarreiraUrl
	idBarreira = request.form("idbar")
	idVeiculo =  request.form("idvei")
	idPrimeiraEscala = request.form("idesc1")
	idSegundaEscala = request.form("idesc2")
	status=1
	op = request("operacao")	
	idBarreiraUrl = request("idb")

	if idBarreira = null or  idRota = null or  idEscalaParcial = null or  session("idUsu") = null or session("idUsu") = " " then
		%>
		<script>
            alert('Não foi possivel cadastrar. Parâmetros inválidos!!');
            window.location.assign('passo3.asp?idb=<%=idBarreira%>');
        </script>
        <%
	elseIf op = " " or op = null or op = 1 then
		inserir()
	elseIf op = 2 then
		excluir(id)
	else	
	end if
	
	function inserir()
		on error resume next		
		Set rs = conn.Execute("INSERT INTO SEBV_VeiculoEscala (IdEscalaParcial, IdBarreiraVol, IdVeiculo, Status) VALUES ('"&idPrimeiraEscala&"','"&idBarreira&"','"&idVeiculo&"','"&Status&"')")
		set rs1 = conn.Execute("UPDATE SEBV_ServidoresEsc SET Situacao = 'Fechado' FROM SEBV_ServidoresEsc AS SE INNER JOIN SEBV_EscalaParcial EP ON SE.IdEscalaParcial = EP.Id  WHERE SE.IdBarreira = '"&idBarreira&"' AND MesRef = '"&session("mesRef")&"' AND YEAR(EP.DataInicio)='"&session("anoRef")&"' ")
		Set rs2 = conn.Execute("UPDATE SEBV_RotaEscala SET Situacao = 'Fechado' FROM SEBV_RotaEscala AS RE INNER JOIN SEBV_EscalaParcial EP ON RE.IdEscalaParcial = EP.Id  WHERE RE.IdBarreiraVol = '"&idBarreira&"' AND MesRef = '"&session("mesRef")&"' AND YEAR(EP.DataInicio)='"&session("anoRef")&"' ")
		if err <> 0 then
		%>
			<script>
            alert('Não foi possivel cadastrar!!');
            window.location.assign('passo4.asp?idb=<%idBarreira%>');
            </script>
		<%
		  else
		%>
			<script>
			window.open('visualizaAdmin.asp?idb=<%=idBarreira%>&ide1=<%=idPrimeiraEscala%>&ide2=<%=idSegundaEscala%>');
			window.location.assign('index.asp?idUsu=<%=session("idUsu")%>', '_blank');
			</script>
         <%
  		end if
		rs.Close
		Set rs = Nothing		
	end function
	
%>