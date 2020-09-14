  <%@LANGUAGE="VBSCRIPT" CODEPAGE="65001" %>
  <!--#include file ="lib/conexao.asp"-->
  <% 	
	response.Charset="utf-8"
	dim modelo, placa, op, idVeiculo, quantidade, existeServ, idBarreiraUrl
	idBarreiraForm= request.form("idbar")
	idBarreiraUrl = request("idb")
	idEp =  request.form("idep")
	matricula = request.form("idserv")
	situacao = request.form("situacao")
	vinculo =  request.form("vinc")
	op = request("operacao")
	idServidor = request("id")

	if idBarreiraForm = null or idEp = null or session("idUsu") = null or session("idUsu") = " " then
		%>
		<script>
            alert('Não foi possivel cadastrar. Parâmetros inválidos!!');
            window.location.assign('passo2.asp?idb=<%=idBarreiraForm%>');
        </script>
		<%
	elseIf op = " " or op = null or op = 1 then	
		verificaServidor()
		verificaQuantidade()
		if quantidade = false then
			%>
			<script>
				alert('Não é possivel cadastrar mais de dois servidores em uma escala!!');
				window.location.assign('passo2.asp?idb=<%=idBarreiraForm%>');
			</script>
			<%
		elseIf quantidade = true then
			inserir()
		end if
	elseIf op = 2 then
		excluir()
	else
	end if

	function verificaQuantidade()
		on error resume next
		Set rs = conn.Execute("SELECT COUNT(*) as quantidade FROM SEBV_ServidoresEsc WHERE IdEscalaParcial = '"&idEp&"' and IdBarreira = '"&idBarreiraForm&"'")
		if err <> 0 then			
		else
			if rs("quantidade") < 2 then
				quantidade = true
			else
				quantidade = false
			end if
		end if
		rs.close
		Set rs = Nothing
	end function 

	function verificaServidor()
		on error resume next
		Set rs = conn.Execute("SELECT COUNT(*) as servidor FROM SEBV_ServidoresEsc WHERE IdEscalaParcial = '"&idEp&"' and IdBarreira = '"&idBarreiraForm&"' and Matricula='"&matricula&"' and VinculoMat='"&vinculo&"'")
		if err <> 0 then			
		else
			if rs("servidor") > 0 then
				existeServ = true
			else
				existeServ = false
			end if
		end if
		rs.close
		Set rs = Nothing
	end function 
	
	function inserir()		
		on error resume next		
		Set rs = conn.Execute("INSERT INTO SEBV_ServidoresEsc (IdEscalaParcial, IdBarreira, Matricula, VinculoMat, Situacao) VALUES ('"&idEp&"','"&idBarreiraForm&"','"&matricula&"','"&vinculo&"','"&situacao&"')")
		formserv.reset()
		if err <> 0 then
		%>
			<script>
            window.location.assign('passo2.asp?idb=<%=idBarreiraForm%>');
            </script>
		<%
  		else
		%>	
			<script>
			window.location.assign('passo2.asp?idb=<%=idBarreiraForm%>');
			</script>
         <%
  		end if
		rs.Close
		Set rs = Nothing		
	end function
	
	
	function excluir()
		on error resume next
		Set rs = conn.Execute("DELETE FROM SEBV_ServidoresEsc WHERE Id ='"&idServidor&"'")
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