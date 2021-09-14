DELIMITER $$
DROP PROCEDURE IF EXISTS buy_item;

CREATE PROCEDURE buy_item(IN user varchar(50))

BEGIN
	DECLARE done INTEGER DEFAULT 0;
	DECLARE v_cnt INTEGER DEFAULT 0;
    DECLARE v_price INTEGER DEFAULT 0;
    DECLARE v_size varchar(10);
    DECLARE v_code char(10);


    
    DECLARE cur_basket CURSOR FOR SELECT cnt, price,size, p_code from basket where id=user;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = true;
	OPEN cur_basket;    
	    read_loop:LOOP
        	FETCH cur_basket INTO v_cnt, v_price, v_size, v_code;
            
            IF done THEN
                LEAVE read_loop;
            END IF;

            update user set buy_cnt=buy_cnt-v_cnt, buy_amount=buy_amount-v_price where username=user;

            update p_stock set p_cnt=p_cnt-v_cnt where p_code=v_code and p_size=v_size;
        END LOOP read_loop;
    CLOSE cur_basket;

    DELETE FROM basket WHERE id=user;
END;
$$
DELIMITER ;