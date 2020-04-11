

# 数据库  Homework2

> 18软件工程教务二班 肖霖畅 18342105

#### 题目一

题目：找出满足下面要求的订单的订单行的平均值：这些订单来自于 信用良好 且 享有折扣大于7折(我们认为6折就大于7折) 的顾客.  

SQL指令：

```SQL
SELECT AVG(o.o_ol_cnt) 
FROM bmsql_oorder AS o INNER JOIN bmsql_customer as c 
ON c.c_id = o.o_c_id AND c.c_credit = 'GC' AND c.c_discount > 0.3;
```

  结果：

![image-20200330212236784](D:\Work and study\Study\大二下-数据库\数据库  Homework2.assets\image-20200330212236784.png)

#### 题目二

题目：请找出满足下面要求的仓库的号码(id)：这些仓库的销售税比某个存有特殊货物的仓库的销售税要高  

SQL指令： 

```SQL
SELECT w_id FROM bmsql_warehouse 
WHERE w_tax > (SELECT MIN(w.w_tax) 
               FROM bmsql_warehouse AS w 
               WHERE exists (SELECT s.s_w_id,s.s_i_id 
                             FROM bmsql_stock AS s 
                             WHERE exists (SELECT i.i_id,i.i_name 
                                           FROM bmsql_item AS i 
                                           WHERE i.i_name ~ '^sp' AND i.i_id = s.s_i_id) 											AND w.w_id = s.s_w_id));
```

  结果：

![image-20200330205854339](C:\Users\12203\AppData\Roaming\Typora\typora-user-images\image-20200330205854339.png)

分析：不小心把w_name和w_tax也放入了，本题先找到含有特殊标志的item，并找到其对应的仓库的销售税的最小值，最后遍历仓库找到销售税比该值大的仓库即可。

#### 题目三

题目：如果一种特殊货物在每个仓库都有存放,那么我们就认为这种货物是完全特殊货物。请找出所有完全特殊货物,输出这些货物的名字  。 

 SQL代码：

1、嵌套代码

```sql
SELECT i.i_name FROM (SELECT stockPerItem.s_i_id W
                      FROM (SELECT s_i_id, COUNT(s_w_id) 
                            FROM bmsql_stock 
                            GROUP BY s_i_id
                           )stockPerItem(s_i_id,count_of_per_item)
					  WHERE exists (
                            SELECT * 
                            FROM (
                                SELECT COUNT(*)
                                FROM bmsql_warehouse
                            )NumOfWarehouse(count_of_warehouse) 
                            WHERE NumOfWarehouse.count_of_warehouse = 													stockPerItem.count_of_per_item
                        )
                     )ALLids 
                     INNER JOIN (
                         SELECT i_name,i_id 
                         FROM bmsql_item 
                         WHERE i_name ~'^sp')i 
                     ON i.i_id = ALLids.s_i_id;
```

结果：

![image-20200330193902578](C:\Users\12203\AppData\Roaming\Typora\typora-user-images\image-20200330193902578.png)

2、拼表代码

```sql
SELECT i_name FROM bmsql_item i 
INNER JOIN 
(SELECT s_i_id, COUNT(s_w_id) 
 FROM (bmsql_stock s
	   INNER JOIN bmsql_warehouse w
	   ON s.s_w_id = w.w_id) 
 INNER JOIN bmsql_item ii
 ON s.s_i_id = ii.i_id AND ii.i_name ~ '^sp'
GROUP BY s_i_id) stockPerItem(id, count_of_per_item) 
ON i.i_id = stockPerItem.id 
AND exists (SELECT * 
			FROM (SELECT COUNT(*)
				  FROM bmsql_warehouse)NumOfWarehouse(count_of_warehouse) 
			WHERE NumOfWarehouse.count_of_warehouse = stockPerItem.count_of_per_item
			);
```

结果：

![image-20200404125459339](D:\Work and study\Study\大二下-数据库\数据库  Homework2.assets\image-20200404125459339.png)

分析：本题先在bmsql_stock表中对每个item对应的warehouse数量进行计算，然后每个数量与warehouse的总数量进行比较后得到在所有仓库都存放着的货物的id，最后与只包含特殊货物的货物表进行拼表，得到结果。

#### 题目四

题目：求出每个仓库那些订单行大于10的订单的数量，输出仓库id和对应的订单数量  。  

SQL语句：

```SQL
SELECT o_w_id, COUNT(o_ol_cnt) 
FROM bmsql_oorder 
WHERE o_ol_cnt > 10 
GROUP BY o_w_id;
```

结果：

![image-20200330194855187](C:\Users\12203\AppData\Roaming\Typora\typora-user-images\image-20200330194855187.png)

分析：直接在bmsql_stock表上对每一个仓库对应大于10行订单行的订单进行求数量，最后输出即可。

#### 题目五

题目：如果一种货物同时存在于多个仓库，且其中某个仓库的销售税小于0.02，另一个仓库的销售税大于0.13,那么我们称这种货物为特殊税货物。请找出所有特殊税货物的名字。

SQL代码：

1、嵌套代码

```sql
SELECT DISTINCT i.i_name 
FROM (SELECT DISTINCT s_i_id 
      FROM (SELECT s.s_i_id 
            FROM bmsql_stock AS s 
            WHERE exists (
                SELECT w.w_id 
                FROM bmsql_warehouse AS w 
                WHERE w.w_id = s.s_w_id AND w.w_tax < 0.02
            )
     )q
	 WHERE exists (
         SELECT s1.s_i_id 
         FROM bmsql_stock AS s1 
         WHERE exists (
             SELECT w1.w_id 
             FROM bmsql_warehouse AS w1 
             WHERE w1.w_id = s1.s_w_id AND w1.w_tax > 0.13
         	) AND q.s_i_id = s1.s_i_id
     	)
     )x 
     INNER JOIN bmsql_item AS i 
 	 ON i.i_id = x.s_i_id;
```

结果：

总数是100000。

![image-20200404130242099](D:\Work and study\Study\大二下-数据库\数据库  Homework2.assets\image-20200404130242099.png)

![image-20200330195434463](C:\Users\12203\AppData\Roaming\Typora\typora-user-images\image-20200330195434463.png)

2、拼表代码

```SQL
SELECT COUNT(t1.name)
FROM (SELECT DISTINCT i_name 
	  FROM (bmsql_stock INNER JOIN bmsql_warehouse
			ON s_w_id = w_id AND w_tax < 0.02) 
	  INNER JOIN bmsql_item 
	  ON s_i_id = i_id) t1(name) 
	  INNER JOIN
		  (SELECT DISTINCT i_name 
		   FROM (bmsql_stock INNER JOIN bmsql_warehouse 
				 ON s_w_id = w_id AND w_tax > 0.13) 
		   INNER JOIN bmsql_item 
		   ON s_i_id = i_id) t2(name) 
	   ON t1.name = t2.name;
```

结果：

![image-20200404135523660](D:\Work and study\Study\大二下-数据库\数据库  Homework2.assets\image-20200404135523660.png)

![image-20200404135438998](D:\Work and study\Study\大二下-数据库\数据库  Homework2.assets\image-20200404135438998.png)

