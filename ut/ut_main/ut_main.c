#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <libgen.h>
#include <stdarg.h>
#include <xlocale.h>

#include <time.h>
#include <sys/utsname.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>
#include <ftw.h>
#include <signal.h>
#include <dlfcn.h>
#include "CUnit/Basic.h"

int i_ftw_cb( const char* s_filename, const struct stat* t_info, int i_flag );

void vDumpStored( void );

#if 0
/**
 * 
**/
void
    vExitMessage( int i_code, void* p )
{
    fflush(stdout);
    fflush(stderr);
    printf( "Shutting down unit testing.\n" );

    if( i_code )
    {
        printf( "A test has caused a premature end to unit testing. Check log messages files\n" );
    }
}

void fail_handler( int i )
{
    /* fatal errors during unit testing can be communicated via */
    /* the return code, instead of forcing an assertion failure */
    /* CU_FAIL( "A function requested that the chain should exit." ); */
}
#endif

int
    iInitSystem( void )
{

    return EXIT_SUCCESS;
}

int
    main( int argc, char** argv )
{
	char* pc_lib_search_path = dirname(argv[0]);

    if( argc != 1 )
    {
        perror( "Not expecting command line arguments." );
        return 1;
    }
    
    iInitSystem();

    /* initialize the CUnit test registry */
    if( CUE_SUCCESS != CU_initialize_registry( ) )
        return CU_get_error( );

    printf( "Loading unit test libraries from beneath %s:\n", pc_lib_search_path );
    int i_result = ftw( pc_lib_search_path, i_ftw_cb, 10 );
    
    if( i_result != 0 )
    {
        perror( "Something went wrong while looking for tests." );
        return 1;
    }
    
    printf( "done.\n\n" );
    printf( "Performing unit testing on src revision %s on %s\n\n", "unknown", "datestamp" );

    /* Run all tests using the CUnit Basic interface */
    printf( "Starting to perform unit testing.\n\n" );
    CU_basic_set_mode( CU_BRM_VERBOSE );
    CU_basic_run_tests( );
    CU_cleanup_registry( );
    return CU_get_error( );
    return(EXIT_SUCCESS);
}

int
    i_ftw_cb( const char* s_filename, const struct stat* t_info, int i_flag )
{
    if( strstr( s_filename, ".so" ) && (i_flag == FTW_F ) )
    {
        printf( " * %s %zd bytes\n", s_filename, t_info->st_size );
		
        void* handle = NULL ;
        int (*sub_main)() = NULL;
		
        handle = dlopen( s_filename, RTLD_LAZY );
        if( !handle )
        {
            fprintf( stderr, "getting_handle %s\n", dlerror( ) );
            exit( 1 );
        }
        
        sub_main = dlsym( handle, "sub_main" );
        if( !sub_main )
        {
            fprintf( stderr, "getting sub_main %s\n", dlerror( ) );
            exit( 1 );
        }
		
		/* Register the test with CUnit */
        (*sub_main)();
		
        /* Don't dlclose(handle) as it will unload the library */
    }

    return 0;
}