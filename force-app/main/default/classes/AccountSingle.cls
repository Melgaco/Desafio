public with sharing class AccountSingle {
	@AuraEnabled
	public static List<Account> getTasks() {
		return [SELECT Id, Name, AccountNumber, Type FROM Account WITH SECURITY_ENFORCED LIMIT 1];
	}
}