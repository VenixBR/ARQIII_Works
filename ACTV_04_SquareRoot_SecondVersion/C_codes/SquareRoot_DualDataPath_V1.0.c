#include <stdio.h>

int main(){
    int input   = 100;
    int root;
    int root1   = 0;
    int root2   = 1;
    int square1 = 1;
    int square2 = 4;
    int ready  = 1;
    int cicles = 1;
    int N1=1, N2=1;
    int used;
    
        printf("\nPlease, type a input value: ");
        scanf("%d", &input);
        
    while(!(N1 < 0) && !(N2 < 0)){
        // printf("\nroot1   : %d\n" , root1);
        // printf("\nroot2   : %d\n" , root2);
        // printf("square1 : %d\n" , square1);
        // printf("square2 : %d\n" , square2);
        root1   = root1 + 2;
        root2   = root2 + 2;
        square1 = square1 + (root1<<2);
        square2 = square2 + (root2<<2);
        cicles += 2;
        
        N1 = input-square1;
        N2 = input-square2;    
    }
    
    if (N1<0){
      used = 1;
      root = root1;
    } else {
      used = 2;
      root = root2;
    }
    
    printf("\nThe square root is    : %d", root);
    printf("\nFound by DataPath     : %d", used);
    printf("\nNumber of clock cicles: %d\n\n", cicles);
}


