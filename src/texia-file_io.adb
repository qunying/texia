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
with Ada.Characters.Latin_1;
with Ada.Integer_Text_IO;

package body TeXiA.File_IO is

   use Ada.Text_IO;
   use Ada.Integer_Text_IO;
   package Latin_1 renames Ada.Characters.Latin_1;

   ---------------------------------------------------------------------------
   function input_ln
     (ctx  : access TeXiA.Context_t;
      file : Ada.Text_IO.File_Type)
      return Boolean
   is
      last         : Natural;
      first        : buf_range_t := ctx.first;
      crln_trimmed : Boolean     := False;
   begin
      ctx.last := ctx.first;

      Get_Line (File => file, Item => ctx.buffer, Last => last);
      if last + 2 >= buf_range_t'Last then
         -- report overflow here
         Put
           (Standard_Error,
            "! Unable to read an entire line---" & "bufsize=");
         -- output buffer range without leading space
         Put (Item => Integer (buf_range_t'Last - 1), Width => 1);
         New_Line;
         Put_Line (Standard_Error, "Please increase buf_size in texia.ads.");
         raise Buffer_Overflow;
      end if;
      if last = 0 then
         return True;
      end if;

      ctx.last := buf_range_t (last) + 1;

      if ctx.last > ctx.max_buf_stack then
         ctx.max_buf_stack := ctx.last + 1;
      end if;
      -- trim space at the end
      while ctx.last > ctx.first
        and then Is_Blank (ctx.buffer (ctx.last - 1)) loop
         ctx.last := ctx.last - 1;
      end loop;

      -- trim CR or LF in the front
      while first < ctx.last and then Is_EoL (ctx.buffer (first)) loop
         first        := first + 1;
         crln_trimmed := True;
      end loop;
      if crln_trimmed then
         if first = ctx.last then
            ctx.last := ctx.first;
         else
            first := first - 1;

            ctx.buffer (1 .. (ctx.last - 1 - first))   :=
              ctx.buffer (first + 1 .. ctx.last - 1);

            ctx.last := ctx.last - first;
         end if;
      end if;

      return True;
   exception
      when End_Error =>
         return False;
   end input_ln;

   ---------------------------------------------------------------------------
   -- s.37 init terminal
   function init_terminal (ctx : access TeXiA.Context_t) return Boolean is
   begin
      Put_Line (banner);
      loop
         Put ("**");
         Flush (Standard_Output);
         if not input_ln (ctx, Standard_Input) then
            New_Line;
            Put_Line ("! End of file on the terminal... why?");
            return False;
         end if;
         --- need to use current input st
         if ctx.last = ctx.first then
            Put_Line ("Please type the name of your input file.");
         else
            return True;
         end if;
      end loop;
   end init_terminal;

   ---------------------------------------------------------------------------
   function Is_Blank (C : Character) return Boolean is
   begin
      return C = ' ' or else C = Latin_1.HT;
   end Is_Blank;

   ---------------------------------------------------------------------------
   function Is_EoL (C : Character) return Boolean is
   begin
      return C = Latin_1.CR or else C = Latin_1.LF;
   end Is_EoL;

end TeXiA.File_IO;

-- vim: sw=3 ts=8 sts=3 expandtab spell:
