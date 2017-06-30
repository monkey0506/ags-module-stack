# Stack Script Module for AGS
by monkey0506

## Description

The Stack module introduces a vectorized stack type into which you can place any type of data.
Great if you need to store data of various different types, or all of one type; this module can
handle all of your data storage needs!

## Foreword: About Stacks

You can think of a "stack" as a special sort of array. Just like an array can hold multiple
variables, so can a stack. The major differences are the fact that 1) these stacks are *vectorized*
and 2) they are *generic*. The stacks being *vectorized* means that you don't have to explicitly
state the size of the stack prior to using it. It will grow/shrink as needed. This is also great as
it optimizes the memory consumption. The fact that the stacks are *generic* means that they do not
abide to any single data type. You can "push" any type of data, from basic `int`s and `float`s to
`GUI`s and even other `Stack`s! You *do* have to convert your data when pushing it onto or popping
it off of the stack, but the conversion is simple. Below is the function list, after that there are
examples to put everything into perspective for you!

## Dependencies

AGS v3.1.2+

## Macros (#define-s)

#### Stack_VERSION

Defines the current version of the module, formatted as a `float`.

#### Stack_VERSION_100

Defines version 1.0 of the module.

## Enumerated types

#### StackDataType

- `eStackDataInt`: The stored data is an int
- `eStackDataFloat`: The stored data is a float
- `eStackDataString`: The stored data is a String
- `eStackDataCharacter`: The stored data is a Character
- `eStackDataInventoryItem`: The stored data is an InventoryItem
- `eStackDataGUI`: The stored data is a GUI
- `eStackDataGUIControl`: The stored data is a GUIControl
- `eStackDataStack`: The stored data is a Stack object

#### StackPopType

- `eStackPopFirstInLastOut`: The first item pushed onto the stack will be the last item popped back
  out. This is the default setting for all stacks.
- `eStackPopFirstInFirstOut`: The first item pushed onto the stack will be the first item popped
  back out.
- `eStackPopRandom`: All items on the stack are popped out in random order.

#### StackSettings

- `eStackStrictTypes`: Sets whether the module obeys data types (`true`) or whether conversions are
possible (`false`). The default value is `false`.

**NOTE:** Data of the type `eStackDataStack` will ignore this setting. Data of this type may only
be used/returned by functions which specifically state it in their description below. Conversion is
not possible for this type.

## Functions and Properties

### StackData

#### StackData.GetAsCharacter

`Character* StackData.GetAsCharacter()`

Returns this data as a `Character`.

#### StackData.GetAsFloat

`float StackData.GetAsFloat()`

Returns this data as a `float`. Uses 0 as a `null` value.

#### StackData.GetAsGUIControl

`GUIControl* StackData.GetAsGUIControl()`

Returns this data as a `GUIControl`.

#### StackData.GetAsGUI

`GUI* StackData.GetAsGUI()`

Returns this data as a `GUI`.

#### StackData.GetAsInt

`int StackData.GetAsInt()`

Returns this data as an `int`. Uses 0 as a `null` value.

#### StackData.GetAsInventoryItem

`InventoryItem* StackData.GetAsInventoryItem()`

Returns this data as an `InventoryItem`.

#### StackData.GetAsString

`String StackData.GetAsString()`

Returns this data as a `String`.

#### StackData.GetType

`StackDataType StackData.GetType()`

Returns the [type](#stackdatatype) of this data.

---------

### Stack

#### Stack.CharacterToData

`static StackData Stack.CharacterToData(Character *theCharacter)`

Returns a StackData object containing `theCharacter`.

#### Stack.Clear

`void Stack.Clear()`

Removes all items from the stack.

#### Stack.Copy

`StackData Stack.Copy()`

Produces a specially formatted `StackData` object which contains a *copy* of this stack. This
object can **only** be used with/by the following functions:
[StackData.GetType](#stackdatagetype), [Stack.Push](#stackpush), [Stack.Pop](#stackpop),
[Stack.LoadFromStack](#stackloadfromstack).

#### Stack.FloatToData

`static StackData Stack.FloatToData(float theFloat)`

Returns a StackData object containing `theFloat`.

#### Stack.GUIControlToData

`static StackData Stack.GUIControlToData(GUIControl *theControl)`

Returns a StackData object containing `theControl`.

#### Stack.GUIToData

`static StackData Stack.GUIToData(GUI *theGUI)`

Returns a StackData object containing `theGUI`.

#### Stack.IntToData

`static StackData Stack.IntToData(int theInt)`

Returns a StackData object containing `theInt`.

#### Stack.InventoryItemToData

`static StackData Stack.InventoryItemToData(InventoryItem *theItem)`

Returns a StackData object containing `theItem`.

#### Stack.IsEmpty

`bool Stack.IsEmpty()`

Returns whether the stack has **no** items in it.

#### Stack.ItemCount

`writeprotected int Stack.ItemCount`

Returns the number of items stored in the stack.

#### Stack.LoadFromStack

`bool Stack.LoadFromStack(StackData otherStack)`

Replaces this stack's data with the data from `otherStack`. `otherStack` must be a `StackData`
object which was formatted by [Stack.Copy](#stackcopy) for this function to operate. Returns
whether the data was successfully loaded.

#### Stack.Pop

`StackData Stack.Pop(optional bool remove, optional int index)`

Pops an item off the stack (the index is determined by the stack's [PopType](#stackpoptype-1)
setting). You may optionally choose whether or not to `remove` the item from the stack and/or
supply an alternate `index`. The data returned may be a `StackData` object of type
`eStackDataStack`. See the definition of this type and [Stack.Copy](#stackcopy) for further
information.

#### Stack.PopType

`StackPopType Stack.PopType`

Gets/sets the `StackPopType` for this stack, which controls the order in which items are popped off
the stack. The default setting for this is `eStackPopFirstInLastOut`.

#### Stack.Push

`bool Stack.Push(StackData data, optional int index)`

Pushes `data` onto the end of the stack. If `index` is provided, the item at that index in the
stack will be replaced with `data`. Returns whether the operation was successful. Rejects `null`
data and invalid indices. This function will accept `StackData` objects which have been formatted
by [Stack.Copy](#stackcopy).

#### Stack.StringToData

`static StackData Stack.StringToData(String theString)`

Returns a StackData object containing `theString`.

## Examples

This module is admittedly a bit intimidating, so here's a couple examples of how the scripts can be used.

### Stack definition

Here we'll just define a `Stack` to use with the rest of our examples.

     Stack mystack;
     mystack.PopType = eStackPopFirstInFirstOut; // pop the items out in the same order they are pushed in

We'll assume this definition for the rest of the examples.

### Pushing int data

Let's push some integers onto our stack, and pop them back out!
     
     mystack.Push(Stack.IntToData(351)); // note we must convert our ints to our generic StackData type
     mystack.Push(Stack.IntToData(493));
     mystack.Push(Stack.IntToData(826));
     Display("Our stack has %d items in it.", mystack.ItemCount);
     int i = 0;
     int size = mystack.ItemCount; // note that since we are popping items off our stack, it is shrinking. we must store its size first!
     while (i < size)
     {
       StackData data = mystack.Pop();
       Display("The item from %d is %d", i, data.GetAsInt()); // we must convert our data back to an int to display it
       i++;
     }
     Display("Our stack NOW has %d items in it.", mystack.ItemCount);
     
That will display the following:
     
     Our stack has 3 items in it.
     The item from 0 is 351.
     The item from 1 is 493.
     The item from 2 is 826.
     Our stack NOW has 0 items in it.

### Stacked stacks

Let's try pushing stacks onto each other!

     mystack.Push(Stack.StringToData("Hello World!"));
     mystack.Push(Stack.StringToData("This is the script."));
     mystack.Push(Stack.StringToData("Well, I've got to go."));
     mystack.Push(Stack.StringToData("Goodbye World."));
     Stack otherstack;
     StackData mystackCopy = mystack.Copy();
     otherstack.Push(mystackCopy); // we use Stack.Copy to push mystack onto otherstack
     Display("otherstack has %d item(s).", otherstack.ItemCount);
     
Displays:
     
     otherstack has 1 item(s).
     
*But wait! What I really wanted to do was just make `otherstack` a copy of the data in `mystack`.*

Don't worry, that's easy enough to fix!
     
     otherstack.Clear(); // removes all the items from otherstack (note this step is not necessary)
     otherstack.LoadFromStack(mystackCopy); // load from stack will now copy each element from mystackCopy into otherstack
     Display("otherstack NOW has %d item(s).", otherstack.ItemCount);
     
Displays:
     
     otherstack NOW has 4 item(s).

That's it for the example code. If you have any questions, comments, bug reports, etc. feel free to
contact me on the forums. For any bug reports, please post to the forum thread so everyone can be
notified!
