<!--#include file ="lib/conexao.asp"-->
<%

  function RegionalFuncionario()
      Set objSql = conn.Execute("SELECT Nome, RegionalDesc, Sexo FROM CadFunc AS F INNER JOIN Municipio AS M ON F.LotacaoOrigem=M.MunicipioId INNER JOIN Regional AS R ON  M.MunicipioRegionalId = R.RegionalId WHERE Matricula='"&session("idUsu")&"'")
          If Not objSql.Eof Then
              While Not objSql.Eof
              if IsNull(objSql("Nome")) then
                  response.write("Nada encontrado")
              else
                  session("nomeFunc") = (objSql("Nome"))
                  session("regionalFunc") = objSql("RegionalDesc")
                  session("sexoFunc") = objSql("Sexo")
              End If
              objSql.movenext
              Wend
          End If
          objSql.Close
          Set objSql = Nothing
  end function
RegionalFuncionario()


%>
<!DOCTYPE html>
<html lang="pt-br">

<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <meta name="description" content="">
  <meta name="author" content="">
  <link href="img/logoEBV.png" rel="icon">
  <title>EBV - ADAPEC</title>
  <link href="vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
  <link href="vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css">
  <link href="css/ruang-admin.min.css" rel="stylesheet">
  <link href="vendor/datatables/dataTables.bootstrap4.min.css" rel="stylesheet">
</head>

<body id="page-top">
  <div id="wrapper">
    <!-- Sidebar -->
    <ul class="navbar-nav sidebar sidebar-light accordion" id="accordionSidebar">
      <a class="sidebar-brand d-flex align-items-center justify-content-center" href="index.asp?idUsu=<%=session("idUsu")%>">
        <div class="sidebar-brand-icon">
          <img src="img/logoEBV.png">
        </div>
        <div class="sidebar-brand-text mx-3">Escala Barreira Volante</div>
      </a>
      <hr class="sidebar-divider my-0">
      <li class="nav-item active">
        <a class="nav-link" href="index.asp?idUsu=<%=session("idUsu")%>">
          <i class="fas fa-home"></i>
          <span>Home</span></a>
      </li>
      <hr class="sidebar-divider">
      <div class="sidebar-heading">
        Gerenciador
      </div>
      <li class="nav-item">
        <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseBarreira"
          aria-expanded="true" aria-controls="collapseBarreira">
          <i class="fas fa-bars"></i>
          <span>Barreiras</span>
        </a>
        <div id="collapseBarreira" class="collapse" aria-labelledby="headingBarreira" data-parent="#accordionSidebar">
          <div class="bg-white py-2 collapse-inner rounded">
            <h6 class="collapse-header">Gerenciamento de barreiras</h6>
            <a class="collapse-item" href="lista_barreiras.asp">Lista de Barreiras</a>
            <a class="collapse-item" href="form_barreira.asp">Cadastrar Barreira</a>
          </div>
        </div>
      </li>
      <li class="nav-item">
        <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseBootstrap"
          aria-expanded="true" aria-controls="collapseBootstrap">
          <i class="fas fa-route"></i>
          <span>Rotas</span>
        </a>
        <div id="collapseBootstrap" class="collapse" aria-labelledby="headingBootstrap" data-parent="#accordionSidebar">
          <div class="bg-white py-2 collapse-inner rounded">
            <h6 class="collapse-header">Gerenciamento de rotas</h6>
            <a class="collapse-item" href="lista_rotas.asp">Lista de Rotas</a>
            <a class="collapse-item" href="form_rota.asp">Cadastrar Rota</a>
          </div>
        </div>
      </li>
      <li class="nav-item">
        <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseCar"
          aria-expanded="true" aria-controls="collapseCar">
          <i class="fas fa-car"></i>
          <span>Veículos</span>
        </a>
        <div id="collapseCar" class="collapse" aria-labelledby="headingCar" data-parent="#accordionSidebar">
          <div class="bg-white py-2 collapse-inner rounded">
            <h6 class="collapse-header">Gerenciamento de veículos</h6>
            <a class="collapse-item" href="lista_veiculos.asp">Lista de veículos</a>
            <a class="collapse-item" href="form_veiculo.asp">Cadastrar veículo</a>
          </div>
        </div>
      </li>
      <li class="nav-item">
        <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseEscPar"
          aria-expanded="true" aria-controls="collapseEscPar">
          <i class="fab fa-buffer"></i>
          <span>Escalas Parciais</span>
        </a>
        <div id="collapseEscPar" class="collapse" aria-labelledby="headingEscPar" data-parent="#accordionSidebar">
          <div class="bg-white py-2 collapse-inner rounded">
            <h6 class="collapse-header">Gerenciamento de Escalas</h6>
            <a class="collapse-item" href="lista_eps.asp">Lista de escalas parciais</a>
            <a class="collapse-item" href="form_ep.asp">Cadastrar escala parcial</a>
          </div>
        </div>
      </li>
      <li class="nav-item">
        <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseTable" aria-expanded="true"
          aria-controls="collapseTable">
          <i class="fas fa-filter"></i>
          <span>Relatório</span>
        </a>
        <div id="collapseTable" class="collapse" aria-labelledby="headingTable" data-parent="#accordionSidebar">
          <div class="bg-white py-2 collapse-inner rounded">
            <h6 class="collapse-header">Relatório de Escalas</h6>
            <a class="collapse-item" href="relatorio.asp">Visualizar</a>
           
          </div>
        </div>
      </li>
      <hr class="sidebar-divider">
      <div class="version" id="version-ruangadmin"></div>
    </ul>
    <!-- Sidebar -->
    <div id="content-wrapper" class="d-flex flex-column">
      <div id="content">
        <!-- TopBar -->
        <nav class="navbar navbar-expand navbar-light bg-navbar topbar mb-4 static-top">
          <button id="sidebarToggleTop" class="btn btn-link rounded-circle mr-3">
            <i class="fa fa-bars"></i>
          </button>
          <ul class="navbar-nav ml-auto">
            <div class="topbar-divider d-none d-sm-block"></div>
            <li class="nav-item dropdown no-arrow">
              <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-toggle="dropdown"
                aria-haspopup="true" aria-expanded="false">
                <img class="img-profile rounded-circle" <%if session("sexoFunc") = "M" then%>src="img/boy.png" <%else %> src="img/girl.png" <%end if%> style="max-width: 60px">
                <span class="ml-2 d-none d-lg-inline text-white small"><%=session("nomeFunc")%></span>
              </a>
              <div class="dropdown-menu dropdown-menu-right shadow animated--grow-in" aria-labelledby="userDropdown">
                <div class="dropdown-divider"></div>
                <a class="dropdown-item" href="javascript:void(0);" data-toggle="modal" data-target="#logoutModal">
                  <i class="fas fa-sign-out-alt fa-sm fa-fw mr-2 text-gray-400"></i>
                  Logout
                </a>
              </div>
            </li>
          </ul>
        </nav>
        <!-- Topbar -->
   


  <script src="vendor/jquery/jquery.min.js"></script>
  <script src="vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
  <script src="vendor/jquery-easing/jquery.easing.min.js"></script>
  <script src="js/ruang-admin.min.js"></script>
</body>

</html>