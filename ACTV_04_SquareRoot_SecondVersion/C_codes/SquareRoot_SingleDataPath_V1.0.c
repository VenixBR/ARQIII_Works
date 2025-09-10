#include <stdio.h>

int main(){
    int input  = 100;
    int root   = 0;
    int square = 1;
    int ready  = 1;
    int cicles = 1;
    
        printf("\nPlease, type a input value: ");
        scanf("%d", &input);
        
    while(!(input-square < 0)){
        // printf("\nroot   : %d\n" , root);
        // printf("square : %d\n" , square);
        root   = root + 1;
        square = square + (root<<1)+1;
        cicles += 2;
        
    }
    ready = 0;
    
    printf("\nThe square root is    : %d", root);
    printf("\nNumber of clock cicles: %d\n\n", cicles);
}


