unit zwto;
interface
var erg,erga,zeigp:array[1..12] of byte;
    dateinam:string;
    tlang:word;
    fn:byte;
const zazto:array[1..12]of string[3]=('C  ','CIS','D  ','ES ','E  ','F  ',
                                       'FIS','G  ','GIS','A  ','B  ','H  ');
      zhoer:array[1..12]of word=(262,277,294,311,330,349,370,392,415,
                                 440,466,493);


function  zeit        :word;
function  dbk         :boolean;
procedure hoer        (x,y:word;vv:boolean);
procedure tonds       (x,y,th:word;zeich:boolean);
procedure darstell12t (x,y:word);
procedure eingabe12t  (x,y:word;var ps:word);
procedure persausw    (var x,y:word);
function  interpret   (var wv:byte):byte;
procedure allmogl     (wv:word);
procedure umkehrung;
procedure zahl        (wv:byte);
procedure perspek;
implementation
uses crt,saa12t,graph,dos;

function zeit;
var h,m,s,hs:word;

begin
 gettime (h,m,s,hs);
 zeit:=((h*60*+m)*60+s)*100+hs;
end;

function dbk;
var hv:word;
begin
 repeat mausles;until not maus.lt;
 hv:=zeit;
 repeat mausles;until(zeit-hv>10)or maus.lt;
 dbk:=maus.lt;
end;

procedure hoer;
var i,a:byte;
    verlschl:boolean;
    z:word;

begin
 if vv then i:=1 else i:=12;
 a:=i;verlschl:=false;
 repeat;
  sound(zhoer[erg[i]]);
  z:=zeit;
  mausanaus(false);
  if i<>a then bar(x-23+a*24,y+1,x-1+a*24,y+3);
  setfillstyle(1,f3);
  bar(x-23+i*24,y+1,x-1+i*24,y+3);
  mausanaus(true);
  setfillstyle(0,0);
  a:=i;
  if vv then
   if i=12 then verlschl:=true else i:=i+1
  else if i=1 then verlschl:=true else i:=i-1;
  mausles;
  while zeit-z<tlang do;
 until verlschl or maus.rt or(keypressed and(readkey=#27));
 nosound;
 mausanaus(false);
 bar(x-23+a*24,y+1,x-1+a*24,y+3);
 mausanaus(true);
end;

procedure auflz(x,y:word);

begin
 line(x,y-3,x,y-2);
 line(x+3,y+2,x+3,y+3);
 rectangle(x,y-1,x+3,y+1);
end;

procedure kreuz(x,y:word);

begin
 line(x,y-3,x,y+3);
 line(x-1,y+1,x+4,y+1);
 line(x+3,y-3,x+3,y+3);
 line(x-1,y-1,x+4,y-1);
end;

procedure be(x,y:word);

begin
 line(x,y-3,x,y+1);
 arc(x,y,270,90,2);
end;

procedure tonds;
var y2:word;

begin
 if zeich then begin
  setcolor(fv);setfillstyle(1,fv);
 end else begin
  setcolor(fh);setfillstyle(0,0);
 end;
 case th of
  1:begin y2:=20;auflz(x+2,y+y2);end;
  2:begin y2:=20;kreuz(x+2,y+y2);end;
  3:begin y2:=18;auflz(x+2,y+y2);end;
  4:begin y2:=16;be(x+2,y+y2);end;
  5:begin y2:=16;auflz(x+2,y+y2);end;
  6:begin y2:=14;auflz(x+2,y+y2);end;
  7:begin y2:=14;kreuz(x+2,y+y2);end;
  8:begin y2:=12;auflz(x+2,y+y2);end;
  9:begin y2:=12;kreuz(x+2,y+y2);end;
  10:begin y2:=10;auflz(x+2,y+y2);end;
  11:begin y2:=8;be(x+2,y+y2);end;
  12:begin y2:=8;auflz(x+2,y+y2);end;
 end;
 fillellipse(x+12,y+y2,3,2);
 if zeich and(th<3)then line(x+8,y+y2-(y2 mod 4),x+16,y+y2-(y2 mod 4));
 if not zeich then begin
  if th<3 then begin
   setcolor(fh);
   line(x+8,y+y2-(y2 mod 4),x+16,y+y2-(y2 mod 4));
  end
  else begin
   setcolor(fn);
   line(x+2,y+y2-(y2 mod 4),x+15,y+y2-(y2 mod 4));
  end;
  setcolor(fn);
  if th>5 then line(x+2,y+y2-(y2 mod 4)+4,x+15,y+y2-(y2 mod 4)+4);
 end;
 setcolor(fv);setfillstyle(0,0);
end;

procedure darstell12t;
var i:byte;

begin
 setcolor(fn);
 mausanaus(false);
 for i:=0 to 4 do line(x+1,y+i*4,x+287,y+i*4);
 for i:=0 to 12 do begin
  setcolor(fn);
  line(x+i*24,y,x+i*24,y+16);
  if i>0 then tonds(x+i*24-22,y,erg[i],true);
 end;
 mausanaus(true);
end;

procedure eingabe12t;
var th,tha,psa:byte;
    verlschl:boolean;

begin
 erga:=erg;verlschl:=false;fehler:=false;
 darstell12t(x,y);
 if ps<1 then ps:=1;
 if ps>12 then ps:=12;
 th:=erg[ps];tha:=th;psa:=ps;
 setfillstyle(1,f3);
 mausanaus(false);
 bar(x+ps*24-23,y+1,x+ps*24-1,y+3);
 mausanaus(true);
 setfillstyle(0,0);
 repeat
  if th<1 then th:=12;
  if th>12 then th:=1;
  if ps<1 then ps:=1;
  if ps>12 then ps:=12;
  if(tha<>th)and(psa=ps)then begin
   mausanaus(false);
   tonds(x+ps*24-22,y,tha,false);
   tonds(x+ps*24-22,y,th,true);
   mausanaus(true);
   tha:=th;
  end;
  if psa<>ps then begin
   erg[psa]:=th;
   th:=erg[ps];
   setfillstyle(1,f3);
   mausanaus(false);
   bar(x+ps*24-23,y+1,x+ps*24-1,y+3);
   setfillstyle(0,0);
   bar(x+psa*24-23,y+1,x+psa*24-1,y+3);
   mausanaus(true);
   psa:=ps;tha:=th;
  end;
  if keypressed then begin
   case readkey of
    #0:case readkey of
        #60:begin
             mausanaus(false);
             bar(x+ps*24-23,y+1,x+ps*24-1,y+3);
             mausanaus(true);
             erg[ps]:=th;
             hoer(x,y,true);
             setfillstyle(1,f3);
             mausanaus(false);
             bar(x+ps*24-23,y+1,x+ps*24-1,y+3);
             mausanaus(true);
             setfillstyle(0,0);
            end;
        #71:ps:=1;
        #72:th:=th+1;
        #75:ps:=ps-1;
        #77:ps:=ps+1;
        #79:ps:=12;
        #80:th:=th-1;
       end;
    #13:verlschl:=true;
    #27:begin erg:=erga;fehler:=true;verlschl:=true;end;
   end;
  end
  else begin
   Mausles;
   if maus.lt and mausber(x,y,x+288,y+20)then
    ps:=trunc((maus.x-x)/24)+1
   else if maus.t then verlschl:=true;
  end;
 until verlschl;
 mausanaus(false);
 bar(x+psa*24-23,y+1,x+psa*24-1,y+3);
 mausanaus(true);
 setcolor(fv);
 if not fehler then erg[psa]:=th;
end;

function interpret;
var i:byte;
    inte:array[1..3]of record
                        w:byte;
                        r:boolean;
                       end; 
    verlschl:boolean;

begin
 for i:=1 to 3 do begin
  inte[i].w:=12+erg[i]-erg[i+1];
  if inte[i].w>11 then inte[i].w:=inte[i].w-12;
  if inte[i].w>6 then begin
   inte[i].w:=12-inte[i].w;
   inte[i].r:=true;
  end else inte[i].r:=false;
 end;
 i:=1;verlschl:=false;wv:=0;
 repeat
  if(inte[1].w=5)then begin
   verlschl:=true;wv:=1;
  end
  else if(inte[2].w<>0)and(inte[1].r=inte[2].r)and(((inte[1].w=3)and(inte[2].w=4))
       or((inte[1].w=4)and(inte[2].w=3)))then begin
        verlschl:=true;wv:=2;
       end
       else if(inte[3].w<>0)and(inte[1].w=inte[2].w)and(inte[2].w=inte[3].w)then begin
             verlschl:=true;wv:=3;
            end
            else wv:=0;
  i:=i+1;
  inte[1]:=inte[2];inte[2]:=inte[3];
  if i<10 then inte[3].w:=12+erg[i+2]-erg[i+3] else inte[3].w:=0;
  inte[3].r:=inte[3].w>11;
  if inte[3].r then inte[3].w:=inte[3].w-12;
  if inte[3].w>6 then begin
   inte[3].w:=12-inte[3].w;
   inte[3].r:=true;
  end else inte[3].r:=false;
 until verlschl or (i>11);
 if verlschl then interpret:=i-1
 else interpret:=0;
end;

procedure allmogl;
var st,i,sta:byte;
    wvmogl:longint;
    dat:text;
    s:string[8];
    verlschl,such:boolean;
    inte:array[1..3]of byte;

begin
 wvmogl:=0;such:=wv=0;
 mausanaus(false);
 if such then begin
  assign(dat,dateinam);rewrite(dat);
  outtextxy(130,156,'0         M”glichkeiten gefunden.');
 end;
 st:=erg[12];
 erg[12]:=erg[11];
 erg[11]:=st;
 repeat
  if interpret(st)=0 then begin
   wvmogl:=wvmogl+1;
   if such then begin
    str(wvmogl,s);
    bar(130,156,194,164);outtextxy(130,156,s);
    for i:=1 to 12 do write(dat,zazto[erg[i]]+' ');
    writeln(dat);
   end
   else begin
    erga:=erg;
    prozent(wv,wvmogl,wvmogl-1);
   end;
  end;
  st:=erg[12];
  erg[12]:=erg[11];
  erg[11]:=st;
  i:=interpret(sta);
  if sta=0 then st:=10 else st:=i+sta;
  if i=0 then begin
   wvmogl:=wvmogl+1;
   if such then begin
    str(wvmogl,s);
    bar(130,156,194,164);outtextxy(130,156,s);
    for i:=1 to 12 do write(dat,zazto[erg[i]]+' ');
    writeln(dat);
   end
   else if wvmogl<=wv then begin
    erga:=erg;
    prozent(wv,wvmogl,wvmogl-1);
   end;
  end;
  if st>10 then st:=10;
  repeat;
   i:=1;sta:=st;
   erg[st]:=erg[st]+1;
   while i<st do begin
    if erg[st]=erg[i] then begin erg[st]:=erg[st]+1;i:=0;end;
    i:=i+1
   end;
   if erg[st]>12 then begin erg[st]:=1;st:=st-1;end;
  until (st=sta) or (st=0);
  sta:=st;
  for st:=sta+1 to 12 do begin
   erg[st]:=1;
   i:=1;
   while i<st do begin
    if erg[st]=erg[i] then begin erg[st]:=erg[st]+1;i:=0;end;
    i:=i+1
   end;
  end;
  i:=1;verlschl:=true;
  repeat
   if erga[i]<>erg[i] then begin verlschl:=false;i:=12;end;
   i:=i+1;
  until i>12;
 until (not such and (wv<=wvmogl)) or verlschl or(keypressed and(readkey=#27));
 fehler:=wv>wvmogl+1;
 if such then close(dat) else erg:=erga;
 mausanaus(true);
end;

procedure persausw;
var verlschl:boolean;
    xa,ya:byte;
    xx:array[1..4]of word;

begin
 xx[1]:=34;xx[2]:=333;xx[3]:=339;xx[4]:=637;
 ya:=1;
 if x>12 then x:=12;if x=0 then x:=1;
 if y=0 then y:=1;if y>4 then y:=4;
 if x<>12 then xa:=12 else xa:=11;
 verlschl:=false;fehler:=false;
 repeat
  if x>12 then begin y:=y+1;x:=1;end;
  if x=0 then begin y:=y-1;x:=12;end;
  if y=0 then y:=4;
  if y>4 then y:=1;
  if(xa<>x)or(ya<>y)then begin
   setfillstyle(1,f3);
   mausanaus(false);
   bar(xx[y],x*32+44,xx[y]+2,x*32+60);
   if ya=1 then setfillstyle(1,8) else setfillstyle(0,0);
   bar(xx[ya],xa*32+44,xx[ya]+2,xa*32+60);
   mausanaus(true);
   xa:=x;ya:=y;
  end;
  if keypressed then begin
   case readkey of
    #0:case readkey of
        #71:begin y:=1;x:=1;end;
        #72:x:=x-1;
        #75:y:=y-1;
        #77:y:=y+1;
        #79:begin y:=4;x:=12;end;
        #80:x:=x+1;
       end;
    #13:verlschl:=true;
    #27:begin fehler:=true;verlschl:=true;end;
   end;
  end
  else begin
   mausles;
   if maus.lt and mausber(40,76,633,451)then begin
    x:=trunc((maus.y-44)/32);
    y:=1;
    if maus.x>183 then y:=2;
    if maus.x>336 then y:=3;
    if maus.x>488 then y:=4;
    verlschl:=dbk;
   end
   else if maus.t then begin fehler:=true;verlschl:=true;end;
  end;
 until verlschl;
 if ya=1 then setfillstyle(1,8)else setfillstyle(0,0);
 mausanaus(false);
 bar(xx[ya],xa*32+44,xx[ya]+2,xa*32+60);
 mausanaus(true);
 setfillstyle(0,0);
end;

procedure umkehrung;
var i,a:byte;
    hv:shortint;

begin
 erga:=erg;
 for i:=2 to 12 do begin
  hv:=erga[i-1]-erga[i];
  if erg[i-1]+hv<1 then hv:=hv+12;
  if erg[i-1]+hv>12 then hv:=hv-12;
  erg[i]:=erg[i-1]+hv;
 end;
end;

procedure zahl;
var i,a:byte;

begin
 for i:=1 to wv do begin
  for a:=1 to 12 do begin
   erg[a]:=erg[a]-1;
   if erg[a]=0 then erg[a]:=12;
  end;
 end;
end;

procedure perspek;
var i:byte;

begin
 erg:=zeigp;
 line(337,70,337,454);
 for i:=1 to 12 do begin
  darstell12t(40,i*32+44);
  zahl(1);
 end;
 umkehrung;
 for i:=1 to 12 do begin
  darstell12t(345,i*32+44);
  zahl(1);
 end;
 erg:=zeigp;
end;

begin
end.