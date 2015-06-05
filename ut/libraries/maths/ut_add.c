#include "add.h"

#include "CUnit/Basic.h"


/* test names and corresponding functions */

#define TESTNAME_NORMAL         "Normal test"
void v_maths_test_normal( void );


int
init_suite_1( void )
{

    return CUE_SUCCESS;
}

int
clean_suite_1( void )
{

    return CUE_SUCCESS;
}

CU_ErrorCode
sub_main( )
{
    CU_pSuite pSuite = NULL;

    /* add a suite to the registry */
    pSuite = CU_add_suite( "Test of maths", init_suite_1, clean_suite_1 );

    if( NULL == pSuite )
    {
        CU_cleanup_registry( );
        return CU_get_error( );
    }

    /* add the tests to the suite */
    if( (NULL == CU_add_test( pSuite, TESTNAME_NORMAL,
                              v_maths_test_normal )) )
    {
        CU_cleanup_registry( );
        return CU_get_error( );
    }
    
    return CUE_SUCCESS;
}

void v_maths_test_normal( void )
{
    int result = add( 2, 3 );
    CU_ASSERT_EQUAL( result, 5 );
}