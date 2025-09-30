#include <stdio.h>

int main(){
    int input  = 100;
    int root   = 1;
    int square = 0;
    
    int root2  = 2;
    int square2 = 1;
    
    int root3  = 3;
    int square3 = 4;
    
    int root4  = 4;
    int square4 =9;
    
    int ready  = 1;
    int cicles = 1;
    
        printf("\nPlease, type a input value: ");
        scanf("%d", &input);
        
        printf("\nroot1   : %d\n" , root);
         printf("square1 : %d\n" , square);
         printf("root2   : %d\n" , root2);
         printf("square2 : %d\n" , square2);
         printf("root3   : %d\n" , root3);
         printf("square3 : %d\n" , square3);
         printf("root4   : %d\n" , root4);
         printf("square4 : %d\n" , square4);
        
    while(!(input-square < 0||input-square2 < 0 || input-square3 < 0 || input-square4 < 0)){
         
         
        
        square = square + (root<<3)+8;
        square2 = square2 + (root2<<3)+8;
        square3 = square3 + (root3<<3)+8;
        square4 = square4 + (root4<<3)+8;
        root   = root + 4;
        root2   = root2 + 4;
        root3   = root3 + 4;
        root4   = root4 + 4;
        cicles += 1;
        
        printf("\nroot1   : %d\n" , root);
         printf("square1 : %d\n" , square);
         printf("root2   : %d\n" , root2);
         printf("square2 : %d\n" , square2);
         printf("root3   : %d\n" , root3);
         printf("square3 : %d\n" , square3);
         printf("root4   : %d\n" , root4);
         printf("square4 : %d\n" , square4);
        
    } 
    //root = root -1;
    ready = 0;
    
    printf("\nThe square root is    : %d", root);
    printf("\nNumber of clock cicles: %d\n\n", cicles);
}


