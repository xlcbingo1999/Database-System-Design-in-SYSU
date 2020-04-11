/* question 1*/
SELECT d.D_ID,d.D_NAME FROM (SELECT W_ID,W_TAX FROM bmsql_warehouse WHERE W_TAX > 0.18)w INNER JOIN (SELECT D_ID,D_NAME,D_W_ID,D_TAX FROM bmsql_district WHERE D_TAX < 0.1)d ON w.W_ID = d.D_W_ID;

/* question 2*/
SELECT DISTINCT w.w_name FROM (SELECT w_id,w_name FROM bmsql_warehouse)w INNER JOIN (SELECT h_c_id,h_w_id FROM bmsql_history)h ON w.w_id = h.h_w_id INNER JOIN (SELECT c_id FROM bmsql_customer WHERE c_state='GD' AND c_credit='GC')c ON h.h_c_id = c.c_id;

/* question 3*/
SELECT C_FIRST,C_MIDDLE,C_LAST,C_DISCOUNT FROM bmsql_customer WHERE C_CREDIT = 'BC' AND C_DISCOUNT = 0.1000;


/* question 4*/
SELECT i.I_NAME,w.W_NAME,s.S_QUANTITY FROM (SELECT I_NAME,I_ID FROM bmsql_item)i INNER JOIN (SELECT S_W_ID,S_I_ID,S_QUANTITY FROM bmsql_stock WHERE S_QUANTITY < 12)s ON s.S_I_ID=i.I_ID INNER JOIN (SELECT W_ID,W_NAME FROM bmsql_warehouse)w ON s.S_W_ID=w.W_ID;

/* question 5*/
SELECT w.W_STATE,w.W_CITY FROM (SELECT D_W_ID,D_STATE FROM bmsql_district WHERE D_STATE='GD')d INNER JOIN (SELECT W_ID,W_CITY,W_STATE FROM bmsql_warehouse)w ON w.W_ID = d.D_W_ID;



