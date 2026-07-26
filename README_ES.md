# Coffee Shop Sales — Analisis de Ventas End-to-End

> [Read in English](README.md)

## Descripcion

Analisis de ventas completo de Maven Roasters, una cadena de cafeterias ficticia con tres locales en Nueva York: **Astoria**, **Hell's Kitchen** y **Lower Manhattan**.

El dataset contiene **149.116 transacciones** que cubren de enero a junio de 2023, obtenido de [Maven Analytics](https://mavenanalytics.io/data-playground).

El objetivo del proyecto es identificar tendencias de ventas, franjas horarias de mayor actividad, productos estrella y distribucion del revenue entre locales, comunicando los hallazgos a traves de SQL, dashboards interactivos y data storytelling.

---

## Stack Tecnico

| Herramienta | Uso |
|---|---|
| PostgreSQL | Limpieza y analisis de datos |
| Google Sheets | Exploracion inicial y reporte |
| Metabase | Dashboard interactivo |
| Google Slides | Presentacion de data storytelling |

---

## Estructura del Proyecto

```
Coffee-Shop-Sales/
├── Coffee_shop_sales.sql        # Consultas de limpieza y analisis
├── Coffee Shop Sales Clean.csv  # Dataset limpio
├── Coffee Shop Sales Report.ods # Reporte en Google Sheets
├── Coffee Shop Sales Slides.odp # Presentacion en Google Slides
├── images/                      # Capturas del dashboard
│   ├── Pestaña1.png
│   └── Pestaña2.png
└── README_ES.md
```

---

## Limpieza de Datos

El dataset original requirio las siguientes transformaciones en PostgreSQL:

- Conversion de `transaction_date` de texto a `DATE`
- Conversion de `transaction_time` de texto a `TIME`
- Sustitucion de coma por punto en `unit_price` y conversion a `NUMERIC`
- Verificacion de ausencia de valores nulos y de duplicados en `transaction_id`

---

## Preguntas de Negocio Respondidas

| # | Pregunta | Nivel |
|---|---|---|
| Q1 | Cual es el revenue total por ubicacion? | Facil |
| Q2 | Cuantas transacciones se realizaron por mes? | Facil |
| Q3 | Cual es el producto mas vendido por unidades? | Facil |
| Q4 | Cuales son las 5 categorias con mayor revenue? | Facil |
| Q5 | Cual es el ticket medio por transaccion? | Facil |
| Q6 | Cual es el revenue por dia de la semana? | Medio |
| Q7 | Que franja horaria tiene mas transacciones? | Medio |
| Q8 | Que productos generan el 80% del revenue? (Pareto) | Medio |
| Q9 | Como ha evolucionado el revenue mensual por ubicacion? | Medio |
| Q10 | Cual es el producto mas vendido en cada ubicacion? | Medio |
| Q11 | Cual es el producto menos vendido por unidades? | Facil |
| Q12 | Que franja horaria tiene mas transacciones por ubicacion? | Medio |

---

## Hallazgos Clave

- El revenue casi se duplica de enero a junio con una tendencia creciente sostenida en los tres locales
- Coffee y Tea representan mas del 66% del revenue total
- La mañana concentra mas del 54% de todas las transacciones en los tres locales
- Hell's Kitchen lidera en revenue total, pero los tres locales tienen un rendimiento muy equilibrado
- Solo 11 tipos de producto generan el 80% del revenue total (regla de Pareto)
- El lunes es el dia mas rentable; el fin de semana registra una caida notable

---

## Dashboard — Metabase

### Preguntas 1 a 6
![Dashboard Pestana 1](images/Pestaña1.png)

### Preguntas 7 a 12
![Dashboard Pestana 2](images/Pestaña2.png)

---

## Reporte y Presentacion

- [Reporte en Google Sheets](https://github.com/AlejandroBeldaFernandez/Coffee-Shop-Sales/blob/main/Coffee%20Shop%20Sales%20Report.ods)
- [Presentacion en Google Slides](https://github.com/AlejandroBeldaFernandez/Coffee-Shop-Sales/blob/main/Coffee%20Shop%20Sales%20Slides.odp)

---

## Conclusiones de Negocio

- Reforzar la oferta de Coffee y Tea ya que representan el 66% del revenue
- Ejecutar campañas de marketing en enero y febrero para compensar la caida estacional
- Concentrar los recursos de personal en la franja de mañana, especialmente de lunes a miercoles
- Revisar los productos con menor rotacion como Green Beans para evaluar si tiene sentido mantenerlos en el catalogo
- Los tres locales tienen un rendimiento muy similar, lo que indica una gestion equilibrada de la cadena

---

## Autor

**Alejandro Belda Fernandez**
[GitHub](https://github.com/AlejandroBeldaFernandez)
