-------------------------------------------------------------------------------
--                          TeXiA - TeX in Ada                               --
--                                                                           --
-- Copyright (C) 2012, Zhu Qun-Ying (zhu.qunying@gmail.com)                  --
-- All rights reserved.                                                      --
--                                                                           --
-- This file is part of TeXiA.                                               --
--                                                                           --
-- TeXiA is free software: you can redistribute it and/or modify             --
-- it under the terms of the GNU General Public License as published by      --
-- the Free Software Foundation, either version 3 of the License, or         --
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
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.     --
-------------------------------------------------------------------------------

with TeXiA.Version;
with TeXiA.Global;
with TeXiA.File_IO;
with TeXiA.Print;

with Ada.Text_IO;       use Ada.Text_IO;
with GNAT.Command_Line; use GNAT.Command_Line;
with Ada.Command_Line;  use Ada.Command_Line;

procedure TeXiA_Main is
   CLI_Config      : Command_Line_Configuration;
   CLI_Help        : aliased Boolean;
   Display_Version : aliased Boolean;
   ctx             : aliased TeXiA.Global.Context_T;
begin
   -- defined commmand line arguments
   Define_Alias (CLI_Config, "-?", "-h");
   Define_Switch
     (CLI_Config,
      Output      => CLI_Help'Access,
      Switch      => "-h",
      Long_Switch => "--help",
      Help        => "Print this help.");
   Define_Switch
     (CLI_Config,
      Output      => Display_Version'Access,
      Switch      => "-v",
      Long_Switch => "--version",
      Help        => "Print version information.");

   Set_Usage
     (CLI_Config,
      Usage => "[switches] [input-file]",
      Help  => TeXiA.Version.Name &
               " " &
               TeXiA.Version.Str &
               " - " &
               TeXiA.Version.Short_GPL_Str);

   Getopt (CLI_Config);
   if CLI_Help then
      Display_Help (CLI_Config);
   end if;
   if Display_Version then
      Put_Line (TeXiA.Version.Name & " " & TeXiA.Version.Str);
      Put_Line (TeXiA.Version.Copyright);
      New_Line;
      Put_Line (TeXiA.Version.GPL_Notice);
      return;
   end if;

   if Argument_Count > 1 then
      Put_Line ("only one input file is allowed.");
      Display_Help (CLI_Config);
   end if;
   if Argument_Count = 0 then
      if not TeXiA.File_IO.Init_Terminal (ctx'Access) then
         return;
      end if;
   end if;

exception
   when Exit_From_Command_Line | Invalid_Switch =>
      null; -- OK for these exceptions

end TeXiA_Main;

-- vim: sw=3 ts=8 sts=3 expandtab spell:
