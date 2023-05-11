global class CleanAccounts implements Database.Batchable<sObject>{
	public String query;
	global CleanAccounts(){
		this.query='SELECT ID, Inativa__c FROM ACCOUNT';
	}
	global Database.QueryLocator start(Database.BatchableContext BC){
		// collect the batches of records or objects to be passed to execute
		return Database.getQueryLocator(query);
	}
	global void execute(Database.BatchableContext BC, List<sObject> scope){
		// process each batch of records
        List<Account> lAcc = (List<Account>) scope;
        List<Account> updAcc = new List<Account>();
        
        for(Account s: lAcc){
            if(!s.Inativa__c && accountIsInactive(s)){ //validando Inativa__c para não executar o update caso a conta já seja inativa
                s.Inativa__c = true;
                try{
                    update s;
                }catch(Exception ex){
                    System.debug(ex.getMessage());
                }
            }
        }
        
	}
	global void finish(Database.BatchableContext BC){
		// execute any post-processing operations
	}

    private boolean accountIsInactive(Account a){
        System.debug('@@@ VALIDANDO: '+a.Id);
        Boolean TaskInactive = [SELECT ID, ActivityDate, AccountId 
                                FROM Task 
                                WHERE ActivityDate > LAST_90_DAYS 
                                AND AccountId =:a.Id].size() == 0 ? true : false;

        Boolean OppInactive = [SELECT ID, AccountId, StageName, LastStageChangeDate 
                                FROM Opportunity 
                                WHERE (LastStageChangeDate  > LAST_N_DAYS:120 
                                AND AccountId =:a.Id 
                                AND StageName =:'Closed Won') OR StageName =:'Negotiation/Review'].size() == 0 ? true : false;
        
        if(TaskInactive && OppInactive){
            System.debug('@@@ INATIVANDO: '+a.Id);
            return true;
        }
        return false; //Ambos devem ser true para inativar uma conta
    }
}