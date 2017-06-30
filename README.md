# Stack Script Module for AGS
by monkey0506

## Description

The Stack module introduces a vectorized stack type into which you can place any type of data.
Great if you need to store data of various different types, or all of one type; this module can
handle all of your data storage needs!

## Dependencies

AGS 3.4.0.3 (Alpha) or higher

## What's New

The Stack module v2.0 introduces some breaking API changes, so it can't be used to directly replace
v1.3, but there are some major improvements, and updating to the new version shouldn't be too much
of a hassle.

Previous versions of the Stack module relied on serializing all of your data into a `String` before
it could be stored in a `Stack`. This made the stacks extremely inefficient. Improvements to the
AGS engine have made it possible to keep track of your data with no added penalty to size in memory
while seeing huge boosts in speed.

With the new version there is no longer a requirement to use messy conversion operators before your
data can be added to a `Stack`. Special functions have been added to make this easier. You can also
now access items in the `Stack` directly (with no speed penalty), and convert them back into their
basic data type with a simpler interface. See the changelog for full list of changes.

## Macros (#define-s)

#### Stack_VERSION

Defines the current version of the module, formatted as a `float`.

#### Stack_VERSION_200

Defines version 2.0 of the module.

## Enumerated types

#### StackDataType

- `eStackDataInt`: The stored data is an int
- `eStackDataFloat`: The stored data is a float
- `eStackDataString`: The stored data is a String
- `eStackDataCharacter`: The stored data is a Character
- `eStackDataInventoryItem`: The stored data is an InventoryItem
- `eStackDataGUI`: The stored data is a GUI
- `eStackDataGUIControl`: The stored data is a GUIControl
- `eStackDataInvalid`: The object does not contain any valid StackData

#### StackPopStyle

- `eStackPopFirstInLastOut`: The first item pushed onto the stack will be the last item popped back
  out. This is the default setting for all stacks.
- `eStackPopFirstInFirstOut`: The first item pushed onto the stack will be the first item popped
  back out.
- `eStackPopRandom`: All items on the stack are popped out in random order.

## Functions and Properties

### StackData

#### StackData.AsType properties

##### StackData.AsCharacter

##### StackData.AsFloat

##### StackData.AsGUIControl

##### StackData.AsGUI

##### StackData.AsInt

##### StackData.AsInventoryItem

`Character* StackData.AsCharacter`  
`float StackData.AsFloat`  
`GUIControl* StackData.AsGUIControl`  
`GUI* StackData.AsGUI`  
`int StackData.AsInt`  
`InventoryItem* StackData.AsInventoryItem`  
`String StackData.AsString`

Returns the value represented by this `StackData`, or `null` (0 for `int` and `float`) if the [Type](#stackdatatype-2) does not match.

#### StackData.IsNullOrInvalid

`static bool StackData.IsNullOrInvalid(StackData)`

Returns whether the `StackData` object is `null` or invalid (type is `eStackDataInvalid`).

#### StackData.TypeToData functions

#### StackData.CharacterToData

##### StackData.FloatToData

##### StackData.GUIControlToData

##### StackData.GUIToData

##### StackData.IntToData

##### StackData.InventoryItemToData

##### StackData.StringToData

##### StackData.StringCachedToData

`static StackData StackData.CharacterToData(Character*)`  
`static StackData StackData.FloatToData(float)`  
`static StackData StackData.GUIControlToData(GUIControl*)`  
`static StackData StackData.GUIToData(GUI*)`  
`static StackData StackData.IntToData(int)`  
`static StackData StackData.InventoryItemToData(InventoryItem*)`  
`static StackData StackData.StringToData(String)`  
`static StackData StackData.StringCachedToData(int cacheID)`

Returns a StackData object holding the specified value.

#### StackData.Type

`StackDataType StackData.Type`

Returns the [type](#stackdatatype) of this data.

---------

### Stack

#### Stack.Capacity

`int Stack.Capacity`

Gets or sets the capacity of the `Stack`. May only be increased; maximum is 1000000. Setting the
capacity can prevent unnecessary copying at the cost of consuming more memory. For huge `Stack`s
this can make your code faster by a factor of as much as *six or seven times*, so you should
especially set this before adding several items at once.

*Example:*

    Stack stack;
    stack.Capacity = 512; // set the capacity first
    int i;
    for (i = 0; i < 500; i++)
    {
      stack.PushInt(i * 5); // add a bunch of integers
    }

#### Stack.Clear

`void Stack.Clear()`

Removes all items from a Stack.

#### Stack.GetStringCachedID

`static int Stack.GetStringCachedID(String)`

Returns a unique ID that matches the specified `String` in the internal cache. See
[Stack.StringCacheCapacity](#stackstringcachecapacity) for more details; you should use this when
using repeated `String` operations on Stacks.

*Example:*

    String text = "Hello World!";
    int textID = Stack.GetStringCachedID(text);
    // push 5 copies of TEXT onto a Stack
    Stack stack;
    int i;
    for (i = 0; i < 5; i++)
    {
      stack.PushStringCached(textID);
    }

#### Stack.Items

`StackData Stack.Items[int index]`

Gets or sets the item at `index` in the `Stack`. If reading an invalid `index`, an invalid
`StackData` object is returned; if setting an invalid `index`, nothing happens. This is used to
read or overwrite existing items only, it cannot append new items to the Stack; instead use
[Stack.Push](#stackpush) for that. Items are indexed from zero, up to
[Stack.ItemCount](#stackitemcount) - 1.

*Example:*

    Stack stack;
    stack.PushInt(5);
    stack.PushInt(10);
    stack.PushInt(15);
    Display("The second item is: %d", stack.Items[1].AsInt); // Displays 10
    stack.Items[1] = StackData.IntToData(42);
    Display("It is now: %d", stack.Items[i].AsInt); // Displays 42

#### Stack.ItemCount

readonly int Stack.ItemCount

Returns the number of items the `Stack` currently holds. This is one higher than the maximum valid
index for [Stack.Items](#stackitems).

*Example:*

    Stack stack;
    stack.PushInt(5);
    stack.PushInt(10);
    stack.PushInt(15);
    Display("The stack is holding %d items.", stack.ItemCount); // Displays 3

#### Stack.Pop

`StackData Stack.Pop(optional int index, optional bool remove)`

Pops a value from the `Stack`, or returns `null` on error. You may optionally specify an `index`,
or choose to leave the item on the `Stack`. Typically if you are not removing the item then you
would use the [Stack.Items](#stackitems) array instead. There are also specialized functions if you
know the type of data in the `Stack`.

*Example:*

    Stack stack;
    stack.PushInt(42);
    StackData item = stack.Pop();
    Display("Items in the stack: %d, popped item: %d", stack.ItemCount, item.AsInt); // Displays 0 and 42

#### Stack.PopStyle

`StackPopStyle Stack.PopStyle`

Gets or sets the order that items are popped from a `Stack` with the [Pop](#stackpop) functions.
The default is `eStackPopFirstInLastOut`.

*Example:*

    Stack stack;
    stack.PopStyle = eStackFirstInFirstOut; // sets the stack to FIFO mode

#### Stack.PopType functions

##### Stack.PopCharacter

##### Stack.PopFloat

##### Stack.PopGUI

##### Stack.PopGUIControl

##### Stack.PopInt

##### Stack.PopInventoryItem

##### Stack.PopString

`Character* Stack.PopCharacter(optional int index, optional bool remove)`  
`float Stack.PopFloat(optional int index, optional bool remove)`  
`GUI* Stack.PopGUI(optional int index, optional bool remove)`  
`GUIControl* Stack.PopGUIControl(optional int index, optional bool remove)`  
`int Stack.PopInt(optional int index, optional bool remove)`  
`InventoryItem* Stack.PopInventoryItem(optional int index, optional bool remove)`  
`String Stack.PopString(optional int index, optional bool remove)`

Specialized functions to pop an item off of a `Stack`, similar to [Stack.Pop](#stackpop).

*Note:* These functions do not leave the item on the `Stack` if the types do not match, so if you
are unsure of the type of data you are trying to retrieve, use `Stack.Pop` instead.

#### Stack.Push

`bool Stack.Push(StackData, optional int index, optional bool insert)`

Pushes the `StackData` object into the `Stack`, or returns `false` on error. You may *optionally*
specify the `index` for the item to be entered into the `Stack`, or overwrite an existing item.
You typically would only need this if you are moving an item from one `Stack` to another, and use
the specialized functions for general use.

*Example:*

    Stack stack;
    stack.Push(StackData.IntToData(5)); // UGLY! Use Stack.PushInt instead!
    Stack otherStack;
    otherStack.Push(stack.Pop()); // pop an item off one Stack and push it onto another

#### Stack.PushType functions

##### Stack.PushCharacter

##### Stack.PushFloat

##### Stack.PushGUI

##### Stack.PushGUIControl

##### Stack.PushInt

##### Stack.PushInventoryItem

##### Stack.PushString

`bool Stack.PushInt(int, optional int index, optional bool insert)`  
`bool Stack.PushFloat(float, optional int index, optional bool insert)`  
`bool Stack.PushString(String, optional int index, optional bool insert)`  
`bool Stack.PushCharacter(Character*, optional int index, optional bool insert)`  
`bool Stack.PushInventoryItem(InventoryItem*, optional int index, optional bool insert)`  
`bool Stack.PushGUI(GUI*, optional int index, optional bool insert)`  
`bool Stack.PushGUIControl(GUIControl, optional int index, optional bool insert)`  

Specialized methods to make pushing items onto a `Stack` easier.

*Note:* If you are pushing the same `String` to a `Stack` more than once, you may consider using
[Stack.PushStringCached](#stackpushstringcached) instead. See that function for more info.

*Example:*

    Stack stack;
    stack.PushInt(42);
    stack.PushFloat(3.1415);
    stack.PushString("Hello World!");

#### Stack.PushStringCached

`bool Stack.PushStringCached(int cachedID, optional int index, optional bool insert)`

Pushes a cached `String` onto the `Stack`. Due to certain technical restrictions in AGS, `String`
operations on `Stack`s may be slow. If you are pushing the same `String` onto a `Stack` more than
once, consider using this function instead as it is faster. You can use `Stack.GetStringCachedID`
to obtain the unique ID that this function uses as its first parameter. Also be sure to set
[Stack.StringCacheCapacity](#stackstringcachecapacity) as needed to boost performance when working
with `String`s.

*Note:* There is no penalty when popping `String`s off of a `Stack`, so there is no matching
`PopStringCached` function. The performance penalty occurs when converting the `String` into
`StackData`.

*Example:*

    String text = "Hello World!";
    int textID = Stack.GetStringCachedID(text);
    // push 5 copies of TEXT onto a Stack
    Stack stack;
    int i;
    for (i = 0; i < 5; i++)
    {
      stack.PushStringCached(textID);
    }

#### Stack.StringCacheCapacity

`static int Stack.StringCacheCapacity`

Gets or sets the capacity of the internal `String` cache. May only be increased; maximum value is
1000000. Due to technical restrictions in AGS, `String`s are pooled/cached globally when converted
to `StackData`. This may make `String` operations on `Stack`s slower than other types of data.
Setting a high capacity may improve speeds if you are doing a lot of `String` operations. You
should also use the *cached ID* (see [Stack.GetStringCachedID](#stackgetstringcachedid)) whenever
possible for this reason. Increasing this value will consume more memory though, so use some
discretion. Note that this value *will* automatically increase if needed.

*Example:*

    // game_start
    Stack.StringCacheCapacity = 512;
