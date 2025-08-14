/*
Realiza las siguientes consultas en SQL:
*/

-- • Encuentra el empleado que ha generado la mayor cantidad de ventas en el último trimestre.

SELECT e.FirstName Nombre,e.LastName Apellido 
FROM Employee e 
join Track t on e.EmployeeId = t.TrackId
JOIN Genre g ON t.TrackId  = e.ReportsTo 
GROUP BY Nombre , Apellido
HAVING COUNT(t.TrackId) = 1;

-- • Lista los cinco artistas con más canciones vendidas en el último año.

SELECT a.Name  
FROM Artist a
WHERE a.ArtistId  NOT IN (
    SELECT p.name
    FROM Playlist p
    JOIN PlaylistTrack pt ON p.Playlistid = pt.Playlistid
    WHERE p.Playlistid >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
);

-- Obtén el total de ventas y la cantidad de canciones vendidas por país.

SELECT c.Country  as Pais, i.Total
FROM Customer c
join Employee e on e.EmployeeId = c.SupportRepId 
JOIN Invoice i on c.CustomerId = i.InvoiceId 
WHERE COUNT(c.CustomerId) >= 1,00;


-- • Calcula el número total de clientes que realizaron compras por cada género en un mes específico.
SELECT 
    p.nombre_producto,
    dv.cantidad AS cantidad_vendida,
    (SELECT pr.fecha
     FROM produccion pr
     WHERE pr.id_producto = p.id_producto
     ORDER BY pr.fecha DESC
     LIMIT 1) AS fecha_cosecha,
    (SELECT pa.nombre_parcela
     FROM produccion pr
     JOIN parcelas pa ON pa.id_parcela = pr.id_parcela
     WHERE pr.id_producto = p.id_producto
     ORDER BY pr.fecha DESC
     LIMIT 1) AS lote,
    v.fecha AS fecha_venta
FROM detalle_venta dv
JOIN productos p ON p.id_producto = dv.id_producto
JOIN ventas v ON v.id_venta = dv.id_venta;

-- • Encuentra a los clientes que han comprado todas las canciones de un mismo álbum.
SELECT 
    m.nombre_maquina AS Maquinaria,
    em.estado AS Estado,
    COALESCE(ma.fecha, 'No ha sido mantenida') AS Ultimo_Mantenimiento,
    COALESCE(ma.descripcion, 'Sin descripción') AS Descripción_Mantenimiento
FROM maquinaria m
JOIN estado_maquinaria em ON m.id_estado = em.id_estado
LEFT JOIN mantenimiento ma ON m.id_maquina = ma.id_maquina
ORDER BY m.nombre_maquina;

-- • Lista los tres países con mayores ventas durante el último semestre.
SELECT 
    p.nombre_producto,
    dv.cantidad AS cantidad_vendida,
    (SELECT pr.fecha
     FROM produccion pr
     WHERE pr.id_producto = p.id_producto
     ORDER BY pr.fecha DESC
     LIMIT 1) AS fecha_cosecha,
    (SELECT pa.nombre_parcela
     FROM produccion pr
     JOIN parcelas pa ON pa.id_parcela = pr.id_parcela
     WHERE pr.id_producto = p.id_producto
     ORDER BY pr.fecha DESC
     LIMIT 1) AS lote,
    v.fecha AS fecha_venta
FROM detalle_venta dv
JOIN productos p ON p.id_producto = dv.id_producto
JOIN ventas v ON v.id_venta = dv.id_venta;

-- • Muestra los cinco géneros menos vendidos en el último año.
SELECT 
    e.id_empleado,
    e.nombre AS nombre_empleado,
    re.nombre_rol AS cargo,
    m.nombre_maquina,
    p.nombre_producto,
    pr.nombre_parcela,
    pd.fecha,
    pd.cantidad
FROM empleados e
INNER JOIN roles_empleados re ON e.id_rol = re.id_rol
LEFT JOIN asignaciones a ON e.id_empleado = a.id_empleado
LEFT JOIN maquinaria m ON a.id_maquina = m.id_maquina
LEFT JOIN produccion pd ON e.id_empleado = pd.id_parcela
LEFT JOIN productos p ON pd.id_producto = p.id_producto
LEFT JOIN parcelas pr ON pd.id_parcela = pr.id_parcela
ORDER BY e.id_empleado;

-- • Encuentra los cinco empleados que realizaron más ventas de Rock.
SELECT 
    p.nombre_producto AS Producto,
    i.cantidad AS Inventario_Actual,
    COALESCE(prd.cantidad, 0) AS Produccion_Reciente,
    i.cantidad - COALESCE(prd.cantidad, 0) AS Diferencia
FROM productos p
LEFT JOIN inventario i ON p.id_producto = i.id_producto
LEFT JOIN (
    SELECT id_producto, cantidad
    FROM produccion
    WHERE fecha = (SELECT MAX(fecha) FROM produccion)
) prd ON p.id_producto = prd.id_producto
ORDER BY p.nombre_producto;

-- • Genera un informe de los clientes con más compras recurrentes.
SELECT 
    m.nombre_maquina AS Maquinaria,
    em.estado AS Estado,
    COALESCE(ma.fecha, 'No ha sido mantenida') AS Ultimo_Mantenimiento,
    COALESCE(ma.descripcion, 'Sin descripción') AS Descripción_Mantenimiento
FROM maquinaria m
JOIN estado_maquinaria em ON m.id_estado = em.id_estado
LEFT JOIN mantenimiento ma ON m.id_maquina = ma.id_maquina
ORDER BY m.nombre_maquina;

-- • Calcula el precio promedio de venta por género.
SELECT 
    e.nombre AS Empleado,
    m.nombre_maquina AS Maquinaria,
    a.fecha_asignacion AS Fecha_Asignacion,
    re.nombre_rol as rol
FROM asignaciones a
JOIN empleados e ON a.id_empleado = e.id_empleado
JOIN maquinaria m ON a.id_maquina = m.id_maquina
JOIN roles_empleados re ON e.id_rol = re.id_rol
ORDER BY e.nombre, a.fecha_asignacion;

-- • Lista las cinco canciones más largas vendidas en el último año.
SELECT 
    p.nombre_producto AS Producto,
    SUM(dv.cantidad) AS Cantidad_Vendida
FROM detalle_venta dv
JOIN productos p ON dv.id_producto = p.id_producto
JOIN ventas v ON dv.id_venta = v.id_venta
WHERE MONTH(v.fecha) = MONTH(CURDATE()) AND YEAR(v.fecha) = YEAR(CURDATE())
GROUP BY p.id_producto
ORDER BY Cantidad_Vendida DESC;

-- • Muestra los clientes que compraron más canciones de Jazz.
SELECT 
    c.nombre AS Cliente,
    p.nombre_producto AS Producto,
    SUM(dv.cantidad) AS Cantidad_Comprada,
    SUM(dv.cantidad * dv.precio_unitario) AS Total_Gastado
FROM ventas v
JOIN clientes c ON v.id_cliente = c.id_cliente
JOIN detalle_venta dv ON v.id_venta = dv.id_venta
JOIN productos p ON dv.id_producto = p.id_producto
GROUP BY c.id_cliente, p.id_producto
ORDER BY Total_Gastado DESC;

-- • Encuentra la cantidad total de minutos comprados por cada cliente en el último mes.
SELECT 
    e.nombre AS empleado,
    re.nombre_rol AS cargo,
    hs.salario,
    m.nombre_maquina AS maquinaria_asignada
FROM empleados e
JOIN roles_empleados re ON e.id_rol = re.id_rol
LEFT JOIN (
    SELECT id_empleado, salario
    FROM historial_salarios
    WHERE fecha_fin = '2024-12-31'
) hs ON e.id_empleado = hs.id_empleado
LEFT JOIN asignaciones a ON e.id_empleado = a.id_empleado
LEFT JOIN maquinaria m ON a.id_maquina = m.id_maquina
ORDER BY e.nombre;

-- • Muestra el número de ventas diarias de canciones en cada mes del último trimestre.
SELECT 
    p.nombre_producto,
    ROUND(AVG(dv.precio_unitario), 2) AS precio_promedio,
    SUM(dv.cantidad) AS total_vendido
FROM detalle_venta dv
JOIN productos p ON dv.id_producto = p.id_producto
GROUP BY p.id_producto
ORDER BY precio_promedio DESC;

-- • Calcula el total de ventas por cada vendedor en el último semestre.
SELECT 
    m.nombre_maquina,
    COUNT(ma.id_maquina) AS total_mantenimientos
FROM maquinaria m
LEFT JOIN mantenimiento ma ON m.id_maquina = ma.id_maquina
GROUP BY m.id_maquina
ORDER BY total_mantenimientos DESC;

-- • Encuentra el cliente que ha realizado la compra más cara en el último año.
SELECT 
    p.nombre_producto,
    (SELECT SUM(cantidad) FROM detalle_compra WHERE id_producto = p.id_producto) AS total_comprado,
    (SELECT SUM(cantidad) FROM detalle_venta WHERE id_producto = p.id_producto) AS total_vendido
FROM productos p
WHERE p.id_producto = 8;

-- • Lista los cinco álbumes con más canciones vendidas durante los últimos tres meses.
SELECT 
    c.nombre AS cliente,
    COUNT(DISTINCT dv.id_producto) AS productos_distintos
FROM ventas v
JOIN clientes c ON v.id_cliente = c.id_cliente
JOIN detalle_venta dv ON v.id_venta = dv.id_venta
GROUP BY c.id_cliente
HAVING productos_distintos >= 1
ORDER BY productos_distintos DESC;

-- • Obtén la cantidad de canciones vendidas por cada género en el último mes.
SELECT 
    p.id_parcela,
    p.nombre_parcela,
    MONTH(pr.fecha) AS mes,
    YEAR(pr.fecha) AS ano,
    SUM(pr.cantidad) AS costo_mensual
FROM produccion pr
JOIN parcelas p ON pr.id_parcela = p.id_parcela
GROUP BY p.id_parcela, mes, ano
ORDER BY ano DESC, mes DESC;

-- • Lista los clientes que no han comprado nada en el último año.
SELECT 
    cp.nombre_categoria,
    p.nombre_producto,
    ROUND(AVG(dv.precio_unitario) - AVG(dc.precio_unitario), 2) AS rentabilidad_promedio
FROM productos p
JOIN categorias_productos cp 
    ON p.id_categoria = cp.id_categoria
JOIN detalle_venta dv 
    ON dv.id_producto = p.id_producto
JOIN detalle_compra dc 
    ON dc.id_producto = p.id_producto
GROUP BY cp.nombre_categoria, p.nombre_producto
ORDER BY rentabilidad_promedio DESC;
