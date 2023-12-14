uses dos,crt;
var tx:string;

procedure eingabe   (l:byte;var u:string);
var zpos,x,y:byte;
    ua,leer :string;
    tast:char;

begin
 if (l=0) or (l>80) then exit;
 ua:=u;
 x:=wherex;y:=wherey;
 if (x>78) or (y>22) then exit;
 if l+x> 80 then l:=80-x ;
 u:=copy(u,1,l);

 leer:='';
 for zpos:= 1 to 80 do
 begin
   leer:=leer+' ';
 end;
 zpos:=length(u)+1;

 repeat
  if zpos <1 then zpos:=length(u)+1;
  if zpos>l then zpos:=l;
  if zpos>length(u)+1 then zpos:=1;
  gotoxy(x,y);
  write (copy(u+leer,1,l));
  gotoxy (x+zpos-1,y);
  tast:=readkey;
  case tast of
   #0 :case readkey of
        #71:zpos:=1;
        #75:zpos:=zpos-1;
        #77:zpos:=zpos+1;
        #79:zpos:=length(u)+1;
        #83:delete (u,zpos,1);
       end;
   #8 :if zpos>1 then
       begin
        delete(u,zpos-1,1);
        zpos:=zpos-1;
       end;
   #13:begin
        gotoxy(x,y);
    exit;
       end;
   #27:begin
        u:=ua;
        gotoxy(x,y);
    exit;
       end;
   else
    if length(u)<l then begin
     insert (tast,u,zpos);
     zpos:=zpos+1;
    end;
  end;
 until false;
end;


procedure code(da:string);
var bv,bj:char;
    lesd,shrd:file of char;

begin
 assign(lesd,da);reset(lesd);
 assign(shrd,copy(da,1,pos('.',da))+'MIZ');rewrite(shrd);
 bv:='C';
 while not eof(lesd) do begin
  read(lesd,bj);
  bj:=char((((byte(bj)xor byte(bv))+73)xor 76)+68);
  write(shrd,bj);
  bv:=bj;
 end;
close(lesd);close(shrd);
end;

procedure decode(da:string);
var bv,bj:char;
    lesd,shrd:file of char;

begin
 assign(lesd,da);reset(lesd);
 assign(shrd,copy(da,1,pos('.',da))+'DCO');rewrite(shrd);
 bv:='C';
 while not eof(lesd) do begin
  read(lesd,bj);
  bv:=char((((byte(bj)-68)xor 76)-73) xor byte(bv));
  write(shrd,bv);
  bv:=bj;
 end;
 close(lesd);close(shrd);
end;

begin
 tx:='';
 repeat
  clrscr;
  write('Dateiname: ');eingabe(69,tx);
  if tx<>'' then
   if copy(tx,pos('.',tx),4)='.COD' then decode(tx)
   else code(tx);
 until tx=''
end.
