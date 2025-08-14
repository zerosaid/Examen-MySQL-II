/*

Crea los siguientes eventos:

*/

-- • ReporteVentasMensual: Genera un informe mensual de ventas y lo almacena automáticamente.
DELIMITER //
CREATE EVENT IF NOT EXISTS ReporteVentasMensual
ON SCHEDULE EVERY 1 MONTH
STARTS CURRENT_TIMESTAMP + INTERVAL 1 MONTH
DO
BEGIN
    INSERT INTO reportes_ventas (mes, anio, total_ventas, fecha_generacion)
    SELECT 
        MONTH(NOW()) AS mes,
        YEAR(NOW()) AS anio,
        SUM(total) AS total_ventas,
        NOW()
    FROM ventas
    WHERE MONTH(fecha) = MONTH(NOW()) 
      AND YEAR(fecha) = YEAR(NOW());
END;
//

-- • ActualizarSaldosCliente: Actualiza los saldos de cuenta de clientes al final de cada mes.

CREATE EVENT IF NOT EXISTS ActualizarSaldosCliente
ON SCHEDULE EVERY 1 MONTH
STARTS CURRENT_TIMESTAMP + INTERVAL 1 MONTH
DO
BEGIN
    UPDATE clientes c
    JOIN (
        SELECT id_cliente, SUM(total) AS compras
        FROM ventas
        WHERE MONTH(fecha) = MONTH(NOW()) 
          AND YEAR(fecha) = YEAR(NOW())
        GROUP BY id_cliente
    ) v ON c.id_cliente = v.id_cliente
    SET c.saldo = c.saldo - v.compras;
END;
//
-- • AlertaAlbumNoVendidoAnual: Envía una alerta cuando un álbum no ha registrado ventas en el último año.

CREATE EVENT IF NOT EXISTS AlertaAlbumNoVendidoAnual
ON SCHEDULE EVERY 1 YEAR
STARTS CURRENT_TIMESTAMP + INTERVAL 1 YEAR
DO
BEGIN
    INSERT INTO alertas (mensaje, fecha)
    SELECT CONCAT('El álbum "', a.titulo, '" no ha registrado ventas en el último año.') AS mensaje,
           NOW()
    FROM albumes a
    LEFT JOIN ventas v 
           ON a.id_album = v.id_album 
           AND v.fecha >= DATE_SUB(NOW(), INTERVAL 1 YEAR)
    WHERE v.id_venta IS NULL;
END;
//

-- • LimpiarAuditoriaCada6Meses: Borra los registros antiguos de auditoría cada seis meses.

CREATE EVENT IF NOT EXISTS LimpiarAuditoriaCada6Meses
ON SCHEDULE EVERY 6 MONTH
STARTS CURRENT_TIMESTAMP + INTERVAL 6 MONTH
DO
BEGIN
    DELETE FROM auditoria
    WHERE fecha < DATE_SUB(NOW(), INTERVAL 6 MONTH);
END;
//

-- • ActualizarListaDeGenerosPopulares: Actualiza la lista de géneros más vendidos al final de cada mes.

CREATE EVENT IF NOT EXISTS ActualizarListaDeGenerosPopulares
ON SCHEDULE EVERY 1 MONTH
STARTS CURRENT_TIMESTAMP + INTERVAL 1 MONTH
DO
BEGIN
    TRUNCATE TABLE generos_populares;
    
    INSERT INTO generos_populares (id_genero, nombre_genero, total_ventas)
    SELECT g.id_genero, g.nombre, COUNT(v.id_venta) AS total_ventas
    FROM generos g
    JOIN albumes a ON g.id_genero = a.id_genero
    JOIN ventas v ON a.id_album = v.id_album
    WHERE MONTH(v.fecha) = MONTH(NOW()) 
      AND YEAR(v.fecha) = YEAR(NOW())
    GROUP BY g.id_genero, g.nombre
    ORDER BY total_ventas DESC;
END;
//

DELIMITER ;