# ConnectClass

ジェネリクスを利用し、後から参照するクラス型を指定可能な汎用クラスを定義する方法。

例として、双方向リストのようなクラスを定義してみる。なお、この手法には Interface 実装が必須となる。
```pascal
var
   H :IMyHead;
   K :IMyKnot;
   T :IMyTail;
begin
     H := TMyHead.Create( 'TMyHead' );
     K := TMyKnot.Create( 'TMyKnot' );
     T := TMyTail.Create( 'TMyTail' );

     //  [Head]<Next>
     //     ↑    ↓
     //  <Prev>[Knot]<Next>
     //           ↑    ↓
     //        <Prev>[Tail]
     H.Next := K;
     K.Prev := H;  K.Next := T;
                   T.Prev := K;
end;
```

## MYX.Connect1
ジェネリクスではないクラスとして、単純に `Prev`/`Next` プロパティを持つクラス `TItem` を定義する。
なお、同時にインタフェース `IItem` も定義し、クラス側のフィールドにもインタフェース型を用いる。
```pascal
     IItem = interface
       ///// アクセス
       function GetPrev :IItem;
       procedure SetPrev( Prev_:IItem );
       function GetNext :IItem;
       procedure SetNext( Next_:IItem );
       ///// プロパティ
       property Prev :IItem read GetPrev write SetPrev;
       property Next :IItem read GetNext write SetNext;
     end;
```
```pascal
     TItem = class( TInterfacedObject, IItem )
     private
       _Prev :IItem;
       _Next :IItem;
     protected
       ///// アクセス
       function GetPrev :IItem;
       procedure SetPrev( Prev_:IItem );
       function GetNext :IItem;
       procedure SetNext( Next_:IItem );
     public
       ///// プロパティ
       property Prev :IItem read GetPrev write SetPrev;
       property Next :IItem read GetNext write SetNext;
     end;
```

## MYX.Connect2
プロパティをキャストするジェネリクスクラス `TItem<P,N>` を定義する（以降`キャストクラス`と呼称）。
```pascal
     TItem<_TPrev_,_TNext_:IItem> = class( TItem, IItem )
     private
     protected
       ///// アクセス
       function GetPrev :_TPrev_;
       procedure SetPrev( Prev_:_TPrev_ );
       function GetNext :_TNext_;
       procedure SetNext( Next_:_TNext_ );
     public
       ///// プロパティ
       property Prev :_TPrev_ read GetPrev write SetPrev;
       property Next :_TNext_ read GetNext write SetNext;
     end;
```

## MYX.Connect3
キャストクラス `TItem<P,N>` は自由に継承することができるが、共にインタフェース `IItem` も更新していく。
```pascal
     IMyItem = interface( IItem )
       ///// アクセス
       function GetName :String;
       ///// プロパティ
       property Name :String read GetName;
     end;
```
```pascal
     TMyItem<_TPrev_,_TNext_:IMyItem> = class( TItem<_TPrev_,_TNext_>, IMyItem )
     private
     protected
       _Name :String;
       ///// アクセス
       function GetName :String;
     public
       constructor Create( const Name_:String );
       ///// プロパティ
       property Name :String read GetName;
     end;
```

## MYX.Connect4
最終的に利用する際には、キャストクラス `TMyItem<P,N>` に参照させたいクラス型を指定し、単純なクラス型へ落とし込む。
```pascal
     IMyHead = interface;
     IMyKnot = interface;
     IMyTail = interface;
```
```pascal
     IMyHead = interface( IMyItem )
       ///// アクセス
       function GetNext :IMyKnot;  procedure SetNext( Next_:IMyKnot );
       ///// プロパティ
       property Next  :IMyKnot read GetNext write SetNext;
       property NameH :String  read GetName;
     end;

     IMyKnot = interface( IMyItem )
       ///// アクセス
       function GetPrev :IMyHead;  procedure SetPrev( Prev_:IMyHead );
       function GetNext :IMyTail;  procedure SetNext( Next_:IMyTail );
       ///// プロパティ
       property Prev  :IMyHead read GetPrev write SetPrev;
       property Next  :IMyTail read GetNext write SetNext;
       property NameK :String  read GetName;
     end;

     IMyTail = interface( IMyItem )
       ///// アクセス
       function GetPrev :IMyKnot;  procedure SetPrev( Prev_:IMyKnot );
       ///// プロパティ
       property Prev  :IMyKnot read GetPrev write SetPrev;
       property NameT :String  read GetName;
     end;
```
```pascal
     TMyHead = class( TMyItem<IMyHead,IMyKnot>, IMyHead )
     public
       ///// プロパティ
       property NameH :String read GetName;
     end;

     TMyKnot = class( TMyItem<IMyHead,IMyTail>, IMyKnot )
     public
       ///// プロパティ
       property NameK :String read GetName;
     end;

     TMyTail = class( TMyItem<IMyKnot,IMyItem>, IMyTail )
     public
       ///// プロパティ
       property NameT :String read GetName;
     end;
```
