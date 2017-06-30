/*******************************************\
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

#### Stack_VERSION_130

Defines version 1.3 of the module.

#### Stack_VERSION_120

Defines version 1.2 of the module.

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
- `eStackDataInvalid`: The object does not contain any valid StackData

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

#### Stack.GetItemsArray

`StackData[] Stack.GetItemsArray()`

Returns an array containing each of the items in the stack. The size of the array will be the same
as the [ItemCount](#stackitemcount). If `ItemCount` is 0, returns `null`.

*NOTE:* Since the stacks are all vectorized, it's not practical for this to be implemented as a
property. Doing so would require a static size specified for the size of the property. This method
allows you to get the items in a dynamic array without having to limit the number of items that can
be returned this way.

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

#### Stack.LoadFromFile

`void Stack.LoadFromFile(File *theFile)`

Attempts to read back a `Stack` object from `theFile`, and load it into this stack. If `theFile`
was not written by [File.WriteStack](#filewritestack) this will crash the game, just as the normal
`File` functions do.

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

---------

### File

#### File.WriteStack

`bool File.WriteStack(StackData stackCopy)`

Writes the stack data from `stackCopy` to the file. If `stackCopy` does not contain a valid stack,
or there is an error writing to the file, returns `false`.

#### File.ReadStackBack

`StackData File.ReadStackBack()`

Attempts to read back a `Stack` object from the file. If the file was not written by
[File.WriteStack](#filewritestack) this will crash the game, just as the normal `File` functions
do.

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

# Licensing

Permission is hereby granted, free of charge, to any person obtaining a copy of this script module
and associated documentation files (the "Module"), to deal in the Module without restriction,
including without limitation the rights to use, copy, modify, merge, publish, distribute,
sublicense, and/or sell copies of the Module, and to permit persons to whom the Module is furnished
to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or
substantial portions of the Module.

THE MODULE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE MODULE OR THE USE OR OTHER DEALINGS IN THE MODULE.

# Changelog

## Version 1.3

Version:     1.3  
Author:      monkey0506  
Date:        21 August 2009  
Description: Fixed bug with `String.Format` and large `Stack`s (`String.Format` has a limit on the
size of the `String` it can return; replaced where applicable with `String.Append` instead). Also
added further support to prevent issues with `Stack.Copy`. Previously if you pushed the same stack
copy onto a single stack multiple times there would be problems with the internal data structure.
This should resolve that.

## Version 1.2a

Version:     1.2a  
Author:      monkey0506  
Date:        29 March 2009  
Description: Fixed bug where `Stack.GetItemsArray` may request a 0-sized array.

## Version 1.2

Version:     1.2  
Author:      monkey0506  
Date:        28 March 2009  
Description: Added `Stack.GetItemsArray`, `File.WriteStack`, `File.ReadStackBack`, and
`Stack.LoadFromFile` functions. The module now exports `StackDataFormat` so it can be used by other
scripts for extending the module. It is not imported, it must be locally imported to the script
requiring it. Modified the way `Stack.Copy` formats the data to better prevent collisions. Fixed a
bug with `Stack.Push` where if you were adding an item at a specific index `ItemCount` was still
getting increased. Added data type `eStackDataInvalid` to indicate that the object is not valid
`StackData`. Included module information in the Properties pane for the script.

## Version 1.0

Version:     1.0  
Author:      monkey0506  
Date:        20 March 2009  
Description: First public release.   

\*******************************************/

#ifdef AGS_SUPPORTS_IFVER
  #ifver 3.1.2
    #define Stack_VERSION 1.3
    #define Stack_VERSION_130
    #define Stack_VERSION_120
    #define Stack_VERSION_100
  #endif
#endif
#ifndef Stack_VERSION
  #error Stack module error!: This module requires AGS v3.1.2 or higher! Please upgrade to a higher version of AGS to use this module!
#endif

managed struct StackData {}; // this is a virtual data type, for autocomplete purposes only
#define StackData String // $AUTOCOMPLETEIGNORE$
/*
 Our virtual struct 'StackData' is actually replaced by the built-in String type. All
 of the functions declared for our virtual type are technically being declared on the
 String type. However, autocomplete does not detect this so the connection is
 invisible to the end-user.
*/

enum StackDataType { // this defines the type of data actually stored
  eStackDataInt = 'i',
  eStackDataFloat = 'f',
  eStackDataString = 's',
  eStackDataCharacter = 'c',
  eStackDataInventoryItem = 'n',
  eStackDataGUI = 'g',
  eStackDataGUIControl = 't',
  eStackDataStack = 'k', // this actually indicates this data is a copy of another Stack, returned from Stack.Copy
  eStackDataInvalid = 0 // indicates the object is not valid StackData
};

///Stack module: Returns the integer value of this StackData object. Uses 'null' value of 0.
import int GetAsInt(this StackData*);
///Stack module: Returns the floating-point decimal value of this StackData object. Uses 'null' value of 0.0.
import float GetAsFloat(this StackData*);
///Stack module: Returns the String equivalent of this StackData object.
import String GetAsString(this StackData*);
/*
 IMPORTANT:
 
   Although 'StackData' is really just 'String', you should still use this function
   to get the String data. The module internally adds extra markers to track what
   type of data is being stored. This function will return the user-stored data.
*/
///Stack module: Returns the value of this StackData object as a Character.
import Character* GetAsCharacter(this StackData*);
///Stack module: Returns the value of this StackData object as an InventoryItem.
import InventoryItem* GetAsInventoryItem(this StackData*);
///Stack module: Returns the value of this StackData object as a GUI.
import GUI* GetAsGUI(this StackData*);
///Stack module: Returns the value of this StackData object as a GUIControl.
import GUIControl* GetAsGUIControl(this StackData*);
///Stack module: Returns the type of data stored in this StackData object.
import StackDataType GetType(this StackData*);

enum StackPopType { // specifies the order items are removed from the stack
  eStackPopFirstInLastOut = 0, // the first item pushed in will be the last popped out, default behavior
  eStackPopFirstInFirstOut, // the first item pushed in will be the first popped out
  eStackPopRandom, // all items are popped out in a random sequence
};

enum StackSettings {
  eStackStrictTypes = false // sets whether the module obeys data types (TRUE) or whether conversion is possible (FALSE)
};

struct Stack {
  ///Stack module: Returns a StackData object containing THEINT.
  import static StackData IntToData(int theInt); // $AUTOCOMPLETESTATICONLY$
  ///Stack module: Returns a StackData object containning THEFLOAT.
  import static StackData FloatToData(float theFloat); // $AUTOCOMPLETESTATICONLY$
  ///Stack module: Returns a StackData object containing THESTRING.
  import static StackData StringToData(String theString); // $AUTOCOMPLETESTATICONLY$
  ///Stack module: Returns a StackData object containing THECHARACTER.
  import static StackData CharacterToData(Character *theCharacter); // $AUTOCOMPLETESTATICONLY$
  ///Stack module: Returns a StackData object containing THEINVENTORYITEM.
  import static StackData InventoryItemToData(InventoryItem *theItem); // $AUTOCOMPLETESTATICONLY$
  ///Stack module: Returns a StackData object containing THEGUI.
  import static StackData GUIToData(GUI *theGUI); // $AUTOCOMPLETESTATICONLY$
  ///Stack module: Returns a StackData object containing THECONTROL.
  import static StackData GUIControlToData(GUIControl *theControl); // $AUTOCOMPLETESTATICONLY$
  protected StackData Data;
  ///Stack module: Gets/sets the order in which items are popped off the stack.
  StackPopType PopType;
  ///Stack module: Returns the number of items currently in the stack.
  writeprotected int ItemCount;
  ///Stack module: Pushes DATA onto the stack. You may alternately replace the item at INDEX.
  import bool Push(StackData data, int index=SCR_NO_VALUE);
  ///Stack module: Returns an item from the stack. You may optionally choose to leave the item in the stack and/or supply an alternate INDEX.
  import StackData Pop(bool remove=true, int index=SCR_NO_VALUE);
  ///Stack module: Clears all data stored in this stack.
  import void Clear();
  ///Stack module: Returns whether the stack is currently empty.
  import bool IsEmpty();
  ///Stack module: Returns a special StackData object containing a copy of this stack.
  import StackData Copy();
  ///Stack module: Replaces this stack's data with the data from OTHERSTACK. OTHERSTACK must have been formatted by Stack.Copy.
  import bool LoadFromStack(StackData otherStack);
  ///Stack module: Replaces this stack's data with the object saved in THEFILE.
  import void LoadFromFile(File *theFile);
};

///Stack module: Returns an array containing the items in the stack.
import StackData[] GetItemsArray(this Stack*); // since we are returning a dynamic array, we can't put this in the actual struct definition

///Stack module: Saves the stack data to the file.
import bool WriteStack(this File*, StackData stackCopy);
///Stack module: Attempts to read a stack object back from the file.
import StackData ReadStackBack(this File*);
