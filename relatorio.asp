<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file ="lib/conexao.asp"-->
<% dim mesRef, ano, mes, IdPrimeiraEscala, IdSegundaEscala
	cont =0
	mesRef 	= trim(request.Form("cmbmes"))
    ano 	= trim(request.Form("cmbano"))
    
if session("idUsu") = "1162756-2" OR session("idUsu") = "11186178-1" OR session("idUsu") = "834272-5" OR session("idUsu") = "6238081" then
    autorizado = true
else
    autorizado = false
end if

if autorizado = true then%>
  <!--#include file="base.asp"-->
<%elseIf autorizado = false then %>
  <!--#include file="base2.asp"-->
<%end if

    if mesRef = "" or mesRef = " " or mesRef = "0" then  mesRef = monthName(month(date())) end if
	if ano = "" or ano = " " or ano = "0" then  ano = year(date()) end if	
	
	if mes = 0 and ano = 0 then
	strSQL = "SELECT BV.Id as IdBarreiraVol, RegionalDesc, MesRef, BV.Descricao, YEAR(DataInicio) AS Ano FROM SEBV_RotaEscala AS RE INNER JOIN SEBV_EscalaParcial AS EP ON RE.IdEscalaParcial = EP.Id INNER JOIN SEBV_Rota AS R ON R.Id=RE.IdRota INNER JOIN Municipio AS M ON R.MunicipioId = M.MunicipioId INNER JOIN Regional AS REG ON M.MunicipioRegionalId = REG.RegionalId INNER JOIN SEBV_BarreiraVolante AS BV ON BV.RegionalId = REG.RegionalId WHERE RE.Situacao = 'Fechado' AND MesRef='"&mesRef&"' AND BV.Status =1 GROUP By BV.Id, RegionalDesc, MesRef, BV.Descricao, YEAR(DataInicio)"
	else
	strSQL = "SELECT BV.Id as IdBarreiraVol, RegionalDesc, MesRef, BV.Descricao, YEAR(DataInicio) AS Ano FROM SEBV_RotaEscala AS RE INNER JOIN SEBV_EscalaParcial AS EP ON RE.IdEscalaParcial = EP.Id INNER JOIN SEBV_Rota AS R ON R.Id=RE.IdRota INNER JOIN Municipio AS M ON R.MunicipioId = M.MunicipioId INNER JOIN Regional AS REG ON M.MunicipioRegionalId = REG.RegionalId INNER JOIN SEBV_BarreiraVolante AS BV ON BV.RegionalId = REG.RegionalId WHERE RE.Situacao = 'Fechado'AND MesRef='"&mesRef&"' AND YEAR(DataInicio)='"&ano&"' AND BV.Status =1 GROUP By BV.Id, RegionalDesc, MesRef, BV.Descricao, YEAR(DataInicio)"
	end if
    set ObjRst = conn.Execute(strSQL)

function RetornaIdEscalas()
	  Set objSql =  conn.Execute("SELECT * FROM SEBV_EscalaParcial WHERE MesRef='"+mesRef+"' AND Status='1'")
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

%>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@9"></script>
<script>

function ChamarLink(BarreiraId,mesEscala) {
        window.open("visualizaAdmin.asp?mesRef="+mesEscala+"&idb="+BarreiraId+"&ide1=&ide2=", "Escala", "height=800,width=1000")
    }

function desbloquearEscala(barreiraId,mesRef){   
  Swal.fire({
  title: 'Deseja continuar?',
    text: "A escala será desbloqueada e poderá ser modificada!",
    icon: 'warning',
    showCancelButton: true,
    confirmButtonColor: '#3085d6',
    cancelButtonColor: '#d33',    
    cancelButtonText: 'Cancelar',
    confirmButtonText: 'Sim, prosseguir!'
  }).then((result) => {
    if (result.value) {
        window.location="crud_final.asp?idb="+barreiraId+"&mesRef="+mesRef+"&op=unlock"
    }
  })
}

var url_string = window.location.href;
var url = new URL(url_string);
var resp = url.searchParams.get("msg");
mensagem(resp)

function mensagem(resp) {
  if (resp == "ok"){
     Swal.fire({
      title: "Ótimo!!!",
      text: "Escala desbloqueada com sucesso!\n ",
      icon: "success",
      button: "Ok!",
      });
      return false;
  }
  else if (resp == "err1"){
     Swal.fire({
      title: "Ops!!!",
      text: "Ocorreu um erro no desbloqueio. Tente novamente!",
      icon: "error",
      button: "Ok!",
      });
      return false;
  }
  else
  return false;
}
	
</script>
</head>
<body>

<div class="container" id="listaBar">    
<div class="main">
<table  border="0" align="center" cellpadding="0" cellspacing="0" class="table table-sm"><tr>                 
                <td bgcolor="#f2f2f2"><div align="center"><strong>Pesquisar Escalas Cadastradas</strong></div></td> 			           
              </tr>
			  <tr><td><br>
                  <form name="form1" method="post" action="relatorio.asp">                   
                     <div class="row">
                     <div class="form-group col-md-3">
                     <label for="cmbmes">Mês</label> 
                      <select name="cmbmes" class="form-control form-control-sm" id="cmbmes">
                        <option value="0">Selecionar</option>
                        <option value="janeiro">Janeiro</option>
                        <option value="fevereiro">Fevereiro</option>
                        <option value="março">Mar&ccedil;o </option>
                        <option value="abril">Abril</option>
                        <option value="maio">Maio</option>
                        <option value="junho">Junho</option>
                        <option value="julho">Julho</option>
						<option value="agosto">Agosto</option>
                        <option value="setembro">Setembro</option>
                        <option value="outubro">Outubro</option>
                        <option value="novembro">Novembro</option>
                        <option value="dezembro">Dezembro</option>
                      </select>
                      </div>
                      <div class="form-group col-md-2">
					  <label for="cmbano">Ano</label>
                      <select name="cmbano"  class="form-control  form-control-sm">
                        <option value="0" selected>Selecionar</option>
                        <option value="2020">2020</option>
						<option value="2021">2021</option>       
                        <option value="2022">2022</option>           
						<option value="2023">2023</option>
                      </select>
                      </div>
                      <div   class="form-group col-md-2">
                      <input style=" margin-top:27px" type="submit" name="Submit" title="Pesquisar" value="Pesquisar" class="btn btn-primary mb-2"></div>             
                    </div>
                  </form></td>
			  </tr>  
            </table>
<br>
<br> <h5 >Lista de Escalas Cadastradas</h5>
<table class="table table-bordered table-sm" id="listaB" > 
<thead class="thead-light" >
	<tr >
        <th> REGIONAL </th>
        <th> BARREIRA </th>
        <th> MÊS </th>
        <th> OPÇÔES </th>
    </tr>
</thead>
<tbody>
    <% 
    Do while not ObjRst.EOF 
        cont =cont+1
	%>
    <tr>
        <td ><%=ObjRst("RegionalDesc")%></td>
        <td ><%=ObjRst("Descricao")%></td>
        <td ><%=UCASE(ObjRst("MesRef"))%></td>
        
        <td >
            <a class="btn btn-warning btn-sm " alt="Exibir "  onClick="ChamarLink('<%=ObjRst("IdBarreiraVol")%>','<%=ObjRst("MesRef")%>','<%=IdPrimeiraEscala%>','<%=IdSegundaEscala%>')"><i class="far fa-eye" aria-hidden="true" ></i></a>
        <%if autorizado = true then%>
            <a class="btn btn-danger btn-sm" alt="Excluir "  onClick="desbloquearEscala('<%=ObjRst("IdBarreiraVol")%>','<%=ObjRst("MesRef")%>')" ><i class="fas fa-lock-open" style="color:white;" aria-hidden="true"></i></a>
        <%else
            end if%>
        </td>
    </tr>
    <% 
        ObjRst.Movenext()
        loop 
        set ObjRst =  Nothing 
    %>

</tbody>
</table><br><p>Total de escalas cadastradas: <%=cont%></p>
<br><br><br><br>
</div>
</div>

<script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN"crossorigin="anonymous"></script>
<link rel="stylesheet" href="https://cdn.datatables.net/1.10.18/css/dataTables.bootstrap4.min.css">
<script src="https://cdn.datatables.net/1.10.18/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.10.18/js/dataTables.bootstrap4.min.js"></script>
<footer class="card-footer text-muted"><center>Todos os Direitos Reservados &copy;2019 <a href="intranet.adapec.to.gov.br/intranet"> ADAPEC</a></center></center></footer>
</body>
