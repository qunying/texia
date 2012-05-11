------------------------------------------------------------------------------
--                          TeXiA - TeX in Ada                              --
--                                                                          --
-- Copyright (C) 2012, Zhu Qun-Ying (zhu.qunying@gmail.com)                 --
-- All rights reserved.                                                     --
--                                                                          --
-- This file is part of TeXiA.                                              --
--                                                                          --
----
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

with TeXiA;
with TeXiA.File_IO;
with Ada.Text_IO; use Ada.Text_IO;

procedure TeXiA_Main is

begin
   Put_Line ("TeXiA " & TeXiA.Version);
   Put_Line (TeXiA.Copyright);
   Put_Line (TeXiA.GPL_notice);
end TeXiA_Main;
