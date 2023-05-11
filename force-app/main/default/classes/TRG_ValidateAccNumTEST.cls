@isTest
private class TRG_ValidateAccNumTEST {
    private static List<Account> testSetup(){
        List<Account> lAcc = new List<Account>();
        Account acc = new Account(
            Name = 'CPF test',
            AccountNumber = '123',
            Type = 'CPF'
        );
        lAcc.add(acc);
        Account acc1 = new Account(
            Name = 'CNPJ test',
            AccountNumber = '456',
            Type = 'CNPJ'
        );
        lAcc.add(acc1);
        Account acc2 = new Account(
            Name = 'Parceiro test',
            AccountNumber = '789',
            Type = 'Parceiro'
        );
        lAcc.add(acc2);
        Account acc3 = new Account(
            Name = 'Cliente final test',
            AccountNumber = 'ABC',
            Type = 'Cliente final'
        );
        lAcc.add(acc3);
        return lAcc;
    }

    @isTest
    static void TestSingleInsert(){
        
        Account acc = new Account(
            Name = 'TestSingleInsert',
            AccountNumber = '123',
            Type = 'CPF'
        );
        insert acc;

        List<Account> res = new List<Account>();
        
        res = [select id from Account Where Name =:'TestSingleInsert'];
        
        System.assertEquals(true, res.size() == 1, 'Expected: Possui 1 registro');
    }

    @isTest
    static void TestFailCPFSingleInsert(){
        
        Account acc = new Account(
            Name = 'TestFailCPFSingleInsert',
            AccountNumber = '',
            Type = 'CPF'
        );
        try{
            insert acc;
        }catch(Exception ex){
            System.assertEquals(false, String.isEmpty(ex.getMessage()),'Expected: Possui mensagem de erro (CPF)');
        }
        
    }

    @isTest
    static void TestFailCNPJSingleInsert(){
        
        Account acc = new Account(
            Name = 'TestFailCNPJSingleInsert',
            AccountNumber = '',
            Type = 'CNPJ'
        );
        try{
            insert acc;
        }catch(Exception ex){
            System.assertEquals(false, String.isEmpty(ex.getMessage()),'Expected: Possui mensagem de erro (CNPJ)');
        }
    }

    @isTest
    static void TestMultipleInsert(){
        
        insert testSetup();

        List<Account> res = new List<Account>();
        res = [select id from Account];
        System.assertEquals(true, res.size() > 0,'Expected: Possui um conjunto de registros de conta');
    }
    
    @isTest
    static void TestHeavyMultipleInsert(){ //Teste preventivo para validar possíveis erros de limite na org
        List<Account> BigListAccount = new List<Account>();
        for(Integer x=0; x < 50; x++){
            for(Account a : testSetup()){
                BigListAccount.add(a); //estratégia adotada para simular uma grande carga de dados do tamanho de uma batch de 200 registros
            }
        }
        insert BigListAccount;
        List<Account> res = new List<Account>();
        res = [select id from Account];
        System.assertEquals(true, res.size() == BigListAccount.size(),'Expected: Possui um largo conjunto de registros de conta');
    }
}