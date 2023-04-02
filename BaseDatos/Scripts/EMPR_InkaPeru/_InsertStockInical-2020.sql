USE BDInkaPeru

CREATE TABLE #tmp(CODIGO VARCHAR(10), STOCK DECIMAL(15,2))
INSERT INTO #tmp values('0829002',7002)
INSERT INTO #tmp values('0801001',2500)
INSERT INTO #tmp values('0801004',1140)
INSERT INTO #tmp values('0801003',10126)
INSERT INTO #tmp values('0829005',5849)
INSERT INTO #tmp values('0801006',3625)
INSERT INTO #tmp values('0801007',393)
INSERT INTO #tmp values('0829008',162)
INSERT INTO #tmp values('0801022',3810)
INSERT INTO #tmp values('0801027',1775)
INSERT INTO #tmp values('0801028',757)
INSERT INTO #tmp values('0801020',7766)
INSERT INTO #tmp values('0801021',4438)
INSERT INTO #tmp values('0801019',2839)
INSERT INTO #tmp values('0801018',573)
INSERT INTO #tmp values('0801026',145)
INSERT INTO #tmp values('1201001',5617)
INSERT INTO #tmp values('1201003',5419)
INSERT INTO #tmp values('1107003',2464)
INSERT INTO #tmp values('1107004',2551)
INSERT INTO #tmp values('0901024',361)
INSERT INTO #tmp values('0901025',628)
INSERT INTO #tmp values('1107013',21)
INSERT INTO #tmp values('1107014',20)
INSERT INTO #tmp values('0801012',70)
INSERT INTO #tmp values('0801565',175)
INSERT INTO #tmp values('1001001',78)
INSERT INTO #tmp values('1001136',223)
INSERT INTO #tmp values('1001133',104)
INSERT INTO #tmp values('1001137',31)
INSERT INTO #tmp values('0933001',11)
INSERT INTO #tmp values('0904054',32)
INSERT INTO #tmp values('1101149',313)
INSERT INTO #tmp values('0933003',85)
INSERT INTO #tmp values('1101145',223)
INSERT INTO #tmp values('0904053',78)
INSERT INTO #tmp values('1309004',178)
INSERT INTO #tmp values('1309005',7)
INSERT INTO #tmp values('1309006',154)
INSERT INTO #tmp values('1309007',0)
INSERT INTO #tmp values('1309008',489)
INSERT INTO #tmp values('1309022',50)
INSERT INTO #tmp values('1309023',50)
INSERT INTO #tmp values('1309024',25)
INSERT INTO #tmp values('1309025',25)
INSERT INTO #tmp values('1309012',10)
INSERT INTO #tmp values('1309018',10)
INSERT INTO #tmp values('1309026',10)
INSERT INTO #tmp values('1309027',3)
INSERT INTO #tmp values('1309021',12)
INSERT INTO #tmp values('1309028',19)
INSERT INTO #tmp values('1309017',20)
INSERT INTO #tmp values('1309029',0)
INSERT INTO #tmp values('1309032',20)
INSERT INTO #tmp values('1309014',18)
INSERT INTO #tmp values('1309031',20)
INSERT INTO #tmp values('1309030',19)
INSERT INTO #tmp values('1309016',10)
INSERT INTO #tmp values('1309034',10)
INSERT INTO #tmp values('1309015',6)
INSERT INTO #tmp values('1309011',9)
INSERT INTO #tmp values('1309013',10)
INSERT INTO #tmp values('1309010',3)
INSERT INTO #tmp values('1309009',8)


USE BDInkaPeru
go

SELECT * FROM Logistica.LOG_StockIniciales WHERE PERIO_Codigo = '2020'

SELECT t.CODIGO, t.STOCK, l.STINI_Cantidad, * FROM Logistica.LOG_StockIniciales l 
  INNER JOIN #tmp t ON t.CODIGO = l.ARTIC_Codigo
 WHERE PERIO_Codigo = '2020'

BEGIN TRAN x
  UPDATE Logistica.LOG_StockIniciales SET STINI_Cantidad = 0 WHERE PERIO_Codigo = '2020'
  UPDATE l
     SET l.STINI_Cantidad = t.STOCK
    FROM Logistica.LOG_StockIniciales l 
   INNER JOIN #tmp t ON t.CODIGO = l.ARTIC_Codigo
   WHERE PERIO_Codigo = '2020'
ROLLBACK TRAN x