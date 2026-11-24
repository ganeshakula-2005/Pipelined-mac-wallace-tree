#include <stdio.h>
#define NUM_COLS  32
int main(){

    int cur_col_lens[NUM_COLS] = {1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9};
    int num_fa = 0;
    int num_ha = 0;
    for (int i = 0; i < 5; i++){
        int next_col_lens[32];
        int flag_carry[32];
        //int prev_n_ha = 0;

        for (int col = 0; col < NUM_COLS; col++){
            
            int n_fa = cur_col_lens[col] / 3;
            int rem = cur_col_lens[col] % 3;
            //int n_ha = (col > 0)?(((rem == 2) && (flag_carry[col - 1] == 1)) ? 1 : 0 ): 0;
            int n_pass = (rem == 1) ? 1 :(rem == 2) ? 2 : 0;
            //flag_carry[col] = ((n_ha >= 1)|(n_fa >= 1))? 1 : 0;
            int carries_in = 0;
            /*

            int n_fa = cur_col_lens[col] / 3;
            int rem = cur_col_lens[col] % 3;
            int n_ha = (rem == 2)? 1 : 0;
            int n_pass = (rem == 1) ? 1 : 0;
            int carries_in = 0;
            */
            if (col > 0) {
                carries_in = (cur_col_lens[col - 1] / 3 );
            }
            //prev_n_ha = n_ha;
            next_col_lens[col] = n_fa + n_pass + carries_in;

            //printf("stage - %d, col - %d, n_fa = %d, n_ha = %d, n_pass = %d, carries_in = %d",i, col, n_fa, n_ha, n_pass, carries_in);
            //printf("\n");
            num_fa += n_fa;
           // num_ha += n_ha;

        }
        for (int j = 0;j < 32; j++){
            cur_col_lens[j] = next_col_lens[j];
        }

        for (int j = 0;j < 32; j++){
            printf("%d ",cur_col_lens[j]);
        }
        printf("\n");
    }

    printf("fulladder = %d, halfadder = %d",num_fa,num_ha);

}