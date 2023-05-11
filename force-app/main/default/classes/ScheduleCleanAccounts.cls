global class ScheduleCleanAccounts implements Schedulable{
    public List<String> Schedules = 
                new List<String>{'0 0 0 ? * MON,TUE,WED,THU,FRI *', 
                                 '0 0 6 ? * MON,TUE,WED,THU,FRI *',
                                 '0 0 12 ? * MON,TUE,WED,THU,FRI *',
                                 '0 0 18 ? * MON,TUE,WED,THU,FRI *'};

    global void execute(SchedulableContext sc) {
        // This is good practice if you are likely to be processing a
        // lot of records at a time
        CleanAccounts b = new CleanAccounts();
        Database.executeBatch(b);
    }
}
