#include <stdio.h>
#include <stdlib.h>

#include "add.h"

int main( int argc, char* argv[] )
{
    int result = -1;
    
    /* Make sure arguments are used to prevent warnings */
    if( argc != 1 )
    {
        perror( "I wasn't expecting any arguments" );
        exit(1);
    }
    
    printf("Hello world! From %s.\n", argv[0] );
    
    result = add( 2, 3 );
    
    printf( "result = %d\n", result );
    
    return 0;
}