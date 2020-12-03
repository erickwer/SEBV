<%
' DEFINE O ENCONDING DA PAGINA QUE FAZ A CONEXÃO COM O BANCO DE DADOS 
Response.CharSet = "utf-8"
Set conn = Server.CreateObject("ADODB.Connection")
conn.Open "Provider=SQLNCLI11;Server=localhost;Database=Adapec;Uid=sa;Pwd=123;"
%>