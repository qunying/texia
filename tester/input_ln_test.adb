-------------------------------------------------------------------------------
--                                                                           --
-- Copyright (C) 2012, Zhu Qun-Ying (zhu.qunying@gmail.com)                  --
-- All Rights Reserved.							     --
--                                                                           --
-- This file is part of TeXiA.                                               --
--                                                                           --
-- TeXiA is free software; you can redistribute it and/or modify             --
-- it under the terms of the GNU General Public License as published by      --
-- the Free Software Foundation; either version 3 of the License, or         --
-- (at your option) any later version.                                       --
--                                                                           --
-- TeXiA is distributed in the hope that it will be useful,                  --
-- but WITHOUT ANY WARRANTY; without even the implied warranty of            --
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the             --
-- GNU General Public License for more details.                              --
--                                                                           --
-- You should have received a copy of the GNU General Public License         --
-- along with this program; if not, see <http://www.gnu.org/licenses/>.      --
-------------------------------------------------------------------------------

with Ada.Text_IO;
with Ada.Text_IO.Text_Streams;
with Ada.Strings.Unbounded;
with Ada.Characters.Latin_1;
with Ada.Streams.Stream_IO;

with TeXiA.File_IO;

package body input_ln_test is
   use Ahven.Framework;
   use Ada.Text_IO;
   use Ada.Text_IO.Text_Streams;
   use TeXiA.File_IO;

   package SU renames Ada.Strings.Unbounded;
   package Latin_1 renames Ada.Characters.Latin_1;
   package SIO renames Ada.Streams.Stream_IO;
   package TIO renames Ada.Text_IO;

   function "+" (S : String) return SU.Unbounded_String renames
     SU.To_Unbounded_String;
   function "-" (U : SU.Unbounded_String) return String renames SU.To_String;

   type line_test is record
      line_dat : SU.Unbounded_String;
      last     : TeXiA.buf_range_t;
      expect   : Boolean;
   end record;
   type line_test_lst is array (Positive range <>) of line_test;

   procedure Initialize (T : in out Test) is
   begin
      Set_Name (T, "input_ln test");
      Add_Test_Routine (T, Test_Addition'Access, "input_ln");
   end Initialize;

   procedure Test_Addition is
      texia_ctx      : aliased TeXiA.Context_t;
      test_file      : TIO.File_Type;
      line_test_data : line_test_lst (1 .. 7);
      val            : Boolean;
      test_filename  : constant String := "/tmp/input_ln_test.dat";
      test_stream    : SIO.File_Type;
   begin
      line_test_data (1).line_dat := +("line1 data" & Latin_1.LF);
      line_test_data (1).last     := SU.Length (line_test_data (1).line_dat) -
                                     1;
      line_test_data (1).expect   := True;

      line_test_data (2).line_dat := +("line2 data" & Latin_1.LF);
      line_test_data (2).last     := SU.Length (line_test_data (2).line_dat) -
                                     1;
      line_test_data (2).expect   := True;

      line_test_data (3).line_dat :=
        +("line3 data               " & Latin_1.LF);
      line_test_data (3).last     := line_test_data (2).last;
      line_test_data (3).expect   := True;

      line_test_data (4).line_dat := +(Latin_1.CR & Latin_1.LF);
      line_test_data (4).last     := 1;
      line_test_data (4).expect   := False;

      line_test_data (5).line_dat := +(Latin_1.LF & Latin_1.CR);
      line_test_data (5).last     := 1;
      line_test_data (5).expect   := False;

      line_test_data (6).line_dat := +(Latin_1.CR & Latin_1.CR & Latin_1.LF);
      line_test_data (6).last     := 1;
      line_test_data (6).expect   := False;

      line_test_data (7).line_dat := +("    end" & Latin_1.LF & Latin_1.CR);
      line_test_data (7).last     := SU.Length (line_test_data (7).line_dat) -
                                     2;
      line_test_data (7).expect   := True;

      SIO.Create (test_stream, SIO.Out_File, test_filename);
      for i in line_test_data'Range loop
         String'Write
           (SIO.Stream (test_stream),
            -line_test_data (i).line_dat);
      end loop;
      SIO.Close (test_stream);
      Open (test_file, In_File, test_filename);
      for i in line_test_data'Range loop
         val := input_ln (texia_ctx'Access, test_file, True);
         if val /= line_test_data (i).expect
           or else (line_test_data (i).expect
                   and then (texia_ctx.buffer (1 .. texia_ctx.last) /=
                             SU.To_String (line_test_data (i).line_dat) (
               1 .. line_test_data (i).last)))
         then
            Ahven.Fail ("Line" & Integer'Image (i) & " read error");
         end if;
      end loop;
      Close (test_file);

      -- test for buffer overflow exception
      SIO.Open (test_stream, SIO.Out_File, test_filename);
      for i in 1 .. TeXiA.buf_range_t'Last loop
         Character'Write (SIO.Stream (test_stream), 'A');
      end loop;
      SIO.Close (test_stream);
      Open (test_file, In_File, test_filename);
      val := input_ln (texia_ctx'Access, test_file, True);
      Close (test_file);
      Ahven.Fail ("No exception capture");
   exception
      when Buffer_Overflow =>
         null; -- Working Good
   end Test_Addition;
end input_ln_test;

-- vim: sw=3 ts=8 sts=3 expandtab spell :