package wallace_pkg;

    parameter int NUM_COLS = 32;
    typedef int col_lens_t[NUM_COLS];

    function automatic col_lens_t get_next_col_size(col_lens_t cur_col_lens);

        col_lens_t next_col_lens;

        for (int col = 0; col < NUM_COLS; col++)
        begin
            int n_fa = cur_col_lens[col] / 3;
            int rem = cur_col_lens[col] % 3;
            //bit has_incoming_carry = (col > 0) ? ((cur_col_lens[col - 1] > 2) ? 1 : 0) : 0;
            //int n_ha = (rem == 2 && has_incoming_carry) ? 1 : 0;
            int n_pass = (rem == 1) ? 1 :(rem == 2 ) ? 2 : 0;
    
            int carries_in = 0;
    
            if (col > 0) 
            begin
                carries_in = (cur_col_lens[col - 1] / 3 );
            end

            next_col_lens[col] = n_fa  + n_pass + carries_in;

        end

        return next_col_lens;
    endfunction 

    typedef bit bit_array[NUM_COLS];
    function automatic bit_array expect_carry(col_lens_t cur_col_lens);
    
    bit_array flag_if_carry;

    for (int col = 0; col < NUM_COLS; col++)
    begin

        int n_fa = cur_col_lens[col] / 3;
        int rem = cur_col_lens[col] % 3;
        bit has_incoming_carry = (col > 0) ? ((cur_col_lens[col - 1] > 2) ? 1 : 0) : 0;
        int n_ha = (rem == 2 && has_incoming_carry) ? 1 : 0;

        if (col > 0)
        begin 
            if ((n_fa != 0) | (n_ha == 1 && flag_if_carry[col - 1]))
            begin 

                flag_if_carry[col] = 1'b1;

            end
        end
        else
            flag_if_carry[col] = 1'b0;
            
    end

    return flag_if_carry;

    endfunction 
endpackage
