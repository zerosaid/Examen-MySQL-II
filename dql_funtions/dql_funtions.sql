/*
Desarrolla las siguientes funciones:
 */

-- • TotalGastoCliente(ClienteID, Anio): Calcula el gasto total de un cliente en un año específico.

DELIMITER //

CREATE FUNCTION TotalGastoCliente(idCli INT, anio INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE gastoTotal DECIMAL(10,2);

    SELECT SUM(il.UnitPrice * il.Quantity)
    INTO gastoTotal
    FROM Invoice i
    JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
    WHERE i.CustomerId = idCli
      AND YEAR(i.InvoiceDate) = anio;

    RETURN IFNULL(gastoTotal, 0);
END //

DELIMITER ;

SELECT TotalGastoCliente(5, 2005);

-- • PromedioPrecioPorAlbum(AlbumID): Retorna el precio promedio de las canciones de un álbum.

DELIMITER //

CREATE FUNCTION PromedioPrecioPorAlbum(idAlbum INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE promedio DECIMAL(10,2);

    SELECT AVG(t.UnitPrice)
    INTO promedio
    FROM Track t
    WHERE t.AlbumId = idAlbum;

    RETURN IFNULL(promedio, 0);
END //

DELIMITER ;

SELECT PromedioPrecioPorAlbum(7);

-- • DuracionTotalPorGenero(GeneroID): Calcula la duración total de todas las canciones vendidas de un género específico.

DELIMITER //

CREATE FUNCTION DuracionTotalPorGenero(idGenero INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE duracionTotal INT;

    SELECT SUM(t.Milliseconds)
    INTO duracionTotal
    FROM Track t
    JOIN InvoiceLine il ON t.TrackId = il.TrackId
    JOIN Invoice i ON il.InvoiceId = i.InvoiceId
    WHERE t.GenreId = idGenero;

    RETURN IFNULL(duracionTotal, 0);
END //

DELIMITER ;

SELECT DuracionTotalPorGenero(2);

-- • DescuentoPorFrecuencia(ClienteID): Calcula el descuento a aplicar basado en la frecuencia de compra del cliente.

DELIMITER //

CREATE FUNCTION DescuentoPorFrecuencia(idCli INT)
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    DECLARE compras INT;
    DECLARE descuento DECIMAL(5,2);

    SELECT COUNT(DISTINCT i.InvoiceId)
    INTO compras
    FROM Invoice i
    WHERE i.CustomerId = idCli
      AND i.InvoiceDate >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR);

    SET descuento = CASE
        WHEN compras >= 20 THEN 0.20
        WHEN compras >= 10 THEN 0.10
        WHEN compras >= 5  THEN 0.05
        ELSE 0.00
    END;

    RETURN descuento;
END //

DELIMITER ;

SELECT DescuentoPorFrecuencia(32);

-- • VerificarClienteVIP(ClienteID): Verifica si un cliente es "VIP" basándose en sus gastos anuales.

DELIMITER //

CREATE FUNCTION VerificarClienteVIP(idCli INT)
RETURNS VARCHAR(3)
DETERMINISTIC
BEGIN
    DECLARE gastoAnual DECIMAL(10,2);

    SELECT SUM(il.UnitPrice * il.Quantity)
    INTO gastoAnual
    FROM Invoice i
    JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
    WHERE i.CustomerId = idCli
      AND i.InvoiceDate >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR);

    RETURN IF(gastoAnual >= 1000, 'Sí', 'No');
END //

DELIMITER ;

SELECT VerificarClienteVIP(8);