#include <stdio.h>

int main(){
    int root, sum_2, square, ready, input=49;
    root   = 1;
    sum_2  = 2;
    square = 4;
    ready  = 1;
    
    printf("\nPlease, type a input value: ");
    scanf("%d", &input);
        
    while(ready == 1){
        // printf("\nroot   : %d\n" , root);
        // printf("square : %d\n" , square);
        root   = root+1;
        sum_2  = sum_2+2;
        square = square + sum_2 + 1;
        if(input-square < 0)
            ready = 0;
        else
            ready = 1;
    }
    
    printf("\nThe square root is    : %d", root);
}


