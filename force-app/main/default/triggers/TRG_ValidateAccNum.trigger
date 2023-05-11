trigger TRG_ValidateAccNum on Account (before insert, before update) {
    Utils utils = new Utils();
    String msg = 'Número do cliente é inválido';
    Integer offset = 30;

    for(Account a : Trigger.new){
        
        if(a.Type == 'CNPJ'){
            if(!utils.validaCNPJ(a.AccountNumber)){
                a.addError(msg);
            }
        }else if(a.Type == 'CPF'){
            if(!utils.validaCPF(a.AccountNumber)){
                a.addError(msg);
            }
        }else if(utils.accountIsPartner(a)){
            Opportunity opp = new Opportunity(
                Name = a.Name + ' - opp Parceiro',
                CloseDate = Date.today().addDays(offset),
                StageName = 'Qualification'
            );
            insert opp;
        }else if(utils.accountIsFinalCustomer(a)){
            Task tsk = new Task(
                Subject = 'Consumidor Final',
                WhatId = a.Id,
                Status = 'Not Started', //Org em inglês
                Priority = 'Normal'
            );
            insert tsk;
        }
    }    
}