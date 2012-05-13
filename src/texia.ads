------------------------------------------------------------------------------
--                          TeXiA - TeX in Ada                              --
--                                                                          --
-- Copyright (C) 2012, Zhu Qun-Ying (zhu.qunying@gmail.com)                 --
-- All rights reserved.                                                     --
--                                                                          --
-- This file is part of TeXiA.                                              --
--                                                                          --
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

-- It is based on TeX version 3.1415926

with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;

package TeXiA is

   Version    : constant String := "0.0 20120421";
   Copyright  : constant String :=
      "Copyright (C) 2012, Zhu Qun-Ying. All rights reserved.";
   GPL_notice : constant String :=
      "TeXiA is free software: you can redistribute it and/or modify" &
      LF &
      "it under the terms of the GNU General Public License as published by" &
      LF &
      "the Free Software Foundation, either version 3 of the License, or" &
      LF &
      "(at your option) any later version." &
      LF &
      LF &
      "TeXiA is distributed in the hope that it will be useful," &
      LF &
      "but WITHOUT ANY WARRANTY; without even the implied warranty of" &
      LF &
      "MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the" &
      LF &
      "GNU General Public License for more details." &
      LF &
      LF &
      "You should have received a copy of the GNU General Public License" &
      LF &
      "along with this program.  If not, see <http://www.gnu.org/licenses/>." &
      LF;

   -- some global definitionsls

   -- greatest index in TeX's internal mem arrary, must be strictly
   -- less than max_halfword; must be equal to mem_top in INITEX, otherwise >=
   -- mem_top
   mem_max : constant := 30_000;
   -- smallest index in TeX's internal mem array; must be min_halfword or more;
   -- must be equal to mem_bot in INITEX, otherwise <= mem_bot
   mem_min : constant := 0;
   -- maximum ber of characters simulataneously present in current lines of
   -- open files and in control sequences between \csname and \endcsname;
   -- must not exced max_halfword
   buf_size : constant := 500;
   -- width of context lines on terminal error messages
   erro_line : constant := 72;
   -- width of first lines of contexts in terminal error messages; should be
   -- between 30 and error_line - 15
   half_error_line : constant := 42;
   -- width of longest text lines output
   max_print_line : constant := 79;
   -- maximum number of simultaneous input sources
   stack_size : constant := 200;
   -- maximum number of input files nad error insertions that can be going on
   -- simultaneously
   max_in_ope : constant := 6;
   -- maximum internal font number; must not exceed max_quarterword and must be
   -- at most font_base + 256;
   font_max : constant := 75;
   -- number of words of font_info for all fonts
   font_mem_size : constant := 20_000;
   -- maximum number of simultaneous macro parameters
   param_size : constant := 60;
   -- maximum number of semantic levels simultaneously active
   nest_size : constant := 40;
   -- maximum number of strings; must not exceed max_halfword
   max_strings : constant := 3_000;
   -- minimum number of characters that should be available for the user's
   -- control sequences and font names, after TeX's own error messages are
   -- stored
   string_vacancies : constant := 8_000;
   -- maximum number of characters in strings, including all error messages and
   -- help texts, and the names of all fonts and control sequences; must exceed
   -- string_vacancies by the totla lenght of TeX's own strings, which is
   -- currently about 23_000
   pool_size : constant := 32_000;
   -- space for saving values outside of current group; must be at most
   -- max_halfword
   save_size : constant := 600;
   -- space for hyphenation patterns; should be larger for INITEX than it is in
   -- production versions of TeX
   trie_size : constant := 8_000;
   -- space for "opcodes" in the hyphenation patterns
   trie_op_size : constant := 500;
   -- size of the output buffer; must be a multiple of 8
   dvi_buf_size : constant := 800;
   -- file names shouldn't be longer than this
   file_name_size : constant := 40;
   pool_name      : constant String :=
      "TeXformats:TEX.POOL                     ";

   mem_bot : constant := 0;
   mem_top : constant := mem_max;

   font_base  : constant := 0;
   hash_size  : constant := 2_100; -- at most (mem_max - mem_min)/10
   hash_primt : constant := 1_777;
   hyph_size  : constant := 307;

   subtype name_length_t is Integer range 1 .. file_name_size;
   subtype buf_range_t is Integer range 1 .. buf_size + 1;

   type Context_t is record
      bad           : Integer;
      name_of_file  : String (1 .. file_name_size);
      name_length   : name_length_t;
      buffer        : String (buf_range_t'Range);
      first         : buf_range_t := 1;
      last          : buf_range_t := 1;
      max_buf_stack : buf_range_t := 1;
      loc           : buf_range_t;
   end record;

end TeXiA;
