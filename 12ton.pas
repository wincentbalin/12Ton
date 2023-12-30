uses crt,saa12t,graph,dos,zwto;
var wm,mw:word;
    p:pointer;
    bv:char;

procedure grvtrb;external;
{$l egavga.obj}

function lescodz(var dat:text):string;
var  bj:char;
     hv:string;
     i:word;
begin
 hv:='';i:=0;
 while(hv[length(hv)]<>#10)and(i<=255)do begin
  inc(i);read(dat,bj);
  bv:=char((((byte(bj)-68)xor 76)-73)xor byte(bv));
  hv:=hv+bv;bv:=bj;
 end;
 if i<=255 then lescodz:=copy(hv,1,length(hv)-2)
 else lescodz:=#10
end;

procedure neuko12tr(neu:byte);
var i,a,pos:word;
    p:pointer;
    verlschl:boolean;
    aw:byte;

begin
 pos:=1;
 case neu of
  1:begin
     box(50,9,'Neue Grundreihe',true,p);
     schalter(130,150,'öbernehmen');
    end;
  2:begin
     box(50,9,'Kontrolle von Zwîlfton-Reihen',true,p);
     schalter(130,150,'Testen');
    end;
  3:begin
     box(50,9,'Startreihe fÅr die Suche',true,p);
     schalter(130,150,'OK');
    end;
 end;
 schalter(280,150,'Hîren (F2)');
 schalter(432,150,'Abbrechen');
 setcolor(f3);
 mausanaus(false);
 rectangle(123,116,191,136);
 mausanaus(true);
 repeat
  eingabe12t(200,116,pos);
  if maus.t then begin
   if maus.rt or(maus.lt and mausber(431,149,505,159))then begin
    fehler:=true;erg:=erga;
   end;
   if maus.mt or(maus.lt and mausber(279,149,361,159))then hoer(200,116,true);
   verlschl:=maus.lt and(mausber(129,149,147,159)or((neu=1)and
   mausber(129,149,211,159))or((neu=2)and mausber(129,149,179,159)));
   repeat mausles;until not maus.t;
  end
  else verlschl:=not fehler;
  if verlschl then begin
   i:=1;
   while i<=12 do begin
    a:=i+1;
    while a<=12 do begin
     if erg[i]=erg[a] then begin fehler:=true;pos:=i;i:=12;a:=12;end;
     a:=a+1;
    end;
    i:=i+1;
   end;
   mausanaus(false);
   if fehler then begin
    bar(125,118,189,134);
    outtextxy(125,118,zazto[erg[pos]]);
    outtextxy(125,126,'doppelt!');
    fehler:=false;
   end
   else if neu<>2 then fehler:=true
        else begin
         bar(125,118,189,134);
         a:=interpret(aw);
         if a<>0 then begin
          case aw of
           1:begin
              outtextxy(125,118,'Reine  ');
              i:=12+erg[a]-erg[a+1];
              if(i=17)or(i=7)then outtextxy(125,126,'Quarte!')
              else outtextxy(125,126,'Quinte!')
             end;
           2:begin
              outtextxy(125,126,'Akkord!');
              i:=12+erg[a]-erg[a+1];
              if i>11 then i:=i-12;
              if i>6 then begin
               i:=12-i;
               if i=3 then i:=4 else i:=3;
              end;
              if i=4 then outtextxy(125,118,'Moll-')
              else outtextxy(125,118,'Dur-');
             end;
           3:begin
              outtextxy(125,118,'drei gl.');
              outtextxy(125,126,'Interv.!');
             end;
          end;
          pos:=a;
         end
         else outtextxy(125,118,'OK');
        end;
   mausanaus(true);
  end;
 until fehler;
 box(50,9,'',false,p);
 if verlschl then begin
  fehler:=false;
  if neu=1then begin
   zeigp:=erg;
   mausanaus(false);
   bar(40,76,633,451);
   perspek;
  end else if neu=2 then erg:=zeigp;
 end else erg:=zeigp;
end;

procedure suche12tr;
var p:pointer;

begin
 neuko12tr(3);
 box(50,10,'Zwîlftonreihen suchen',true,p);
 if not fehler then dateingeb(130,110,dateinam);
 mausanaus(false);
 schalter(432,154,'Abbrechen');
 if not fehler then allmogl(0);
 box(50,10,'',false,p);
 erg:=zeigp;
end;

procedure ausgeb(i:word);
var a:word;
    p:pointer;
    verlschl:boolean;
    zmen:dateien;
    dat:text;
    hv,dtna:string;
    hv1:shortint;

begin
 erg:=zeigp;fehler:=false;dtna:=dateinam;
 if i=1 then begin
  i:=1;a:=1;
  repeat
   persausw(i,a);
   if fehler then exit;
   zahl(i-1);
   if a<3 then hoer(40,i*32+44,a=1)
   else begin
    umkehrung;
    hoer(345,i*32+44,a=3);
   end;
   erg:=zeigp;
  until false;
 end
 else begin
  if i=2 then dateinam:='prn'
  else begin
   box(60,8,'Datei, in die die Perspektiven geschrieben werden sollen',true,p);
   dateingeb(80,120,dateinam);
   box(60,8,'',false,p);
   if fehler then exit;
  end;
  assign(dat,dateinam);rewrite(dat);
  writeln(dat,'             Grundgestalt(G) ->                  <- Krebs(K)');
  verlschl:=true;
  repeat
   verlschl:=not verlschl;
   for i:=1 to 12 do begin
    if i=1 then hv:='  ' else begin
     if i<8 then hv1:=1-i else hv1:=13-i;
     str(hv1,hv);
     if i>7 then hv:='+'+hv;
    end;
    if not verlschl then write(dat,'      G')
    else write(dat,'      U');
    write(dat,hv+' |  ');
    for a:=1 to 12 do write(dat,zazto[erg[a]]+' ');
    write(dat,' | K');
    if verlschl then write(dat,'U');
    writeln(dat,hv);
    zahl(1);
   end;
   writeln(dat);
   if not verlschl then writeln(dat,'             Umkehrung(U) ->                           <- KU');
   umkehrung;
  until verlschl;
  close(dat);
  if dateinam='prn' then dateinam:=dtna;
 end;
 fehler:=false;
 erg:=zeigp;
end;

procedure metronom;
var i,tla:word;
    p:pointer;
    hv:string;

begin
 box(27,7,'TonlÑnge (Metronomzahlen)',true,p);
 setcolor(f3);
 rectangle(258,121,384,133);
 schalter(222,142,'OK');
 schalter(340,142,'Abbrechen');
 mausanaus(false);
 outtextxy(312,123,'Tîne/min');
 outtextxy(260,123,'ca.');
 mausanaus(true);
 tla:=round(6000/tlang);
 if tla>999 then tla:=999;
 i:=1;
 repeat
  str(tla:3,hv);
  eingeb(3,284,123,hv,i);
  if not fehler and maus.t then begin
   if mausber(339,141,413,151)and maus.lt then fehler:=true
   else if mausber(221,141,239,151)and maus.lt then val(hv,tla,i);
   if maus.rt then fehler:=true;
   repeat mausles;until not maus.t;
  end
  else if not fehler then val(hv,tla,i);
  if (tla<1)or(tla>999)then begin
   if tla<1 then tla:=1 else tla:=999;
   i:=1;
  end;
 until (i=0)or fehler;
 box(27,7,'',false,p);
 if not fehler then tlang:=round(6000/tla);
end;

procedure peragru;
var i,a:word;

begin
 i:=1;a:=1;
 persausw(i,a);
 if not fehler then begin
  erg:=zeigp;
  zahl(i-1);
  if a>2 then umkehrung;
  if a mod 2=0 then begin
   erga:=erg;
   for i:=1 to 12 do erg[12-i+1]:=erga[i];
  end;
  neuko12tr(1);
  if fehler then erg:=zeigp;
 end;
end;

procedure vwdtsuch;
var i,tla:word;
    p:pointer;
    hv:string;

begin
 box(27,9,'Wieviele Reihen spÑter?',true,p);
 setcolor(f3);
 rectangle(266,121,376,133);
 schalter(222,150,'OK');
 schalter(340,150,'Abbrechen');
 mausanaus(false);
 outtextxy(304,123,'Reihe(n).');
 mausanaus(true);
 tla:=100;
 i:=1;
 repeat
  if tla>9999 then begin tla:=9999; end;
  str(tla:4,hv);
  eingeb(4,268,123,hv,i);
  if not fehler and maus.t then begin
   if mausber(339,149,413,159)and maus.lt then fehler:=true
   else if mausber(221,149,239,159)and maus.lt then val(hv,tla,i);
   if maus.rt then fehler:=true;
   repeat mausles;until not maus.t;
  end
  else if not fehler then val(hv,tla,i);
  if (tla<1)or(tla>9999)then begin
   if tla<1 then tla:=1 else tla:=9999;
   i:=1;
  end;
 until (i=0) or fehler;
 if not fehler then begin
  mausanaus(false);
  bar(219,147,247,167);
  allmogl(tla);
 end;
 box(27,9,'',false,p);
 if not fehler then neuko12tr(1)
 else erg:=zeigp;
end;

procedure info;
var p:pointer;
    i:byte;
begin
 box(50,16,'Informationen Åber !12Ton',true,p);
 schalter(495,177,'OK');
 mausanaus(false);
 setcolor(fv);
 for i:=1 to 7 do
  if i<>5 then outtextxy(120,73+10*i,intinf[i+6]);
 setcolor(f3);
 outtextxy(120,123,intinf[11]);
 for i:=1 to 4 do outtextxy(120,143+i*10,intinf[i-1]);
 mausanaus(true);
 repeat mausles;until keypressed or maus.t;
 box(50,16,'',false,p);
end;

procedure einricht;
var hv:string;
    vm,va,q:integer;
    dum,p:longint;
    reg:registers;
    dat:text;
    dat1:text;
    sd:searchrec;
	
	s1: string;


begin
 fehler:=false;bv:='C';
  menu[1,1].e:='Eingeben';
  menu[1,2].e:='AuswÑhlen';
  menu[1,3].e:='Verwandte Suchen...';
  menu[1,4].e:='Kontrollieren';
  menu[1,5].e:='';
  menu[1,1].ht:='Eingeben einer neuen Grundreihe (fÅr die Darstellung in den Perspektiven).';
  menu[1,2].ht:='Aus den Perspektiven eine neue Grundreihe auswÑhlen.';
  menu[1,3].ht:='Die x-te Reihe mit Ñhnlichem Anfang suchen.';
  menu[1,4].ht:='Kontrolle von Zwîlfton-Reihen auf Richtigkeit';
  menu[1,5].ht:='';
  menu[1,1].o:=1;
  menu[1,2].o:=1;
  menu[1,3].o:=11;
  menu[1,4].o:=1;
  menu[1,5].o:=0;
  menu[2,1].e:='Lautsprecher...';
  menu[2,2].e:='Drucker';
  menu[2,3].e:='Datei...';
  menu[2,4].e:='';
  menu[2,1].ht:='Hîren einer gewÑhlten Perspektive.';
  menu[2,2].ht:='Ausgabe aller Perspektiven auf dem Drucker (PRN).';
  menu[2,3].ht:='Ausgabe aller Perspektiven in eine Datei.';
  menu[2,4].ht:='';
  menu[2,1].o:=1;
  menu[2,2].o:=5;
  menu[2,3].o:=1;
  menu[2,4].o:=0;
  menu[3,1].e:='Reihen Suchen...';
  menu[3,2].e:='TonlÑnge';
  menu[3,3].e:='Info';
  menu[3,4].e:='Ende';
  menu[3,5].e:='';
  menu[3,1].ht:='Suchen verwandter Reihen und Schreiben in eine Datei';
  menu[3,2].ht:='éndern der TonlÑnge';
  menu[3,3].ht:='Informationen Åber !12Ton';
  menu[3,4].ht:='Beendet !12Ton';
  menu[3,5].ht:='';
  menu[3,1].o:=8;
  menu[3,1].o:=1;
  menu[3,1].o:=1;
  menu[3,1].o:=1;
  menu[3,1].o:=0;
  mlmenu[1].e:='Grundreihe';
  mlmenu[2].e:='Ausgabe';
  mlmenu[3].e:='Sonstiges';
  mlmenu[4].e:='';
  mlmenu[1].o1:=1;
  mlmenu[2].o1:=1;
  mlmenu[3].o1:=1;
  mlmenu[4].o1:=0;
  mlmenu[1].o2:=34;
  mlmenu[2].o2:=30;
  mlmenu[3].o2:=31;
  mlmenu[4].o2:=0;
  intinf[0]:='Autor und Inhaber der Urheberrechte:';
  intinf[1]:='Matthias Kleinmann';
  intinf[2]:='';
  intinf[3]:='';
  intinf[4]:='!12Ton.DAT';
  intinf[5]:='FÅr MenÅ ALT drÅcken';
  intinf[6]:='Ich hoffe, ich konnte Ihnen weiterhelfen!';
  intinf[7]:='';
  intinf[8]:='';
  intinf[9]:='';
  intinf[10]:='';
  intinf[11]:='';
  intinf[12]:='';
  intinf[13]:='Bei Problemen wenden Sie sich bitte an den';
  intinf[14]:='!12ton.miz';
  intinf[15]:='1089';
  intinf[16]:='!12ton.exe';
  intinf[17]:='60784';
  dateinam:=intinf[4];
{Einlesen der Datei- Infos Ende}
 zeigp[1]:=7;zeigp[2]:=1;zeigp[3]:=10;zeigp[4]:=11;
 zeigp[5]:=2;zeigp[6]:=5;zeigp[7]:=3;zeigp[8]:=6;
 zeigp[9]:=9;zeigp[10]:=8;zeigp[11]:=12;zeigp[12]:=4;
 tlang:=38;fv:=8;fh:=7;f3:=11;fn:=5;
 maus.anaus:=false;mausja:=true;
 reg.ax:=0;intr($33,reg);
 if reg.ax=0 then mausja:=false;
 if mausja then begin
  reg.ax:=4;reg.cx:=300;reg.dx:=150;intr($33,reg);
  reg.ax:=7;reg.cx:=0;reg.dx:=638;intr($33,reg);
  reg.ax:=8;reg.cx:=0;reg.dx:=465;intr($33,reg);
  reg.ax:=15;reg.cx:=10;reg.dx:=20;intr($33,reg);
  mausanaus(false);
 end;mem[0:1047]:=128;
 vm:=vga;va:=vgahi;initgraph(vm,va,'');
 if vm<0 then begin fehler:=true;exit;end;
 setcolor(fv);setbkcolor(fh);setpalette(8,0);
{Oberfl"chengestaltung-Anfang}
 vm:=1;while mlmenu[vm].e<>''do vm:=vm+1;
 rechteck(1,1,634,14);
 for va:=1 to vm-1 do begin
  p:=women(va,false);
  outtextxy(p+8,4,mlmenu[va].e);
  line(mlmenu[va].o1*8+p,12,mlmenu[va].o1*8+8+p,12);
 end;
 rechteck(1,463,634,473);
 outtextxy(12,465,intinf[5]);
 rechteck(2,45,633,60);rechteck(2,45,30,451);
 bar(30,45,36,59);
 setcolor(8);line(30,45,36,45);
 setcolor(f3);line(30,60,36,60);
 line(32,62,36,62);putpixel(31,61,f3);
 setcolor(fv);line(32,61,36,61);
 outtextxy(5,50,'     Grundgestalt(G) >        < Krebs(K)   Umkehrung(U) >                 < KU');
 line(169,53,179,53);line(248,53,256,53);
 line(449,53,459,53);line(600,53,608,53);
 line(337,47,337,59);
 for p:=1 to 12 do begin
  if p=1 then hv:='G' else begin
   if p<8 then va:=1-p else va:=13-p;
   str(va,hv);
   if p>7 then hv:='G+'+hv else hv:='G'+hv;
  end;
  outtextxy(5,p*32+50,hv);
 end;
 perspek;
{Oberfl"chengestaltung-Ende}
 info
end;


begin
 clrscr;textcolor(9);textbackground(0);
 writeln('Lade...');
 if registerbgidriver(@grvtrb)>=0 then einricht
 else begin Writeln('!!Grafikfehler!!');fehler:=true end;
 wm:=0;mw:=0;
 if not fehler then begin
  repeat
   if menja then begin
    wartmen(wm,mw);
    case wm of
     1:case mw of
       1:neuko12tr(1);
       2:peragru;
       3:vwdtsuch;
       4:neuko12tr(2);
      end;
     2:ausgeb(mw);
     3:case mw of
        1:suche12tr;
        2:metronom;
        3:info;
       end;
    end;
   end;
  until (wm=3)and(mw=4);
 end;
 closegraph;writeln;mem[0:1047]:=160;
 if fehler then begin
  writeln('Bitte wenden Sie sich an den Autor:');
  writeln('  ',intinf[1]);
  writeln('  ',intinf[2]);
  writeln('  ',intinf[3]);
  if readkey='' then;
 end
 else writeln(intinf[6]);
end.
