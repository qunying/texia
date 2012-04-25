------------------------------------------------------------------------------
--                          TeXiA - TeX in Ada                              --
--                                                                          --
-- Copyright (C) 2012, Zhu Qun-Ying (zhu.qunying@gmail.com)                 --
-- All rights reserved.                                                     --
--                                                                          --
-- This file is part of TeXiA.                                              --
--                                                                          --                                                                         --
-- TeXiA is free software: you can redistribute it and/or modify            --
-- it under the terms of the GNU General Public License as published by     --
-- the Free Software Foundation, either version 3 of the License, or        --
-- (at your option) any later version.                                      --
--                                                                          --
-- TeXiA is distributed in the hope that it will be useful,                 --
-- but WITHOUT ANY WARRANTY; without even the implied warranty of           --
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the            --
-- GNU General Public License for more details.                             --
--                                                                          --
-- You should have received a copy of the GNU General Public License        --
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.    --
------------------------------------------------------------------------------

with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;

package TeX is

   Version    : constant String := "0.0 20120421";
   Copyright  : constant String := "Copyright (C) 2012, Zhu Qun-Ying."
     & " All rights reserved.";
   GPL_notice : constant String :=
     "TeXiA is free software: you can redistribute it and/or modify" & LF
     & "it under the terms of the GNU General Public License as published by"
     & LF
     & "the Free Software Foundation, either version 3 of the License, or" & LF
     & "(at your option) any later version." & LF
     & LF
     & "TeXiA is distributed in the hope that it will be useful," & LF
     & "but WITHOUT ANY WARRANTY; without even the implied warranty of" & LF
     & "MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the" & LF
     & "GNU General Public License for more details." & LF
     & LF
     & "You should have received a copy of the GNU General Public License" & LF
     & "along with this program.  If not, see <http://www.gnu.org/licenses/>."
     & LF;

end Tex;
