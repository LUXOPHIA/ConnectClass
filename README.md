# ConnectClass

ジェネリックスを利用し、後から参照するクラス型を指定可能なクラスを定義する。

## TItem

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

     //-------------------------------------------------------------------------

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

## TItem<_TPrev_,_TNext_>

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

## TMyItem<_TPrev_,_TNext_>


```pascal
     IMyItem = interface( IItem )
       ///// アクセス
       function GetName :String;
       ///// プロパティ
       property Name :String read GetName;
     end;

     //-------------------------------------------------------------------------

     TMyItem<_TPrev_,_TNext_:IMyItem> = class( TItem<_TPrev_,_TNext_>, IMyItem )
     private
     protected
       _Name :String;
     public
       constructor Create( const Name_:String );
       ///// アクセス
       function GetName :String;
       ///// プロパティ
       property Name :String read GetName;
     end;
```

## TMyHead, TMyKnot, TMyTail

```pascal
     IMyHead = interface;
     IMyKnot = interface;
     IMyTail = interface;

     IMyHead = interface( IMyItem )
       ///// アクセス
       function GetNext :IMyKnot;  procedure SetNext( Next_:IMyKnot );
       ///// プロパティ
       property Next :IMyKnot read GetNext write SetNext;
     end;

     IMyKnot = interface( IMyItem )
       ///// アクセス
       function GetPrev :IMyHead;  procedure SetPrev( Prev_:IMyHead );
       function GetNext :IMyTail;  procedure SetNext( Next_:IMyTail );
       ///// プロパティ
       property Prev :IMyHead read GetPrev write SetPrev;
       property Next :IMyTail read GetNext write SetNext;
     end;

     IMyTail = interface( IMyItem )
       ///// アクセス
       function GetPrev :IMyKnot;  procedure SetPrev( Prev_:IMyKnot );
       ///// プロパティ
       property Prev :IMyKnot read GetPrev write SetPrev;
     end;

     //-------------------------------------------------------------------------

     TMyHead = class( TMyItem<IMyHead,IMyKnot>, IMyHead )
     end;

     TMyKnot = class( TMyItem<IMyHead,IMyTail>, IMyKnot )
     end;

     TMyTail = class( TMyItem<IMyKnot,IMyItem>, IMyTail )
     end;
```
