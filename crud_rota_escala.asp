  <%@LANGUAGE="VBSCRIPT" CODEPAGE="65001" %>
  <!--#include file ="lib/conexao.asp"-->
  <% 	
	response.Charset="utf-8"
	dim descricao, idMun, op, idRota, idBarreiraUrl
	idBarreira = request.form("idbar")
	idRota =  request.form("rota")
	idEscalaParcial = request.form("idesc")
	diaEsc = request.form("data")
	horaIni = trim(request.form("horaIni"))
	horaFin = trim(request.form("horaFin"))
	op = request("operacao")	
	id = request("id")
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
		Set rs = conn.Execute("INSERT INTO SEBV_RotaEscala (IdBarreiraVol, IdRota, IdEscalaParcial, DiaEscala, HoraSaida, HoraChegada, Situacao) VALUES ('"&idBarreira&"','"&idRota&"','"&idEscalaParcial&"','"&diaEsc&"','"&horaIni&"','"&horaFin&"','Vinculado')")
		if err <> 0 then
		%>
			<script>
            alert('Não foi possivel cadastrar!!');
            window.location.assign('passo3.asp?idb=<%=idBarreira%>');
            </script>
		<%
  		else
		%>	
			<script>
			window.location.assign('passo3.asp?idb=<%=idBarreira%>&resp=ins');
			</script>
         <%
  		end if
		rs.Close
		Set rs = Nothing		
	end function
	
	
	function excluir(id)
		on error resume next
		Set rs = conn.Execute("DELETE FROM SEBV_RotaEscala WHERE Id ='"&id&"'")
		if err <> 0 then
		%>
			<script>
			window.location.assign('passo3.asp?idb=<%=idBarreiraUrl%>&resp=err');
			</script>
		<%
		else
		%>
			<script>
			window.location.assign('passo3.asp?idb=<%=idBarreiraUrl%>&resp=ok');
			</script>
        <%
		end if
		rs.close
		Set rs = Nothing
	end function 
	
%>