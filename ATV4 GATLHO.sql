DELIMITER §§
Create Trigger tri_vendas_ai
After Insert On comivenda
For Each Row
Begin
    ## declaro as variáveis que utilizarei
	Declare 	num_itens 		int DEFAULT 0;
    Declare 	vtotal_itens 	float(10,2) DEFAULT 0;	
	Declare 	vtotal_item 	float(10,2);
	Declare 	total_item 		float(10,2);
    Declare 	endloop 		INT DEFAULT 0;
	
    ## cursor para buscar os itens já registrados da venda
	
    Declare 		busca_itens 		Cursor For
		Select 		n_totaivenda,		 n_qtdeivenda
		From 		comivenda
		where 		n_numevenda = 		New.n_numevenda;
        
	DECLARE CONTINUE HANDLER FOR SQLSTATE '020000' SET FIMLOOP= 1;
    
    ## abro o cursor
	Open busca_itens;
		
        ## declaro e inicio o loop
		itens : Loop
        
        IF endloop = 1 Then
			Leave itens;
		End If;
        
    
		Fetch busca_itens Into total_item, num_itens;
        
        ## SOMO O VALOR TOTAL DOS ITENS 
			Set vtotal_item = vtotal_item+ num_itens;
			Set vtotal_itens = vtotal_itens + vtotal_item;
            
		End Loop itens;
        
	Close busca_itens;
    
Set vtotal_item = New.valoivenda* New.qtdeivenda;
Update comvenda Set n_totavenda = vtotal_itens -vtotal_item
Where n_numevenda = New.n_numevenda;
    
End §§
delimiter ;