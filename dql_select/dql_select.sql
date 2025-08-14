/*
Realiza las siguientes consultas en SQL:
*/

-- • Encuentra el empleado que ha generado la mayor cantidad de ventas en el último trimestre.

SELECT e.FirstName AS Nombre,
       e.LastName  AS Apellido,
       COUNT(il.InvoiceLineId) AS Total_Ventas
FROM Employee e
JOIN Customer c   ON e.EmployeeId = c.SupportRepId
JOIN Invoice i    ON c.CustomerId = i.CustomerId
JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
WHERE i.InvoiceDate >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
GROUP BY e.EmployeeId
ORDER BY Total_Ventas DESC
LIMIT 1;

-- • Lista los cinco artistas con más canciones vendidas en el último año.

SELECT ar.Name AS Artista,
       COUNT(il.TrackId) AS Canciones_Vendidas
FROM Artist ar
JOIN Album al       ON ar.ArtistId = al.ArtistId
JOIN Track t        ON al.AlbumId = t.AlbumId
JOIN InvoiceLine il ON t.TrackId = il.TrackId
JOIN Invoice i      ON il.InvoiceId = i.InvoiceId
WHERE i.InvoiceDate >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY ar.ArtistId
ORDER BY Canciones_Vendidas DESC
LIMIT 5;

-- Obtén el total de ventas y la cantidad de canciones vendidas por país.

SELECT c.Country AS Pais,
       SUM(i.Total) AS Total_Ventas,
       COUNT(il.InvoiceLineId) AS Canciones_Vendidas
FROM Customer c
JOIN Invoice i      ON c.CustomerId = i.CustomerId
JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
GROUP BY c.Country
ORDER BY Total_Ventas DESC;

-- • Calcula el número total de clientes que realizaron compras por cada género en un mes específico.

SELECT g.Name AS Genero,
       COUNT(DISTINCT c.CustomerId) AS Total_Clientes
FROM Genre g
JOIN Track t        ON g.GenreId = t.GenreId
JOIN InvoiceLine il ON t.TrackId = il.TrackId
JOIN Invoice i      ON il.InvoiceId = i.InvoiceId
JOIN Customer c     ON i.CustomerId = c.CustomerId
WHERE MONTH(i.InvoiceDate) = 7
  AND YEAR(i.InvoiceDate) = 2024
GROUP BY g.GenreId
ORDER BY Total_Clientes DESC;

-- • Encuentra a los clientes que han comprado todas las canciones de un mismo álbum.

SELECT c.CustomerId,
       c.FirstName,
       c.LastName,
       al.Title AS Album
FROM Customer c
JOIN Invoice i      ON c.CustomerId = i.CustomerId
JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
JOIN Track t        ON il.TrackId = t.TrackId
JOIN Album al       ON t.AlbumId = al.AlbumId
GROUP BY c.CustomerId, al.AlbumId
HAVING COUNT(DISTINCT t.TrackId) = (
    SELECT COUNT(*)
    FROM Track t2
    WHERE t2.AlbumId = al.AlbumId
);

-- • Lista los tres países con mayores ventas durante el último semestre.

SELECT c.Country,
       SUM(i.Total) AS Total_Ventas
FROM Customer c
JOIN Invoice i ON c.CustomerId = i.CustomerId
WHERE i.InvoiceDate >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY c.Country
ORDER BY Total_Ventas DESC
LIMIT 3;

-- • Muestra los cinco géneros menos vendidos en el último año.

SELECT g.Name AS Genero,
       COUNT(il.TrackId) AS Canciones_Vendidas
FROM Genre g
JOIN Track t        ON g.GenreId = t.GenreId
JOIN InvoiceLine il ON t.TrackId = il.TrackId
JOIN Invoice i      ON il.InvoiceId = i.InvoiceId
WHERE i.InvoiceDate >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY g.GenreId
ORDER BY Canciones_Vendidas ASC
LIMIT 5;

-- • Encuentra los cinco empleados que realizaron más ventas de Rock.

SELECT e.FirstName,
       e.LastName,
       COUNT(il.InvoiceLineId) AS Ventas_Rock
FROM Employee e
JOIN Customer c     ON e.EmployeeId = c.SupportRepId
JOIN Invoice i      ON c.CustomerId = i.CustomerId
JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
JOIN Track t        ON il.TrackId = t.TrackId
JOIN Genre g        ON t.GenreId = g.GenreId
WHERE g.Name = 'Rock'
GROUP BY e.EmployeeId
ORDER BY Ventas_Rock DESC
LIMIT 5;

-- • Genera un informe de los clientes con más compras recurrentes.

SELECT c.FirstName,
       c.LastName,
       COUNT(i.InvoiceId) AS Numero_Compras
FROM Customer c
JOIN Invoice i ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId
ORDER BY Numero_Compras DESC
LIMIT 10;

-- • Calcula el precio promedio de venta por género.

SELECT g.Name AS Genero,
       ROUND(AVG(il.UnitPrice), 2) AS Precio_Promedio
FROM Genre g
JOIN Track t        ON g.GenreId = t.GenreId
JOIN InvoiceLine il ON t.TrackId = il.TrackId
GROUP BY g.GenreId
ORDER BY Precio_Promedio DESC;

-- • Lista las cinco canciones más largas vendidas en el último año.

SELECT t.Name AS Cancion,
       t.Milliseconds / 60000 AS Minutos,
       COUNT(il.InvoiceLineId) AS Veces_Vendida
FROM Track t
JOIN InvoiceLine il ON t.TrackId = il.TrackId
JOIN Invoice i      ON il.InvoiceId = i.InvoiceId
WHERE i.InvoiceDate >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY t.TrackId
ORDER BY Minutos DESC
LIMIT 5;

-- • Muestra los clientes que compraron más canciones de Jazz.

SELECT c.FirstName,
       c.LastName,
       COUNT(il.TrackId) AS Canciones_Jazz
FROM Customer c
JOIN Invoice i      ON c.CustomerId = i.CustomerId
JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
JOIN Track t        ON il.TrackId = t.TrackId
JOIN Genre g        ON t.GenreId = g.GenreId
WHERE g.Name = 'Jazz'
GROUP BY c.CustomerId
ORDER BY Canciones_Jazz DESC
LIMIT 10;

-- • Encuentra la cantidad total de minutos comprados por cada cliente en el último mes.

SELECT c.FirstName,
       c.LastName,
       ROUND(SUM(t.Milliseconds) / 60000, 2) AS Minutos_Comprados
FROM Customer c
JOIN Invoice i      ON c.CustomerId = i.CustomerId
JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
JOIN Track t        ON il.TrackId = t.TrackId
WHERE MONTH(i.InvoiceDate) = MONTH(CURDATE())
  AND YEAR(i.InvoiceDate) = YEAR(CURDATE())
GROUP BY c.CustomerId
ORDER BY Minutos_Comprados DESC;

-- • Muestra el número de ventas diarias de canciones en cada mes del último trimestre.

SELECT DATE(i.InvoiceDate) AS Dia,
       COUNT(il.InvoiceLineId) AS Ventas_Diarias
FROM Invoice i
JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
WHERE i.InvoiceDate >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
GROUP BY Dia
ORDER BY Dia;

-- • Calcula el total de ventas por cada vendedor en el último semestre.

SELECT c.FirstName,
       c.LastName,
       i.Total AS Compra_Mas_Cara,
       i.InvoiceDate
FROM Customer c
JOIN Invoice i ON c.CustomerId = i.CustomerId
WHERE i.InvoiceDate >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
ORDER BY i.Total DESC
LIMIT 1;

-- • Encuentra el cliente que ha realizado la compra más cara en el último año.

SELECT c.FirstName,
       c.LastName,
       i.Total AS Compra_Mas_Cara,
       i.InvoiceDate
FROM Customer c
JOIN Invoice i ON c.CustomerId = i.CustomerId
WHERE i.InvoiceDate >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
ORDER BY i.Total DESC
LIMIT 1;

-- • Lista los cinco álbumes con más canciones vendidas durante los últimos tres meses.

SELECT al.Title AS Album,
       ar.Name AS Artista,
       COUNT(il.TrackId) AS Canciones_Vendidas
FROM Album al
JOIN Artist ar     ON al.ArtistId = ar.ArtistId
JOIN Track t       ON al.AlbumId = t.AlbumId
JOIN InvoiceLine il ON t.TrackId = il.TrackId
JOIN Invoice i     ON il.InvoiceId = i.InvoiceId
WHERE i.InvoiceDate >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
GROUP BY al.AlbumId
ORDER BY Canciones_Vendidas DESC
LIMIT 5;

-- • Obtén la cantidad de canciones vendidas por cada género en el último mes.

SELECT c.CustomerId,
       c.FirstName,
       c.LastName
FROM Customer c
LEFT JOIN Invoice i 
    ON c.CustomerId = i.CustomerId 
    AND i.InvoiceDate >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
WHERE i.InvoiceId IS NULL;

-- • Lista los clientes que no han comprado nada en el último año.

SELECT MONTH(i.InvoiceDate) AS Mes,
       YEAR(i.InvoiceDate) AS Año,
       SUM(i.Total) AS Total_Ventas,
       COUNT(il.TrackId) AS Canciones_Vendidas
FROM Invoice i
JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
WHERE i.InvoiceDate >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY Año, Mes
ORDER BY Año DESC, Mes DESC;
