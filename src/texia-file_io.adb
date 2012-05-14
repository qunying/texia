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
with Ada.Characters.Latin_1;
with Ada.Integer_Text_IO;

package body TeXiA.File_IO is

   use Ada.Text_IO;
   use Ada.Integer_Text_IO;
   package Latin_1 renames Ada.Characters.Latin_1;

   function input_ln
     (ctx         : access TeXiA.Context_t;
      file        : Ada.Text_IO.File_Type;
      bypass_eoln : Boolean)
      return        Boolean
   is
      last        : Natural;
      first       : buf_range_t := 1;
      eol_trimmed : Boolean     := False;
   begin
      ctx.last := ctx.first;
      Get_Line (File => file, Item => ctx.buffer, Last => last);
      if last = buf_range_t'Last then
         -- report overflow here
         Put
           (Standard_Error,
            "! Unable to read an entire line---" & "bufsize=");
         -- output buffer range without leading space
         Put (Item => Integer (buf_range_t'Last), Width => 1);
         New_Line;
         Put_Line (Standard_Error, "Please increase buf_size in texia.ads.");
         raise Buffer_Overflow;
      end if;
      if last = 0 then
         return False;
      end if;

      ctx.last := buf_range_t (last);
      if ctx.last = ctx.first then
         return False;
      end if;
      if ctx.last > ctx.max_buf_stack then
         ctx.max_buf_stack := ctx.last;
      end if;
      -- trim space at the end
      while ctx.last > ctx.first and then Is_Blank (ctx.buffer (ctx.last))
      loop
         ctx.last := ctx.last - 1;
      end loop;

      -- trim CR or LF in the front
      while first < ctx.last and then Is_EoL (ctx.buffer (first)) loop
         first       := first + 1;
         eol_trimmed := True;
      end loop;
      if eol_trimmed then
         if first = ctx.last and then Is_EoL (ctx.buffer (first)) then
            ctx.last := ctx.first;
            return False;
         else
            ctx.buffer (1 .. (ctx.last - first + 1))   :=
              ctx.buffer (first .. ctx.last);

            ctx.last := ctx.last - first + 1;
         end if;
      end if;

      return True;
   exception
      when End_Error =>
         return False;
   end input_ln;

   function Is_Blank (C : Character) return Boolean is
   begin
      return C = ' ' or else C = Latin_1.HT;
   end Is_Blank;

   function Is_EoL (C : Character) return Boolean is
   begin
      return C = Latin_1.CR or else C = Latin_1.LF;
   end Is_EoL;

end TeXiA.File_IO;

-- vim: sw=3 ts=8 sts=3 expandtab spell:
