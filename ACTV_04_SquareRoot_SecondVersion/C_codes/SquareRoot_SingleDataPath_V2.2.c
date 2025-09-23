#include <stdio.h>

int main(){
    int input  = 100;
    int root   = 0;
    int square1 = 0;
    int square2 = 1;
    int ready  = 1;
    int cicles = 1;
    int temp   = 0;
    
        printf("\nPlease, type a input value: ");
        scanf("%d", &input);

	printf("\nroot   : %d\n" , root);
        printf("square : %d\n" , square1);
        
    while(!(input-square1 < 0)){
         
        
	temp = square2;
        square2 = square1 + (root<<2);
	square1 = temp;
        root   = root + 1;
        cicles += 1;
        
    } 
    ready = 0;
    root = root - 1;
    
    printf("\nThe square root is    : %d", root);
    printf("\nNumber of clock cicles: %d\n\n", cicles);
}


