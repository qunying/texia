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

package body TeXiA.String is
   -----------------------------------------------------------------------
   -- s.40
   function Length (ctx : Context_T; idx : pool_pointer) return Integer is
   begin
      return Len : Integer do
         Len := ctx.str_start (idx + 1) - ctx.str_start (idx);
      end return;
   end Length;

   -----------------------------------------------------------------------
   -- s.41
   function Cur_Length (ctx : Context_T) return Integer is
   begin
      return Len : Integer do
         Len := ctx.pool_ptr - ctx.str_start (ctx.str_ptr);
      end return;
   end Cur_Length;

   -----------------------------------------------------------------------
   -- s.42
   procedure Append_Char (ctx : in out Context_T; Char : Character) is
   begin
      ctx.str_pool (ctx.pool_ptr) := Char;
      ctx.pool_ptr := ctx.pool_ptr + 1;
   end Append_Char;

   -----------------------------------------------------------------------
   procedure Flush_Char (ctx : in out Context_T) is
   begin
      -- forget the last char in the pool
      ctx.pool_ptr := ctx.pool_ptr - 1;
   end Flush_Char;

   -----------------------------------------------------------------------
   procedure Room (ctx : Context_T; idx : pool_pointer) is
   begin
      if ctx.pool_ptr + idx > pool_size then
         -- FixME call overflow
         -- overflow (ctx, "pool size", pool_size - ctx.init_pool_str);
         null;
      end if;
   end Room;
end TeXiA.String;

-- vim: sw=3 ts=8 sts=3 expandtab spell :
