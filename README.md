# ConnectClass

ジェネリクスを利用し、後から参照するクラス型を指定可能な汎用クラスを定義する方法。

例として、双方向リストのような相互参照し合うクラスを定義してみる。なお、この手法には Interface 実装が必須となる。
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
もちろん、何度参照を行き来しても、それぞれのクラスが（キャストもせずに）直接参照できなくてはならない。
```
・H.Next = TMyKnot
・K.Prev = TMyHead
・K.Next = TMyTail
・T.Prev = TMyKnot
・H.Next.Prev = TMyHead
・H.Next.Next = TMyTail
・K.Prev.Next = TMyKnot
・K.Next.Prev = TMyKnot
・T.Prev.Prev = TMyHead
・T.Prev.Next = TMyTail
・H.Next.Prev.Next = TMyKnot
・H.Next.Next.Prev = TMyKnot
・K.Prev.Next.Prev = TMyHead
・K.Prev.Next.Next = TMyTail
・K.Next.Prev.Prev = TMyHead
・K.Next.Prev.Next = TMyTail
・T.Prev.Prev.Next = TMyKnot
・T.Prev.Next.Prev = TMyKnot
```

## MYX.Connect1.pas
ジェネリクスではないクラスとして、単純に `Prev`/`Next` プロパティを持つクラス `TItem` を定義する。
なお、同時にインタフェース `IItem` も定義し、クラス側のフィールドにもインタフェース型を用いる。
```pascal
     IItem = interface
       ///// アクセス
       function GetPrev :IItem;  procedure SetPrev( Prev_:IItem );
       function GetNext :IItem;  procedure SetNext( Next_:IItem );
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
       function GetPrev :IItem;  procedure SetPrev( Prev_:IItem );
       function GetNext :IItem;  procedure SetNext( Next_:IItem );
     public
       ///// プロパティ
       property Prev :IItem read GetPrev write SetPrev;
       property Next :IItem read GetNext write SetNext;
     end;
```

## MYX.Connect2.pas
プロパティをキャストするジェネリッククラス `TItem<P,N>` を定義する（以降`キャストクラス`と呼称）。
```pascal
     TItem<_TPrev_,_TNext_:IItem> = class( TItem, IItem )
     private
     protected
       ///// アクセス
       function GetPrev :_TPrev_;  procedure SetPrev( Prev_:_TPrev_ );
       function GetNext :_TNext_;  procedure SetNext( Next_:_TNext_ );
     public
       ///// プロパティ
       property Prev :_TPrev_ read GetPrev write SetPrev;
       property Next :_TNext_ read GetNext write SetNext;
     end;
```

## MYX.Connect3.pas
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

## MYX.Connect4.pas
最終的に利用する際には、キャストクラス `TMyItem<P,N>` に参照させたいクラス型を指定し、単純なクラス型へ落とし込む。
しかしその際、それぞれのクラスのインタフェースにおいて、相互参照するプロパティを再度定義し直す必要がある。
もっとも、対応するアクセサは、キャストクラス `TItem<P,N>` の 時点で実装済なので、クラス側での改めて実装し直す必要はない。
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
     TMyHead = class( TMyItem<TMyItem,IMyKnot>, IMyHead )
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

----
## 失敗例 1
そもそも初めからクラスをジェネリクス化しておけば、相互参照するクラスを定義可能である。
しかし、`_TPrev_`/`_TNext_` へは最終的に `TItem<_TPrev_,_TNext_>` 型が代入される予定にもかかわらず、型制約がないので、最も基本的な `TObject` 型と見なされてしまい、`TItem<_TPrev_,_TNext_>` クラス独自のプロパティやメソッドを利用することができない。
```pascal
     TItem<_TPrev_,_TNext_> = class
     private
       _Prev :_TPrev_;
       _Next :_TNext_;
     protected
       ///// アクセス
       function GetPrev :_TPrev_;  procedure SetPrev( Prev_:_TPrev_ );
       function GetNext :_TNext_;  procedure SetNext( Next_:_TNext_ );
     public
       ///// プロパティ
       property Prev :_TPrev_ read GetPrev write SetPrev;
       property Next :_TNext_ read GetNext write SetNext;
     end;
```

## 失敗例 2
型制約を導入するとしても、もちろん再帰定義になってしまうので、ジェネリッククラスが自分自身の型で制約することはできない。
```pascal
     TItem<_TPrev_,_TNext_:TItem<_TPrev_,_TNext_>> = class
     ～
     end;
```
そこで、ジェネリスク化されていないクラス `TItem` として一旦定義した上で、キャストクラス `TItem<P,N>` を作る必要性が出てくる。
```pascal
     TItem = class
     private
       _Prev :TItem;
       _Next :TItem;
     protected
       ///// アクセス
       function GetPrev :TItem;  procedure SetPrev( Prev_:TItem );
       function GetNext :TItem;  procedure SetNext( Next_:TItem );
     public
       ///// プロパティ
       property Prev :TItem read GetPrev write SetPrev;
       property Next :TItem read GetNext write SetNext;
     end;
```
```pascal
     TItem<_TPrev_,_TNext_:TItem> = class( TItem )
     protected
       ///// アクセス
       function GetPrev :_TPrev_;  procedure SetPrev( Prev_:_TPrev_ );
       function GetNext :_TNext_;  procedure SetNext( Next_:_TNext_ );
     public
       ///// プロパティ
       property Prev :_TPrev_ read GetPrev write SetPrev;
       property Next :_TNext_ read GetNext write SetNext;
     end;
```
しかしこの手法では、複数のクラスを相互参照させようとした場合、プロトタイプ宣言 `= class;` をした段階では、すべてのクラスが `TObject` 型と見なされているので、キャストクラスへ代入できなくなる。
```pascal
     TMyHead = class;
     TMyKnot = class;
     TMyTail = class;
```
```pascal
     TMyHead = class( TItem<TMyItem,TMyKnot> )
     end;
     
     TMyKnot = class( TItem<TMyHead,TMyTail> )
     end;
     
     TMyTail = class( TItem<TMyKnot,TMyItem> )
     end;
```
したがって最終的に **MYX.Connect1.pas** のように、インタフェースを使わざるを得なくなる。

## 失敗例 3
キャストクラスを作る際に、対となるキャストインタフェースもジェネリクス化しておくという手段も考えられる。
この手法が可能であれば、**MYX.Connect4.pas** において、インタフェース `IMyHead`/`IMyKnot`/`IMyTail` を作る必要もなくなる。
```pascal
     IItem<_TPrev_,_TNext_:IItem> = class( IItem )
       ///// アクセス
       function GetPrev :_TPrev_;  procedure SetPrev( Prev_:_TPrev_ );
       function GetNext :_TNext_;  procedure SetNext( Next_:_TNext_ );
       ///// プロパティ
       property Prev :_TPrev_ read GetPrev write SetPrev;
       property Next :_TNext_ read GetNext write SetNext;
     end;
```
```pascal
     TItem<_TPrev_,_TNext_:IItem> = class( TItem, IItem<_TPrev_,_TNext_> )
     protected
       ///// アクセス
       function GetPrev :_TPrev_;  procedure SetPrev( Prev_:_TPrev_ );
       function GetNext :_TNext_;  procedure SetNext( Next_:_TNext_ );
     public
       ///// プロパティ
       property Prev :_TPrev_ read GetPrev write SetPrev;
       property Next :_TNext_ read GetNext write SetNext;
     end;
```

しかしこの場合も、インタフェースのプロトタイプ宣言 `= interface;` 段階において、すべてのインタフェースが `IInterface` 型と見なされる問題により、キャストインタフェース `IItem<P,N>` へ代入することができなくなる。
```pascal
     IMyHead = interface;
     IMyKnot = interface;
     IMyTail = interface;
```
```pascal
     IMyHead = class( IItem<TMyItem,TMyKnot> )
     end;
     
     IMyKnot = class( IItem<TMyHead,TMyTail> )
     end;
     
     IMyTail = class( IItem<TMyKnot,TMyItem> )
     end;
```

----
[![Delphi Starter](http://img.en25.com/EloquaImages/clients/Embarcadero/%7B063f1eec-64a6-4c19-840f-9b59d407c914%7D_dx-starter-bn159.png)](https://www.embarcadero.com/jp/products/delphi/starter)
