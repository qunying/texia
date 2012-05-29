-------------------------------------------------------------------------------
--                          TeXiA - TeX in Ada                               --
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
with Ada.Exceptions;

with TeXiA.Global;
with TeXiA.File_IO;

package body input_ln_test is
   use Ahven.Framework;
   use Ada.Text_IO;
   use Ada.Text_IO.Text_Streams;
   use Ada.Exceptions;
   use TeXiA.File_IO;

   package SU renames Ada.Strings.Unbounded;
   package Char renames Ada.Characters.Latin_1;
   package SIO renames Ada.Streams.Stream_IO;
   package TIO renames Ada.Text_IO;

   function "+" (S : String) return SU.Unbounded_String renames
     SU.To_Unbounded_String;
   function "-" (U : SU.Unbounded_String) return String renames SU.To_String;

   type line_test is record
      line_dat : SU.Unbounded_String;
      last     : TeXiA.Global.Buf_Range_T;
      expect   : Boolean;
      empty    : Boolean := False;
   end record;
   type line_test_lst is array (Positive range <>) of line_test;

   procedure Initialize (T : in out Test) is
   begin
      Set_Name (T, "input_ln test");
      Add_Test_Routine (T, Test_Addition'Access, "input_ln");
   end Initialize;

   procedure Test_Addition is
      texia_ctx      : aliased TeXiA.Global.Context_T;
      test_file      : TIO.File_Type;
      line_test_data : line_test_lst (1 .. 7);
      val            : Boolean;
      test_filename  : constant String := "/tmp/input_ln_test.dat";
      test_stream    : SIO.File_Type;
   begin
      line_test_data (1).line_dat := +("line1 data" & Char.LF);
      line_test_data (1).last     := SU.Length (line_test_data (1).line_dat) -
                                     1;
      line_test_data (1).expect   := True;

      line_test_data (2).line_dat := +("line2 data" & Char.LF);
      line_test_data (2).last     := SU.Length (line_test_data (2).line_dat) -
                                     1;
      line_test_data (2).expect   := True;

      line_test_data (3).line_dat := +("line3 data               " & Char.LF);
      line_test_data (3).last     := line_test_data (2).last;
      line_test_data (3).expect   := True;

      line_test_data (4).line_dat := +(Char.CR & Char.LF);
      line_test_data (4).last     := 1;
      line_test_data (4).expect   := True;
      line_test_data (4).empty    := True;

      line_test_data (5).line_dat := +(Char.LF & Char.CR);
      line_test_data (5).last     := 1;
      line_test_data (5).expect   := True;
      line_test_data (5).empty    := True;

      line_test_data (6).line_dat := +(Char.CR & Char.CR & Char.LF);
      line_test_data (6).last     := 1;
      line_test_data (6).expect   := True;
      line_test_data (6).empty    := True;

      line_test_data (7).line_dat := +("    end" & Char.LF & Char.CR);
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
         val := Input_Ln (texia_ctx'Access, test_file);
         if val /= line_test_data (i).expect
           or else (line_test_data (i).expect
                   and then ((line_test_data (i).empty
                             and then texia_ctx.last /= texia_ctx.first)
                            or else (line_test_data (i).empty /= True
               and then texia_ctx.buffer (1 .. texia_ctx.last - 1) /=
               SU.To_String (line_test_data (i).line_dat) (1 .. line_test_data (i).last))))
         then
            Ahven.Fail ("Line" & Integer'Image (i) & " read error");
         end if;
      end loop;
      Close (test_file);

      -- test for buffer overflow exception
      SIO.Open (test_stream, SIO.Out_File, test_filename);
      for i in 1 .. TeXiA.Global.Buf_Range_T'Last - 1 loop
         Character'Write (SIO.Stream (test_stream), 'A');
      end loop;
      SIO.Close (test_stream);
      Open (test_file, In_File, test_filename);
      val := Input_Ln (texia_ctx'Access, test_file);
      Close (test_file);
      Ahven.Fail ("No exception captured.");
   exception
      when Buffer_Overflow =>
         null; -- Working Good
      when Error : others =>
         Ahven.Fail ("Unexpected exception:" & Exception_Information (Error));
   end Test_Addition;
end input_ln_test;

-- vim: sw=3 ts=8 sts=3 expandtab spell :
