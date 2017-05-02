Select sp.TerritoryID, st.Name, COUNT(*) AS NumOfStates
FROM person.StateProvince sp
INNER JOIN sales.SalesTerritory st
ON sp.TerritoryID = st.TerritoryID
GROUP BY sp.TerritoryID, st.Name;


SELECT 'db.territoryCOUNT.save({'

+'"territory":"' + st.Name +'",'
+ '"territoryID":"' +CONVERT(varchar(MAX), sp.TerritoryID)+'",' 
+'"state":"' + sp.Name 
+'"});'
FROM person.StateProvince sp
INNER JOIN sales.SalesTerritory st
ON sp.TerritoryID = st.TerritoryID;


