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

with TeX;

with Ada.Text_IO; use Ada.Text_IO;

procedure Texia is

begin
   Put_Line ("TeXia verison: " & TeX.Version);
   Put_Line (TeX.Copyright);
   Put_Line (TeX.GPL_notice);
end Texia;
