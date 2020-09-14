  <%@LANGUAGE="VBSCRIPT" CODEPAGE="65001" %>
  <!--#include file ="lib/conexao.asp"-->
  <% 	
	response.Charset="utf-8"
	dim descricao, idMun, op, idRota
	descricao = request.form("descricao")
	idMun =  request.form("municipio")
	op = request("operacao")
	status = 1
	idRota = request("id")
	
	
	if descricao = null or descricao = " " or session("idUsu") = null or session("idUsu") = " " then
		%>
		<script>
            alert('Não foi possivel cadastrar. Parâmetros inválidos!!');
            window.location.assign('form_rota.asp?idUsu=<%=session("idUsu")%>');
        </script>
        <%
	elseIf op = " " or op = null or op = 1 then
		inserir()
	elseIf op = 2 then
		desativar(idRota)
	else	
	end if
	
	function inserir()		
		on error resume next		
		Set rs = conn.Execute("INSERT INTO SEBV_Rota (Descricao, MunicipioId, Status, RespCadastro, DataCadastro) VALUES ('"&descricao&"','"&idMun&"','"&status&"', '"&session("idUsu")&"',GETDATE())")
		if err <> 0 then
		%>
			<script>
            alert('Não foi possivel cadastrar!!');
            window.location.assign('form_rota.asp?idUsu=<%=session("idUsu")%>');
            </script>
		<%
  		else
		%>	
			<script>
			window.location.assign('form_rota.asp?idUsu=<%=session("idUsu")%>&resp=ins');
			</script>
         <%
  		end if
		rs.Close
		Set rs = Nothing		
	end function
	
	
	function desativar(id)
		on error resume next
		Set rs = conn.Execute("UPDATE SEBV_Rota SET Status = 0 WHERE Id ='"&id&"'")
		if err <> 0 then
		%>
			<script>
			window.location.assign('lista_rotas.asp?idUsu=<%=session("idUsu")%>&resp=err');
			</script>
		<%
		else
		%>
			<script>
			window.location.assign('lista_rotas.asp?idUsu=<%=session("idUsu")%>&resp=ok');
			</script>
        <%
		end if
		rs.close
		Set rs = Nothing
	end function 
	
%>