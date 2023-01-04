with Ada.Text_IO;

package body Mp3_Header is
   package S renames Ada.Streams;
   package TIO renames Ada.Text_IO;

   procedure Dump (Header : ID3_v2) is
   begin
      TIO.Put_Line ("File Identifier: " &
                Header.File_Identifier);
      TIO.Put_Line ("Major Version: " &
                Header.Version.Major'Image &
                " Minor Version: " &
                Header.Version.Minor'Image);
      TIO.Put_Line ("Flags Unsyncronisation: " &
                Header.Flags.Unsynchronisation'Image);
      TIO.Put_Line ("Flags Extended Header" &
                Header.Flags.Extended_Header'Image);
      TIO.Put_Line ("Flags experimental indicator" &
                Header.Flags.Experimental_Indicator'Image);
      TIO.Put_Line ("Size Byte #" &
                    Header.Size'Image);

      TIO.New_Line;
   end Dump;

   procedure Read_Header (Stream : not null access Ada.Streams.Root_Stream_Type'Class;
                          Item : out ID3_v2) is
      package IFS renames Interfaces;
      use type IFS.Unsigned_32;
      use type Ada.Streams.Stream_Element_Offset;

      subtype Bit_Number is Natural range 0 .. 8;
      function Is_Bit_Set (B : Byte; Bit : Bit_Number) return Boolean is
         ((B and 2**Bit) /= 0);

      Last : S.Stream_Element_Offset;
      Buffer : S.Stream_Element_Array (1 .. 10);
      B : Byte;
      Size_Byte : IFS.Unsigned_32;
      Size : IFS.Unsigned_32 := 0;
      Shift_By : Natural;
   begin
      Stream.Read (Buffer, Last);
      Item.File_Identifier (1) := Character'Val (Buffer (1));
      Item.File_Identifier (2) := Character'Val (Buffer (2));
      Item.File_Identifier (3) := Character'Val (Buffer (3));

      Item.Version.Major := Byte (Buffer (4));
      Item.Version.Minor := Byte (Buffer (5));

      TIO.Put ("FLAGS " & Buffer (6)'Image);
      B := Byte (Buffer (6));
      Item.Flags.Unsynchronisation := Is_Bit_Set (B, 8);
      Item.Flags.Extended_Header := Is_Bit_Set (B, 7);
      Item.Flags.Experimental_Indicator := Is_Bit_Set (B, 6);

      for Idx in Buffer'Last - 3 .. Buffer'Last loop
         Shift_By := Natural (8 * (Buffer'Last - Idx));
         Size_Byte := IFS.Unsigned_32 (Buffer (Idx));
         Size := Size + IFS.Shift_Left (Size_Byte, Shift_By);
      end loop;
      Item.Size := Size;
      TIO.Put_Line ("Stream object size" & S.Stream_Element'Object_Size'Image);
   end Read_Header;

end Mp3_Header;
