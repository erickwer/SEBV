<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
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
<%elseIf autorizado = false then%>
  <!--#include file="base2.asp"-->
<%end if%>
<%
 sql = "SELECT * FROM SEBV_EscalaParcial WHERE Status = 1 ORDER BY DataInicio"
 Set ObjRst = conn.Execute(sql)
%>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@9"></script>
<script>
var url_string = window.location.href;
var url = new URL(url_string);
var resp = url.searchParams.get("resp");

mensagem(resp);

function mensagem(resp) {
  if (resp == "ok"){
     Swal.fire({
      title: "Ótimo!!!",
      text: "Escala Parcial desabilitada com sucesso!\n ",
      icon: "success",
      button: "Ok!",
      });
    return false;
  }
  else if (resp == "err"){
  Swal.fire({
      title: "Ops!!!",
      text: "Ocorreu um erro ao desativar a Escala Parcial!",
      icon: "error",
      button: "Ok!",
      });
    return false;
  }
  else{
    return false;
  }

}
</script>
<div class="col-lg-12">
  <div class="card mb-4 ">
    <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
      <h6 class="m-0 font-weight-bold text-primary">Lista de Escalas Parciais</h6>
    </div>
    <div class="table-responsive p-3">
      <table class="table align-items-center table-flush table-sm" id="dataTable" >
        <thead class="thead-light">
          <tr>
            <th>Descrição</th>
            <th>Data Inicio</th>
            <th>Data Término</th>
            <th>Mês</th>
            <th>Opções</th>
          </tr>
        </thead>
        <tbody>
      <%
	   		Do while not ObjRst.EOF 
				cont =cont+1
	    %>
        <tr>
          <td ><%=ObjRst("EscalaDesc")%>°</td>
          <td ><%=ObjRst("DataInicio")%></td>
          <td ><%=ObjRst("DataTermino")%></td>  
          <td ><%=UCASE(ObjRst("MesRef"))%></td>             
          <td>
          <%if autorizado = true then%>
            <a href="crud_ep.asp?id=<%=ObjRst("Id")%>&operacao=2" class="btn btn-danger btn-sm" alt="Desativar EP">
              <i class="fas fa-trash"></i>
            </a>
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
      </table>
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
       "order": [],
    "columnDefs": [ {
      "targets"  : 'no-sort',
      "orderable": false,
    }],
        "language": {
            "lengthMenu": "Exibindo _MENU_ registros por página",
            "zeroRecords": "Nenhum dado encontrado",
            "info": "Página _PAGE_ de _PAGES_",
            "infoEmpty": "Nenhum registro encontrado",
            "search": "Buscar:",            
            "paginate":{
              "previous": "Anterior",
              "next": "Próximo"
            }
        }
    } );
    });
  </script>