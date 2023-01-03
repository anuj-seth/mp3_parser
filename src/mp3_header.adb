with Ada.Text_IO;
with Ada.Streams;

package body Mp3_Header is
   package S renames Ada.Streams;
   procedure Dump (Header : ID3_v2) is
      use Ada.Text_IO;
   begin
      Put_Line ("File Identifier: " &
                Header.File_Identifier);
      Put_Line ("Major Version: " &
                Header.Version (1)'Image &
                " Minor Version: " &
                Header.Version (2)'Image);
      --Put_Line ("Flags: " &
        --         Header.Flags'Image);
      Put_Line ("Flags Unsyncronisation: " &
                Header.Flags.Unsynchronisation'Image);
      Put_Line ("Flags Extended Header" &
                Header.Flags.Extended_Header'Image);
      Put_Line ("Flags experimental indicator" &
                Header.Flags.Experimental_Indicator'Image);
      for I in Header.Size'Range loop
         Put_Line ("Size Byte #" &
                   I'Image &
                   ": " &
                   Header.Size(I)'Image);
      end loop;

      New_Line;
   end Dump;

   procedure Read (Stream : not null access Ada.Streams.Root_Stream_Type'Class;
                   Item : out ID3_v2) is
      Last : S.Stream_Element_Offset;
      Buffer : S.Stream_Element_Array (1 .. 10);
   begin
      Stream.Read (Buffer, Last);
      for I in Buffer (1 .. 3)'Range loop
         Item.File_Identifier (Integer (I)) := Character'Val (Buffer (I));
      end loop;
      Ada.Text_IO.Put_Line (S.Stream_Element'Object_Size'Image);
   end Read;

end Mp3_Header;
