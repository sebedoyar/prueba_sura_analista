
-- Nombre de cada cliente y productos que ha comprado
SELECT DISTINCT
    t1.nombre_cliente ,
    t2.nombre_producto
FROM cliente t1
INNER JOIN producto t2 on t1.id_cliente = t2.id_cliente;

-- PRODUCTOS QUE NO SE HAN VENDIDO
SELECT
    t1.*
FROM producto AS t1 LEFT JOIN pedido AS t2 ON t1.productoID = t2.productoID 
WHERE t2.productoID IS NULL;

-- NOMBRE DEL ÚLTIMO PRODUCTO

SELECT * FROM pedido ORDER BY fecha DESC LIMIT 1;

-- NOMBRE DEL CLIENTE Y NUMERO TOTAL DE PRODUCTOS QUE HA COMPRADO ORDENADOS POR EL TOTAL DE PRODUCTOS DESCENDENTE
with compra as (
select 	t1.Orden_ID, t1.Producto_ID,t1.Producto_nombre, t2.cantidad, t2.cliente_ID, t2.fecha
from producto as t1 
INNER JOIN pedido as t2 ON t1.Orden_ID = t2.Orden_ID)

SELECT t1.nombre_cliente,
       count(*) as cantidad_comprada
FROM cliente as t1
INNER join compra as t2 ON t1.cliente_ID = t2.cliente_ID
GROUP BY 1
ORDER BY 2 DESC DESC;


-- CADA UNO DE LOS DIAS DE LA TABLA PEDIDO Y CUANTO SE VENDIO ESE DIA ORGANIZADO DE MENOR A MAYOR FECHA

SELECT t1.fecha, sum(t1.cantidad) as Suma 
FROM pedido AS t1
GROUP BY fecha
ORDER BY fecha ASC;

-- TODOS LOS DATOS DE LAS PERSONAS QUE SON DE CALI Y HAN HECHO COMPRAS SUPERIORES A 1 MILLON DE PESOS
with compra as (
SELECT t1.Orden_ID,t1.cliente_ID, t1.Producto_ID, t1.cantidad, t2.precio,  (t1.cantidad*t2.precio) as valor
FROM pedido as t1
INNER JOIN producto as t2 ON t1.Producto_ID=t2.Producto_ID
),

valor_compra as (select Orden_ID,cliente_ID, sum(valor) as Valor_orden
from compra
group by 1,2)
select * 
FROM cliente as t1 INNER JOIN valor_compra as t2 ON t1.cliente_ID=t2.cliente_ID
WHERE ciudad = "Cali" AND valor_orden > 1000000
;

-- TODOS LOS DATOS DE LOS PRODUCTOS CUYO PRECIO > LAPICERO Y PRECIO < PORTATIL

SELECT * FROM producto 
WHERE precio > (SELECT precio FROM producto WHERE Product_Nombre = 'Lapicero') 
AND precio < (SELECT precio FROM producto WHERE Product_Nombre = 'Portatil'); 

-- DATOS CLIENTES QUE NO HAN COMPRADO PRODUCTO

with compra as (
SELECT t1.Orden_ID,t1.cliente_ID, t1.Producto_ID, t1.cantidad, t2.precio,  (t1.cantidad*t2.precio) as valor
FROM pedido as t1
INNER JOIN producto as t2 ON t1.Producto_ID=t2.Producto_ID
)

SELECT t1.* FROM cliente as t1
RIGHT join compra as t2 ON t1.cliente_ID = t2.cliente_ID
WHERE t1.cliente_ID IS NULL;
