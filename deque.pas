program dequedemo;

procedure ExitWithError(message: string);
begin
    writeln(ErrOutput, message);
    halt(1)
end;

type
    LongItemPtr = ^LongItem;
    LongItem = record
        data: longint;
        prev, next: LongItemPtr;
    end;

    LongDeque = record
        first, last: LongItemPtr;
    end;

procedure LongDequeInit(var deque: LongDeque);
begin
    deque.first := nil;
    deque.last := nil
end;

procedure LongDequePushFront(var first, last: LongItemPtr; n: longint);
var
    tmp: LongItemPtr;
begin
    new(tmp);
    tmp^.data := n;
    tmp^.prev := nil;
    tmp^.next := first;
    if tmp^.next = nil then
        last := tmp
    else
        tmp^.next^.prev := tmp;
    first := tmp;
end;

procedure LongDequePushBack(var first, last: LongItemPtr; n: longint);
var
    tmp: LongItemPtr;
begin
    new(tmp);
    tmp^.data := n;
    tmp^.prev := last;
    tmp^.next := nil;
    if tmp^.prev = nil then
        first := tmp
    else
        tmp^.prev^.next := tmp;
    last := tmp;
end;

{ THE DEQUE MUST BE NOT EMPTY FOR THIS PROCEDURE CALL }
procedure LongDequePopFront(var first, last: LongItemPtr; var n: longint);
var
    tmp: LongItemPtr;
begin
    n := first^.data;
    tmp := first;
    first := first^.next;
    if first = nil then
        last := nil
    else
        first^.prev := nil;
    dispose(tmp)
end;

{ THE DEQUE MUST BE NOT EMPTY FOR THIS PROCEDURE CALL }
procedure LongDequePopBack(var first, last: LongItemPtr; var n: longint);
var
    tmp: LongItemPtr;
begin
    n := last^.data;
    tmp := last;
    last := last^.prev;
    if last = nil then
        first := nil
    else
        last^.next := nil;
    dispose(tmp)
end;

{ current after delete stores the invalid address }
procedure LongDequeDelete(var first, last, current: LongItemPtr);
begin
    if current^.prev = nil then
        first := current^.next
    else
        current^.prev^.next := current^.next;
    if current^.next = nil then
        last := current^.prev
    else
        current^.next^.prev := current^.prev;
    dispose(current);
end;

{ if there is no curr element than procedure will insert new one before first }
procedure LongDequeInsertAfter(var first, last, curr: LongItemPtr; n: longint);
var
    tmp: LongItemPtr;
begin
    new(tmp);
    tmp^.data := n;
    tmp^.prev := curr;
    if curr = nil then
        tmp^.next := first
    else
        tmp^.next := curr^.next;
    if tmp^.next = nil then
        last := tmp
    else
        tmp^.next^.prev := tmp;
    if tmp^.prev = nil then
        first := tmp
    else
        tmp^.prev^.next := tmp
end;

{ if there is no curr element than procedure will insert new one after last }
procedure LongDequeInsertBefore(var first, last, curr: LongItemPtr; n: longint);
var
    tmp: LongItemPtr;
begin
    new(tmp);
    tmp^.data := n;
    tmp^.next := curr;
    if curr = nil then
        tmp^.prev := last
    else
        tmp^.prev := curr^.prev;
    if tmp^.next = nil then
        last := tmp
    else
        tmp^.next^.prev := tmp;
    if tmp^.prev = nil then
        first := tmp
    else
        tmp^.prev^.next := tmp;
end;

function LongDequeIsEmpty(var deque: LongDeque): boolean;
begin
    LongDequeIsEmpty := (deque.first = nil) and (deque.last = nil);
end;

procedure PrintDeque(first, last: LongItemPtr);
var
    curr: LongItemPtr;
begin
    curr := first;
    while curr <> nil do begin
        writeln(curr^.data);
        curr := curr^.next
    end
end;

procedure ClearDeque(var deque: LongDeque);
var
    tmp: LongItemPtr;
begin
    while not LongDequeIsEmpty(deque) do begin
        tmp := deque.first;
        deque.first := deque.first^.next;
        if deque.first = nil then
            deque.last := nil;
        dispose(tmp)
    end
end;

var
    deque: LongDeque;
    n: longint;
begin
    {$I-}
    LongDequeInit(deque);
    while not SeekEof do begin
        read(n);
        if IOResult <> 0 then
            ExitWithError('Coldn''t read the longint value');
        LongDequePushBack(deque.first, deque.last, n)
    end;
    LongDequePopFront(deque.first, deque.last, n);
    LongDequePopBack(deque.first, deque.last, n);
    PrintDeque(deque.first, deque.last);
    ClearDeque(deque);
    PrintDeque(deque.first, deque.last)
end.
