/* 
 @<COPYRIGHT>@
 ==================================================
 Copyright 2012
 Siemens Product Lifecycle Management Software Inc.
 All Rights Reserved.
 ==================================================
 @<COPYRIGHT>@
*/

#include <unidefs.h>
#if defined(SUN)
#include <unistd.h>
#endif

#include <tcobjectsync2206impl.hxx>

using namespace J9::Soa::TCJira_ObjectSync::_2022_06;
using namespace Teamcenter::Soa::Server;



TcObjectSyncImpl::OUTPUT TcObjectSyncImpl::tcObjectSyncOperation ( const INPUTMAP& /*mapInput*/ )
{


			OUTPUT outvalue;
			//outvalue.outputValue = globalErrorString; // Return the collected error messages
			outvalue.outputValue = "testing custom soa"; // Return the collected error messages

			return outvalue;
}

