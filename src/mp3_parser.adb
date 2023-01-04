with Ada.Text_IO;
with Ada.Integer_Text_IO;

with Ada.Streams.Stream_IO;

with Mp3_Header;

procedure Mp3_Parser is
   package TIO renames Ada.Text_IO;
   package IIO renames Ada.Integer_Text_IO;
   package SIO renames Ada.Streams.Stream_IO;

   The_Header : Mp3_Header.ID3_v2;

   F : SIO.File_Type;
   Out_F : SIO.File_Type;
   S : SIO.Stream_Access;
   File_Name : constant String := "files/gallan.mp3";
begin
   SIO.Open (F, SIO.In_File, File_Name);
   S := SIO.Stream (F);
   Mp3_Header.ID3_v2'Read (S, The_Header);
   TIO.Put_Line (The_Header'Size'Image);
   TIO.Put ("Header Object_Size");
   IIO.Put (Mp3_Header.ID3_v2'Object_Size);
   TIO.New_Line;
   Mp3_Header.Dump (The_Header);
   SIO.Close (F);

   SIO.Create (F, SIO.Out_File, "test.bin");
   S := SIO.Stream (F);
   Mp3_Header.ID3_v2'Write (S, The_Header);
   SIO.Close (F);
end Mp3_Parser;
