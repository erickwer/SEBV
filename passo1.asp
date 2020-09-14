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
 sql = "SELECT * FROM SEBV_BarreiraVolante as bv INNER JOIN Regional as r on bv.RegionalId=r.RegionalId WHERE Status=1 AND r.RegionalDesc = '"&session("regionalFunc")&"'"
 Set ObjRst = conn.Execute(sql)

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
function validar() {
  var idbar = formbar.idbar.value;
  if(idbar == ""){
      Swal.fire({
      title: "Ops!!!",
      text: "Ocorreu um erro desconhecido!",
      icon: "error",
      button: "Ok!",
      });
      formbar.idbar.focus()
      return false;
  } 
  else {
    formbar.submit();  
  }
</script>
<div class="col-lg-12">
  <div class="card mb-4 ">
    <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
      <h6 class="m-0 font-weight-bold text-primary">Lista de Barreiras Volante</h6>
    </div>
    <div class="table-responsive table-sm">
      <table class="table align-items-center table-flush table-sm" id="dataTable" >
        <thead class="thead-light">
          <tr>
            <th>Descrição</th>
            <th>Regional</th>
            <th>Opções</th>
          </tr>
        </thead>
        <tbody>
      <%
	   		Do while not ObjRst.EOF 
				cont =cont+1
	    %>
        <tr>
          <td ><%=ObjRst("Descricao")%></td>
          <td ><%=ObjRst("RegionalDesc")%></td>       
            <td>      
              <a href="passo2.asp?idb=<%=ObjRst("Id")%>"  class="btn btn-primary btn-icon-split btn-sm" alt="Desativar barreira" >
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
<script src="vendor/datatables/jquery.dataTables.min.js"></script>
<script src="vendor/datatables/dataTables.bootstrap4.min.js"></script>
<script src="https://cdn.datatables.net/1.10.21/css/jquery.dataTables.min.css"></script>

  <!-- Page level custom scripts -->