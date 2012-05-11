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

package body TeXiA.File_IO is

   use Ada.Text_IO;
   function input_ln
     (ctx         : access TeXiA.Context_t;
      file        : Ada.Text_IO.File_Type;
      bypass_eoln : Boolean)
      return        Boolean
   is
      last : Natural;
   begin
      ctx.last := ctx.first;
      Get_Line (Item => ctx.buffer, Last => last);
      if last = buf_range_t'Last then
         -- report overflow here
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
      while ctx.last > ctx.first and then Is_Blank (ctx.buffer (ctx.last))
      loop
         ctx.last := ctx.last - 1;
      end loop;

      return True;
   exception
      when End_Error =>
         return False;
   end input_ln;

   function Is_Blank (C : Character) return Boolean is
   begin
      return C = ' ' or else C = ASCII.HT;
   end Is_Blank;
end TeXiA.File_IO;

-- vim: sw=3 ts=8 sts=3 expandtab spell:
