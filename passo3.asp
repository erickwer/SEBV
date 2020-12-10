<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001" %>
<!--#include file ="lib/conexao.asp"-->
<%
dim autorizado

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
<%
dim nomeFunc, regionalFunc, IdPrimeiraEscala, IdSegundaEscala, existeCad, idBarreira

  municipioId = request.form("municipio")
  descricao = request.form("descricao")
  resp = request("resp")
  idBarreira = request("idb")
'BUSCAR REGIONAL DO FUNCIONÁRIO
function RegionalFuncionario()
      Set objSql = conn.Execute("SELECT Nome, RegionalDesc FROM CadFunc AS F INNER JOIN Municipio AS M ON F.LotacaoOrigem=M.MunicipioId INNER JOIN Regional AS R ON  M.MunicipioRegionalId = R.RegionalId WHERE Matricula='"&session("idUsu")&"'")
          If Not objSql.Eof Then
              While Not objSql.Eof
              if IsNull(objSql("Nome")) then
                  response.write("Nada encontrado")
              else
                  session("nomeFunc") = (objSql("Nome"))
                  session("regionalFunc") = objSql("RegionalDesc")
              End If
              objSql.movenext
              Wend
          End If
          objSql.Close
          Set objSql = Nothing
          end function
RegionalFuncionario()

function RetornaIdEscalas()
    Set objSql =  conn.Execute("SELECT * FROM SEBV_EscalaParcial WHERE MesRef='"&session("mesRef")&"' AND Status = '1'")
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

  strSQL = "SELECT DiaEscala, Re.Id, HoraSaida, HoraChegada, Ro.Descricao, M.MunicipioDesc FROM SEBV_RotaEscala AS Re INNER JOIN SEBV_Rota AS Ro ON Re.IdRota=Ro.Id INNER JOIN Municipio AS M ON Ro.MunicipioId=M.MunicipioId INNER JOIN SEBV_EscalaParcial AS Ep On Re.IdEscalaParcial = Ep.Id INNER JOIN Regional AS R ON M.MunicipioRegionalId=R.RegionalId WHERE Re.IdEscalaParcial = '"&IdPrimeiraEscala&"' AND Situacao = 'Vinculado' AND RegionalDesc = '"&session("regionalFunc")&"' AND Ep.MesRef='"&session("mesRef")&"' ORDER BY DiaEscala"
  
  set ObjRst = conn.Execute(strSQL)		
  strSQL2 = "SELECT DiaEscala, Re.Id, HoraSaida, HoraChegada, Ro.Descricao, M.MunicipioDesc FROM SEBV_RotaEscala AS Re INNER JOIN SEBV_Rota AS Ro ON Re.IdRota=Ro.Id INNER JOIN Municipio AS M ON Ro.MunicipioId=M.MunicipioId INNER JOIN SEBV_EscalaParcial AS Ep On Re.IdEscalaParcial = Ep.Id INNER JOIN Regional AS R ON M.MunicipioRegionalId=R.RegionalId WHERE Re.IdEscalaParcial = '"&IdSegundaEscala&"' AND Situacao = 'Vinculado' AND RegionalDesc = '"&session("regionalFunc")&"' AND Ep.MesRef='"&session("mesRef")&"' ORDER BY DiaEscala"
  set ObjRst2 = conn.Execute(strSQL2)			
  strSql1 = "SELECT R.Id, R.Descricao, M.MunicipioDesc, Reg.RegionalDesc FROM SEBV_Rota AS R INNER JOIN Municipio AS M ON R.MunicipioId = M.MunicipioId INNER JOIN Regional AS Reg ON M.MunicipioRegionalId = Reg.RegionalId WHERE RegionalDesc = '"&session("regionalFunc")&"'"
  set rs1 = conn.Execute(strSql1)
  strSql2 = "SELECT R.Id, R.Descricao, M.MunicipioDesc, Reg.RegionalDesc FROM SEBV_Rota AS R INNER JOIN Municipio AS M ON R.MunicipioId = M.MunicipioId INNER JOIN Regional AS Reg ON M.MunicipioRegionalId = Reg.RegionalId WHERE RegionalDesc = '"&session("regionalFunc")&"'"
  set rs2 = conn.Execute(strSql2)


  function verificaExistencia(matricula)
      set rs =  conn.Execute("SELECT COUNT (*) as qt FROM SEBV_ServidoresEsc AS s INNER JOIN SEBV_EscalaParcial AS p ON s.IdEscalaParcial = p.Id WHERE s.Matricula = '"&matricula&"'AND p.MesRef='"&session("mesRef")&"'")
      if rs("qt") <> 0 then
          existeCad = true
      else 
          existeCad = false
      end if
      rs.close
      set rs = Nothing
  end function  
      
  function verificaCadastroEscala()
      set rs =  conn.Execute("SELECT COUNT (*) as qt FROM EBF_EscalaBarreiraFixa AS f INNER JOIN EBF_EscalaParcial  AS p ON f.IdEscalaParcial = p.Id WHERE IdBarreira = '"&idBarreira&"'AND MesRef='"&session("mesRef")&"' AND statusCadastro ='Definido'")
      if rs("qt") <> 0 then
          existeCadEscala = true
      else 
          existeCadEscala = false
      end if
      rs.close
      set rs = Nothing
  end function 
  
%>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@9"></script>
<script>
var url_string = window.location.href;
var url = new URL(url_string);
var resp = url.searchParams.get("resp");
var idUsu = url.searchParams.get("idUsu");
mensagem(resp)

function mensagem(resp) {
  if (resp == "ins"){
     Swal.fire({
      title: "Ótimo!!!",
      text: "Rota inserida com sucesso!\n ",
      icon: "success",
      button: "Ok!",
      });
      return false;
  }
  else if (resp == "err1"){
     Swal.fire({
      title: "Ops!!!",
      text: "Ocorreu um erro no cadastro. Tente novamente!",
      icon: "error",
      button: "Ok!",
      });
      return false;
  }
  else
  return false;
}

function enviarForm1(){   
    formroute1.operacao.value = 1;
    formroute1.submit();
}

function enviarForm2(){   
    formroute2.operacao.value = 1;
    formroute2.submit();
}
function avancar(){   
  Swal.fire({
  title: 'Deseja continuar?',
    text: "Certifique-se cadastrou corretamente todas as rotas da 1° e 2° escala!",
    icon: 'warning',
    showCancelButton: true,
    confirmButtonColor: '#3085d6',
    cancelButtonColor: '#d33',    
    cancelButtonText: 'Cancelar',
    confirmButtonText: 'Sim, prosseguir!'
  }).then((result) => {
    if (result.value) {
        window.location="passo4.asp?idb=<%=idBarreira%>"
    }
  })
}

</script>
 <div class="col">
  <div class="card">
    <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
     
    </div>
    <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
          <h6 class="m-0 font-weight-bold text-primary">Rotas da 1° Escala do Mês de <%=UCASE(session("mesRef"))%></h6>
        </div>
    <div class="card-body">
      
      <form id="formroute1" name="formroute1" method="POST" action="crud_rota_escala.asp" >
        <input name="operacao" type="hidden" value="" id="operacao"/>
        <input name="idesc" type="hidden" value="<%=IdPrimeiraEscala%>" id="idesc"/>
        <input name="idbar" type="hidden" value="<%=idBarreira%>" id="idbar"/>
        <div class="form-row">
        <div class="form-group mr-2">
          <label for="data">Dia da Escala:</label>
          <input type="date" class="form-control form-control-sm" name="data" id="data" required>
        </div>
        <div class="form-group mr-2">
          <label for="horaIni">Hora inicio:</label>
           <select class="select2-single form-control form-control-sm" name="horaIni" id="horaIni" required> 
            <option value=""  > ... </option>
            <option value="05:00"> 05:00 </option>
            <option value="06:00"> 06:00 </option>
            <option value="07:00"> 07:00 </option>
            <option value="08:00"> 08:00 </option>
            <option value="09:00"> 09:00 </option>
            <option value="10:00"> 10:00 </option>
            <option value="11:00"> 11:00 </option>
            <option value="12:00"> 12:00 </option>
            <option value="13:00"> 13:00 </option>
            <option value="14:00"> 14:00 </option>
            <option value="15:00"> 15:00 </option>
            <option value="16:00"> 16:00 </option>
            <option value="17:00"> 17:00 </option>
            <option value="18:00"> 18:00 </option>
            <option value="19:00"> 19:00 </option>
            <option value="20:00"> 20:00 </option>
            <option value="21:00"> 21:00 </option>
          </select>
        </div>
        <div class="form-group mr-4">
          <label for="horaFin">Hora término:</label>
          <select class="select2-single form-control form-control-sm" name="horaFin" id="horaFin" required> 
            <option value=""  > ... </option>
            <option value="05:00"> 05:00 </option>
            <option value="06:00"> 06:00 </option>
            <option value="07:00"> 07:00 </option>
            <option value="08:00"> 08:00 </option>
            <option value="09:00"> 09:00 </option>
            <option value="10:00"> 10:00 </option>
            <option value="11:00"> 11:00 </option>
            <option value="12:00"> 12:00 </option>
            <option value="13:00"> 13:00 </option>
            <option value="14:00"> 14:00 </option>
            <option value="15:00"> 15:00 </option>
            <option value="16:00"> 16:00 </option>
            <option value="17:00"> 17:00 </option>
            <option value="18:00"> 18:00 </option>
            <option value="19:00"> 19:00 </option>
            <option value="20:00"> 20:00 </option>
            <option value="21:00"> 21:00 </option>
          </select>
        </div>
        <div class="form-group mr-4">
        <label for="select2Single">Rota:</label>
        <select class="select2-single form-control form-control-sm" name="rota" id="select2Single" required> 
          <option value=""  > ... </option>
          <%
              do while not rs1.EOF %>
              <option value="<%=rs1("Id")%>"> <%=rs1("Descricao")%> - <%=rs1("MunicipioDesc")%> </option>
          <% 
            rs1.Movenext()
            loop 
            Set rs1 = Nothing           
          %>
        </select>
        </div>
        <div class="form-group mt-auto">
        <button class="btn btn-warning btn-icon-split btn-sm" onClick="enviarForm1(); return false;">
        <span class="icon text-white-50">
          <i class="fas fa-arrow-right"></i>
        </span>
        <span class="text">Adicionar</span>
      </button>
      </div>
      </form>
      </div>
        
      <table class="table align-items-center table-flush table-sm" id="dataTable" >
        <thead class="thead-light">
          <tr>
            <th>Data</th>
            <th>Hora inicio</th>
            <th>Hora término</th>
            <th>Rota</th>
            <th>Municipio</th>
            <th>Opções</th>
          </tr>
        </thead>
        <tbody>
      <%
         Do while not ObjRst.EOF           
	    %>
        <tr>
            <td ><%If Len(Day(ObjRst("DiaEscala"))) <= 1 and Len(Month(ObjRst("DiaEscala"))) <= 1 then %>
                0<%=(Day(ObjRst("DiaEscala")))%>/0<%=(Month(ObjRst("DiaEscala")))%>
              <%elseIf Len(Day(ObjRst("DiaEscala"))) <= 1 and Len(Month(ObjRst("DiaEscala"))) <> 1 then%>
                0<%=(Day(ObjRst("DiaEscala")))%>/<%=(Month(ObjRst("DiaEscala")))%>
              <%elseIf Len(Day(ObjRst("DiaEscala"))) > 1 and Len(Month(ObjRst("DiaEscala"))) <= 1 then%>
                <%=(Day(ObjRst("DiaEscala")))%>/0<%=(Month(ObjRst("DiaEscala")))%>
              <%else%>
                <%=(Day(ObjRst("DiaEscala")))%>/<%=(Month(ObjRst("DiaEscala")))%>
              <%
               end if   
               %>            
            </td>
            <td ><%=ObjRst("HoraSaida")%></td>
            <td ><%=ObjRst("HoraChegada")%></td> 
            <td ><%=ObjRst("Descricao")%></td> 
            <td ><%=ObjRst("MunicipioDesc")%></td>              
            <td>
              <a href="crud_rota_escala.asp?id=<%=ObjRst("Id")%>&idb=<%=idBarreira%>&operacao=2" style="font-size: 0.5rem;"  class="btn btn-danger btn-sm" alt="Desativar EP">
                <i class="fas fa-trash fa-lg"></i>
              </a>
            </td>
        </tr>
      <% 
				ObjRst.Movenext()
				loop 
				set ObjRst =  Nothing 
			%>
      </tbody>
      </table>
    </div>
    <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
      <h6 class="m-0 font-weight-bold text-primary">Rotas da 2° Escala do Mês de <%=UCASE(session("mesRef"))%></h6>
    </div>
    <div class="card-body">
      <form id="formroute2" name="formroute2" method="POST" action="crud_rota_escala.asp" >
        <input name="operacao" type="hidden" value="" id="operacao"/>
        <input name="idesc" type="hidden" value="<%=IdSegundaEscala%>" id="idesc"/>
        <input name="idbar" type="hidden" value="<%=idBarreira%>" id="idbar"/>
        <div class="form-row">
        <div class="form-group mr-2 ">
          <label for="data">Dia da Escala:</label>
          <input type="date" class="form-control form-control-sm" name="data" id="data" required>
        </div>
        <div class="form-group mr-4">
          <label for="horaIni">Hora inicio:</label>
          <select class="select2-single form-control form-control-sm" name="horaIni" id="horaIni" required> 
            <option value=""  > ... </option>
            <option value="05:00"> 05:00 </option>
            <option value="06:00"> 06:00 </option>
            <option value="07:00"> 07:00 </option>
            <option value="08:00"> 08:00 </option>
            <option value="09:00"> 09:00 </option>
            <option value="10:00"> 10:00 </option>
            <option value="11:00"> 11:00 </option>
            <option value="12:00"> 12:00 </option>
            <option value="13:00"> 13:00 </option>
            <option value="14:00"> 14:00 </option>
            <option value="15:00"> 15:00 </option>
            <option value="16:00"> 16:00 </option>
            <option value="17:00"> 17:00 </option>
            <option value="18:00"> 18:00 </option>
            <option value="19:00"> 19:00 </option>
            <option value="20:00"> 20:00 </option>
            <option value="21:00"> 21:00 </option>
          </select>
        </div>
        <div class="form-group mr-4">
          <label for="horaFin">Hora término:</label>
          <select class="select2-single form-control form-control-sm" name="horaFin" id="horaFin" required> 
            <option value=""  > ... </option>
            <option value="05:00">05:00</option>
            <option value="06:00">06:00</option>
            <option value="07:00"> 07:00 </option>
            <option value="08:00"> 08:00 </option>
            <option value="09:00"> 09:00 </option>
            <option value="10:00"> 10:00 </option>
            <option value="11:00"> 11:00 </option>
            <option value="12:00"> 12:00 </option>
            <option value="13:00"> 13:00 </option>
            <option value="14:00"> 14:00 </option>
            <option value="15:00"> 15:00 </option>
            <option value="16:00"> 16:00 </option>
            <option value="17:00"> 17:00 </option>
            <option value="18:00"> 18:00 </option>
            <option value="19:00"> 19:00 </option>
            <option value="20:00"> 20:00 </option>
            <option value="21:00"> 21:00 </option>
          </select>
        </div>
        <div class="form-group mr-4">
        <label for="select2Single">Rota:</label>
        <select class="select2-single form-control form-control-sm" name="rota" id="select2Single" required> 
          <option value=""  > ... </option>
          <%
              do while not rs2.EOF %>
              <option value="<%=rs2("Id")%>"> <%=rs2("Descricao")%> - <%=rs2("MunicipioDesc")%> </option>
          <% 
            rs2.Movenext()
            loop 
            Set rs2 = Nothing
          %>
        </select>
        </div>
        <div class="form-group mt-auto">
        <button class="btn btn-warning btn-icon-split btn-sm" onClick="enviarForm2(); return false;">
        <span class="icon text-white-50">
          <i class="fas fa-arrow-right"></i>
        </span>
        <span class="text">Adicionar</span>
      </button>
      </div>
      </form>
      </div>
        
      <table class="table align-items-center table-flush table-sm" id="dataTable" >
        <thead class="thead-light ">
          <tr>
            <th>Data</th>
            <th>Hora inicio</th>
            <th>Hora término</th>
            <th>Rota</th>
            <th>Municipio</th>
            <th>Opções</th>
          </tr>
        </thead>
        <tbody>
      <%
         Do while not ObjRst2.EOF           
	    %>
        <tr>
            <td ><%If Len(Day(ObjRst2("DiaEscala"))) <= 1 and Len(Month(ObjRst2("DiaEscala"))) <= 1 then %>
                0<%=(Day(ObjRst2("DiaEscala")))%>/0<%=(Month(ObjRst2("DiaEscala")))%>
              <%elseIf Len(Day(ObjRst2("DiaEscala"))) <= 1 and Len(Month(ObjRst2("DiaEscala"))) <> 1 then%>
                0<%=(Day(ObjRst2("DiaEscala")))%>/<%=(Month(ObjRst2("DiaEscala")))%>
              <%elseIf Len(Day(ObjRst2("DiaEscala"))) > 1 and Len(Month(ObjRst2("DiaEscala"))) <= 1 then%>
                <%=(Day(ObjRst2("DiaEscala")))%>/0<%=(Month(ObjRst2("DiaEscala")))%>
              <%else%>
                <%=(Day(ObjRst2("DiaEscala")))%>/<%=(Month(ObjRst2("DiaEscala")))%>
              <%
               end if   
               %> 
            <td ><%=ObjRst2("HoraSaida")%></td>
            <td ><%=ObjRst2("HoraChegada")%></td> 
            <td ><%=ObjRst2("Descricao")%></td> 
            <td ><%=ObjRst2("MunicipioDesc")%></td>              
            <td>
              <a href="crud_rota_escala.asp?id=<%=ObjRst2("Id")%>&idb=<%=idBarreira%>&operacao=2"   style="font-size: 0.5rem;"  class="btn btn-danger btn-sm" alt="Desativar EP">
                <i class="fas fa-trash fa-lg"></i>
              </a>
            </td>
        </tr>
      <% 
				ObjRst2.Movenext()
				loop 
				set ObjRst2 =  Nothing 
			%>
      </tbody>
      </table>
    </div><br><br>
    <div class="col text-center">
      <button class="btn btn-primary btn-icon-split" onClick="avancar(); return false;">
        <span class="icon text-white-50">
          <i class="fas fa-arrow-right"></i>
        </span>
        <span class="text">Avançar</span>
      </button>
      </div>
   <br><br>
  </div>
</div>



          
        