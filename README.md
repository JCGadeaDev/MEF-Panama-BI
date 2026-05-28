# 🏛️ MEF Panamá — Sistema de Inteligencia Presupuestaria

> **Demo BI End-to-End** | Plataforma de analítica presupuestaria para el Ministerio de Economía y Finanzas de Panamá

![Status](https://img.shields.io/badge/Status-Live%20Demo-brightgreen)
![Stack](https://img.shields.io/badge/Stack-SQL%20Server%20%7C%20Power%20BI%20%7C%20HTML-blue)
![License](https://img.shields.io/badge/License-MIT-lightgrey)

---

## 🌐 Live Demo

🔗 **[Ver Demo en Vivo →](https://mef-panama-bi.netlify.app)**

---

## 📌 Descripción del Proyecto

Plataforma de Business Intelligence end-to-end diseñada para la gestión y análisis de la ejecución presupuestaria del sector público panameño. El proyecto integra un modelo de datos relacional en SQL Server, métricas DAX avanzadas en Power BI y una landing page HTML con control de acceso por roles simulado.

Este proyecto fue desarrollado como **demostración técnica** de capacidades BI para entidades gubernamentales, cubriendo el flujo completo desde la ingesta de datos hasta la visualización ejecutiva.

---

## 🎯 Funcionalidades Principales

- 📊 **Dashboard ejecutivo** con KPIs de ejecución presupuestaria por ministerio y sector
- 🔐 **Sistema de roles simulado** — acceso diferenciado para Analista, Director y Ministro
- 📈 **Análisis histórico** 2022–2024 con variación interanual (YoY)
- 🏛️ **10 ministerios** cubiertos: MEDUCA, CSS, MINSA, MIVIOT, MOP, MINSEG, MEF, MICI, MIDA, MiAMBIENTE
- 🔍 **Semáforo de ejecución** — clasificación automática por % de ejecución presupuestaria
- 📋 **Vistas SQL optimizadas** para consumo directo en Power BI vía DirectQuery

---

## 🗂️ Estructura del Proyecto

```
mef-panama-bi/
├── MEF_Panama_Landing_Demo.html     # Landing page con login y roles
├── MEF_Panama_SQL_Setup.sql         # Script completo: esquema, datos y vistas
├── MEF_Panama_Demo_BI.xlsx          # Dataset fuente en Excel
├── Demo_Ministerio_de_Economia_Panama.pbix  # Reporte Power BI
└── README.md
```

---

## 🏗️ Arquitectura Técnica

```
Excel (Fuente) → SQL Server (Star Schema) → Power BI (DAX + DirectQuery) → Landing HTML (RBAC)
```

### Modelo de Datos — Star Schema

```
dim_sector ──────┐
                 ├──→ fact_presupuesto ←──── dim_tiempo
dim_ministerio ──┘
```

| Tabla | Tipo | Descripción |
|---|---|---|
| `mef.fact_presupuesto` | Hechos | Presupuesto aprobado vs ejecutado por entidad/año |
| `mef.dim_ministerio` | Dimensión | 10 entidades del sector público |
| `mef.dim_sector` | Dimensión | 4 sectores: Social, Infraestructura, Seguridad, Económico |
| `mef.dim_tiempo` | Dimensión | Años fiscales 2022–2024 |

### Vistas SQL para Power BI

| Vista | Propósito |
|---|---|
| `vw_ejecucion_presupuestaria` | Vista principal con % ejecución calculado |
| `vw_resumen_sector` | Agregación por sector y año fiscal |
| `vw_variacion_anual` | Variación YoY con función LAG() |

---

## 📐 Métricas DAX Implementadas

```dax
-- % de Ejecución Total
Pct Ejecución =
    DIVIDE(SUM(fact_presupuesto[monto_ejecutado]),
           SUM(fact_presupuesto[presupuesto_aprobado]), 0)

-- Variación YoY del Monto Ejecutado
Var YoY Ejecutado =
    VAR AnioActual = SELECTEDVALUE(dim_tiempo[anio_fiscal])
    VAR AnioAnt    = AnioActual - 1
    VAR EjActual   = CALCULATE(SUM(fact_presupuesto[monto_ejecutado]),
                               dim_tiempo[anio_fiscal] = AnioActual)
    VAR EjAnt      = CALCULATE(SUM(fact_presupuesto[monto_ejecutado]),
                               dim_tiempo[anio_fiscal] = AnioAnt)
    RETURN DIVIDE(EjActual - EjAnt, EjAnt, BLANK())

-- Ranking por Ejecución (Dense)
Ranking Ejecución =
    RANKX(ALL(dim_ministerio[nombre]),
          [Pct Ejecución], , DESC, Dense)

-- Saldo No Ejecutado
Saldo No Ejecutado =
    SUM(fact_presupuesto[presupuesto_aprobado]) -
    SUM(fact_presupuesto[monto_ejecutado])
```

---

## 🔐 Sistema de Roles (Landing HTML)

| Rol | Credenciales | Acceso |
|---|---|---|
| **Analista** | `analista` / `mef2025` | Datos operativos y filtros |
| **Director** | `director` / `mef2025` | Vista gerencial + comparativos |
| **Ministro** | `ministro` / `mef2025` | Dashboard ejecutivo completo |

> ⚠️ Credenciales de demo — solo para fines de demostración técnica.

---

## 🚀 Setup Local

### 1. Base de Datos SQL Server

```sql
-- Crear base de datos
CREATE DATABASE MEF_Panama_Demo;
USE MEF_Panama_Demo;

-- Ejecutar el script completo
-- MEF_Panama_SQL_Setup.sql
```

### 2. Power BI Desktop

1. Abrir `Demo_Ministerio_de_Economia_Panama.pbix`
2. Actualizar la conexión a tu instancia SQL Server local
3. Refrescar el modelo de datos

### 3. Landing Page HTML

```bash
# Opción 1: Abrir directamente en el navegador
open MEF_Panama_Landing_Demo.html

# Opción 2: Servidor local
npx serve .
# → http://localhost:3000
```

---

## 🛠️ Tech Stack

| Capa | Tecnología |
|---|---|
| **Base de Datos** | SQL Server 2019+ / PostgreSQL 15+ |
| **Modelado** | Star Schema, T-SQL, Stored Views |
| **Analytics** | Power BI Desktop, DAX, DirectQuery |
| **Frontend** | HTML5, CSS3 Vanilla, JavaScript ES6 |
| **Fuente de Datos** | Microsoft Excel (.xlsx) |
| **Deploy** | Netlify (HTML) |

---

## 📊 Cobertura de Datos

| Métrica | Valor |
|---|---|
| Ministerios / Entidades | 10 |
| Sectores cubiertos | 4 |
| Años fiscales | 2022 · 2023 · 2024 |
| Registros en fact table | 30 |
| Presupuesto total cubierto (2024) | ~$8.88B USD |

---

## 📁 Recursos Adicionales

- 📥 [Descargar reporte .pbix](./Demo_Ministerio_de_Economia_Panama.pbix)
- 📥 [Descargar dataset .xlsx](./MEF_Panama_Demo_BI.xlsx)
- 📜 [Ver script SQL completo](./MEF_Panama_SQL_Setup.sql)

---

## 👨‍💻 Autor

**Juan Carlos Gadea Brenes**
Cloud Solutions Architect · Technical Lead · Data Engineer

[![Portfolio](https://img.shields.io/badge/Portfolio-portafolio--jc--gadea.vercel.app-blue)](https://portafolio-jc-gadea.vercel.app/)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-JCGadeaDev-0077B5)](https://www.linkedin.com/in/jcgadeadev/)
[![GitHub](https://img.shields.io/badge/GitHub-JCGadeaDev-181717)](https://github.com/JCGadeaDev)

---

## 📄 Licencia

MIT License — libre para uso educativo y de referencia técnica.
