<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001" %>
<!--#include file ="lib/conexao.asp"-->
<%
dim autorizado

if session("idUsu") = "1162756-2" OR session("idUsu") = "11186178-1" OR session("idUsu") = "834272-5" OR session("idUsu") = "6238081" then
	autorizado = true
else
  autorizado = false
  response.redirect("index.asp?idUsu="&session("idUsu"))
end if

if autorizado = true then%>
  <!--#include file="base.asp"-->
<%elseIf autorizado = false then %>
  <!--#include file="base2.asp"-->
<%end if%>
<%
  session("idUsu") = trim(request("idUsu"))
  municipioId = request.form("municipio")
  descricao = request.form("descricao")
  resp = request("resp")
  response.write(municipioId)
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

function validar() {
  var escaladesc = formep.escaladesc.value;
  var dataini = formep.dataIni.value;  
  var datafin = formep.dataFin.value; 

  if(escaladesc == ""){
      Swal.fire({
      title: "Ops!!!",
      text: "Selecione o número da escala!",
      icon: "error",
      button: "Ok!",
      });
      return false;
  }
  else if(dataini == ""){
      Swal.fire({
      title: "Ops!!!",
      text: "Preencha a data inicial da escala!",
      icon: "error",
      button: "Ok!",
      });
      return false;
  }  
   else if(datafin == ""){
      Swal.fire({
      title: "Ops!!!",
      text: "Preencha a data final da escala!",
      icon: "error",
      button: "Ok!",
      });
      return false;
  }
  else{
    formep.operacao.value = 1;
    formep.submit();    
  }          
  
}

</script>

 <div class="col-lg-7">
    <!-- Select2 -->
    <div class="card mb-4">
      <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
        <h6 class="m-0 font-weight-bold text-primary">Inserir Escala Parcial</h6>
      </div>
      <div class="card-body">
        <form name="formep" id="formep" action="crud_ep.asp" method="POST">  
        <div class="form-group ">
        <label for="validationCustom03">Escala</label>
        <select id="validationCustom03" name="escaladesc" class="form-control"  <%if trim(acao) = "edit" then%> readonly="readonly" <%end if%>  >
          <option value=""  > ... </option>
          <option value="1" <%if trim(escalaDesc) = "1" then%> selected <%end if%>>1°</option>
          <option value="2" <%if trim(escalaDesc) = "2" then%> selected <%end if%>>2°</option>                   
        </select>
        </div>   
        <div class="form-group">
          <label for="inputDtInicio">Data Inicio</label><br>
          <input id="dataIni" class="form-control" type="date" name="dataIni"  required>
            
        </div>
        <div class="form-group">
          <label for="dataFin">Data Final</label><br>
          <input id="dataFin" class="form-control" type="date" name="dataFin"  required>
        </div> 
        <input type="text" class="form-control" id="operacao" name="operacao" hidden>
        <button class="btn btn-primary btn-icon-split" onClick="validar(); return false;">
          <span class="icon text-white-50">
            <i class="fas fa-arrow-right"></i>
          </span>
          <span class="text">Cadastrar</span>
        </button>
        </form>
      </div>
    </div>
  </div>


          
        