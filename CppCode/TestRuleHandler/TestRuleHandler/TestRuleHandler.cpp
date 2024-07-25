#include<stdio.h>
#include<tccore/aom.h>
#include<tc/emh.h>
#include<tc/tc_startup.h>
#include <tccore/custom.h>
#include <user_exits/epm_toolkit_utils.h>
#include <ict/ict_userservice.h>
#include<epm/epm.h>
#include<epm/epm.h>

EPM_decision_t Rule_ask_responsible_party(EPM_rule_message_t msg)
{
	int status;

	/*int s;*/
	EPM_decision_t decision;
	/*char *userName;
	tag_t aUserTag, respnsibleParty;
	status = EPM_ask_responsible_party(msg.task, &respnsibleParty);*/

	tag_t job_tag = NULLTAG;
	tag_t root_task_tag = NULLTAG;
	tag_t* attachments_tag = NULL;
	tag_t owningUser = NULLTAG;
	char** StrSysCmd = NULL;
	char* object_type = NULL;
	int attachment_count = 0;
	int attachment_type = EPM_target_attachment;
	status = EPM_ask_job(msg.task, &job_tag); //// used to get workflow
	status = EPM_ask_root_task(job_tag, &root_task_tag); // used to get task from workflow
	status = EPM_ask_attachments(root_task_tag, attachment_type, &attachment_count, &attachments_tag); //used to get attachements which are present in target
	for (int i = 0; i < attachment_count; i++)
	{
		status = WSOM_ask_object_type2(attachments_tag[i], &object_type);
		printf(object_type);

		if (tc_strcmp(object_type, "Dataset") == 0)
		{
			printf("hogyare babababab");
			decision = EPM_go;
		}
		else
		{
			printf("nahi huware bababab");
			decision = EPM_nogo;
		}
	}

	return decision;
}

extern "C" int RuleHandlerCheckDataset_register_custom_handlers(int* decision, va_list args)
{
	int rcode = ITK_ok;
	*decision = ALL_CUSTOMIZATIONS;
	rcode = EPM_register_rule_handler("RuleDS", "this is Rule handler test", Rule_ask_responsible_party);
	printf("registings start_________________________");
	if (rcode == ITK_ok)
		fprintf(stdout, "Rule Handler check dataset successfully registered!\n");
	else
		fprintf(stdout, "Rule Handler check dataset not registered!\n");
		fprintf(stdout, "Check the dataset attachment!\n");
	return rcode;

}
extern "C" DLLAPI int RuleHandlerCheckDataset_register_callbacks()
{
	CUSTOM_register_exit("RuleHandlerCheckDataset", "USER_gs_shell_init_module", (CUSTOM_EXIT_ftn_t)RuleHandlerCheckDataset_register_custom_handlers);
	return(ITK_ok);
}