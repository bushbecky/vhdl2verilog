-----------------------------------------------------------------------------------
--                                            __ _      _     _                  --
--                                           / _(_)    | |   | |                 --
--                __ _ _   _  ___  ___ _ __ | |_ _  ___| | __| |                 --
--               / _` | | | |/ _ \/ _ \ '_ \|  _| |/ _ \ |/ _` |                 --
--              | (_| | |_| |  __/  __/ | | | | | |  __/ | (_| |                 --
--               \__, |\__,_|\___|\___|_| |_|_| |_|\___|_|\__,_|                 --
--                  | |                                                          --
--                  |_|                                                          --
--                                                                               --
--                                                                               --
--              Peripheral-NTM for MPSoC                                         --
--              Neural Turing Machine for MPSoC                                  --
--                                                                               --
-----------------------------------------------------------------------------------

-----------------------------------------------------------------------------------
--                                                                               --
-- Copyright (c) 2020-2024 by the author(s)                                      --
--                                                                               --
-- Permission is hereby granted, free of charge, to any person obtaining a copy  --
-- of this software and associated documentation files (the "Software"), to deal --
-- in the Software without restriction, including without limitation the rights  --
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell     --
-- copies of the Software, and to permit persons to whom the Software is         --
-- furnished to do so, subject to the following conditions:                      --
--                                                                               --
-- The above copyright notice and this permission notice shall be included in    --
-- all copies or substantial portions of the Software.                           --
--                                                                               --
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR    --
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,      --
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE   --
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER        --
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, --
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN     --
-- THE SOFTWARE.                                                                 --
--                                                                               --
-- ============================================================================= --
-- Author(s):                                                                    --
--   Paco Reina Campo <pacoreinacampo@queenfield.tech>                           --
--                                                                               --
-----------------------------------------------------------------------------------

with Ada.Text_IO;
use Ada.Text_IO;

package body ntm_tensor_algebra is

  procedure ntm_tensor_convolution (
    data_a_in : in tensor;
    data_b_in : in tensor;
    
    data_out : out tensor
  ) is
    temporal : float;
  begin
    for i in data_out'Range(1) loop
      for j in data_out'Range(2) loop
        for k in data_out'Range(3) loop
          temporal := 0.0;

          for m in 1 .. i loop
            for n in 1 .. j loop
              for p in 1 .. k loop
                temporal := temporal + data_a_in(m, n, p) * data_b_in(i-m, j-n, k-p);

                data_out(i, j, k) := temporal;
              end loop;
            end loop;
          end loop;
        end loop;
      end loop;
    end loop;

  end ntm_tensor_convolution;

  procedure ntm_tensor_inverse (
    data_in : in tensor;
    
    data_out : out tensor
  ) is
  begin
    for i in data_out'Range(1) loop
      for j in data_out'Range(2) loop
        for k in data_out'Range(3) loop
          data_out(i, j, k) := data_in(i, j, k);
        end loop;
      end loop;
    end loop;

  end ntm_tensor_inverse;

  procedure ntm_tensor_matrix_convolution (
    data_a_in : in tensor;
    data_b_in : in matrix;
    
    data_out : out matrix
  ) is
    temporal : float;
  begin
    for i in data_a_in'Range(1) loop
      for j in data_a_in'Range(2) loop
        for k in data_a_in'Range(3) loop
          temporal := 0.0;

          for m in 1 .. i loop
            for n in 1 .. j loop
              for p in 1 .. k loop
                temporal := temporal + data_a_in(m, n, p) * data_b_in(i-m, j-n);

                data_out(i, j) := temporal;
              end loop;
            end loop;
          end loop;
        end loop;
      end loop;
    end loop;

  end ntm_tensor_matrix_convolution;

  procedure ntm_tensor_matrix_product (
    data_a_in : in tensor;
    data_b_in : in matrix;
    
    data_out : out matrix
  ) is
    temporal : float;
  begin
    for i in data_a_in'Range(1) loop
      for j in data_a_in'Range(2) loop
        for k in data_a_in'Range(3) loop
          for m in data_a_in'Range(3) loop
            temporal := temporal + data_a_in(i, j, m) * data_b_in(i, m);

            data_out(i, j) := temporal;
          end loop;
        end loop;
      end loop;
    end loop;

  end ntm_tensor_matrix_product;

  procedure ntm_tensor_multiplication (
    data_in : in array4;
    
    data_out : out tensor
  ) is
  begin
    for i in data_out'Range(1) loop
      for j in data_out'Range(2) loop
        for k in data_out'Range(3) loop
          data_out(i, j, k) := 1.0;

          for t in data_in'Range(4) loop
            data_out(i, j, k) := data_out(i, j, k) * data_in(i, j, k, t);
          end loop;
        end loop;
      end loop;
    end loop;

  end ntm_tensor_multiplication;

  procedure ntm_tensor_product (
    data_a_in : in tensor;
    data_b_in : in tensor;
    
    data_out : out tensor
  ) is
    temporal : float;
  begin
    for i in data_out'Range(1) loop
      for j in data_out'Range(2) loop
        for k in data_out'Range(3) loop
          for m in data_a_in'Range(3) loop
            temporal := temporal + data_a_in(i, j, m) * data_b_in(i, m, k);

            data_out(i, j, k) := temporal;
          end loop;
        end loop;
      end loop;
    end loop;

  end ntm_tensor_product;

  procedure ntm_tensor_summation (
    data_in : in array4;
    
    data_out : out tensor
  ) is
  begin
    for i in data_out'Range(1) loop
      for j in data_out'Range(2) loop
        for k in data_out'Range(3) loop
          data_out(i, j, k) := 0.0;

          for t in data_in'Range(4) loop
            data_out(i, j, k) := data_out(i, j, k) + data_in(i, j, k, t);
          end loop;
        end loop;
      end loop;
    end loop;

  end ntm_tensor_summation;

  procedure ntm_tensor_transpose (
    data_in : in tensor;
    
    data_out : out tensor
  ) is
   begin
    for i in data_out'Range(1) loop
      for j in data_out'Range(2) loop
        for k in data_out'Range(3) loop
          data_out(i, j, k) := data_in(i, k, j);
        end loop;
      end loop;
    end loop;

  end ntm_tensor_transpose;

end ntm_tensor_algebra;
