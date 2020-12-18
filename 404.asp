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
                <a class="dropdown-item" href="http://intranet.adapec.to.gov.br/intranet/sistemas.asp" >
                  <i class="fas fa-reply-all  fa-sm fa-fw mr-2 text-gray-400"></i>
                  Sistemas Intranet
                </a>
                <a class="dropdown-item" href="http://intranet.adapec.to.gov.br/intranet" >
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
<div class="container-fluid" id="container-wrapper">
  <div class="text-center">
    <img src="img/error.svg" style="max-height: 100px;" class="mb-3">
    <h3 class="text-gray-800 font-weight-bold">Oopss!</h3>
    <p class="lead text-gray-800 mx-auto">O sistema está em manutenção e deve voltar em breve. Tente novamente mais tarde!</p>
    <a href="http://intranet.adapec.to.gov.br/intranet/sistemas.asp">&larr; Menu de sistemas</a>
  </div>
