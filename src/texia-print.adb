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
-- As a special exception under Section 7 of GPL version 3, running TeXiA on --
-- input document does not by itself cause the resulting output to be        --
-- covered by the GNU General Public License.  This exception does not       --
-- however invalidate any other reasons why the executable file might be     --
-- covered by the GNU Public License.                                        --
--                                                                           --
-- You should have received a copy of the GNU General Public License         --
-- along with this program; if not, see <http://www.gnu.org/licenses/>.      --
-------------------------------------------------------------------------------

with TeXiA.Global;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Characters.Latin_1;

package body TeXiA.Print is
   use TeXiA.Global;
   package Char renames Ada.Characters.Latin_1;

   --------------------------------------------------------------------------
   procedure Print_Ln (ctx : in out TeXiA.Global.Context_T) is
   begin
      case ctx.selector is
         when Term_and_Log =>
            New_Line;
            ctx.term_offset := 0;
            New_Line (ctx.log_file);
            ctx.file_offset := 0;
         when Log_Only =>
            New_Line (ctx.log_file);
            ctx.file_offset := 0;
         when Term_Only =>
            New_Line;
            ctx.term_offset := 0;
         when No_Print | Pseudo | New_String =>
            null;
         when 0 .. 15 =>
            New_Line (ctx.write_file (ctx.selector));
      end case;
   end Print_Ln;

   --------------------------------------------------------------------------
   procedure Print_Char (ctx : in out TeXiA.Global.Context_T; c : Character) is
      -----------------------------------------------------------------------
      function Needs_Wrapping (Char_Pos : Integer; Offset : Integer)
        return Boolean is
      begin
         if (Char_Pos >= 16#C0# and then Char_Pos <= 16#DF# and then
             Offset + 2 >= max_print_line) or else
           (Char_Pos >= 16#E0# and then Char_Pos <= 16#EF# and then
            Offset + 3 >= max_print_line) or else
           (Char_Pos >= 16#F0# and then Offset + 4 >= max_print_line) then
            return True;
         end if;
         return False;
      end Needs_Wrapping;
      pragma Inline (Needs_Wrapping);

      -----------------------------------------------------------------------
      procedure Fixed_Term_Offset is
         Char_Pos : Integer := Character'Pos (c);
      begin
         if Needs_Wrapping (Char_Pos, ctx.term_offset) then
            New_Line;
            ctx.term_offset := 0;
         end if;
      end Fixed_Term_Offset;
      pragma Inline (Fixed_Term_Offset);

      procedure Fixed_Log_Offset is
         Char_Pos : Integer := Character'Pos (c);
      begin
         if Needs_Wrapping (Char_Pos, ctx.file_offset) then
            New_Line (ctx.log_file);
            ctx.file_offset := 0;
         end if;
      end Fixed_Log_Offset;

      procedure Write_Term is
         Char_Pos : Integer := Character'Pos (c);
      begin
         if c >= Char.Space or else c = Char.LF or else c = Char.CR
           or else c = Char.HT then
            Put (c);
         else
            if ctx.term_offset + 2 >= max_print_line then
               New_Line;
               ctx.term_offset := 0;
            end if;
            Put ('^');
            Put ('^');
            Put (Character'Val (Char_Pos + 64));
            ctx.term_offset := ctx.term_offset + 2;
         end if;
      end Write_Term;
      pragma Inline (Write_Term);

   begin
      -- fixed me int_par new_line_char_code
      case ctx.selector is
         when Term_and_Log =>
            Fixed_Term_Offset;
            Write_Term;
            ctx.term_offset := ctx.term_offset + 1;
            if ctx.term_offset = max_print_line then
               New_Line;
               ctx.term_offset := 0;
            end if;

            Fixed_Log_Offset;
            Put (ctx.log_file, c);
            ctx.file_offset := ctx.file_offset + 1;
            if ctx.file_offset = max_print_line then
               New_Line (ctx.log_file);
               ctx.file_offset := 0;
            end if;

         when Term_Only =>
            Fixed_Term_Offset;
            Write_Term;
            ctx.term_offset := ctx.term_offset + 1;
            if ctx.term_offset = max_print_line then
               New_Line;
               ctx.term_offset := 0;
            end if;

         when Log_Only =>
            Fixed_Log_Offset;
            Put (ctx.log_file, c);
            ctx.file_offset := ctx.file_offset + 1;
            if ctx.file_offset = max_print_line then
               New_Line (ctx.log_file);
               ctx.file_offset := 0;
            end if;
         when No_Print =>
            return;
         when Pseudo =>
            if ctx.tally < ctx.trick_count then
               ctx.trick_buf (ctx.tally mod ctx.trick_count + 1) := c;
            end if;
         when New_String =>
            -- FIXME
            null;
         when 0 .. 15 =>
            Put (ctx.write_file (ctx.selector), c);
      end case;
      ctx.tally := ctx.tally + 1;
   end Print_Char;

end TeXiA.Print;

-- vim: sw=3 ts=8 sts=3 expandtab spell :
