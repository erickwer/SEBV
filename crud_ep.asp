  <%@LANGUAGE="VBSCRIPT" CODEPAGE="65001" %>
  <!--#include file ="lib/conexao.asp"-->
  <% 	
	response.Charset="utf-8"
	dim descricao, op, idEp
	descricao = request.form("escaladesc")
	dataIni = Trim(request.form("dataIni"))
	dataFin = Trim(request.form("dataFin"))
	idEp =  request("id")
	op = request("operacao")
	status = 1

	
	if descricao = null or descricao = " " or session("idUsu") = null or session("idUsu") = " " then
		%>
		<script>
            alert('Não foi possivel cadastrar. Parâmetros inválidos!!');
            window.location.assign('form_ep.asp?idUsu=<%=session("idUsu")%>');
        </script>
        <%
	elseIf op = " " or op = null or op = 1 then
		inserir()
	elseIf op = 2 then
		desativar(idEp)
	else	
	end if
	
	function inserir()
		on error resume next		
		Set rs = conn.Execute("INSERT INTO SEBV_EscalaParcial (EscalaDesc, DataInicio, DataTermino, MesRef, Status, DataCadastro) VALUES ('"&descricao&"',(Convert(Date,'"&dataIni&"')),(Convert(Date,'"&dataFin&"')),'"&session("mesRef")&"','"&status&"',GETDATE())")
		if err <> 0 then
		%>
			<script>
            alert('Não foi possivel cadastrar!!');
            window.location.assign('form_ep.asp?idUsu=<%=session("idUsu")%>');
            </script>
		<%
  		else
		%>	
			<script>
			window.location.assign('form_ep.asp?idUsu=<%=session("idUsu")%>&resp=ins');
			</script>
         <%
  		end if
		rs.Close
		Set rs = Nothing		
	end function
	
	
	function desativar(id)	
		on error resume next
		Set rs = conn.Execute("UPDATE SEBV_EscalaParcial SET Status = 0 WHERE Id ='"&id&"'")
		if err <> 0 then
		%>
			<script>
			window.location.assign('lista_eps.asp?idUsu=<%=session("idUsu")%>&resp=err');
			</script>
		<%
		else
		%>
			<script>
			window.location.assign('lista_eps.asp?idUsu=<%=session("idUsu")%>&resp=ok');
			</script>
        <%
		end if
		rs.close
		Set rs = Nothing
	end function 
	
%>