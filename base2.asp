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
  <title>SEBV - ADAPEC</title>
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
          <span>Escala Final</span></a>
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
                <img class="img-profile rounded-circle"  <%if session("sexoFunc") = "M" then%>src="img/boy.png" <% else %> src="img/girl.png"  <%end if%>style="max-width: 60px">
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