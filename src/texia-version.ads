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

package TeXiA.Version is
   package Char renames Ada.Characters.Latin_1;
   Name          : constant String := "TeXiA";
   Major : constant := 0;
   Minor : constant := 0;
   Date  : constant := 20120421;
   Str   : constant String := "0.0 20120421";
   Copyright     : constant String := "Copyright (C) 2012, Zhu Qun-Ying.";
   Short_GPL_Str : constant String := "Licensed under GPLv3 or latter.";
   GPL_Notice    : constant String :=
      "TeXiA is free software: you can redistribute it and/or modify" &
      Char.LF &
      "it under the terms of the GNU General Public License as published by" &
      Char.LF &
      "the Free Software Foundation, either version 3 of the License, or" &
      Char.LF &
      "(at your option) any later version." &
      Char.LF &
      Char.LF &
      "TeXiA is distributed in the hope that it will be useful," &
      Char.LF &
      "but WITHOUT ANY WARRANTY; without even the implied warranty of" &
      Char.LF &
      "MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the" &
      Char.LF &
      "GNU General Public License for more details." &
      Char.LF &
      Char.LF &
      "As a special exception under Section 7 of GPL version 3, " &
      "running TeXiA on" &
      Char.LF &
      "input document does not by itself cause the resulting output to be" &
      Char.LF &
      "covered by the GNU General Public License.  This exception does not" &
      Char.LF &
      "however invalidate any other reasons why the executable file might be" &
      Char.LF &
      "covered by the GNU Public License." &
      Char.LF &
      Char.LF &
      "You should have received a copy of the GNU General Public License" &
      Char.LF &
      "along with this program.  If not, see <http://www.gnu.org/licenses/>.";

   banner : constant String :=
      "This is " & Name & ", Version " & Str & ", " & Short_GPL_Str;

end TeXiA.Version;

-- vim: sw=3 ts=8 sts=3 expandtab spell :
