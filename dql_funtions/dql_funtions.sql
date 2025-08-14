/*
Desarrolla las siguientes funciones:
 */

-- • TotalGastoCliente(ClienteID, Anio): Calcula el gasto total de un cliente en un año específico.

create function TotalGastoCliente(idCli int, ani date)
returns decimal(10,2)
deterministic
begin
    declare gastototal decimal(10,2);

    select sum(il.unitprice * il.quntity)
    into gastototal
    from Track t
    join InvoiceLine il on t.track = il.track
    JOIN Invoice i on i.invoiceid = il.invoiceid
    where iltra = idCli
    and i.Invoicedate BETWEEN Invoicedate;

    return ifnull(totalcosto, 0);
end //

SELECT TotalGastoCliente(5, 2005);

-- • PromedioPrecioPorAlbum(AlbumID): Retorna el precio promedio de las canciones de un álbum.

create function PromedioPrecioPorAlbum(fechainicio date, fechafin date)
returns decimal(10,2)
deterministic
begin
    declare totalventas decimal(10,2);
    declare dias int;

    select sum(total) into totalventas
    from ventas
    where fecha between fechainicio and fechafin;

    set dias = datediff(fechafin, fechainicio) + 1;

    return if(dias > 0, totalventas / dias, 0);
end //

SELECT PromedioPrecioPorAlbum(7);
-- • DuracionTotalPorGenero(GeneroID): Calcula la duración total de todas las canciones vendidas de un género específico.
SELECT DuracionTotalPorGenero(2);
-- • DescuentoPorFrecuencia(ClienteID): Calcula el descuento a aplicar basado en la frecuencia de compra del cliente.
SELECT DescuentoPorFrecuencia(32);
-- • VerificarClienteVIP(ClienteID): Verifica si un cliente es "VIP" basándose en sus gastos anuales.
SELECT VerificarClienteVIP(8);