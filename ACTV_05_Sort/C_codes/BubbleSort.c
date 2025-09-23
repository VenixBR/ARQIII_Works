#include <stdlib.h>
#include <stdio.h>
#include <time.h>

void main(){
    srand(time(NULL));
    
    int n = 10;
    int values[n];
    int temp;
    
    for(int i=0 ; i<n ; i++){
        values[i] = rand();
        printf("Value %d: %d\n", i, values[i]);
    }

    for(int i=0 ; i<n ; i++){
        for(int j=0; j<n ; j++){
            if(values[j]>values[j+1]){
                temp = values[j];
                values[j] = values[j+1];
                values[j+1] = temp;
            }
        }
    }

    printf("\n");
    for(int i=0 ; i<n ; i++){
        printf("Value %d: %d\n", i, values[i]);
    }
}
