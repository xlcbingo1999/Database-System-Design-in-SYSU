-- 第一题
SELECT AVG(o.o_ol_cnt) FROM bmsql_oorder AS o INNER JOIN bmsql_customer as c ON c.c_id = o.o_c_id AND c.c_credit = 'GC' AND c.c_discount > 0.3;

-- 第二题
SELECT w_id FROM bmsql_warehouse WHERE w_tax > (SELECT MIN(w.w_tax) FROM bmsql_warehouse AS w WHERE exists (SELECT s.s_w_id,s.s_i_id FROM bmsql_stock AS s WHERE exists (SELECT i.i_id,i.i_name FROM bmsql_item AS i WHERE i.i_name ~ '^sp' AND i.i_id = s.s_i_id) AND w.w_id = s.s_w_id));

-- 第三题（嵌套代码）
SELECT i.i_name FROM (SELECT stockPerItem.s_i_id W FROM (SELECT s_i_id, COUNT(s_w_id) FROM bmsql_stock GROUP BY s_i_id)stockPerItem(s_i_id,count_of_per_item) WHERE exists (SELECT * FROM (SELECT COUNT(*) FROM bmsql_warehouse)NumOfWarehouse(count_of_warehouse) WHERE NumOfWarehouse.count_of_warehouse = stockPerItem.count_of_per_item))ALLids INNER JOIN (SELECT i_name,i_id FROM bmsql_item WHERE i_name ~'^sp')i ON i.i_id = ALLids.s_i_id;

-- 第三题（拼表代码）
SELECT i_name FROM bmsql_item i INNER JOIN (SELECT s_i_id, COUNT(s_w_id) FROM (bmsql_stock s INNER JOIN bmsql_warehouse w ON s.s_w_id = w.w_id) INNER JOIN bmsql_item ii ON s.s_i_id = ii.i_id AND ii.i_name ~ '^sp' GROUP BY s_i_id) stockPerItem(id, count_of_per_item) ON i.i_id = stockPerItem.id AND exists (SELECT * FROM (SELECT COUNT(*) FROM bmsql_warehouse)NumOfWarehouse(count_of_warehouse) WHERE NumOfWarehouse.count_of_warehouse = stockPerItem.count_of_per_item);

-- 第四题
SELECT o_w_id, COUNT(o_ol_cnt) FROM bmsql_oorder WHERE o_ol_cnt > 10 GROUP BY o_w_id;

-- 第五题（嵌套代码）
SELECT DISTINCT i.i_name FROM (SELECT DISTINCT s_i_id FROM (SELECT s.s_i_id FROM bmsql_stock AS s WHERE exists (SELECT w.w_id FROM bmsql_warehouse AS w WHERE w.w_id = s.s_w_id AND w.w_tax < 0.02))q WHERE exists (SELECT s1.s_i_id FROM bmsql_stock AS s1 WHERE exists (SELECT w1.w_id FROM bmsql_warehouse AS w1 WHERE w1.w_id = s1.s_w_id AND w1.w_tax > 0.13) AND q.s_i_id = s1.s_i_id))x INNER JOIN bmsql_item AS i ON i.i_id = x.s_i_id;

-- 第五题（拼表代码）
SELECT COUNT(t1.name) FROM (SELECT DISTINCT i_name FROM (bmsql_stock INNER JOIN bmsql_warehouse ON s_w_id = w_id AND w_tax < 0.02) INNER JOIN bmsql_item ON s_i_id = i_id) t1(name) INNER JOIN (SELECT DISTINCT i_name FROM (bmsql_stock INNER JOIN bmsql_warehouse ON s_w_id = w_id AND w_tax > 0.13) INNER JOIN bmsql_item ON s_i_id = i_id) t2(name) ON t1.name = t2.name;