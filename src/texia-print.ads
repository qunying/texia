-------------------------------------------------------------------------------
--                          TeXiA - TeX in Ada                               --
--                                                                           --
-- Copyright (C) 2012-2018, Zhu Qun-Ying (zhu.qunying@gmail.com)             --
-- All Rights Reserved.                                                      --
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

package TeXiA.Print is
   -- s.57 To end a line of text output, call Print_Ln to print an end of line
   procedure Print_Ln (ctx : in out TeXiA.Global.Context_T);

   -- s.58 Sends one character to the desired destination
   procedure Print_Char (ctx : in out TeXiA.Global.Context_T; c : Character);

   -- s.59 output an entire string
   procedure Print (s : Integer);
end TeXiA.Print;

-- vim: sw=3 ts=8 sts=3 expandtab spell :
