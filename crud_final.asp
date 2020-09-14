  <%@LANGUAGE="VBSCRIPT" CODEPAGE="65001" %>
  <!--#include file ="lib/conexao.asp"-->
  <% 	
	response.Charset="utf-8"
	dim descricao, idMun, op, idRota, idBarreiraUrl, mesRef, IdPrimeiraEscala
	mesRef = trim(request("mesRef"))
	status=1
	op = request("op")	
	idBarreiraUrl = request("idb")

function RetornaIdEscalas()
	Set objSql =  conn.Execute("SELECT * FROM SEBV_EscalaParcial WHERE MesRef='"&mesRef&"'")
	do while not objSql.EOF
		if objSql("EscalaDesc") = "1" Then
			IdPrimeiraEscala = objSql("Id")
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
      
RetornaIdEscalas()

	if idBarreiraUrl = null and  session("idUsu") = null or session("idUsu") = " " then
		%>
		<script>
            alert('Não foi possivel desbloquear. Parâmetros inválidos!!');
            window.location.assign('relatorio.asp');
        </script>
        <%
	elseIf op = "unlock"  then
		liberar()
	else	
	end if
	
	function liberar()
		on error resume next
		Set rs1 = conn.Execute("UPDATE SEBV_ServidoresEsc SET Situacao = 'Vinculado' FROM SEBV_ServidoresEsc AS SE INNER JOIN SEBV_EscalaParcial EP ON SE.IdEscalaParcial = EP.Id  WHERE SE.IdBarreira = '"&idBarreiraUrl&"' AND MesRef = '"&mesRef&"' ")
		Set rs2 = conn.Execute("UPDATE SEBV_RotaEscala SET Situacao = 'Vinculado' FROM SEBV_RotaEscala AS RE INNER JOIN SEBV_EscalaParcial EP ON RE.IdEscalaParcial = EP.Id  WHERE RE.IdBarreiraVol = '"&idBarreiraUrl&"' AND MesRef = '"&mesRef&"' ")
		Set rs3 = conn.Execute("DELETE FROM SEBV_VeiculoEscala WHERE IdBarreiraVol = '"&idBarreiraUrl&"' AND IdEscalaParcial = '"&IdPrimeiraEscala&"'")
		
		if err <> 0 then
		%>
			<script>
            alert('Não foi possivel desbloquear!!');
            window.location.assign('relatorio.asp?resp=err');
            </script>
		<%
		  else
		  	
		%>	
			<script>
			window.location.assign('relatorio.asp?msg=ok');
			</script>
         <%
  		end if
		rs1.Close
		rs2.Close
		rs3.Close
		Set rs1 = Nothing
		Set rs2 = Nothing
		Set rs3 = Nothing		
	end function
	
%>