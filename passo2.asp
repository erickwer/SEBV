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
dim nomeFunc, regionalFunc, IdPrimeiraEscala, mesEsc, IdSegundaEscala, existeCad, idBarreira, existeCadEscala, existeJusPrim, existeJusSeg, jusPrim, jusSeg, rsPrim, rsSeg
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
	  Set objSql =  conn.Execute("SELECT * FROM SEBV_EscalaParcial WHERE MesRef='"&session("mesRef")&"' AND YEAR(DataInicio)='"&session("anoRef")&"' and Status='1'")
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

  strSQL = "SELECT F.MatriculaNova, F.VinculoMatricula, F.Nome, F.LotacaoComp, C.Nome [Cargo], R.RegionalDesc,  M.MunicipioDesc FROM CadFunc AS F INNER JOIN HistCargo AS H ON F.Matricula = H.Matricula INNER JOIN Cargo AS C ON H.CodCargo = C.Codcargo INNER JOIN Municipio AS M ON F.LotacaoOrigem = M.MunicipioId INNER JOIN Regional AS R ON M.MunicipioRegionalId = R.RegionalId WHERE (F.SitFuncional = 'ATIVO') AND (C.CodCargo in(221,222)) AND F.LotacaoComp = 'BARREIRA FIXA'  and h.DTTermino is null and R.RegionalDesc = '"&session("regionalFunc")&"' ORDER BY RegionalDesc"
  set ObjRst = conn.Execute(strSQL)			
  strSql1 = "SELECT sb.Id, sb.Matricula, sb.VinculoMat, sb.Situacao, f.Nome, r.RegionalDesc FROM SEBV_ServidoresEsc as sb INNER JOIN CadFunc as f on sb.Matricula = f.MatriculaNova INNER JOIN Municipio as M ON f.LotacaoOrigem = M.MunicipioId INNER JOIN Regional AS R ON M.MunicipioRegionalId=R.RegionalId  INNER JOIN SEBV_EscalaParcial AS ep ON sb.IdEscalaParcial = ep.Id  WHERE IdEscalaParcial='"&IdPrimeiraEscala&"' AND RegionalDesc ='"&session("regionalFunc")&"' AND ep.MesRef='"&session("mesRef")&"' AND Situacao = 'Vinculado' AND sb.IdBarreira ='"&IdBarreira&"'"
  set rs1 = conn.Execute(strSql1)
  strSql2 = "SELECT sb.Id, sb.Matricula, sb.VinculoMat, sb.Situacao, f.Nome, r.RegionalDesc FROM SEBV_ServidoresEsc as sb INNER JOIN CadFunc as f on sb.Matricula = f.MatriculaNova INNER JOIN Municipio as M ON f.LotacaoOrigem = M.MunicipioId INNER JOIN Regional AS R ON M.MunicipioRegionalId=R.RegionalId  INNER JOIN SEBV_EscalaParcial AS ep ON sb.IdEscalaParcial = ep.Id  WHERE IdEscalaParcial='"&IdSegundaEscala&"' AND RegionalDesc ='"&session("regionalFunc")&"' AND ep.MesRef='"&session("mesRef")&"' AND Situacao = 'Vinculado' AND sb.IdBarreira ='"&IdBarreira&"'"
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
      set rs =  conn.Execute("SELECT COUNT (*) as qt FROM SEBV_RotaEscala AS f INNER JOIN SEBV_EscalaParcial  AS p ON f.IdEscalaParcial = p.Id WHERE f.IdBarreiraVol = '"&idBarreira&"'AND MesRef='"&session("mesRef")&"' AND YEAR(DataInicio)='"&session("anoRef")&"' AND Situacao ='Fechado'")
      set rs7 = conn.Execute("SELECT COUNT (*) AS qt FROM SEBV_Justificativa AS JU INNER JOIN SEBV_EscalaParcial AS EP ON JU.IdEscalaParcial = EP.Id INNER JOIN SEBV_BarreiraVolante AS BV ON JU.IdBarreira = BV.Id WHERE JU.IdBarreira = '"&idBarreira&"' AND MesRef='"&session("mesRef")&"' AND YEAR(DataInicio)='"&session("anoRef")&"' AND JU.Situacao = 'Fechado'")
      if rs("qt") <> 0  OR rs7("qt") <> 0then
          existeCadEscala = true
      else 
          existeCadEscala = false
      end if
      rs.close
      set rs = Nothing
  end function 

verificaCadastroEscala()

function verificaJus()
  set rs4 = conn.execute("SELECT COUNT (*) AS qt FROM SEBV_Justificativa WHERE IdEscalaParcial = '"&IdPrimeiraEscala& "'AND IdBarreira = '"&IdBarreira&"'")
  set rs5 = conn.execute("SELECT COUNT (*) AS qt FROM SEBV_Justificativa WHERE IdEscalaParcial = '"&IdSegundaEscala& "'AND IdBarreira = '"&IdBarreira&"'")
    if rs4("qt") > 0 then
      existeJusPrim = true
    elseIf rs4("qt") = 0 then
      existeJusPrim = false
    elseIf rs5("qt") > 0 then
      existeJusSeg = true
    elseIf rs5("qt") = 0 then
      existeJusSeg = false
    else
    end if    
    rs4.close
    rs5.close
    set rs4 = Nothing
    set rs5 = Nothing
end function
verificaJus()

function retornaJus()

  set rsPrim = conn.execute("SELECT TOP 1 * FROM SEBV_Justificativa WHERE IdEscalaParcial = '"&IdPrimeiraEscala&"' AND IdBarreira = '"&idBarreira&"'")
  set rsSeg = conn.execute("SELECT TOP 1 * FROM SEBV_Justificativa WHERE IdEscalaParcial = '"&IdSegundaEscala&"' AND IdBarreira = '"&idBarreira&"'")
  jusPrim = false
  jusSeg = false
  if not rsPrim.EOF then
    if rsPrim("IdBarreira") <> "" then
      jusPrim = true
    end if
  end if
  if not rsSeg.EOF then
    if rsSeg("IdBarreira") <> "" then
      jusSeg = true
    else 
    end if
  end if
end function
retornaJus()

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
      text: "Escala Parcial inserida com sucesso!\n Para visualizar acesse o menu de Escalas Parciais e clique em 'Lista de Escalas Parciais'. ",
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

function enviar(id,mat,vin){   
    formserv.operacao.value = 1;
    formserv.vinc.value = vin;
    formserv.idep.value = id;
    formserv.idserv.value = mat
    formserv.submit(); 
}

function avancar(){   
    Swal.fire({
  title: 'Deseja continuar?',
  text: "Certifique-se de que cadastrou os dois servidores na 1° e 2° escala!",
  icon: 'warning',
  showCancelButton: true,
  confirmButtonColor: '#3085d6',
  cancelButtonColor: '#d33',
  cancelButtonText:'Voltar',
  confirmButtonText: 'Sim, prosseguir!'
}).then((result) => {
  if (result.value) {
      window.location="passo3.asp?idb=<%=idBarreira%>"
  }
})
}

</script>

<%if existeCadEscala = true then%>
<div class="col-lg-10">
 <div class="card">
    <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
      <h6 class="m-0 font-weight-bold text-primary">Escala cadastrada!!!</h6>
    </div>
    <div class="card-body">      
      <div class="alert alert-danger alert-dismissible" role="alert">
        <h6><i class="fas fa-ban"></i><b> Opa!</b></h6>
        Já existe uma escala cadastrada para essa barreira no mês de <%=UCASE(session("mesRef"))%> de <%=session("anoRef")%>!<br>
        <a href="visualizaAdmin.asp?idb=<%=idBarreira%>&ide1=<%=IdPrimeiraEscala%>&mesRef=<%=session("mesRef")%>&ide2=<%=IdSegundaEscala%>&Ano=<%=session("anoRef")%>" target="_blank" class="btn btn-primary btn-icon-split">
        <span class="icon text-white-50">
          <i class="fas fa-arrow-right"></i>
        </span>
        <span class="text">Visualizar Escala</span>
      </a>
      </div>
    </div>
  </div>
</div>
<%else%>
<!-- Modal Justificativa 1 -->
<div class="modal fade" id="exampleModalCenter1" tabindex="-1" role="dialog"
  aria-labelledby="exampleModalCenterTitle1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalCenterTitle1">Justificativa</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
      <form id="formjus" name="formjus" method="POST" action="crud_justificativa.asp">
      <input name="numjus" type="hidden" value="1" id="numjus"/>
        <input name="idbarjus" type="hidden" value="<%=idBarreira%>" id="idbarjus"/>
        <input name="idepjus" type="hidden" value="<%=IdPrimeiraEscala%>" id="idepjus"/>
        <input name="situacaojus" type="hidden" value="Vinculado" id="situacaojus"/>
        <input name="operacao" type="hidden" value="1" id="operacao"/>
        <div class="form-group">
          <label for="exampleFormControlTextarea2">Digite aqui</label>
          <textarea class="form-control" name="justificativa" id="justificativa" rows="3"></textarea>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-outline-primary" data-dismiss="modal">Fechar</button>
        <button type="submit" class="btn btn-primary">Salvar</button>
      </div>
      </form>
    </div>
  </div>
</div>
<!-- Modal Justificativa 2 -->
<div class="modal fade" id="exampleModalCenter2" tabindex="-1" role="dialog"
  aria-labelledby="exampleModalCenterTitle2" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalCenterTitle2">Justificativa</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
      <form id="formjus" name="formjus" method="POST" action="crud_justificativa.asp">
        <input name="numjus" type="hidden" value="2" id="numjus"/>
        <input name="idbarjus" type="hidden" value="<%=idBarreira%>" id="idbarjus"/>
        <input name="idepjus" type="hidden" value="<%=IdSegundaEscala%>" id="idepjus"/>
        <input name="situacaojus" type="hidden" value="Vinculado" id="situacaojus"/>
        <input name="operacao" type="hidden" value="1" id="operacao"/>
        <div class="form-group">
          <label for="exampleFormControlTextarea2">Digite aqui</label>
          <textarea class="form-control" name="justificativa" id="justificativa" rows="3"></textarea>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-outline-primary" data-dismiss="modal">Fechar</button>
        <button type="submit" class="btn btn-primary">Salvar</button>
      </div>
      </form>
    </div>
  </div>
</div>
 <div class="col">
  <div class="card">
    <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
      <h6 class="m-0 font-weight-bold text-primary">Servidores da Escala Final - Mês de <%=UCASE(session("mesRef"))%></h6>
    </div>
    <div class="card-body">
      <div class="table-responsive">
      <form id="formserv" name="formserv" method="POST" action="crud_servidor.asp">
        <input name="idbar" type="hidden" value="<%=idBarreira%>" id="idbar"/>
        <input name="idep" type="hidden" value="" id="idep"/>
        <input name="vinc" type="hidden" value="" id="vinc"/>
        <input name="situacao" type="hidden" value="Vinculado" id="situacao"/>
        <input name="operacao" type="hidden" value="" id="operacao"/>
        <input name="idserv" type="hidden" value="" id="idserv"/>
      </form>

      <table class="table align-items-center table-flush table-sm" id="dataTable" >
        <thead class="thead-light">
          <tr>
            <th>Nome</th>
            <th>Matricula</th>
            <th>Regional</th>
            <th>Escalas</th>
          </tr>
        </thead>
        <tbody>
      <%
         Do while not ObjRst.EOF 
          verificaExistencia(ObjRst("MatriculaNova"))
          If existeCad = false then
          cont = cont+1
          matricula = trim(ObjRst("MatriculaNova"))
          vin = trim(ObjRst("VinculoMatricula"))
	    %>
        <tr>
            <td ><%=ObjRst("Nome")%></td>
            <td ><%=trim(ObjRst("MatriculaNova"))%>-<%=trim(ObjRst("VinculoMatricula"))%></td>
            <td ><%=ObjRst("RegionalDesc")%></td>              
            <td>
            <%if jusPrim = false then%>
              <button class="btn btn-info btn-sm"   style="font-size: 0.7rem;" onClick="enviar(<%=IdPrimeiraEscala%>, <%=matricula%>, <%=vin%>); return false;">
                <i class="m-1 font-weight-bold text-light">1°</i>
              </button>
            <%else
              end if
            %>
             <%if jusSeg = false then%>
              <button class="btn btn-warning btn-sm" style="font-size: 0.7rem;"  onClick="enviar(<%=IdSegundaEscala%>,<%=matricula%>, <%=vin%>); return false;">
                <i class="m-1 font-weight-bold text-light">2°</i>
              </button>
              <%else
              end if
            %>
            </td>
        </tr>
      <% 
      else 
        end if
				ObjRst.Movenext()
				loop 
				set ObjRst =  Nothing 
			%>
      </tbody>
      </table>
    </div>
  </div>
  
    <div class="table-responsive p-3">
    <% if jusPrim =  false and rs1.EOF THEN%>
     <button type="button" class="btn btn-warning float-right" data-toggle="modal" data-target="#exampleModalCenter1"
        id="#modalCenter1">Justificar 1° Escala</button>
         <% else
      END IF
    %>
      <div class="card-header">
        <h6 class="m-0 font-weight-bold text-primary text-align-center">Servidores da 1° Escala</h6>
      </div>

    <%if jusPrim = true then%>
      <div class="alert alert-light" role="alert" >
        <div class=" m-0 font-weight-bold">
        Justificativa cadastrada: </div>
        <%=rsPrim("Descricao")%>        
        <a href="crud_justificativa.asp?idJus=<%=rsPrim("Id")%>&idb=<%=idBarreira%>&operacao=2"  style="font-size: 0.5rem;" class="btn btn-danger btn-sm float-right" alt="Excluir justificativa">
              <i class="fas fa-trash fa-lg"></i>
          </a>
      </div>
    <%else%>
      <table class="table align-items-center table-flush table-sm" id="dataTable" >
        <thead class="thead-light">
          <tr>
            <th>Nome</th>
            <th>Matricula</th>
            <th>Opções</th>
          </tr>
        </thead>
        <tbody>
      <%
	   		Do while not rs1.EOF 
		    cont =cont+1
	    %>
        <tr>
          <td ><%=rs1("Nome")%></td>
          <td ><%=trim(rs1("Matricula"))%>-<%=trim(rs1("VinculoMat"))%></td>            
          <td>
          <a href="crud_servidor.asp?id=<%=rs1("Id")%>&idb=<%=idBarreira%>&operacao=2"  style="font-size: 0.5rem;" class="btn btn-danger btn-sm" alt="Desativar Rota">
              <i class="fas fa-trash fa-lg"></i>
          </a>
          </td>
        </tr>
      <% 
				rs1.Movenext()
				loop 
				set rs1 =  Nothing 
			%>
      </tbody>
      </table> 
    </div>
    <%end if%>
 <div class="table-responsive p-3">
  <% if jusSeg =  false  and rs2.EOF THEN%>
  <button type="button" class="btn btn-warning float-right" data-toggle="modal" data-target="#exampleModalCenter2"
      id="#modalCenter2">Justificar 2° Escala</button>
      <% else
      END IF
      %>
      <div class="card-header">
        <h6 class="m-0 font-weight-bold text-primary text-align-center">Servidores da 2° Escala </h6>
      </div>
      <%if jusSeg = true then%>
      <div class="alert alert-light" role="alert" >
        <div class=" m-0 font-weight-bold">
        Justificativa cadastrada: </div>
        <%=rsSeg("Descricao")%>        
        <a href="crud_justificativa.asp?idJus=<%=rsSeg("Id")%>&idb=<%=idBarreira%>&operacao=2"  style="font-size: 0.5rem;" class="btn btn-danger btn-sm float-right" alt="Excluir justificativa">
              <i class="fas fa-trash fa-lg"></i>
          </a>
      </div>
    <%else%>
      <table class="table align-items-center table-flush table-sm" id="dataTable" >
        <thead class="thead-light">
          <tr>
            <th>Nome</th>
            <th>Matricula</th>
            <th>Opções</th>
          </tr>
        </thead>
        <tbody>
      <%
	   		Do while not rs2.EOF 
		    cont =cont+1
	    %>
            <tr>
              <td ><%=rs2("Nome")%></td>
              <td ><%=trim(rs2("Matricula"))%>-<%=trim(rs2("VinculoMat"))%></td>              
              <td>
              <a href="crud_servidor.asp?id=<%=rs2("Id")%>&idb=<%=idBarreira%>&operacao=2" style="font-size: 0.5rem;" class="btn btn-danger btn-sm" alt="Desativar Rota">
                  <i class="fas fa-trash fa-lg"></i>
              </a>
              </td>
            </tr>
            <% 
				rs2.Movenext()
				loop 
				set rs2 =  Nothing 
			  %>
      </tbody>
      </table><br><br>
       <%end if%>
    <div class="col text-center">
      <button class="btn btn-primary btn-icon-split" onClick="avancar(); return false;">
        <span class="icon text-white-50">
          <i class="fas fa-arrow-right"></i>
        </span>
        <span class="text">Avançar</span>
      </button>
      </div>
    </div>
  </div>
</div>
<%end if%>

<script src="vendor/datatables/jquery.dataTables.min.js"></script>
<script src="vendor/datatables/dataTables.bootstrap4.min.js"></script>
<script src="https://cdn.datatables.net/1.10.21/css/jquery.dataTables.min.css"></script>

  <!-- Page level custom scripts -->
  <script>
    $(document).ready(function () {
       $('#dataTable').DataTable( {
        "lengthMenu": [ 4, 8, 15, 20 ],
        "paging": true,
        "ordering": false,
        "language": {
            "lengthMenu": "Exibindo _MENU_ registros por página",
            "zeroRecords": "Nenhum dado encontrado",
            "info": "Página _PAGE_ de _PAGES_",
            "infoEmpty": "Nenhum registro encontrado",
            "infoFiltered": "(_MAX_ itens filtrados)",
            "search": "Buscar:",
            "paginate":{
              "previous": "Anterior",
              "next": "Próximo"
            }
        }
    } );
    });
  </script>
          
        