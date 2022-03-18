/*---------------------------------------------*/      
    /*-------------Tbl_Log_Webservice--------------*/      
    /*------------Approved/4 months----------------*/    
    Declare @limitDate DateTime = Dateadd([Mm] , -4 , Getdate());    
    Set @rowNumber = 1;    
    While @rowNumber > 0    
    Begin    
    Delete Top (100000)    
    From [Tbl_Log_Webservice]    
    Where     
     [Createddate] < @limitDate;    
    Set @rowNumber = @@rowCount;    
    End;    
    Update Statistics [Tbl_Log_Webservice]; 