# AGS Script Module Stack Extension Guide
by monkey0506

*NOTE:* This guide is intended for use by **advanced users** only. The use of this guide is not
recommended if you do not understand what you are doing. It is intended to expose the necessary
measures to extend the functionality of the Stack module. Any changes are subject to limited/no
support by the original module author.

## Table of Contents

* [Introduction](#introduction)
* [Register the data type](#register-the-data-type)
* [Converting the data](#converting-the-data)
  * [Built-in types](#built-in-types)
  * [Custom types](#custom-types)
* [Pushing and Popping the stack](#pushing-and-popping-the-stack)
* [Converting the data back](#converting-the-data-back)
  * [Built-in types](#built-in-types-1)
  * [Custom types](#custom-types-1)
* [Bringing it all together](#bringing-it-all-together)
  * [Built-in types](#built-in-types-2)
  * [Custom types](#custom-types-2)
* [Conclusion](#conclusion)
* [Changelog](#changelog)

# Introduction:

This guide is compatible with both built-in and custom data types. Note however that all data must
be available in either `int`, `float`, or `String` format. Further, anything requiring a persistent
pointer, such as `DynamicSprite`s or `Overlay`s will not work. With that said, this guide is
designed to indicate exactly what needs to be done to support a new data type not included in the
original module. Upon request, official support for any built-in types may be added.

# Register the data type

This is simple enough. All of the data types must be registered with a unique type identifier in
order for the end-user to know what type of data they are actually dealing with. The way this is
done is simply by adding an entry to the `StackDataType` enumeration in *Stack.ash*. For example if
we were going to add the `Hotspot` type, we could do this:

    enum StackDataType {
      // all of our other types
      eStackDataHotspot = 'h'
    };

Just to reiterate, the identifier must be **unique** or the user won't be able to tell what type of
data they are actually working with.

*NOTE:* The `StackDataType` enumeration can **only** accept a *char* as a value. That is, you may
assign it a character-literal value, as the supplied types do, or you may supply it an integer
value in the range of (0-255). The module is not equipped to detect types outside of these
parameters and will not function as intended, possibly inducing freezing/crashing of your game.

## Built-in types

All of the module's data is converted to `StackData` in order to be pushed onto the stack. The
`StackData` type is internally just defined as a synonym for the `String` type. Note that it does
store other data, so you don't want to read it as a `String` normally, but we `can` use `String`
functions. We need to format our data very specifically. The format it should take is
**[TYPE][DATA]**. For `TYPE` we are going to use a local variable of the *Stack.asc* script,
`StackDataFormat`. `DATA` will be the `Hotspot.ID`. So we could do it like this:

    // Stack.ash
    // within the Stack struct
      import static StackData HotspotToData(Hotspot *theHotspot);

    // Stack.asc
    static StackData Stack::HotspotToData() {
      StackData type = StackData.Format(StackDataFormat, eStackDataHotspot);
      return StackData.Format("%s%d", type, theHotspot.ID);
    }

That returns the properly formatted `StackData` with the data type and the data included. If you
wanted to implement the same function for a custom type, it would have to work a bit differently.

## Custom types

If you want to use a custom data type, you'll also be responsible for writing your own custom
conversion function. The `StackData` object should still conform to the same standard, however
you're pretty free to add whatever actual data you want:

    // Stack.ash
    enum StackDataType {
      // all of our other types
      eStackDataCharacterStat = 'x'
    };

    // Stack.asc
    export StackDataFormat; // we need to borrow this in our other script

    // CharacterStats.ash (just an example)
    struct CharacterStats { // an example struct
      int HP;
      int MP;
      int XP;
      import StackData ToStackData(); // our custom conversion function
    };

    // CharacterStats.asc
    import StackDataFormat; // grab this from Stack.asc
    
    StackData CharacterStats::ToStackData() {
      StackData type = StackData.Format(StackDataFormat, eStackDataCharacterStat);
      return StackData.Format("%s%d,%d,%d", type, this.HP, this.MP, this.XP);
    }

As you can see, we can format more than one variable into the `StackData` object, but it must still
take the format of **[TYPE][DATA]**.

# Pushing and Popping the stack

Once your type has been registered and you've converted your data into the `StackData` type, the
*Stack.Push* and *Stack.Pop* functions should now work normally as expected. No further action is
required for these functions to operate once the data is converted.

## Built-in types

Converting the data back to its original data type is fairly straight-forward at this point:

  // Stack.ash
  import Hotspot* GetAsHotspot(this StackData*);

  // Stack.asc
  Hotspot* GetAsHotspot(this StackData*) {
    StackData data = this.Substring(StackDataFormat.Length - 1, this.Length);
    StackDataType type = data.GetType();
    if ((data.AsInt < 0) || (data.AsInt >= AGS_MAX_HOTSPOTS) ||
    (((type != eStackDataHotspot) && (eStackStrictTypes)) || (type == eStackDataStack)) return null;
    return hotspot[data.AsInt];
  }

## Custom types

For a custom data type you're going to have to come up with your own method of deciphering the data
you fed into the `StackData` object previously, but based on our prior example we could now do
this:

    // CharacterStats.ash
    struct CharacterStats {
      // ...
      import bool LoadFromStackData(StackData data);
    }
    
    bool CharacterStats::LoadFromStackData(StackData data) {
      if ((data == null) || (data.GetType() != eStackDataCharacterStat)) return false;
      data = data.Substring(StackDataFormat.Length - 1, data.Length);
      StackData buffer = data.Substring(0, data.IndexOf(","));
      this.HP = buffer.AsInt;
      data = data.Substring(buffer.Length + 1, data.Length);
      buffer = data.Substring(0, data.IndexOf(","));
      this.MP = buffer.AsInt;
      data = data.Substring(buffer.Length + 1, data.Length);
      this.XP = data.AsInt;
      return true;
    }

# Bringing it all together

## Built-in types

    // Stack.ash
    enum StackDataType {
      // all of our other types
      eStackDataHotspot = 'h'
    };
    
    struct Stack {
      // ...
      import static StackData HotspotToData(Hotspot *theHotspot);
    };
    
    import Hotspot* GetAsHotspot(this StackData*);

    // Stack.asc
    static StackData Stack::HotspotToData() {
      StackData type = StackData.Format(StackDataFormat, eStackDataHotspot);
      return StackData.Format("%s%d", type, theHotspot.ID);
    }
    
    Hotspot* GetAsHotspot(this StackData*) {
      StackData data = this.Substring(StackDataFormat.Length - 1, this.Length);
      StackDataType type = data.GetType();
      if ((data.AsInt < 0) || (data.AsInt >= AGS_MAX_HOTSPOTS) ||
      (((type != eStackDataHotspot) && (eStackStrictTypes)) || (type == eStackDataStack)) return null;
      return hotspot[data.AsInt];
    }

    // ExampleScript.asc
    Stack mystack;
    mystack.Push(Stack.HotspotToData(hotspot[5]));
    // ...
    StackData data = mystack.Pop();
    Hotspot *theHotspot = data.GetAsHotspot();

## Custom types

    // Stack.ash
    enum StackDataType {
      // all of our other types
      eStackDataCharacterStat = 'x'
    };

    // Stack.asc
    export StackDataFormat; // we need to borrow this in our other script

    // CharacterStats.ash
    struct CharacterStats { // an example struct
      int HP;
      int MP;
      int XP;
      import StackData ToStackData(); // our custom conversion function
      import bool LoadFromStackData(StackData data);
    };

    // CharacterStats.asc
    import StackDataFormat; // grab this from Stack.asc

    StackData CharacterStats::ToStackData() {
      StackData type = StackData.Format(StackDataFormat, eStackDataCharacterStat);
      return StackData.Format("%s%d,%d,%d", type, this.HP, this.MP, this.XP);
    }
    
    bool CharacterStats::LoadFromStackData(StackData data) {
      if ((data == null) || (data.GetType() != eStackDataCharacterStat)) return false;
      data = data.Substring(StackDataFormat.Length - 1, data.Length);
      StackData buffer = data.Substring(0, data.IndexOf(","));
      this.HP = buffer.AsInt;
      data = data.Substring(buffer.Length + 1, data.Length);
      buffer = data.Substring(0, data.IndexOf(","));
      this.MP = buffer.AsInt;
      data = data.Substring(buffer.Length + 1, data.Length);
      this.XP = data.AsInt;
      return true;
    }

    // ExampleScript.asc
    CharacterStats playerStats;
    playerStats.HP = 100;
    playerStats.MP = 10;
    playerStats.XP = 0;
    // ...
    Stack mystack;
    mystack.Push(playerStats.ToStackData());
    // ...
    StackData data = mystack.Pop();
    playerStats.LoadFromStackData(data);

# Conclusion

With this you should now be fully equipped to extend the Stack module with new types, both built-in
and custom. If you have any questions don't hesitate to ask, you can always contact me at the AGS
Forums. As denoted in the introduction, limited support may be available if you are modifying the
module's code, however I will make an effort to help when and where I can.

# Changelog

- 21 March 2009, First public version.
