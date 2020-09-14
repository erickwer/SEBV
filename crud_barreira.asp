  <%@LANGUAGE="VBSCRIPT" CODEPAGE="65001" %>
  <!--#include file ="lib/conexao.asp"-->
  <% 	
	response.Charset="utf-8"
	dim modelo, placa, op, idVeiculo
	descricao = request.form("descricao")
	regionalId =  request.form("regional")
	op = request("operacao")
	status = 1
	idBarreira = request("id")
	
	if descricao = null or descricao = " " or session("idUsu") = null or session("idUsu") = " " then
		%>
		<script>
            alert('Não foi possivel cadastrar. Parâmetros inválidos!!');
            window.location.assign('form_barreira.asp?idUsu=<%=session("idUsu")%>');
        </script>
        <%
	elseIf op = " " or op = null or op = 1 then
		inserir()
	elseIf op = 2 then
		desativar(idBarreira)
	else	
	end if
	
	function inserir()		
		on error resume next		
		Set rs = conn.Execute("INSERT INTO SEBV_BarreiraVolante (Descricao, regionalId, Status, DataCadastro) VALUES ('"&descricao&"','"&regionalId&"','"&status&"',GETDATE())")
		if err <> 0 then
		%>
			<script>
            window.location.assign('form_barreira.asp?idUsu=<%=session("idUsu")%>&resp=err1');
            </script>
		<%
  		else
		%>	
			<script>
			window.location.assign('form_barreira.asp?idUsu=<%=session("idUsu")%>&resp=ins');
			</script>
         <%
  		end if
		rs.Close
		Set rs = Nothing		
	end function
	
	
	function desativar(id)
		on error resume next
		Set rs = conn.Execute("UPDATE SEBV_BarreiraVolante SET Status = 0 WHERE Id ='"&id&"'")
		if err <> 0 then
		%>
			<script>
			window.location.assign('lista_barreiras.asp?idUsu=<%=session("idUsu")%>&resp=err');
			</script>
		<%
		else
		%>
			<script>
			window.location.assign('lista_barreiras.asp?idUsu=<%=session("idUsu")%>&resp=ok');
			</script>
        <%
		end if
		rs.close
		Set rs = Nothing
	end function 
	
%>