/*Triggers:
Implementa los siguientes triggers:
*/

-- • ActualizarTotalVentasEmpleado: Al realizar una venta, actualiza el total de ventas acumuladas por el empleado correspondiente.

DELIMITER //

CREATE TRIGGER trg_actualizar_total_ventas_empleado
AFTER INSERT ON ventas
FOR EACH ROW
BEGIN
    -- Sumar el valor de la nueva venta al total del empleado
    UPDATE empleados
    SET total_ventas = total_ventas + NEW.total_venta
    WHERE id_empleado = NEW.id_empleado;
END;
//

DELIMITER ;

-- • AuditarActualizacionCliente: Cada vez que se modifica un cliente, registra el cambio en una tabla de auditoría.

-- • RegistrarHistorialPrecioCancion: Guarda el historial de cambios en el precio de las canciones.

-- • NotificarCancelacionVenta: Registra una notificación cuando se elimina un registro de venta.

-- • RestringirCompraConSaldoDeudor: Evita que un cliente con saldo deudor realice nuevas compras.