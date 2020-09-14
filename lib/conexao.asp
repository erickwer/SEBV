<%
' DEFINE O ENCONDING DA PAGINA QUE FAZ A CONEXÃO COM O BANCO DE DADOS 
Response.CharSet = "utf-8"
Set conn = Server.CreateObject("ADODB.Connection")
conn.Open "Provider=SQLOLEDB.1;Server=ERICK;Database=Adapec;Uid=sa;Pwd=123;"
'conn.Open "Provider=SQLOLEDB.1;Persist Security Info=True;User ID=sa;Initial Catalog=Adapec;Data Source=10.78.2.161"
'fgdsg
%>