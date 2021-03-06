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

package TeXiA.Global is

   -- greatest index in Tex's internal mem array, must be strictly less than
   -- max_halfword; must be equal to mem_top in INITEX, otherwise >= mem_top
   mem_max : constant := 30_000;

   -- smallest index in TeX's internal mem array; must be min_halfword or more;
   -- must be equal to mem_bot in INITEX, otherwise <= mem_bot
   mem_min : constant := 0;

   -- maximum number of characters simultaneously present in current lines of
   -- open files and in control sequences between \csname and \endcsname; must
   -- not exceed max_halfword
   buf_size : constant := 500;

   -- width of context lines on terminal error messages
   error_line : constant := 72;

   -- width of first lines of contexts in terminal error messages; should be
   -- between 30 and error_line - 15
   half_error_line : constant := 42;

   -- width of longest text lines output
   max_print_line : constant := 79;

   -- maximum number of simultaneous input sources
   stack_size : constant := 200;

   -- maximum number of input files and error insertions that can be going on
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

   -- maximum number of strings; must not exceed max_haChar.LFword
   max_strings : constant := 3_000;

   -- minimum number of characters that should be available for the user's
   -- control sequences and font names, after TeX's own error messages are
   -- stored
   string_vacancies : constant := 8_000;

   -- maximum number of characters in strings, including all error messages and
   -- help texts, and the names of all fonts and control sequences; must exceed
   -- string_vacancies by the total length of TeX's own strings, which is
   -- currently about 23_000
   pool_size : constant := 32_000;

   -- space for saving values outside of current group; must be at most
   -- max_haChar.LFword
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
   hash_prime : constant := 1_777;
   hyph_size  : constant := 307;

   subtype Name_Length_T is Integer range 1 .. file_name_size;
   subtype Buf_Range_T is Integer range 1 .. buf_size + 1;

   -- s.110
   min_quarterword : constant := 0;
   max_quarterword : constant := 255;

   min_halfword : constant := 0;
   max_halfword : constant := 65535;

   subtype Quarterword_T is Integer range min_quarterword .. max_quarterword;
   subtype Halfword_T is Integer range min_halfword .. max_halfword;

   -- s.113
   type Two_Choices_T is (half_word, quarter_word);
   type Four_Choices_T is (int_number, glue_ratio, half_word, quarter_word);

   type Twohalves_T (Option : Two_Choices_T := half_word) is record
      rh : Halfword_T;
      case Option is
         when half_word =>
            lh : Halfword_T;
         when quarter_word =>
            b0, b1 : Quarterword_T;
      end case;
   end record;
   pragma Unchecked_Union (Twohalves_T);

   type Four_Quarters_T is record
      b0, b1, b2, b3 : Quarterword_T;
   end record;

   subtype Glue_Ratio_T is Integer;

   type Memory_Word_T (Option : Four_Choices_T := int_number) is record
      case Option is
         when int_number =>
            inum : Integer;
         when glue_ratio =>
            gr : Glue_Ratio_T;
         when half_word =>
            rh, lh : Halfword_T;
         when quarter_word =>
            b0, b1, b2, b3 : Quarterword_T;
      end case;
   end record;
   pragma Unchecked_Union (Memory_Word_T);

   -- s.300
   type Input_State_T is record
      state : Quarterword_T;
      index : Quarterword_T;

      start : Halfword_T;
      loc   : Halfword_T;
      limit : Halfword_T;
      name  : Halfword_T;
   end record;

   -- s.51 selector value
   No_Print     : constant := 16;
   Term_Only    : constant := 17;
   Log_Only     : constant := 18;
   Term_and_Log : constant := 19;
   Pseudo       : constant := 20;
   New_String   : constant := 21;

   subtype Selector_T is Integer range 0 .. 21;
   type File_Array is array (Integer range <>) of Ada.Text_IO.File_Type;

   -- s.73 reporting errors
   type Interaction_Mode_T is (
      Batch_Mode,
      Nonstop_Mode,
      scroll_Mode,
      Error_Stop_Mode);

   -- s.76
   type History_T is (
      Spotless,
      Warning_Issued,
      Error_Message_Issued,
      Fatal_Error_Stop);
   subtype Error_Count_Range_T is Integer range -1 .. 100;

   -- s.38 string handling
   subtype pool_pointer is Integer range 1 .. pool_size;
   subtype str_number is Integer range 1 .. max_strings;

   type pool_pointer_array is array (str_number'Range) of pool_pointer;
   type pool_pointer_array_access is access all pool_pointer_array;

   type String_Access is access all String;

   -- TeXiA's global context
   type Context_T is record
      bad           : Integer     := 0;
      log_file      : Ada.Text_IO.File_Type;
      write_file    : File_Array (0 .. 15);
      name_of_file  : String (1 .. file_name_size);
      name_length   : Name_Length_T;
      buffer        : String (Buf_Range_T'Range);
      first         : Buf_Range_T := 1;
      last          : Buf_Range_T := 1;
      max_buf_stack : Buf_Range_T := 1;
      cur_input     : Input_State_T;

      -- s.39
      str_pool      : String_Access;
      str_start     : pool_pointer_array_access;
      pool_ptr      : pool_pointer := 1;
      str_ptr       : str_number;
      init_pool_ptr : pool_pointer;
      init_str_ptr  : str_number;

      -- s.54
      selector    : Selector_T        := Term_Only;
      tally       : Integer           := 0;
      dig         : String (1 .. 15);
      file_offset : Ada.Text_IO.Count := 0;
      trick_buf   : String (1 .. error_line + 1);
      trick_count : Integer           := 0;
      first_count : Integer           := 0;

      -- s.74,
      interaction : Interaction_Mode_T := Error_Stop_Mode;

      -- s.76, s.77
      deletions_allowed : Boolean             := True;
      set_box_allowed   : Boolean             := True;
      history           : History_T           := Fatal_Error_Stop;
      erro_count        : Error_Count_Range_T := 0;
   end record;

   String_Overflow : exception;
end TeXiA.Global;

-- vim: sw=3 ts=8 sts=3 expandtab spell :
