unit saa12t;
interface
type menutyp=array [1..10] of record
                               e:string[50];
                               ht:string[77];
                               o:byte;
                              end;
     menleisttyp=record
		  e:string[50];
                  o1:byte;
                  o2:byte;
                 end;
     dateien=array[1..200] of string[12];
     maustyp=record
             lt:boolean;
             mt:boolean;
             rt:boolean;
             t:boolean;
             x:word;
             y:word;
             anaus:boolean;
            end;

var fh,fv,f3:byte;
    fehler,mausja: boolean;
    menu:array [1..5] of menutyp;
    mlmenu:array[1..6] of menleisttyp;
    maus:maustyp;
    intinf:array[0..24]of string;
    {0:"Autor und Inhaber der Urheberrechte:"
     1:Name des Autors
     2:Stra·e des Autors
     3:Ort des Autors
     4:Standartdateiname
     5:"FÅr MenÅ ALT drÅcken"
     6:"Ich hoffe, ich konnte Ihnen weiterhelfen!"
     7-15:Infofeld
     16:gepakte Erstellungszeit (10.6.87 7:43)
     17-24:Dateienamen und -grî·en
    }


function  mausber  (x1,y1,x2,y2:word):boolean;
procedure rechteck (x1,y1,x2,y2:word);
function  women    (x:word;modu:boolean):word;
procedure wartmen  (var menzw,pudozw:word);
function  menja    :boolean;
procedure eingeb   (l,x1,y1:integer;var u:string;var wokurs:word);
procedure puldow   (x,y:word;tx:dateien;var wm:word);
procedure mausanaus(anaus:boolean);
procedure Mausles;
procedure box      (l,h:word;txt:string;setz:boolean;var p:pointer);
procedure schalter (x,y:word;tx:string);
procedure dateingeb(x,y:word;var dtn:string);
procedure prozent  (z,en,ea:word);

implementation
uses graph,crt,dos;

procedure Mausles;
 var reg:registers;
begin
 reg.ax:=3;
 intr($33,reg);
 maus.t:=reg.bx<>0;
 maus.lt:=reg.bx mod 2=1;
 maus.rt:=(reg.bx=2)or(reg.bx=3)or(reg.bx=6)or(reg.bx=7);
 maus.mt:=(reg.bx>3)and(reg.bx<8);
 maus.x:=reg.cx;maus.y:=reg.dx;
end;

procedure mausanaus;
 var reg:registers;
begin
 if mausja and(maus.anaus<>anaus) then begin
  maus.anaus:=anaus;
  if anaus then reg.ax:=1
           else reg.ax:=2;
  intr($33,reg);
 end;
end;

function mausber;
begin
 mausber:=(maus.x>=x1)and(maus.x<=x2)and(maus.y>=y1)and(maus.y<=y2)
end;

procedure rechteck;
begin
 setcolor(f3);
 rectangle(x1-1,y1-1,x2,y2);
 line(x1+2,y2+2,x2+2,y2+2);
 line(x2+2,y1+2,x2+2,y2+2);
 putpixel(x2+1,y1+1,f3);
 putpixel(x1+1,y2+1,f3);
 putpixel(x2+1,y2+1,f3);
 setcolor(8);
 line(x1,y1,x2-1,y1);
 line(x1,y1+1,x1,y2-1);
 setfillstyle(1,8);
 bar(x1+6,y2+3,x2+2,y2+6);
 bar(x2+3,y1+6,x2+6,y2+6);
 setcolor(fv);
 line(x2+1,y1+2,x2+1,y2);
 line(x1+2,y2+1,x2,y2+1);
 setfillstyle(0,0);
 bar(x1+1,y1+1,x2-1,y2-1);
end;

function women;
 var a,b:word;
begin
 a:=8;b:=1;
 while mlmenu [b].e<>'' do begin
  if modu and(a<x) then women:=b
  else if modu then exit
       else if(x=b)then begin
        women:=a;exit;
       end;
  a:=a+length(mlmenu[b].e)*8+16;
  b:=b+1;
 end;
end;

procedure menzeig(var menzeilwahl, menpudowahl:word);
var wvmz,wm,a,l,p,wma,wla,puwm,wvm,hv,pul,puwma:word;
    t:char;
    bilsp:array [1..6000] of integer;
    verlschl,raus:boolean;
begin
 fehler:=false;wm:=1;wma:=0;wvmz:=0;
 if(maus.lt and(maus.y<13)) then t:=#13
 else begin maus.x:=0;t:=#0;end;
 setcolor(fv);setfillstyle(0,0);
 while mlmenu[wvmz+1].e<>'' do wvmz:=wvmz+1;
 mausanaus(maus.x<300);
 bar(12,465,633,472);
 outtextxy(12,465,'Unterstrichenen Buchstaben drÅcken');
 mausanaus(true);
 repeat
  if keypressed and(readkey=#0) then begin
   wma:=ord(readkey);
   for a:=1 to wvmz do if wma=mlmenu[a].o2 then begin
                       wm:=a;t:=#13;
                    end;
  end;
  mausles;
 until(memw[$40:$18]<>2)or(t=#13)or maus.lt;
 wma:=0;
 mausanaus(maus.x<300);
 outtextxy(292,465,'bzw. mit den Kursortasten auswÑhlen');
 mausanaus(true);
 if maus.lt then wm:=women(maus.x,true);
 repeat
  verlschl:=false;
  repeat
   if wm>wvmz then wm:=1;
   if wm<1 then wm:=wvmz;
   l:=women(wm,false)+8;
   if wma<>wm then begin
    Mausanaus(false);
    setfillstyle(1,f3);
    bar(l-2,3,length(mlmenu[wm].e)*8+l+2,11);
    outtextxy(l,4,mlmenu[wm].e);
    setfillstyle(0,0);
    if wma<>0 then begin
     bar(wla-2,3,length(mlmenu[wma].e)*8+wla+2,11);
     outtextxy(wla,4,mlmenu[wma].e);
    end;
    Mausanaus(true);
    wla:=l;wma:=wm;
   end;
   if keypressed or(t=#13)then begin
    if(t<>#13)then t:=readkey;
    case t of
     #0:case readkey of
         #77:wm:=wm+1;
         #75:wm:=wm-1;
         #80:verlschl:=true;
         #71:wm:=1;
         #79:wm:=wvmz;
        end;
     #13:verlschl:=true;
     #27:begin wm:=0;verlschl:=true;end;
     else begin
           for a:=1 to wvmz do begin
            if upcase(mlmenu[a].e[mlmenu[a].o1])=upcase(t) then begin
             wm:=a;t:=#13
            end;
           end;
          end;
    end;
   end
   else begin
         Mausles;
         if maus.lt and(maus.y<13)then begin
          wm:=women(maus.x,true);t:=#13;
         end
         else if maus.lt or maus.rt then begin
          verlschl:=true;wm:=0;
         end;
        end;
  until verlschl;
  verlschl:=wm=0;puwm:=1;
  if not verlschl and(menu[wm][1].e<>'')then begin
{pudow-anfang}
   raus:=false;wvm:=0;puwma:=0;pul:=0;t:=#0;
   while  menu[wm][wvm+1].e<>'' do begin
    if pul<length(menu[wm][wvm+1].e) then pul:=length(menu[wm][wvm+1].e);
    wvm:=wvm+1;
   end;
   Mausanaus(false);
   getimage(l-4,13,l+pul*8+9,24+wvm*10,bilsp);
   rechteck(l-3,14,l+pul*8+3,18+wvm*10);
   for hv:=1 to wvm do begin
    outtextxy(l,7+hv*10,menu[wm][hv].e);
    line(menu[wm][hv].o*8+l-8,15+hv*10,menu[wm][hv].o*8+l-1,15+hv*10);
   end;
   Mausanaus(true);
   repeat
    mausles;
    if not maus.lt then raus:=true
    else if(maus.y<13)and(maus.x>8)and(women(maus.x,true)<>wm)then raus:=true
         else raus:=(maus.x>l)and(maus.x<l+pul*8)and(maus.y>17)
          and(maus.y<17+wvm*10);
   until raus;
   raus:=false;
   repeat
    if puwm<1 then puwm:=wvm;
    if puwm>wvm then puwm:=1;
    if puwma<>puwm then begin
     mausles;Mausanaus(false);
     setfillstyle(1,f3);
     bar(l-1,7+puwm*10,l+pul*8,15+puwm*10);
     line(menu[wm][puwm].o*8+l-8,15+puwm*10,menu[wm][puwm].o*8+l-1,15+puwm*10);
     outtextxy(l,7+puwm*10,menu[wm][puwm].e);
     setfillstyle(0,0);
     if puwma<>0 then begin
      bar(l-1,7+puwma*10,l+pul*8,15+puwma*10);
      line(menu[wm][puwma].o*8+l-8,15+puwma*10,menu[wm][puwma].o*8+l-1,
           15+puwma*10);
      outtextxy(l,7+puwma*10,menu[wm][puwma].e);
     end;
     mausanaus(maus.y<300);
     bar(12,465,633,472);
     outtextxy(12,465,menu[wm][puwm].ht);
     mausanaus(true);
     puwma:=puwm;
    end;
    if(t<>#1)and(t<>#27)then t:=#0;
    Mausles;
    if maus.lt and(maus.x>l)and(maus.x<l+pul*8)and(maus.y>17)
     and(maus.y<16+wvm*10) then begin
     t:=#1;puwm:=trunc(maus.y*0.1-0.6);
    end
    else if maus.lt and(maus.y<13)then begin
          wm:=women(maus.x,true);raus:=true;
         end
         else if maus.rt or(maus.lt and(t=#0)) then begin
               raus:=true;verlschl:=true;puwm:=0;
              end;
    if not raus and(keypressed or(t<>#0))and(memw[$40:$18]<>2)then begin
     if t=#0 then t:=readkey;
     case t of
      #13:begin verlschl:=true;raus:=true;end;
      #27:begin puwm:=0;verlschl:=true;raus:=true;end;
      #0:case readkey of
          #72:puwm:=puwm-1;
          #80:puwm:=puwm+1;
          #77:begin wm:=wm+1;raus:=true;end;
          #75:begin wm:=wm-1;raus:=true;end;
          #71:puwm:=1;
          #79:puwm:=wvm;
         end;
      #1:begin
          Mausles;
          if not maus.lt and(maus.x>l)and(maus.x<l+pul*8)and(maus.y>17)
          and(maus.y<17+wvm*10)then begin
           raus:=true;
           verlschl:=true;
          end
          else if not maus.lt then t:=#27;
         end;
      else for hv:=1 to wvm do
            if upcase(menu[wm][hv].e[menu[wm][hv].o])=upcase(t) then begin
             puwm:=hv;raus:=true;verlschl:=true;
           end;
     end;
    end
    else if(memw[$40:$18]=2)and keypressed and(readkey=#0)then begin
          a:=ord(readkey);
          for p:=1 to wvmz do if(a=mlmenu[p].o2)and(p<>wm)then begin
                            wm:=p;raus:=true;puwm:=200;
                           end;
          end;
   until raus;
   Mausanaus(false);
   putimage(l-4,17-4,bilsp,0);
   Mausanaus(true);
   t:=#13;
{pudow-ende}
  end
  else if menu[wm][1].e=''then begin puwm:=1;verlschl:=true;end;
  while keypressed do if readkey=#0 then;
 until verlschl;
 if(puwm=0)and(menu[wm][1].e<>'')then menzeilwahl:=0 else menzeilwahl:=wm;
 if menzeilwahl=0 then menpudowahl:=0 else menpudowahl:=puwm;
 mausanaus(false);
 bar(wla-2,3,length(mlmenu[wma].e)*8+wla+2,11);
 outtextxy(wla,4,mlmenu[wma].e);
 bar(12,465,633,472);
 outtextxy(12,465,intinf[5]);
 mausanaus(true);
end;

procedure wartmen;
begin
 fehler:=false;menzw:=0;pudozw:=0;
 repeat until menja;
 menzeig(menzw,pudozw);
end;

function menja;
begin
 mausles;
 menja:=(memw[$40:$18]=2)or((maus.lt=true)and(maus.y<13));
end;

procedure eingeb;
 var wokursa:byte;
     ua,uaa:string;
     tast:char;
     einfuga,einfug,verlschl:boolean;
Begin
 einfug:=(memw[$40:$17]<128);uaa:=u;fehler:=false;u:=copy(u,1,l);
 verlschl:=false;
 setfillstyle(0,0);setcolor(fv);
 if wokurs<1 then wokurs:=1;
 if wokurs>length(u)+1 then wokurs:=length(u)+1;
 if wokurs>l then wokurs:=l;
 mausanaus(false);
 bar(x1,y1,x1+l*8,y1+8);
 setfillstyle(1,f3);
 if einfug then bar(x1+wokurs*8-8,y1+8,x1+wokurs*8-1,y1+8)
 else bar(x1+wokurs*8-8,y1,x1+wokurs*8-1,y1+8);
 outtextxy(x1,y1,u);
 mausanaus(true);
 repeat
  ua:=u;wokursa:=wokurs;einfuga:=einfug;
  if keypressed then begin
   tast:=readkey;
   case tast of
    #0 :case readkey of
         #71:wokurs:=1;
         #75:wokurs:=wokurs-1;
         #77:wokurs:=wokurs+1;
         #79:wokurs:=length(u)+1;
         #82:einfug:=not einfug;
         #83:delete(u,wokurs,1);
        end;
    #8 :if wokurs>1 then begin
         wokurs:=wokurs-1;
         delete(u,wokurs,1);
        end;
    #13:verlschl:=true;
    #27:begin u:=uaa;fehler:=true;wokurs:=0;verlschl:=true;end;
    else
     if(length(u)<l)or not einfug then begin
      if not einfug then delete(u,wokurs,1);
      insert(tast,u,wokurs);
      wokurs:=wokurs+1;
     end;
   end;
   if not verlschl and(wokurs<1)then wokurs:=1;
   if wokurs>length(u)+1 then wokurs:=length(u)+1;;
   if wokurs>l then wokurs:=l;
   setfillstyle(0,0);
   mausanaus(false);
   if ua<>u then begin
    bar(x1,y1,x1+l*8,y1+8);
    outtextxy(x1,y1,u);
   end
   else if einfuga then bar(x1+wokursa*8-8,y1+8,x1+wokursa*8-1,y1+8)
        else begin
              bar(x1+wokursa*8-8,y1,x1+wokursa*8-1,y1+8);
              if wokursa<=length(u)then
               outtextxy(x1+wokursa*8-8,y1,u[wokursa]);
             end;
   setfillstyle(1,f3);
   if not verlschl then
    if einfug then bar(x1+wokurs*8-8,y1+8,x1+wokurs*8-1,y1+8)
    else begin
          bar(x1+wokurs*8-8,y1,x1+wokurs*8-1,y1+8);
          if wokurs<=length(u) then outtextxy(x1+wokurs*8-8,y1,u[wokurs]);
         end;
   mausanaus(true);
  end
  else begin
   mausles;
   if maus.lt or maus.rt then verlschl:=true;
  end;
 until verlschl;
 setfillstyle(0,0);
end;

procedure puldow;
var i,a,l,wma,wve,ofs,ofsa: byte;
    tas:char;
    raus:boolean;

begin
 raus:=false;i:=0;wma:=0;l:=0;wve:=wm;wm:=1;tas:=#0;ofs:=0;ofsa:=0;
 while  tx[i+1]<>'' do i:=i+1;
 l:=12;
 Mausanaus (false);
 for a:=1 to wve do outtextxy(x,y+a*10-10,tx[a]);
 Mausanaus (true);
 repeat
  if wm<1 then wm:=1;
  if wm>i then wm:=i;
  if wm>ofs+wve then ofs:=wm-wve;
  if wm<ofs+1 then ofs:=wm-1;
  if wma<>wm then begin
   Mausanaus (false);
   if (wma<>0)and(ofs=ofsa) then begin
    bar(x-1,y+(wma-ofs)*10-10,x+l*8,y+(wma-ofs)*10-2);
    outtextxy(x,y+(wma-ofs)*10-10,tx[wma]);
   end;
   if ofsa<>ofs then begin
    bar (x,y,x+l*8+2,y+wve*10);
    for a:=1 to wve do outtextxy(x,y+a*10-10,tx[a+ofs]);
   end;
   setfillstyle(1,f3);
   bar (x-1,y+(wm-ofs)*10-10,x+l*8,y+(wm-ofs)*10-2);
   outtextxy(x,y+(wm-ofs)*10-10,tx[wm]);
   setfillstyle(0,0);
   wma:=wm;
   mausanaus (true);
   ofsa:=ofs;
  end;
  if(tas<>#1)and(tas<>#27)then tas:=#0;
  Mausles;
  if maus.lt and(maus.x>x-1)and(maus.x<x+l*8+1)and(maus.y>y-1)and(maus.y<y+i*10+1) then begin
   tas:=#1;
   wm:=round(int((maus.y-y)/10))+1;
  end
  else if maus.rt or (maus.lt and (tas=#0)) then begin
        raus:=true;
        wm:=0;
       end;
  if not raus and(keypressed or (tas<>#0))then begin
   if tas=#0 then tas:=readkey;
   case tas of
    #13:raus:=true;
    #27:begin wm:=0;raus:=true;end;
    #0:case readkey of
        #72:wm:=wm-1;
        #73:if wm>wve then wm:=wm-wve else wm:=1;
        #80:wm:=wm+1;
        #71:wm:=1;
        #79:wm:=i;
        #81:wm:=wm+wve;
       end;
    #1:begin
        Mausles;
        if not maus.lt and(maus.x>x-1)and(maus.x<x+l*8+1)and(maus.y>y-1)and(maus.y<y+i*10+1) then raus:=true
        else if not maus.lt then tas:=#27;
        end;
   end;
  end
 until raus;
end;

procedure box;
var x1,y1,x2,y2,i:word;

begin
 x1:=317-l*4;x2:=323+l*4;
 y1:=127-h*4;y2:=133+h*4;
 if setz then begin
  mausanaus(false);
  i:=imagesize(x1-1,y1-1,x2+6,y2+6);
  getmem(p,i);
  mausanaus(false);
  getimage(x1-1,y1-1,x2+6,y2+6,p^);
  rechteck(x1,y1,x2,y2);
  setcolor(f3);
  rectangle(round((x1+x2)/2-(length(txt)*4))-3,y1,round((x1+x2)/2+(length(txt)*4))+3,y1+12);
  setcolor(fv);
  outtextxy(round((x1+x2)/2-(length(txt)*4)),y1+2,txt);
  mausanaus(true);
 end
 else begin
  mausanaus(false);
  putimage(x1-1,y1-1,p^,0);
  mausanaus(true);
  i:=imagesize(x1-1,y1-1,x2+6,y2+6);
  freemem(p,i);
 end;
end;

procedure schalter;

begin
 mausanaus(false);
 rechteck(x-2,y-2,x+8*length(tx)+2,y+10);
 outtextxy(x,y,tx);
 mausanaus(true);
end;

{procedure dateingeb;
 var suchv:searchrec;
     a:integer;
     dats:dateien;
     vz:string;
     b:word;

begin
 vz:='a:\';
 mausanaus(false);
 rechteck (x-3,y-3,x+99,y+51);
 mausanaus(true);
 repeat
  for a:=1 to 200 do dats[a]:='';
  findfirst(vz+'*.*',directory,suchv);
  a:=0;
  while doserror=0 do begin
   if(suchv.attr=directory)and(a<200)and(suchv.name<>'.')then begin
    a:=a+1;
    dats[a]:=suchv.name;
   end;
   findnext (suchv);
  end;
  b:=5;
  mausanaus(false);
  bar(x-1,y,x+96,y+48);
  mausanaus(true);
  puldow(x,y,dats,b);
  if b<>0 then vz:=vz+dats[b]+'\'
 until b=0;
end;}

procedure dateingeb;
var tx,v:string;
    hv:searchrec;
    ku:word;

begin
 tx:=dtn;ku:=length(tx);
 while(ku>0)and(tx[ku]<>'\')do ku:=ku-1;
 tx:=copy(tx,1,ku-1);
 ku:=1;
 mausanaus(false);
 outtextxy(x,y,'Verzeichnis:');
 setcolor(f3);
 rectangle(x+100,y-2,x+344,y+10);
 mausanaus(true);
 setcolor(fv);
 repeat
  eingeb(30,x+102,y,tx,ku);
  if(tx[length(tx)]<>'\')and(length(tx)>1)then v:=tx+'\'
  else v:=tx;
  findfirst(v+'*.*',anyfile,hv);
  if fehler or maus.t then exit;
 until(doserror=0);
 tx:=dtn;ku:=length(tx);
 while(ku>0)and(tx[ku]<>'\')do ku:=ku-1;
 tx:=copy(tx,ku+1,length(tx));
 ku:=length(tx);
 while(ku>0)and(tx[ku]<>'.')do ku:=ku-1;
 if ku>1 then tx:=copy(tx,1,ku-1);
 ku:=0;
 mausanaus(false);
 outtextxy(x,y+16,'Datei:');
 outtextxy(x+166,y+16,'.DAT');
 setcolor(f3);
 rectangle(x+100,y+14,x+200,y+26);
 mausanaus(true);
 repeat
  eingeb(8,x+102,y+16,tx,ku);
 until((pos('.',tx)=0)and(tx<>''))or fehler or maus.t;
 if not fehler then dtn:=v+tx+'.DAT';
end;

procedure prozent;
var hv:string[4];
    sv:word;

begin
 if ea=0 then begin
  setfillstyle(1,fv);
  bar(222,150,322,160);
  setfillstyle(0,0);
 end;
 sv:=round((en/z)*100);
 if sv<>round((ea/z)*100) then begin
  if sv<56 then setfillstyle(1,fv)
  else setfillstyle(1,f3);
  bar(256,151,278,159);
  setfillstyle(1,f3);
  if(sv>34)and(sv<56) then bar(256,151,sv+222,159);
  bar(round((ea/z)*100)+222,150,sv+222,160);
  str(sv:3,hv);hv:=hv+'%';
  setcolor(fh);outtextxy(256,151,hv);
  setcolor(fv);setfillstyle(0,0);
 end;
end;


begin
end.