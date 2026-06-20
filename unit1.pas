unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TASeries, Forms, Controls, Graphics,
  Dialogs, StdCtrls, ExtCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Chart1: TChart;
    Chart1LineSeries1: TLineSeries;
    Chart1LineSeries2: TLineSeries;
    Chart2: TChart;
    Chart2LineSeries1: TLineSeries;
    Chart2LineSeries2: TLineSeries;
    Chart3: TChart;
    Chart3LineSeries1: TLineSeries;
    Chart3LineSeries2: TLineSeries;
    Chart4: TChart;
    Chart4LineSeries1: TLineSeries;
    Chart4LineSeries2: TLineSeries;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    SaveDialog1: TSaveDialog;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RadioButton1Change(Sender: TObject);
    procedure RadioButton2Change(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure gambar(io:extended;io1:extended;io2:extended);
    procedure gambarduduk(io:extended;io1:extended;io2:extended);
  private

  public

  end;


const

  mf=0.7;
  lf=1.25;
  masf=1.5;

  gamma1=-15*pi/180;
  gamma2=25*pi/180;

  pi=3.14;
  max=3;
  dt=0.0001;

  {gravitational acceleration}
  g1=9.81;

  {segments masses}
  m1=masf*6.86{9.74};
  m2=masf*2.76{3.86};
  m3=masf*0.89{0.99};


  {moments of inertia}
  I1=0.133{0.167};
  I2=0.048{0.060};
  I3=0.004{0.005};

  {segments length}
  l1=lf*0.383{0.40};
  l2=lf*0.407{0.43};
  l3=lf*0.149;

  {cm}
  a1=lf*0.42*l1{0.2};
  a2=lf*0.41*l2{0.15};
  a3=lf*0.4*l3{0.08};

  {passive damping}
  cpd1=3.09;
  cpd2={3.17;}10;
  cpd3=0.943;

  {joint stifness}

  k11=2.6;
  k21=5.8;
  k31=8.7;
  k41=1.3;

  k12=6.1;
  k22=5.9;
  k32=10.5;
  k42=21.8;

  k13=2;
  k23=5;
  k33=2;
  k43=5;

type

  row=array[1..max] of real;
  matrix=array[1..max] of row;

var
  Form1: TForm1;
  a,b,ab:matrix;
  inversionOK:boolean;
  b1,ab1:row;
  m,c,g:matrix;
  angle,vel,accl,gra,torque:row;
  t,time:real;
  hip,knee,ankle:array[1..1000000] of real;
  theta1,theta2,theta3:real;
  thetadot1,thetadot2,thetadot3:real;
  thetadotdot1,thetadotdot2,thetadotdot3:real;
  filename:text;
  term1,term2,term3:row;
  mpd1,mpd2,mpe1,mpe2,mpd3,mpe3:extended;
  k1,k2,k3,k4:array[1..max] of extended;
  counter:integer;
  time1,hip1,knee1,ankle1:array[1..1000000] of extended;
   filename1:textfile;


implementation

{$R *.frm}

procedure matrixmultiplication (a,b:matrix;n:integer);
var
  i,j,k:integer;
  temp:real;
begin
  for i:= 1 to max do
  begin
    for j:= 1 to n do
    begin
    temp:=0;
      for k:= 1 to max do
      begin
        temp:=temp+a[i,k]*b[k,j];
      end;
    ab[i,j]:=temp;
    end;
  end;
end;

procedure matrixmultiplication1 (a:matrix;b:row;n:integer);
var
  i,j:integer;
  temp:real;
begin
  for i:= 1 to max do
  begin
    temp:=0;
    for j:= 1 to max do
    begin
      temp:=temp+a[i,j]*b[j];
    end;
    ab1[i]:=temp;
  end;
end;

Procedure MatrixInversion (A:Matrix; N:integer);
Var I, J, K : integer;
         Factor  : real;
         Temp    : Row;
Begin
  InversionOK:=False;
         For I:=1 to N do
           For J:=1 to N do
             If I=J then
               B [I,J]:=1
                    else
               B [I,J]:=0;
         For I:=1 to N do
           Begin
             For J:=I+1 to N do
               If Abs (A [I,I])<Abs (A [J,I]) then
                 Begin
                   Temp:=A [I];
                   A [I]:=A [J];
                   A [J]:=Temp;
                   Temp:=B [I];
                   B [I]:=B [J];
                   B [J]:=Temp
                 End;
             If A [I,I]=0 then Exit;
             Factor:=A [I,I];
             For J:=N downto 1 do
               Begin
                 B [I,J]:=B [I,J]/Factor;
                 A [I,J]:=A [I,J]/Factor
               End;
             For J:=I+1 to N do
               Begin
                 Factor:=-A [J,I];
                 For K:=1 to N do
                   Begin
                     A [J,K]:=A [J,K]+A [I,K]*Factor;
                     B [J,K]:=B [J,K]+B [I,K]*Factor
                   End
               End
           End;
         For I:=N downto 2 do
           Begin
             For J:=I-1 downto 1 do
               Begin
                 Factor:=-A [J,I];
                 For K:=1 to N do
                   Begin
                     A [J,K]:=A [J,K]+A [I,K]*Factor;
                     B [J,K]:=B [J,K]+B [I,K]*Factor
                   End
               End
           End;
         { A:=B;    }
  InversionOK:=True
End;

{ TForm1 }

procedure Tform1.gambar(io:extended;io1:extended;io2:extended);
begin
  chart4lineseries2.Clear;
  chart4lineseries1.Clear;

chart4lineseries1.AddXY(10,0);
chart4lineseries1.AddXY(round(10+100*sin(io)),round(10-100*cos(io)));
chart4lineseries1.AddXY(round(10+100*sin(io)+100*sin(io-io1)),round(10-100*cos(io)-100*cos(io-io1)));
chart4lineseries1.AddXY(round(10+100*sin(io)+100*sin(io-io1)+40*cos(io-io1-io2)),round(10-100*cos(io)-100*cos(io1-io)+40*sin(io-io1-io2)));

chart1lineseries1.addY(theta1*180/pi);
chart2lineseries1.addY(theta2*180/pi);
chart3lineseries1.addY(theta3*180/pi);
end;

procedure Tform1.gambarduduk(io:extended;io1:extended;io2:extended);
var i: integer;
begin
  chart4lineseries2.Clear;
  chart4lineseries1.Clear;

chart4lineseries2.AddXY(-150,0);
chart4lineseries2.AddXY(10,0);
chart4lineseries2.AddXY(round(10+100*sin(io)+100*sin(io-io1)),round(10-80*cos(io)-80*cos(io-io1)));
chart4lineseries2.AddXY(round(10+100*sin(io)+100*sin(io-io1)+40*cos(io-io1-io2)),round(10-80*cos(io)-80*cos(io1-io)+40*sin(io-io1-io2)));

chart1lineseries2.addY(90);
chart2lineseries2.addY(theta2*180/pi);
chart3lineseries2.addY(theta3*180/pi);
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  hip0,knee0,ankle0:extended;
begin
  chart4lineseries2.Clear;
  chart4lineseries1.Clear;
  chart1lineseries2.Clear;
  chart2lineseries2.Clear;
  chart3lineseries2.Clear;
  chart1lineseries1.Clear;
  chart2lineseries1.Clear;
  chart3lineseries1.Clear;
if radiobutton1.Checked = true then
  begin
    timer1.Enabled:= false;
     counter := 0;
     time := 0;

     hip0:=(strtofloat(edit1.Text))*pi/180;
     knee0:=(strtofloat(edit2.Text))*pi/180;
     ankle0:=(strtofloat(edit3.Text))*pi/180;

     theta1:=hip0;
     theta2:=knee0;
     theta3:=ankle0;

     thetadot1:=0;
     thetadot2:=0;
     thetadot3:=0;

     thetadotdot1:=0;
     thetadotdot2:=0;
     thetadotdot3:=0;

     angle[1]:=theta1;
     angle[2]:=theta2;
     angle[3]:=theta3;

     vel[1]:=thetadot1;
     vel[2]:=thetadot2;
     vel[3]:=thetadot3;

     accl[1]:=thetadotdot1;
     accl[2]:=thetadotdot2;
     accl[3]:=thetadotdot3;

     time1[counter]:=time;
     hip[counter]:=theta1*180/pi;
     knee[counter]:=theta2*180/pi;
     ankle[counter]:=theta3*180/pi;
     timer1.Enabled:= true;
  end;
if radiobutton2.Checked = true then
  begin
     chart4lineseries1.Clear;
     chart4lineseries2.Clear;
     timer1.Enabled:= false;
     counter := 0;
     time := 0;

     hip0:=90*pi/180;
     knee0:=(strtofloat(edit2.Text))*pi/180;
     ankle0:=(strtofloat(edit3.Text))*pi/180;

     theta1:=hip0;
     theta2:=knee0;
     theta3:=ankle0;

     thetadot1:=0;
     thetadot2:=0;
     thetadot3:=0;

     thetadotdot1:=0;
     thetadotdot2:=0;
     thetadotdot3:=0;

     angle[1]:=theta1;
     angle[2]:=theta2;
     angle[3]:=theta3;

     vel[1]:=thetadot1;
     vel[2]:=thetadot2;
     vel[3]:=thetadot3;

     accl[1]:=thetadotdot1;
     accl[2]:=thetadotdot2;
     accl[3]:=thetadotdot3;

     time1[counter]:=time;
     hip[counter]:=theta1*180/pi;
     knee[counter]:=theta2*180/pi;
     ankle[counter]:=theta3*180/pi;
     timer1.Enabled:= true;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  timer1.Enabled:=false;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
i : integer;
begin
if savedialog1.Execute then
 begin
   assignfile(filename1,savedialog1.filename);
   rewrite(filename1);
    for i := 0 to counter do
    begin
      writeln(filename1,time1[i],' ',hip[i],' ',knee[i],' ',ankle[i]);
    end;
  closefile(filename1);
end;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  timer1.Enabled:= false;
end;

procedure TForm1.RadioButton1Change(Sender: TObject);
begin
  label1.Visible:= true;
  edit1.Visible:= true;
end;

procedure TForm1.RadioButton2Change(Sender: TObject);
begin
  label1.Visible:= false;
  edit1.Visible:= false;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
  var
  j: integer;
begin
{listbox1.Clear;
listbox2.Clear;
listbox3.Clear;}
t := 0;
  while t<0.01 do
  begin
    {HIP JOINT}
    mpd1:=cpd1*thetadot1;
    mpe1:=k11*exp(-k21*(theta1+10*pi/180))-k31*exp(k41*(10*pi/180-theta1));
    torque[1]:=-mpd1+mpe1;


    {KNEE@JOINT}
    mpd2:=cpd2*thetadot2;
    mpe2:=k12*exp(-k22*(theta2-10*pi/180))-k32*exp(-k42*(67*pi/180-theta2));
    torque[2]:=-mpd2+mpe2;

    {ANKLE JOINT}
    mpd3:=cpd3*thetadot3;
    mpe3:=k13*exp(-k23*(theta3-gamma1))-k33*exp(-k43*(gamma2-theta3));
    torque[3]:=-mpd3+mpe3;

 {first to get k1}
  m[1,1]:=I1+m1*sqr(a1)+I2+m2*(sqr(l1)+sqr(a2)+2*l1*a2*cos(theta2))+I3+m3*(sqr(l1)+sqr(l2)+sqr(a3)+2*l1*l2*cos(theta2)+2*l2*a3*cos(theta3)+2*l1*a3*cos(theta3-theta2));
  m[1,2]:=-I2-m2*(sqr(a2)+l1*a2*cos(theta2))-I3-m3*(sqr(l2)-sqr(a3)-l1*l2*cos(theta2)-2*l2*a3*cos(theta3)-l1*a3*cos(theta3-theta2));
  m[1,3]:=I3+m3*(sqr(a3)-l2*a3*cos(theta3)+l1*a3*cos(theta3-theta2));

  m[2,1]:=-I2-m2*(sqr(a2)+l1*a2*cos(theta2))-I3-m3*(sqr(l2)+sqr(a3)+l1*l2*cos(theta2)+2*l2*a3*cos(theta3)+l1*a3*cos(theta3-theta2));
  m[2,2]:=I2+m2*sqr(a2)+I3+m3*(sqr(l2)+sqr(a3)+2*l2*a3*cos(theta3));
  m[2,3]:=-I3-m3*(sqr(a3)+l2*a3*cos(theta3));

  m[3,1]:=I3+m3*(sqr(a3)+l2*a3*cos(theta3)+l1*a3*cos(theta3-theta2));
  m[3,2]:=-I3-m3*(sqr(a3)+l2*a3*cos(theta3));
  m[3,3]:=I3+m3*sqr(a3);


  c[1,1]:=0;
  c[1,2]:=0;
  c[1,3]:=0;

  c[2,1]:=-m2*l1*a2*thetadot1*sin(theta2)-m3*l1*l2*thetadot1*sin(theta2)+m3*l1*a3*thetadot1*sin(theta3-theta2);
  c[2,2]:=m2*l1*a2*thetadot1*sin(theta2)+m3*l1*a3*thetadot1*sin(theta3-theta2)+m3*l1*l2*thetadot1*sin(theta2);
  c[2,3]:=m3*l1*a3*thetadot1*sin(theta3-theta2);

  c[3,1]:=m2*l2*a3*(2*thetadot2-thetadot1)*sin(theta3)-m3*l1*a3*thetadot1*sin(theta3-theta2);
  c[3,2]:=-m2*l2*a3*thetadot2*sin(theta3)+m3*l1*a3*thetadot1*sin(theta3-theta2);
  c[3,3]:=m2*l2*a3*(thetadot2-thetadot1)*sin(theta3)-m3*l1*a3*thetadot1*sin(theta3-theta2);

  gra[1]:=m1*g1*a1*sin(theta1)+m2*g1*(l1*sin(theta1)-a2*sin(theta2-theta1))+m3*g1*(l1*sin(theta1)-l2*sin(theta2-theta1)+a3*sin(theta1-theta2+theta3));
  gra[2]:=m2*g1*a2*sin(theta2-theta1)+m3*g1*(l2*sin(theta2-theta1)-a3*sin(theta1-theta2+theta3));
  gra[3]:=m3*g1*a3*sin(theta1-theta2+theta3);

  {solving motion equations}
  matrixinversion(m,3);
  matrixmultiplication1(b,torque,3);
  term1:=ab1;

  matrixinversion(m,3);
  matrixmultiplication(b,c,3);
  matrixmultiplication1(ab,vel,3);
  term2:=ab1;

  matrixinversion(m,3);
  matrixmultiplication1(b,gra,3);
  term3:=ab1;


    for j:= 1 to max do
    begin
      accl[j]:=term1[j]+term2[j]-term3[j];
    end;


    for j:= 1 to max do
    begin
      k1[j]:=0.5*dt*accl[j];
    end;


{second, to get k2}
    theta1:=theta1+0.5*dt*(thetadot1+0.5*k1[1]);
    theta2:=theta2+0.5*dt*(thetadot2+0.5*k1[2]);
    theta3:=theta3+0.5*dt*(thetadot3+0.5*k1[3]);


    thetadot1:=thetadot1+k1[1];
    thetadot2:=thetadot2+k1[2];
    thetadot3:=thetadot3+k1[3];

  m[1,1]:=I1+m1*sqr(a1)+I2+m2*(sqr(l1)+sqr(a2)+2*l1*a2*cos(theta2))+I3+m3*(sqr(l1)+sqr(l2)+sqr(a3)+2*l1*l2*cos(theta2)+2*l2*a3*cos(theta3)+2*l1*a3*cos(theta3-theta2));
  m[1,2]:=-I2-m2*(sqr(a2)+l1*a2*cos(theta2))-I3-m3*(sqr(l2)-sqr(a3)-l1*l2*cos(theta2)-2*l2*a3*cos(theta3)-l1*a3*cos(theta3-theta2));
  m[1,3]:=I3+m3*(sqr(a3)-l2*a3*cos(theta3)+l1*a3*cos(theta3-theta2));

  m[2,1]:=-I2-m2*(sqr(a2)+l1*a2*cos(theta2))-I3-m3*(sqr(l2)+sqr(a3)+l1*l2*cos(theta2)+2*l2*a3*cos(theta3)+l1*a3*cos(theta3-theta2));
  m[2,2]:=I2+m2*sqr(a2)+I3+m3*(sqr(l2)+sqr(a3)+2*l2*a3*cos(theta3));
  m[2,3]:=-I3-m3*(sqr(a3)+l2*a3*cos(theta3));

  m[3,1]:=I3+m3*(sqr(a3)+l2*a3*cos(theta3)+l1*a3*cos(theta3-theta2));
  m[3,2]:=-I3-m3*(sqr(a3)+l2*a3*cos(theta3));
  m[3,3]:=I3+m3*sqr(a3);


  c[1,1]:=0;
  c[1,2]:=0;
  c[1,3]:=0;

  c[2,1]:=-m2*l1*a2*thetadot1*sin(theta2)-m3*l1*l2*thetadot1*sin(theta2)+m3*l1*a3*thetadot1*sin(theta3-theta2);
  c[2,2]:=m2*l1*a2*thetadot1*sin(theta2)+m3*l1*a3*thetadot1*sin(theta3-theta2)+m3*l1*l2*thetadot1*sin(theta2);
  c[2,3]:=m3*l1*a3*thetadot1*sin(theta3-theta2);

  c[3,1]:=m2*l2*a3*(2*thetadot2-thetadot1)*sin(theta3)-m3*l1*a3*thetadot1*sin(theta3-theta2);
  c[3,2]:=-m2*l2*a3*thetadot2*sin(theta3)+m3*l1*a3*thetadot1*sin(theta3-theta2);
  c[3,3]:=m2*l2*a3*(thetadot2-thetadot1)*sin(theta3)-m3*l1*a3*thetadot1*sin(theta3-theta2);

  gra[1]:=m1*g1*a1*sin(theta1)+m2*g1*(l1*sin(theta1)-a2*sin(theta2-theta1))+m3*g1*(l1*sin(theta1)-l2*sin(theta2-theta1)+a3*sin(theta1-theta2+theta3));
  gra[2]:=m2*g1*a2*sin(theta2-theta1)+m3*g1*(l2*sin(theta2-theta1)-a3*sin(theta1-theta2+theta3));
  gra[3]:=m3*g1*a3*sin(theta1-theta2+theta3);


  {solving motion equations}
  matrixinversion(m,3);
  matrixmultiplication1(b,torque,3);
  term1:=ab1;

  matrixinversion(m,3);
  matrixmultiplication(b,c,3);
  matrixmultiplication1(ab,vel,3);
  term2:=ab1;

  matrixinversion(m,3);
  matrixmultiplication1(b,gra,3);
  term3:=ab1;

    for j:= 1 to max do
    begin
      accl[j]:=term1[j]+term2[j]-term3[j];
    end;

    for j:= 1 to max do
    begin
      k2[j]:=0.5*dt*accl[j];
    end;

{third, to get k3}
    theta1:=theta1+0.5*dt*(thetadot1+0.5*k1[1]);
    theta2:=theta2+0.5*dt*(thetadot2+0.5*k1[2]);
    theta3:=theta3+0.5*dt*(thetadot3+0.5*k1[3]);

    thetadot1:=thetadot1+k2[1];
    thetadot2:=thetadot2+k2[2];
    thetadot3:=thetadot3+k2[3];

  m[1,1]:=I1+m1*sqr(a1)+I2+m2*(sqr(l1)+sqr(a2)+2*l1*a2*cos(theta2))+I3+m3*(sqr(l1)+sqr(l2)+sqr(a3)+2*l1*l2*cos(theta2)+2*l2*a3*cos(theta3)+2*l1*a3*cos(theta3-theta2));
  m[1,2]:=-I2-m2*(sqr(a2)+l1*a2*cos(theta2))-I3-m3*(sqr(l2)-sqr(a3)-l1*l2*cos(theta2)-2*l2*a3*cos(theta3)-l1*a3*cos(theta3-theta2));
  m[1,3]:=I3+m3*(sqr(a3)-l2*a3*cos(theta3)+l1*a3*cos(theta3-theta2));

  m[2,1]:=-I2-m2*(sqr(a2)+l1*a2*cos(theta2))-I3-m3*(sqr(l2)+sqr(a3)+l1*l2*cos(theta2)+2*l2*a3*cos(theta3)+l1*a3*cos(theta3-theta2));
  m[2,2]:=I2+m2*sqr(a2)+I3+m3*(sqr(l2)+sqr(a3)+2*l2*a3*cos(theta3));
  m[2,3]:=-I3-m3*(sqr(a3)+l2*a3*cos(theta3));

  m[3,1]:=I3+m3*(sqr(a3)+l2*a3*cos(theta3)+l1*a3*cos(theta3-theta2));
  m[3,2]:=-I3-m3*(sqr(a3)+l2*a3*cos(theta3));
  m[3,3]:=I3+m3*sqr(a3);


  c[1,1]:=0;
  c[1,2]:=0;
  c[1,3]:=0;

  c[2,1]:=-m2*l1*a2*thetadot1*sin(theta2)-m3*l1*l2*thetadot1*sin(theta2)+m3*l1*a3*thetadot1*sin(theta3-theta2);
  c[2,2]:=m2*l1*a2*thetadot1*sin(theta2)+m3*l1*a3*thetadot1*sin(theta3-theta2)+m3*l1*l2*thetadot1*sin(theta2);
  c[2,3]:=m3*l1*a3*thetadot1*sin(theta3-theta2);

  c[3,1]:=m2*l2*a3*(2*thetadot2-thetadot1)*sin(theta3)-m3*l1*a3*thetadot1*sin(theta3-theta2);
  c[3,2]:=-m2*l2*a3*thetadot2*sin(theta3)+m3*l1*a3*thetadot1*sin(theta3-theta2);
  c[3,3]:=m2*l2*a3*(thetadot2-thetadot1)*sin(theta3)-m3*l1*a3*thetadot1*sin(theta3-theta2);

  gra[1]:=m1*g1*a1*sin(theta1)+m2*g1*(l1*sin(theta1)-a2*sin(theta2-theta1))+m3*g1*(l1*sin(theta1)-l2*sin(theta2-theta1)+a3*sin(theta1-theta2+theta3));
  gra[2]:=m2*g1*a2*sin(theta2-theta1)+m3*g1*(l2*sin(theta2-theta1)-a3*sin(theta1-theta2+theta3));
  gra[3]:=m3*g1*a3*sin(theta1-theta2+theta3);


  {solving motion equations}
  matrixinversion(m,3);
  matrixmultiplication1(b,torque,3);
  term1:=ab1;

  matrixinversion(m,3);
  matrixmultiplication(b,c,3);
  matrixmultiplication1(ab,vel,3);
  term2:=ab1;

  matrixinversion(m,3);
  matrixmultiplication1(b,gra,3);
  term3:=ab1;

    for j:= 1 to max do
    begin
      accl[j]:=term1[j]+term2[j]-term3[j];
    end;

    for j:= 1 to max do
    begin
      k3[j]:=0.5*dt*accl[j];
    end;


{fourth, to get k4}

    theta1:=theta1+dt*(thetadot1+k3[1]);
    theta2:=theta2+dt*(thetadot2+k3[2]);
    theta3:=theta3+dt*(thetadot3+k3[3]);

    thetadot1:=thetadot1+2*k3[1];
    thetadot2:=thetadot2+2*k3[2];
    thetadot3:=thetadot3+2*k3[3];

   m[1,1]:=I1+m1*sqr(a1)+I2+m2*(sqr(l1)+sqr(a2)+2*l1*a2*cos(theta2))+I3+m3*(sqr(l1)+sqr(l2)+sqr(a3)+2*l1*l2*cos(theta2)+2*l2*a3*cos(theta3)+2*l1*a3*cos(theta3-theta2));
  m[1,2]:=-I2-m2*(sqr(a2)+l1*a2*cos(theta2))-I3-m3*(sqr(l2)-sqr(a3)-l1*l2*cos(theta2)-2*l2*a3*cos(theta3)-l1*a3*cos(theta3-theta2));
  m[1,3]:=I3+m3*(sqr(a3)-l2*a3*cos(theta3)+l1*a3*cos(theta3-theta2));

  m[2,1]:=-I2-m2*(sqr(a2)+l1*a2*cos(theta2))-I3-m3*(sqr(l2)+sqr(a3)+l1*l2*cos(theta2)+2*l2*a3*cos(theta3)+l1*a3*cos(theta3-theta2));
  m[2,2]:=I2+m2*sqr(a2)+I3+m3*(sqr(l2)+sqr(a3)+2*l2*a3*cos(theta3));
  m[2,3]:=-I3-m3*(sqr(a3)+l2*a3*cos(theta3));

  m[3,1]:=I3+m3*(sqr(a3)+l2*a3*cos(theta3)+l1*a3*cos(theta3-theta2));
  m[3,2]:=-I3-m3*(sqr(a3)+l2*a3*cos(theta3));
  m[3,3]:=I3+m3*sqr(a3);


  c[1,1]:=0;
  c[1,2]:=0;
  c[1,3]:=0;

  c[2,1]:=-m2*l1*a2*thetadot1*sin(theta2)-m3*l1*l2*thetadot1*sin(theta2)+m3*l1*a3*thetadot1*sin(theta3-theta2);
  c[2,2]:=m2*l1*a2*thetadot1*sin(theta2)+m3*l1*a3*thetadot1*sin(theta3-theta2)+m3*l1*l2*thetadot1*sin(theta2);
  c[2,3]:=m3*l1*a3*thetadot1*sin(theta3-theta2);

  c[3,1]:=m2*l2*a3*(2*thetadot2-thetadot1)*sin(theta3)-m3*l1*a3*thetadot1*sin(theta3-theta2);
  c[3,2]:=-m2*l2*a3*thetadot2*sin(theta3)+m3*l1*a3*thetadot1*sin(theta3-theta2);
  c[3,3]:=m2*l2*a3*(thetadot2-thetadot1)*sin(theta3)-m3*l1*a3*thetadot1*sin(theta3-theta2);

  gra[1]:=m1*g1*a1*sin(theta1)+m2*g1*(l1*sin(theta1)-a2*sin(theta2-theta1))+m3*g1*(l1*sin(theta1)-l2*sin(theta2-theta1)+a3*sin(theta1-theta2+theta3));
  gra[2]:=m2*g1*a2*sin(theta2-theta1)+m3*g1*(l2*sin(theta2-theta1)-a3*sin(theta1-theta2+theta3));
  gra[3]:=m3*g1*a3*sin(theta1-theta2+theta3);

  {solving motion equations}
  matrixinversion(m,3);
  matrixmultiplication1(b,torque,3);
  term1:=ab1;

  matrixinversion(m,3);
  matrixmultiplication(b,c,3);
  matrixmultiplication1(ab,vel,3);
  term2:=ab1;

  matrixinversion(m,3);
  matrixmultiplication1(b,gra,3);
  term3:=ab1;


    for j:= 1 to max do
    begin
      accl[j]:=term1[j]+term2[j]-term3[j];
    end;

    for j:= 1 to max do
    begin
      k4[j]:=0.5*dt*accl[j];
    end;

    for j:= 1 to max do
    begin
      angle[j]:=angle[j]+dt*(vel[j]+1/3*(k1[j]+k2[j]+k3[j]));
    end;

    for j:= 1 to max do
    begin
      vel[j]:=vel[j]+1/3*(k1[j]+2*k2[j]+2*k3[j]+k4[j]);
    end;

    theta1:=angle[1];
    theta2:=angle[2];
    theta3:=angle[3];

    thetadot1:=vel[1];
    thetadot2:=vel[2];
    thetadot3:=vel[3];

    thetadotdot1:=accl[1];
    thetadotdot2:=accl[2];
    thetadotdot3:=accl[3];

    t:=t+dt;
  end;
  counter := counter+1;
  edit4.Text:= inttostr(counter);
  time := time+0.01;
  time1[counter]:=time;
  hip[counter]:=theta1*180/pi;
  knee[counter]:=theta2*180/pi;
  ankle[counter]:=theta3*180/pi;
  {listbox1.Items.Add(floattostr(hip[counter]));
  listbox2.Items.Add(floattostr(knee[counter]));
  listbox3.Items.Add(floattostr(ankle[counter]));}
  if radiobutton1.Checked = true then
    begin
       gambar(theta1,theta2,theta3);
    end;
  if radiobutton2.Checked = true then
    begin
       gambarduduk(theta1, theta2, theta3);
    end;
end;


end.

