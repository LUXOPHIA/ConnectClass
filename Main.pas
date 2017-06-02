unit Main;

interface //#################################################################### ■

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo,
  MYX.Connect4;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
  private
    { private 宣言 }
  public
    { public 宣言 }
  end;

var
  Form1: TForm1;

implementation //############################################################### ■

{$R *.fmx}

procedure TForm1.FormCreate(Sender: TObject);
var
   H :IMyHead;
   K :IMyKnot;
   T :IMyTail;
begin
     H := TMyHead.Create( 'TMyHead' );
     K := TMyKnot.Create( 'TMyKnot' );
     T := TMyTail.Create( 'TMyTail' );

     H.Next := K;
     K.Prev := H;
     K.Next := T;
     T.Prev := K;

     Memo1.Lines.Add( '・H = ' + H.NameH );
     Memo1.Lines.Add( '・K = ' + K.NameK );
     Memo1.Lines.Add( '・T = ' + T.NameT );

     Memo1.Lines.Add( '・H.Next = ' + H.Next.NameK );
     Memo1.Lines.Add( '・K.Prev = ' + K.Prev.NameH );
     Memo1.Lines.Add( '・K.Next = ' + K.Next.NameT );
     Memo1.Lines.Add( '・T.Prev = ' + T.Prev.NameK );

     Memo1.Lines.Add( '・H.Next.Prev = ' + H.Next.Prev.NameH );
     Memo1.Lines.Add( '・H.Next.Next = ' + H.Next.Next.NameT );
     Memo1.Lines.Add( '・K.Prev.Next = ' + K.Prev.Next.NameK );
     Memo1.Lines.Add( '・K.Next.Prev = ' + K.Next.Prev.NameK );
     Memo1.Lines.Add( '・T.Prev.Prev = ' + T.Prev.Prev.NameH );
     Memo1.Lines.Add( '・T.Prev.Next = ' + T.Prev.Next.NameT );

     Memo1.Lines.Add( '・H.Next.Prev.Next = ' + H.Next.Prev.Next.NameK );
     Memo1.Lines.Add( '・H.Next.Next.Prev = ' + H.Next.Next.Prev.NameK );
     Memo1.Lines.Add( '・K.Prev.Next.Prev = ' + K.Prev.Next.Prev.NameH );
     Memo1.Lines.Add( '・K.Prev.Next.Next = ' + K.Prev.Next.Next.NameT );
     Memo1.Lines.Add( '・K.Next.Prev.Prev = ' + K.Next.Prev.Prev.NameH );
     Memo1.Lines.Add( '・K.Next.Prev.Next = ' + K.Next.Prev.Next.NameT );
     Memo1.Lines.Add( '・T.Prev.Prev.Next = ' + T.Prev.Prev.Next.NameK );
     Memo1.Lines.Add( '・T.Prev.Next.Prev = ' + T.Prev.Next.Prev.NameK );
end;

end. //######################################################################### ■

