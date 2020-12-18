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
  dim IdPrimeiraEscala, IdSegundaEscala
 sql = "SELECT * FROM SEBV_Veiculo  WHERE Status=1"
 Set ObjRst = conn.Execute(sql)
 idBarreira = request("idb")

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

%>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@9"></script>
<script>
var url_string = window.location.href;
var url = new URL(url_string);
var resp = url.searchParams.get("resp");

mensagem(resp)

function mensagem(resp) {
  if (resp == "ok"){
     Swal.fire({
      title: "Ótimo!!!",
      text: "Barreira desabilitado com sucesso!\n ",
      icon: "success",
      button: "Ok!",
      });
    return false;
  }
  else if (resp == "err"){
  Swal.fire({
      title: "Ops!!!",
      text: "Ocorreu um erro ao desativar o barreira!",
      icon: "error",
      button: "Ok!",
      });
    return false;
  }
  else{
    return false;
  }
}
function finaliza(idvei){   
  Swal.fire({
  title: 'Deseja continuar?',
    text: "Ao selecionar o veículo você finaliza o cadastro da escala de barreira volante!",
    icon: 'warning',
    showCancelButton: true,
    confirmButtonColor: '#3085d6',
    cancelButtonColor: '#d33',
    cancelButtonText: 'Cancelar',
    confirmButtonText: 'Sim, prosseguir!'
  }).then((result) => {
    if (result.value) {     
      formvei.idvei.value = idvei;
      formvei.operacao.value = 1;
      formvei.submit();
     
    }
  })
}
</script>

<div class="col-lg-12">
  <div class="card mb-4 ">    
    <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
      <h6 class="m-0 font-weight-bold text-primary">Selecionar veículo</h6>
    </div>
    <form id="formvei" name="formvei" method="POST" action="crud_veiculo_escala.asp" >
      <input name="operacao" type="hidden" value="" id="operacao"/>
      <input name="idesc1" type="hidden" value="<%=IdPrimeiraEscala%>" id="idesc1"/>
      <input name="idesc2" type="hidden" value="<%=IdSegundaEscala%>" id="idesc2"/>
      <input name="idbar" type="hidden" value="<%=idBarreira%>" id="idbar"/>
      <input name="idvei" type="hidden" value="" id="idvei"/>
    </form>
    <div class="card-body">
    <div class="table-responsive table-sm">
      <table class="table align-items-center table-flush table-sm" id="dataTable" >
        <thead class="thead-light">
          <tr>
            <th>Modelo</th>
            <th>Placa</th>
            <th>Opções</th>
          </tr>
        </thead>
        <tbody>
      <%
	   		Do while not ObjRst.EOF 
				cont =cont+1
	    %>
        <tr>
            <td ><%=ObjRst("Modelo")%></td>
            <td ><%=ObjRst("Placa")%></td>        
            <td>      
                <a  onClick="finaliza(<%=ObjRst("Id")%>); return false;" class="btn btn-primary btn-icon-split btn-sm" alt="Desativar barreira" >
                    <span class="icon text-white-50">
                      <i class="fas fa-arrow-right fa-lg"></i>
                    </span>
                    <span class="text text-white-50">Selecionar</span>
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
    </div>
  </div>
</div>
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