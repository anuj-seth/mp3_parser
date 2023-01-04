with Ada.Streams;
with Interfaces;

package Mp3_Header is
   type ID3_v2 is private;
   procedure Dump (Header : ID3_v2);
   procedure Read_Header (Stream : not null access Ada.Streams.Root_Stream_Type'Class;
                          Item : out ID3_v2);

private
   type Bit is mod 2 ** 1;
   type Byte is mod 2**8;

   type ID3_Version is
      record
         Major : Byte;
         Minor : Byte;
      end record;

   type ID3_Flags is
      record
         Unsynchronisation : Boolean;
         Extended_Header : Boolean;
         Experimental_Indicator : Boolean;
      end record;

   type ID3_Size is array (1 .. 4) of Byte;

   type ID3_v2 is
      record
         File_Identifier : String (1 .. 3);
         Version         : ID3_Version;
         Flags           : ID3_Flags;
         Size            : Interfaces.Unsigned_32;
      end record;
   for ID3_v2'Read use Read_Header;

end Mp3_Header;
