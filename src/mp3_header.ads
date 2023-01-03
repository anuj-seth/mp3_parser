with Ada.Streams;

package Mp3_Header is
   type ID3_v2 is private;
   procedure Dump (Header : ID3_v2);
   procedure Read (Stream : not null access Ada.Streams.Root_Stream_Type'Class;
                   Item : out ID3_v2);

private
   type Bit is mod 2 ** 1
      with Size => 1;
   type Byte is mod 2**8
      with Size => 8;

   type ID3_Version is array (1 .. 2) of Byte
      with Component_Size => 8;
   

   type ID3_Flags is
      record
         Unsynchronisation : Boolean;
         Extended_Header : Boolean;
         Experimental_Indicator : Boolean;
      end record; 
   for ID3_Flags use 
      record
         --Unused_Bit_0 at 0 range 0 .. 0;
         --Unused_Bit_1 at 0 range 1 .. 1;
         --Unused_Bit_2 at 0 range 2 .. 2;
         --Unused_Bit_3 at 0 range 3 .. 3;
         --Unused_Bit_4 at 0 range 4 .. 4;
         Experimental_Indicator at 0 range 5 .. 5;
         Extended_Header at 0 range 6 .. 6;
         Unsynchronisation at 0 range 7 .. 7;
      end record;
   for ID3_Flags'Object_Size use 8; 
   for ID3_Flags'Alignment use 1;

   type ID3_Size is array (1 .. 4) of Byte
      with Component_Size => 8;

   type ID3_v2 is
      record
         File_Identifier : String (1 .. 3);
         Version         : ID3_Version;
         Flags           : ID3_Flags;
         Size            : ID3_Size;
      end record;

   for ID3_v2 use
      record
        File_Identifier at 0 range 0 .. 23;
        Version at 3 range 0 .. 15;
        Flags at 5 range 0 .. 7;
        Size at 6 range 0 .. 31;
   end record;
   for ID3_v2'Size use 80;
   for ID3_v2'Alignment use 1;
   for ID3_v2'Read use Read;

end Mp3_Header;




