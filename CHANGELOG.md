# Changelog

## Version 2.0

Version:     2.0  
Author:      monkey0506  
Date:        25 January 2015  
Description: Total rewrite of the module to take advantage of new features in AGS such as dynamic
arrays in structs and pointers to managed types. Includes several breaking changes to the interface
from v1.3, which is no longer supported. `StackData` is no longer a masked `String`, and is a
formal data type; `StackDataType` no longer defines its members with character values; support
removed for adding `Stack` objects within other `Stack`s; `StackData` functions have been replaced
by member properties such as `AsInt`, `AsFloat`, `AsString`, etc.; the `eStackStrictTypes` setting
has been removed, all types are now strongly enforced; static conversion functions to `StackData`
have been moved from `Stack` type to static `StackData` functions; `StackPopType` has been renamed
to `StackPopStyle`; *optional* `insert` parameter added to `Stack.Push`; parameters to `Stack.Pop`
have now been reversed for improved interface and matching `Stack.Push`; `Stack.IsEmpty`,
`Stack.Copy`, `Stack.LoadFromStack`, `Stack.LoadFromFile`, `Stack.GetItemsArray`,
`File.WriteStack`, and `File.ReadStackBack` have all been removed; added ability to change `Stack`
capacity; added `String` caching methods; and added specialized functions (`Stack.PushInt`, etc.)
for a simpler interface.

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
