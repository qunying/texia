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

with Ada.Text_IO;

package TeXiA.File_IO is

   Buffer_Overflow : exception;

   -- s.31 brings the next line of input from the given file into available
   -- positions of the buffer array and returns true, unless the file has
   -- already been entirely read, in which case it reutrns false and
   -- set ctx.last := ctx.first
   function input_ln
     (ctx         : access TeXiA.Context_t;
      file        : Ada.Text_IO.File_Type)
      return        Boolean;

   --  Determines if C is a blank (space or tab)
   function Is_Blank (C : Character) return Boolean;
   pragma Inline (Is_Blank);

   -- terminal IO
   function init_terminal (ctx : access TeXiA.Context_t)  return Boolean;

   -- Determinse if C is a end of line character, either CR or LF
   function Is_EoL (C : Character) return Boolean;
   pragma Inline (Is_Blank);
end TeXiA.File_IO;

-- vim: sw=3 ts=8 sts=3 expandtab:
