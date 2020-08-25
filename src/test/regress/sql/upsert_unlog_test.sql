\c upsert
SET CURRENT_SCHEMA TO upsert_test_unlog;
-- enable_upsert_to_merge must be off, or upsert will be translated to merge.
SET enable_upsert_to_merge TO OFF;
SHOW enable_upsert_to_merge;

-- hash table
-- unlogged table without primary key
INSERT INTO t_hash_unlog_0 VALUES(1, 1, 'C3', '{1,2,3}', '{10,20,30,40,50}', ROW(10,20), ROW(100, ROW(10,20), '{100,200}')),
	(1, 2, 'C3', '{1,2,3}', '{10,20,30,40,50}', ROW(10,20), ROW(100, ROW(10,20), '{100,200}'))
	ON DUPLICATE KEY UPDATE NOTHING;
INSERT INTO t_hash_unlog_0 VALUES(2, 3, 'C3', '{1,2,3}', '{10,20,30,40,50}', ROW(10,20), ROW(100, ROW(10,20), '{100,200}')),
	(2, 4, 'C3', '{1,2,3}', '{10,20,30,40,50}', ROW(10,20), ROW(100, ROW(10,20), '{100,200}'))
	ON DUPLICATE KEY UPDATE c2 = 100;

-- unlogged table with primary key
-- multi insert
INSERT INTO t_hash_unlog_1 VALUES(1, 1, 'C3', '{1,2,3}', '{10,20,30,40,50}', ROW(10,20), ROW(100, ROW(10,20), '{100,200}')),
	(1, 2, 'C3', '{1,2,3}', '{10,20,30,40,50}', ROW(10,20), ROW(100, ROW(10,20), '{100,200}'))
	ON DUPLICATE KEY UPDATE NOTHING;
INSERT INTO t_hash_unlog_1 VALUES(2, 3, 'C3', '{1,2,3}', '{10,20,30,40,50}', ROW(10,20), ROW(100, ROW(10,20), '{100,200}')),
	(2, 4, 'C3', '{1,2,3}', '{10,20,30,40,50}', ROW(10,20), ROW(100, ROW(10,20), '{100,200}'))
	ON DUPLICATE KEY UPDATE c1 = EXCLUDED.c1, c3 = EXCLUDED.c3, c4 = EXCLUDED.c4, c5 = EXCLUDED.c5, c6 = EXCLUDED.c6, c7 = EXCLUDED.c7;
SELECT * FROM t_hash_unlog_1 ORDER BY c2;

INSERT INTO t_hash_unlog_1 VALUES(10, 1, 'C30', '{10,20,30}', '{100,200,300,400,500}', ROW(100,200), ROW(1000, ROW(100,200), '{1000,2000}')),
	(11, 2, 'C31', '{11,21,31}', '{101,201,301,401,501}', ROW(101,201), ROW(1001, ROW(101,201), '{1001,2001}'))
	ON DUPLICATE KEY UPDATE NOTHING;
INSERT INTO t_hash_unlog_1 VALUES(20, 3, 'C30', '{10,20,30}', '{10,20,30,40,50}', ROW(100,200), ROW(1000, ROW(100,200), '{1000,2000}')),
	(21, 4, 'C31', '{11,21,31}', '{101,201,301,401,501}', ROW(101,201), ROW(1001, ROW(101,201), '{1001,2001}'))
	ON DUPLICATE KEY UPDATE c1 = EXCLUDED.c1, c3 = EXCLUDED.c3, c4 = EXCLUDED.c4, c5 = EXCLUDED.c5, c6 = EXCLUDED.c6, c7 = EXCLUDED.c7;
SELECT * FROM t_hash_unlog_1 ORDER BY c2;

-- insert and update same tuple, and update twice for another same tuple
INSERT INTO t_hash_unlog_1 VALUES(0, 5, 'C30', '{10,20,30}', '{10,20,30,40,50}', ROW(100,200), ROW(1000, ROW(100,200), '{1000,2000}')),
	(1, 5, 'C31', '{11,21,31}', '{101,201,301,401,501}', ROW(101,201), ROW(1001, ROW(101,201), '{1001,2001}')),
	(10, 1, 'C30', '{10,20,30}', '{100,200,300,400,500}', ROW(100,200), ROW(1000, ROW(100,200), '{1000,2000}')),
	(11, 1, 'C31', '{11,21,31}', '{101,201,301,401,501}', ROW(101,201), ROW(1001, ROW(101,201), '{1001,2001}'))
	ON DUPLICATE KEY UPDATE NOTHING;
SELECT * FROM t_hash_unlog_1 ORDER BY c2;

INSERT INTO t_hash_unlog_1 VALUES(0, 5, 'C30', '{10,20,30}', '{10,20,30,40,50}', ROW(100,200), ROW(1000, ROW(100,200), '{1000,2000}')),
	(1, 5, 'C31', '{11,21,31}', '{101,201,301,401,501}', ROW(101,201), ROW(1001, ROW(101,201), '{1001,2001}')),
	(10, 1, 'C30', '{10,20,30}', '{100,200,300,400,500}', ROW(100,200), ROW(1000, ROW(100,200), '{1000,2000}')),
	(11, 1, 'C31', '{11,21,31}', '{101,201,301,401,501}', ROW(101,201), ROW(1001, ROW(101,201), '{1001,2001}'))
	ON DUPLICATE KEY UPDATE c1 = EXCLUDED.c1, c3 = EXCLUDED.c3, c4 = EXCLUDED.c4, c5 = EXCLUDED.c5, c6 = EXCLUDED.c6, c7 = EXCLUDED.c7;
SELECT * FROM t_hash_unlog_1 ORDER BY c2;

-- replication table
-- unlogged table without primary key
INSERT INTO t_rep_unlog_0 VALUES(1, 1, 'C3', '{1,2,3}', '{10,20,30,40,50}', ROW(10,20), ROW(100, ROW(10,20), '{100,200}')),
	(1, 2, 'C3', '{1,2,3}', '{10,20,30,40,50}', ROW(10,20), ROW(100, ROW(10,20), '{100,200}'))
	ON DUPLICATE KEY UPDATE NOTHING;
INSERT INTO t_rep_unlog_0 VALUES(2, 3, 'C3', '{1,2,3}', '{10,20,30,40,50}', ROW(10,20), ROW(100, ROW(10,20), '{100,200}')),
	(2, 4, 'C3', '{1,2,3}', '{10,20,30,40,50}', ROW(10,20), ROW(100, ROW(10,20), '{100,200}'))
	ON DUPLICATE KEY UPDATE c2 = 100;

-- unlogged table with primary key
-- multi insert
INSERT INTO t_rep_unlog_1 VALUES(1, 1, 'C3', '{1,2,3}', '{10,20,30,40,50}', ROW(10,20), ROW(100, ROW(10,20), '{100,200}')),
	(1, 2, 'C3', '{1,2,3}', '{10,20,30,40,50}', ROW(10,20), ROW(100, ROW(10,20), '{100,200}'))
	ON DUPLICATE KEY UPDATE NOTHING;
INSERT INTO t_rep_unlog_1 VALUES(2, 3, 'C3', '{1,2,3}', '{10,20,30,40,50}', ROW(10,20), ROW(100, ROW(10,20), '{100,200}')),
	(2, 4, 'C3', '{1,2,3}', '{10,20,30,40,50}', ROW(10,20), ROW(100, ROW(10,20), '{100,200}'))
	ON DUPLICATE KEY UPDATE c1 = EXCLUDED.c1, c3 = EXCLUDED.c3, c4 = EXCLUDED.c4, c5 = EXCLUDED.c5, c6 = EXCLUDED.c6, c7 = EXCLUDED.c7;
SELECT * FROM t_rep_unlog_1 ORDER BY c2;

INSERT INTO t_rep_unlog_1 VALUES(10, 1, 'C30', '{10,20,30}', '{100,200,300,400,500}', ROW(100,200), ROW(1000, ROW(100,200), '{1000,2000}')),
	(11, 2, 'C31', '{11,21,31}', '{101,201,301,401,501}', ROW(101,201), ROW(1001, ROW(101,201), '{1001,2001}'))
	ON DUPLICATE KEY UPDATE NOTHING;
INSERT INTO t_rep_unlog_1 VALUES(20, 3, 'C30', '{10,20,30}', '{10,20,30,40,50}', ROW(100,200), ROW(1000, ROW(100,200), '{1000,2000}')),
	(21, 4, 'C31', '{11,21,31}', '{101,201,301,401,501}', ROW(101,201), ROW(1001, ROW(101,201), '{1001,2001}'))
	ON DUPLICATE KEY UPDATE c1 = EXCLUDED.c1, c3 = EXCLUDED.c3, c4 = EXCLUDED.c4, c5 = EXCLUDED.c5, c6 = EXCLUDED.c6, c7 = EXCLUDED.c7;
SELECT * FROM t_rep_unlog_1 ORDER BY c2;

-- insert and update same tuple, and update twice for another same tuple
INSERT INTO t_rep_unlog_1 VALUES(0, 5, 'C30', '{10,20,30}', '{10,20,30,40,50}', ROW(100,200), ROW(1000, ROW(100,200), '{1000,2000}')),
	(1, 5, 'C31', '{11,21,31}', '{101,201,301,401,501}', ROW(101,201), ROW(1001, ROW(101,201), '{1001,2001}')),
	(10, 1, 'C30', '{10,20,30}', '{100,200,300,400,500}', ROW(100,200), ROW(1000, ROW(100,200), '{1000,2000}')),
	(11, 1, 'C31', '{11,21,31}', '{101,201,301,401,501}', ROW(101,201), ROW(1001, ROW(101,201), '{1001,2001}'))
	ON DUPLICATE KEY UPDATE NOTHING;
SELECT * FROM t_rep_unlog_1 ORDER BY c2;

INSERT INTO t_rep_unlog_1 VALUES(0, 5, 'C30', '{10,20,30}', '{10,20,30,40,50}', ROW(100,200), ROW(1000, ROW(100,200), '{1000,2000}')),
	(1, 5, 'C31', '{11,21,31}', '{101,201,301,401,501}', ROW(101,201), ROW(1001, ROW(101,201), '{1001,2001}')),
	(10, 1, 'C30', '{10,20,30}', '{100,200,300,400,500}', ROW(100,200), ROW(1000, ROW(100,200), '{1000,2000}')),
	(11, 1, 'C31', '{11,21,31}', '{101,201,301,401,501}', ROW(101,201), ROW(1001, ROW(101,201), '{1001,2001}'))
	ON DUPLICATE KEY UPDATE c1 = EXCLUDED.c1, c3 = EXCLUDED.c3, c4 = EXCLUDED.c4, c5 = EXCLUDED.c5, c6 = EXCLUDED.c6, c7 = EXCLUDED.c7;
SELECT * FROM t_rep_unlog_1 ORDER BY c2;
