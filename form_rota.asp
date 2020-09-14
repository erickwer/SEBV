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
  municipioId = request.form("municipio")
  descricao = request.form("descricao")
  resp = request("resp")
  response.write(municipioId)
	sql =  "SELECT * FROM Municipio WHERE MunicipioUf = 'TO' ORDER BY MunicipioDesc"
	Set rs = conn.Execute(sql)
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
      text: "Rota inserida com sucesso!\n Para visualizar as rotas acesse o menu de rotas e clique em 'Lista de Rotas'. ",
      icon: "success",
      button: "Ok!",
      });
      return false;
  }
  else
  return false;
}

function validar() {
  var descricao = formrota.descricao.value;
  var municipio = formrota.municipio.value;  
  if(descricao == ""){
      Swal.fire({
      title: "Ops!!!",
      text: "Preencha o campo Descrição!",
      icon: "error",
      button: "Ok!",
      });
      formrota.descricao.focus()
      return false;
  } 
  else {
    formrota.operacao.value = 1;
    formrota.submit();  
  }         
}

</script>
 <div class="col-lg-7">
    <!-- Select2 -->
    <div class="card mb-4">
      <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
        <h6 class="m-0 font-weight-bold text-primary">Inserir Rota</h6>
      </div>
      <div class="card-body">
        <form name="formrota" id="formrota" action="crud_rota.asp" method="POST">              
        <div class="form-group">
          <label for="select2Single">Município</label>
          <select class="select2-single form-control" name="municipio" id="select2Single" > 
            <%
                do while not rs.EOF %>
                <option value="<%=rs("MunicipioId")%>" ><%=rs("MunicipioDesc")%></option>
              <% 
              rs.Movenext()
              loop 
              set rs =  Nothing 
            %>
          </select>
        </div>
        <div class="form-group">
          <label for="Descricao">Descrição</label>
          <input type="text" class="form-control" name="descricao" id="descricao" placeholder="Descrição" >
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


          
        