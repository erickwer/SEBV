this.Header=function Header()
{
 
}
this.Footer=function Footer()
{
    
    this.SetY(-15);
    this.SetTextColor(186,186,186)
    this.SetFont('Arial','B',8);
    this.Cell(0,10,'' + this.PageNo() + '',0,0,'R');
}
