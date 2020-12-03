<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001" %>
<!--#include file ="lib/conexao.asp"-->
<% 
dim idBarreira
idBarreira = request.form("idbarjus")
descricao  = request.form("justificativa")
idEscala = request.form("idepjus")
situacao = request.form("situacaojus")
op = request("operacao")
id = request("idJus")
idBarreiraUrl = request("idb")

	if idBarreira = null  or  idEscala = null or  session("idUsu") = null or session("idUsu") = " " then
		%>
		<script>
            alert('Não foi possivel cadastrar. Parâmetros vazios!!');
            window.location.assign('passo2.asp?idb=<%=idBarreira%>');
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
		Set rs = conn.Execute("INSERT INTO SEBV_Justificativa (IdEscalaParcial, IdBarreira, Descricao, Situacao) VALUES ('"&idEscala&"','"&idBarreira&"','"&descricao&"','"&situacao&"')")
		if err <> 0 then
		%>
			<script>
            alert('Não foi possivel cadastrar!!');
            window.location.assign('passo2.asp?idb=<%=idBarreira%>');
            </script>
		<%
		  else
		%>
			<script>
			 window.location.assign('passo2.asp?idb=<%=idBarreira%>&resp=true');
			</script>
         <%
  		end if
		rs.Close
		Set rs = Nothing		
	end function

    function excluir(id)
		on error resume next
		Set rs = conn.Execute("DELETE FROM SEBV_Justificativa WHERE Id ='"&id&"'")
		if err <> 0 then
		%>
			<script>
			window.location.assign('passo2.asp?idb=<%=idBarreiraUrl%>&resp=err');
			</script>
		<%
		else
		%>
			<script>
			window.location.assign('passo2.asp?idb=<%=idBarreiraUrl%>&resp=ok');
			</script>
        <%
		end if
		rs.close
		Set rs = Nothing
	end function 
	

%>