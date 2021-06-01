delimiter $$
create trigger tri_vendas_ai
after insert on comivenda
for each row
begin
    ## declaro as variáveis que utilizarei
	declare vtotal_itens float(10,2) DEFAULT 0;	
	declare vtotal_item float(10,2);
	declare total_item float(10,2);
    DECLARE qtd_item int DEFAULT 0;
    DECLARE fimloop INT DEFAULT 0;
	
    ## cursor para buscar os itens já registrados da venda
	declare busca_itens cursor for
		select n_totaivenda, n_qtdeivenda
		from comivenda
		where n_numevenda = new.n_numevenda;
	DECLARE CONTINUE HANDLER FOR SQLSTATE '020000' SET FIMLOOP= 1;
    ## abro o cursor
	open busca_itens;
		
        ## declaro e inicio o loop
		itens : loop
        
        IF fimloop = 1 then
			LEAVE itens;
		END IF;
        
    
		fetch busca_itens into total_item, qtd_item;
        
        ## SOMO O VALOR TOTAL DOS ITENS 
        SET vtotal_item = vtotal_item+ qtd_item;
        SET vtotal_itens = vtotal_itens + vtotal_item;
	end loop itens;
close busca_itens;
SET vtotal_item = new.valoivenda* new.qtdeivenda;
UPDATE comvenda set n_totavenda = vtotal_itens -vtotal_item
WHERE n_numevenda = new.n_numevenda;
    
end$$
delimiter ;