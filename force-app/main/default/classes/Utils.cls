public with sharing class Utils {
    public Utils() {

    }

    public Boolean validaCPF(String CPF){
        if(!String.isEmpty(CPF))
            return true;
        else
            return false;
    }

    public Boolean validaCNPJ(String CNPJ){
        if(!String.isEmpty(CNPJ))
            return true;
        else
            return false;
    }

    public Boolean accountIsPartner(Account acc){
        if(acc.Type.contains('Partner') || acc.Type.contains('Parceiro')){
            return true;
        }
        return false;
    }

    public Boolean accountIsFinalCustomer(Account acc){
        if(acc.Type.contains('Customer') || acc.Type.contains('Cliente final')){
            return true;
        }
        return false;
    }
}