# PROYECTO PHOSPITAL - DOCUMENTACION TECNICA FINAL
## Sistema de Gestion Hospitalaria

**Fecha de Finalizacion:** 25 de Noviembre 2025  
**Version:** 7.0 Final  
**Motor de Base de Datos:** SQL Server 2022 Developer  
**Modelo de Datos:** Normalizado (Tercera Forma Normal - 3FN)

---

## 1. DESCRIPCION DEL PROYECTO

PHospital es un sistema integral de gestion hospitalaria desarrollado en SQL Server 2022 que administra de manera completa las operaciones de un hospital: pacientes, personal medico, consultas, tratamientos y facturacion. El sistema esta organizado en cuatro esquemas logicos que separan las diferentes areas funcionales, implementando seguridad robusta, automatizacion de backups y herramientas de analisis avanzado.

---

## 2. ARQUITECTURA DE LA BASE DE DATOS

### 2.1 Esquemas Implementados

| Esquema | Descripcion | Tablas |
|---------|-------------|--------|
| Pacientes | Gestion de informacion de pacientes, tipos de sangre y aseguradoras | 3 |
| Personal | Administracion de medicos y especializaciones | 2 |
| Secretaria | Control de consultas medicas y tratamientos aplicados | 2 |
| Tesoreria | Facturacion, catalogo de tratamientos y detalles de cobro | 3 |

### 2.2 Estructura de Tablas (10 tablas)

**Esquema Pacientes:**
- `Pacientes.TipoDeSangre` - Catalogo de tipos de sangre (8 registros)
- `Pacientes.Aseguradora` - Catalogo de aseguradoras (10 registros)
- `Pacientes.Pacientes` - Informacion de pacientes (1,000 registros)

**Esquema Personal:**
- `Personal.Especializacion` - Catalogo de especialidades medicas (10 registros)
- `Personal.Medicos` - Informacion de medicos (70 registros)

**Esquema Secretaria:**
- `Secretaria.Consultas` - Registro de consultas medicas (8,004 registros)
- `Secretaria.TratamientoXConsulta` - Tratamientos aplicados por consulta (9,855 registros)

**Esquema Tesoreria:**
- `Tesoreria.Tratamientos` - Catalogo de tratamientos disponibles (30 registros)
- `Tesoreria.Factura` - Facturas generadas (6,350 registros)
- `Tesoreria.FacturaDetalle` - Detalles de facturacion (7,825 registros)

### 2.3 Estadisticas del Sistema

| Metrica | Valor |
|---------|-------|
| Medicos registrados | 70 |
| Pacientes registrados | 1,000 |
| Consultas medicas | 8,004 |
| Tratamientos aplicados | 9,855 |
| Facturas generadas | 6,350 |
| Detalles de factura | 7,825 |
| Monto total facturado | $1,023,435 |
| Total de registros | ~25,000 |

---

## 3. FASES DE DESARROLLO

### Fase 1: Estructura Base
Creacion de la base de datos PHospital con los 4 esquemas logicos (Pacientes, Personal, Secretaria, Tesoreria). Implementacion de las 10 tablas con sus relaciones de integridad referencial mediante Foreign Keys. Definicion de constraints PRIMARY KEY, FOREIGN KEY, NOT NULL y UNIQUE para garantizar la integridad de datos.

### Fase 2: Funcionalidades
Implementacion de objetos programables para la logica de negocio:
- 10 Vistas para consultas frecuentes (incluyendo Vista_PowerBI)
- 7 Funciones (3 escalares + 4 de tabla)
- 8 Procedimientos almacenados para operaciones del hospital
- 5 Triggers de validacion con reglas especificas para El Salvador

### Fase 3: Carga de Datos Masivos
Importacion de datos desde archivos CSV utilizando BULK INSERT:
- 60 medicos nuevos (total 70) distribuidos en 9 especialidades
- 970 pacientes nuevos (total 1,000) con datos salvadorenos realistas
- 8,000 consultas distribuidas entre 2023-2025
- 8,952 tratamientos aplicados a consultas finalizadas

**Distribucion de medicos por especialidad:**
- Medicina General: 12
- Pediatria: 10
- Cardiologia: 8
- Ginecologia: 8
- Traumatologia: 7
- Dermatologia: 6
- Oftalmologia: 6
- Psiquiatria: 6
- Odontologia: 7

**Distribucion de pacientes por tipo de sangre:**
- O+: 38% (380 pacientes)
- A+: 31% (310 pacientes)
- B+: 9% (90 pacientes)
- O-: 7% (70 pacientes)
- A-: 6% (60 pacientes)
- AB+: 3% (30 pacientes)
- B-: 2% (20 pacientes)
- AB-: 4% (40 pacientes)

**Distribucion de consultas por estado:**
- Finalizadas: 81% (6,480 consultas)
- Pendientes: 13% (1,040 consultas)
- Canceladas: 6% (480 consultas)

### Fase 4: Generacion de Facturas
Ejecucion del procedimiento de facturacion automatica `Tesoreria.CrearFactura` para todas las consultas finalizadas:
- 6,350 facturas generadas
- 7,825 detalles de factura
- Monto total facturado: $1,023,435

### Fase 5: Seguridad y Auditoria
Implementacion completa del sistema de seguridad:
- 5 roles personalizados con permisos especificos por funcion
- 5 usuarios con politicas de contrasena (CHECK_POLICY, CHECK_EXPIRATION)
- Auditoria de servidor para monitoreo de logins y cambios
- Especificacion de auditoria de BD con 8 acciones monitoreadas
- Ruta de logs de auditoria: `C:\ADMIN BDA\Phospital\AUDITORIAS`

### Fase 6: Indices Optimizados
Analisis y creacion de indices estrategicos:
- 10 indices CLUSTERED automaticos (Primary Keys)
- 10 indices NONCLUSTERED creados estrategicamente
- Eliminacion de 3 indices redundantes tras analisis de rendimiento
- Implementacion de analisis de fragmentacion
- Pruebas de rendimiento con SET STATISTICS IO/TIME

### Fase 7: Funciones Ventana
Implementacion de 4 consultas avanzadas con Window Functions:
- Ranking de aseguradoras usando RANK() OVER
- Promedio de costos por medico usando AVG() OVER (PARTITION BY)
- Seguimiento de pacientes usando LAG() OVER
- Historial cronologico usando ROW_NUMBER() OVER

### Fase 8: Backup y SQL Agent
Implementacion de estrategia completa de respaldo:
- Backups manuales FULL disponibles
- 3 Jobs automaticos en SQL Server Agent
- Estrategia FULL + DIFERENCIAL + LOG

---

## 4. OBJETOS DE BASE DE DATOS

### 4.1 Resumen de Objetos

| Tipo de Objeto | Cantidad |
|----------------|----------|
| Esquemas personalizados | 4 |
| Tablas | 10 |
| Vistas | 10 |
| Funciones | 7 |
| Procedimientos almacenados | 8 |
| Triggers | 5 |
| Indices CLUSTERED (PKs) | 10 |
| Indices NONCLUSTERED | 10 |
| SQL Agent Jobs | 3 |
| Roles personalizados | 5 |
| Usuarios | 5 |
| Auditorias | 3 |
| **Total de objetos** | **67** |

### 4.2 Vistas Implementadas

| Vista | Esquema | Descripcion |
|-------|---------|-------------|
| Vista_Consultas_Detalladas | Secretaria | Informacion completa de consultas |
| Vista_Pacientes_Completa | Pacientes | Datos completos de pacientes |
| Vista_Medicos_Productividad | Personal | Productividad de medicos |
| Vista_Facturacion_Mensual | Tesoreria | Reporte de facturacion por mes |
| Vista_Tratamientos_Mas_Usados | Tesoreria | Tratamientos mas frecuentes |
| Costo_de_Consulta_por_Medico | Secretaria | AVG OVER - Promedio por medico |
| Vista_Comparativa_Consultas | Secretaria | LAG - Seguimiento de pacientes |
| Vista_Historial_Paciente | Secretaria | ROW_NUMBER - Historial cronologico |
| Vista_PowerBI | Secretaria | Vista optimizada para dashboard |
| RankingAseguradoras | dbo | RANK - Ranking de aseguradoras |

### 4.3 Funciones Implementadas

**Funciones Escalares (3):**
- `Secretaria.FN_Total_Consultas_Paciente` - Total de consultas de un paciente
- `Secretaria.FN_Tiene_Consultas_Pendientes` - Verifica consultas pendientes
- `Tesoreria.FN_Calcular_Deuda_Paciente` - Calcula deuda pendiente

**Funciones de Tabla (4):**
- `Secretaria.FN_Tratamientos_De_Consulta` - Tratamientos de una consulta
- `Tesoreria.FN_Total_Gastado_Paciente` - Total gastado por paciente
- `dbo.RankingAseguradoras` - Ranking de aseguradoras (Window Function)
- `dbo.CostoConsultaPorMedico` - Costo promedio por medico (Window Function)

### 4.4 Procedimientos Almacenados

| Procedimiento | Esquema | Funcion |
|---------------|---------|---------|
| SangreCompatible | Pacientes | Verifica compatibilidad de sangre |
| SP_Buscar_Paciente_Por_DUI | Pacientes | Busca paciente por DUI |
| CrearConsulta | Secretaria | Crea nueva consulta medica |
| SP_Reporte_Consultas_Por_Periodo | Secretaria | Reporte de consultas por fechas |
| CrearFactura | Tesoreria | Genera factura de consulta |
| Ver_Historial_de_Facturas | Tesoreria | Historial de facturas de paciente |
| Ver_Ultima_Factura | Tesoreria | Ultima factura de paciente |
| SP_Generar_Facturas_Masivo | Tesoreria | Facturacion masiva |

### 4.5 Triggers de Validacion

| Trigger | Tabla | Funcion |
|---------|-------|---------|
| TR_Validar_DUI | Pacientes.Pacientes | Valida DUI de 8 digitos exactos |
| TR_Validar_Celular_Paciente | Pacientes.Pacientes | Valida celular inicie con 6 o 7, 8 digitos |
| TR_Validar_Edad_Paciente | Pacientes.Pacientes | Valida edad entre 0 y 120 anos |
| TR_Evitar_Eliminar_Paciente_Con_Consultas | Pacientes.Pacientes | Protege integridad referencial |
| TR_Validar_Precio_Tratamiento | Tesoreria.Tratamientos | Valida precio mayor a 0 |

---

## 5. INDICES IMPLEMENTADOS

### 5.1 Indices NONCLUSTERED (10 indices)

**Esquema Pacientes (2 indices):**
```sql
CREATE UNIQUE NONCLUSTERED INDEX IDX_Pacientes_DUI 
ON Pacientes.Pacientes(DUI) 
WHERE DUI IS NOT NULL;

CREATE NONCLUSTERED INDEX IDX_Pacientes_Apellidos 
ON Pacientes.Pacientes(Apellidos);
```

**Esquema Personal (1 indice):**
```sql
CREATE NONCLUSTERED INDEX IDX_Medicos_Especialidad 
ON Personal.Medicos(idEspecializacion);
```

**Esquema Secretaria (4 indices):**
```sql
CREATE NONCLUSTERED INDEX IDX_Consultas_Fecha 
ON Secretaria.Consultas(Fecha);

CREATE NONCLUSTERED INDEX IDX_Consultas_Estado 
ON Secretaria.Consultas(Estado);

CREATE NONCLUSTERED INDEX IDX_Consultas_Paciente 
ON Secretaria.Consultas(idPaciente);

CREATE NONCLUSTERED INDEX IDX_Consultas_Medico 
ON Secretaria.Consultas(idMedico);
```

**Esquema Tesoreria (3 indices):**
```sql
CREATE NONCLUSTERED INDEX IDX_Factura_Fecha 
ON Tesoreria.Factura(Fecha);

CREATE NONCLUSTERED INDEX IDX_Factura_Paciente 
ON Tesoreria.Factura(idPaciente);

CREATE NONCLUSTERED INDEX IDX_Factura_Estado 
ON Tesoreria.Factura(Estado);
```

### 5.2 Distribucion de Indices por Tabla

| Esquema | Tabla | CLUSTERED | NONCLUSTERED |
|---------|-------|-----------|--------------|
| Pacientes | TipoDeSangre | 1 (PK) | 0 |
| Pacientes | Aseguradora | 1 (PK) | 0 |
| Pacientes | Pacientes | 1 (PK) | 2 |
| Personal | Especializacion | 1 (PK) | 0 |
| Personal | Medicos | 1 (PK) | 1 |
| Secretaria | Consultas | 1 (PK) | 4 |
| Secretaria | TratamientoXConsulta | 1 (PK) | 0 |
| Tesoreria | Tratamientos | 1 (PK) | 0 |
| Tesoreria | Factura | 1 (PK) | 3 |
| Tesoreria | FacturaDetalle | 1 (PK) | 0 |
| **Total** | | **10** | **10** |

### 5.3 Indices Descartados por Optimizacion

| Indice | Razon de eliminacion |
|--------|---------------------|
| IDX_Pacientes_TipoSangre | Baja selectividad (solo 8 valores posibles) |
| IDX_Consultas_Paciente_Fecha | Redundante con IDX_Consultas_Paciente |
| IDX_TratamientoXConsulta_Consulta | Tabla auxiliar pequena, FK suficiente |

### 5.4 Consulta de Analisis de Fragmentacion

```sql
SELECT 
    OBJECT_NAME(ips.object_id) AS Tabla,
    i.name AS Indice,
    ips.index_type_desc AS Tipo,
    ips.avg_fragmentation_in_percent AS Fragmentacion
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') AS ips
JOIN sys.indexes AS i ON ips.object_id = i.object_id AND ips.index_id = i.index_id
WHERE ips.database_id = DB_ID()
ORDER BY Fragmentacion DESC;
```

**Niveles de Fragmentacion:**
- Menor a 10%: Optimo, no requiere mantenimiento
- 10-30%: Moderado, ejecutar REORGANIZE
- Mayor a 30%: Alto, ejecutar REBUILD

---

## 6. SEGURIDAD

### 6.1 Roles Personalizados

| Rol | Permisos | Uso |
|-----|----------|-----|
| rol_administrador | CONTROL sobre todos los esquemas | Administracion total del sistema |
| rol_analista | SELECT en vistas y tablas principales | Acceso para Power BI y reportes |
| rol_profesor | SELECT en todos los esquemas | Evaluacion academica |
| rol_alumno | SELECT, INSERT, UPDATE, DELETE | Desarrollo del proyecto |
| rol_invitado | SELECT limitado | Solo lectura basica |

### 6.2 Usuarios Configurados

| Usuario | Rol Asignado | Politicas |
|---------|--------------|-----------|
| Administrador | rol_administrador | CHECK_POLICY=ON, CHECK_EXPIRATION=ON |
| Analista | rol_analista | CHECK_POLICY=ON, CHECK_EXPIRATION=ON |
| Profesor | rol_profesor | CHECK_POLICY=ON, CHECK_EXPIRATION=ON |
| Alumno | rol_alumno | CHECK_POLICY=ON, CHECK_EXPIRATION=ON |
| Invitado | rol_invitado | CHECK_POLICY=ON, CHECK_EXPIRATION=ON |

### 6.3 Auditoria Implementada

**Auditoria de Servidor:**
- Monitoreo de logins exitosos y fallidos
- Cambios en configuracion de servidor
- Modificaciones de seguridad

**Especificacion de Servidor (4 grupos):**
- SUCCESSFUL_LOGIN_GROUP
- FAILED_LOGIN_GROUP
- SERVER_ROLE_MEMBER_CHANGE_GROUP
- DATABASE_ROLE_MEMBER_CHANGE_GROUP

**Especificacion de Base de Datos (8 acciones):**
- SELECT, INSERT, UPDATE, DELETE en tablas criticas
- EXECUTE en procedimientos almacenados
- Cambios de esquema

**Ubicacion de logs:** `C:\ADMIN BDA\Phospital\AUDITORIAS`

---

## 7. SQL SERVER AGENT

### 7.1 Jobs Automatizados

| Job | Tipo | Frecuencia Recomendada | Estado |
|-----|------|------------------------|--------|
| Full_Backup | Backup completo | Semanal (Domingo 2:00 AM) | Activo |
| Diff_Backup | Backup diferencial | Diario (10:00 PM) | Activo |
| Log_Backup | Backup de log | Cada 3-6 horas | Activo |

### 7.2 Estrategia de Backup

```
ESTRATEGIA FULL + DIFERENCIAL + LOG

1. BACKUP FULL (Full_Backup)
   Frecuencia: Semanal
   Archivo: PHospital_FULL_YYYYMMDD.bak
   Contenido: Base de datos completa

2. BACKUP DIFERENCIAL (Diff_Backup)
   Frecuencia: Diario
   Archivo: PHospital_DIFF_YYYYMMDD.bak
   Contenido: Cambios desde ultimo FULL

3. BACKUP LOG (Log_Backup)
   Frecuencia: Cada 3-6 horas
   Archivo: PHospital_LOG_YYYYMMDD_HHMM.trn
   Contenido: Log de transacciones

Objetivos de Recuperacion:
- RTO (Recovery Time Objective): < 1 hora
- RPO (Recovery Point Objective): < 3-6 horas
```

### 7.3 Verificacion de SQL Agent

```sql
--- Ver estado de jobs
SELECT 
    j.name AS NombreJob,
    j.enabled AS Habilitado,
    js.last_run_date AS UltimaEjecucion,
    js.last_run_outcome AS Resultado
FROM msdb.dbo.sysjobs j
LEFT JOIN msdb.dbo.sysjobservers js ON j.job_id = js.job_id
WHERE j.name IN ('Full_Backup', 'Diff_Backup', 'Log_Backup');
```

---

## 8. FUNCIONES VENTANA

### 8.1 Ranking de Aseguradoras

**Objeto:** `dbo.RankingAseguradoras()`  
**Window Function:** RANK() OVER (ORDER BY TotalFacturas DESC)  
**Tecnica Adicional:** CTE (Common Table Expression)

```sql
CREATE FUNCTION dbo.RankingAseguradoras()
RETURNS TABLE
AS
RETURN
(
    WITH FrecuenciaAseguradoras AS (
        SELECT
            a.Aseguradora,
            COUNT(F.id) AS TotalFacturas
        FROM Pacientes.Aseguradora AS a
        INNER JOIN Pacientes.Pacientes AS p ON a.idSeguro = p.idSeguro
        INNER JOIN Tesoreria.Factura AS f ON p.id = f.idPaciente
        GROUP BY a.Aseguradora
    )
    SELECT
        Aseguradora,
        TotalFacturas,
        RANK() OVER (ORDER BY TotalFacturas DESC) AS Ranking
    FROM FrecuenciaAseguradoras
);
```

**Uso:** Identificar aseguradoras mas frecuentadas para negociaciones comerciales.

### 8.2 Costo de Consulta por Medico

**Objeto:** `Secretaria.Costo_de_Consulta_por_Medico`  
**Window Function:** AVG() OVER (PARTITION BY idMedico)

```sql
CREATE VIEW Secretaria.Costo_de_Consulta_por_Medico AS
SELECT
    c.id AS idConsulta,
    m.Nombres + ' ' + m.Apellidos AS Medico,
    p.Nobres + ' ' + p.Apellidos AS Paciente,
    SUM(t.Precio * txc.Cantidad) AS CostoConsultaIndividual,
    AVG(SUM(t.Precio * txc.Cantidad)) 
        OVER (PARTITION BY c.idMedico) AS PromedioGastoMedico
FROM Secretaria.Consultas c
INNER JOIN Secretaria.TratamientoXConsulta txc ON c.id = txc.idConsulta
INNER JOIN Tesoreria.Tratamientos t ON txc.idTratamiento = t.id
INNER JOIN Personal.Medicos m ON c.idMedico = m.id
INNER JOIN Pacientes.Pacientes p ON c.idPaciente = p.id
GROUP BY c.id, c.idMedico, m.Nombres, m.Apellidos, p.Nobres, p.Apellidos;
```

**Uso:** Control de calidad y deteccion de consultas con costos atipicos.

### 8.3 Seguimiento Medico (LAG)

**Objeto:** `Secretaria.Vista_Comparativa_Consultas`  
**Window Function:** LAG() OVER (PARTITION BY idPaciente ORDER BY Fecha)

```sql
CREATE VIEW Secretaria.Vista_Comparativa_Consultas AS
WITH CostosConsulta AS (
    SELECT
        c.idPaciente,
        p.Nobres + ' ' + p.Apellidos AS Paciente,
        c.Fecha AS FechaConsulta,
        SUM(t.Precio * txc.Cantidad) AS Costo
    FROM Secretaria.Consultas c
    INNER JOIN Secretaria.TratamientoXConsulta txc ON c.id = txc.idConsulta
    INNER JOIN Tesoreria.Tratamientos t ON txc.idTratamiento = t.id
    INNER JOIN Pacientes.Pacientes p ON c.idPaciente = p.id
    GROUP BY c.idPaciente, c.Fecha, p.Nobres, p.Apellidos
)
SELECT
    Paciente,
    FechaConsulta,
    Costo AS CostoActual,
    LAG(Costo, 1) OVER (PARTITION BY idPaciente ORDER BY FechaConsulta) AS CostoAnterior,
    Costo - LAG(Costo, 1) OVER (PARTITION BY idPaciente ORDER BY FechaConsulta) AS DiferenciaEnCosto
FROM CostosConsulta;
```

**Uso:** Seguimiento de evolucion de tratamientos y deteccion de complicaciones.

### 8.4 Historial Paciente (ROW_NUMBER)

**Objeto:** `Secretaria.Vista_Historial_Paciente`  
**Window Function:** ROW_NUMBER() OVER (PARTITION BY idPaciente ORDER BY Fecha)

```sql
CREATE VIEW Secretaria.Vista_Historial_Paciente AS
SELECT
    ROW_NUMBER() OVER (PARTITION BY c.idPaciente ORDER BY c.Fecha) AS NumeracionConsulta,
    p.Nobres + ' ' + p.Apellidos AS Paciente,
    c.Fecha AS FechaConsulta,
    m.Nombres + ' ' + m.Apellidos AS Medico,
    e.Especializacion,
    c.Motivo,
    c.Estado
FROM Secretaria.Consultas c
INNER JOIN Pacientes.Pacientes p ON c.idPaciente = p.id
INNER JOIN Personal.Medicos m ON c.idMedico = m.id
INNER JOIN Personal.Especializacion e ON m.idEspecializacion = e.idEspecializacion;
```

**Uso:** Historial clinico completo y ordenado cronologicamente.

### 8.5 Resumen de Funciones Ventana

| Consulta | Window Function | Tecnica | Aplicacion |
|----------|-----------------|---------|------------|
| Ranking Aseguradoras | RANK() | CTE | Negociaciones comerciales |
| Costo por Medico | AVG() OVER | PARTITION BY | Control de calidad |
| Seguimiento Medico | LAG() | CTE, PARTITION BY | Evolucion de pacientes |
| Historial Paciente | ROW_NUMBER() | PARTITION BY | Historial cronologico |

---

## 9. DASHBOARD POWER BI

**Estado:** Implementado y funcional  
**Vista de conexion:** `Secretaria.Vista_PowerBI`  
**Link de acceso:** https://ucaedusv-my.sharepoint.com/:u:/g/personal/00543924_uca_edu_sv/IQCZBJUcWURTTruc08kLZoQLARoOyFyyYIslUJS86NWs4sg?e=RhJEeQ

**Vista utilizada para conexion:**
```sql
CREATE VIEW Secretaria.Vista_PowerBI AS
SELECT
    c.id AS idConsulta,
    c.Fecha AS FechaConsulta,
    p.Nobres + ' ' + p.Apellidos AS Paciente,
    p.edad AS EdadPaciente,
    p.Sexo AS SexoPaciente,
    ts.TipoDeSangre,
    a.Aseguradora,
    m.Nombres + ' ' + m.Apellidos AS Medico,
    e.Especializacion,
    c.Motivo,
    c.Estado,
    ISNULL(SUM(t.Precio * txc.Cantidad), 0) AS CostoTotal
FROM Secretaria.Consultas c
INNER JOIN Pacientes.Pacientes p ON c.idPaciente = p.id
INNER JOIN Pacientes.TipoDeSangre ts ON p.idTipoDeSangre = ts.idSangre
INNER JOIN Pacientes.Aseguradora a ON p.idSeguro = a.idSeguro
INNER JOIN Personal.Medicos m ON c.idMedico = m.id
INNER JOIN Personal.Especializacion e ON m.idEspecializacion = e.idEspecializacion
LEFT JOIN Secretaria.TratamientoXConsulta txc ON c.id = txc.idConsulta
LEFT JOIN Tesoreria.Tratamientos t ON txc.idTratamiento = t.id
GROUP BY 
    c.id, c.Fecha, c.Motivo, c.Estado,
    p.Nobres, p.Apellidos, p.edad, p.Sexo,
    ts.TipoDeSangre, a.Aseguradora,
    m.Nombres, m.Apellidos, e.Especializacion;
```

**Analisis disponibles en el dashboard:**
- Consultas por especialidad
- Tendencias temporales de atencion
- Distribucion por aseguradoras
- Productividad de medicos
- Demografia de pacientes
- Analisis de costos

---

## 10. VALIDACIONES ESPECIFICAS PARA EL SALVADOR

| Validacion | Regla | Implementacion |
|------------|-------|----------------|
| DUI | Exactamente 8 digitos numericos (10000000-99999999) | Trigger TR_Validar_DUI |
| Celular | 8 digitos, inicia con 6 o 7 (60000000-79999999) | Trigger TR_Validar_Celular_Paciente |
| Edad | Entre 0 y 120 anos | Trigger TR_Validar_Edad_Paciente |
| Datos de prueba | Nombres, apellidos y direcciones salvadorenas | Archivos CSV de carga |

---

## 11. BACKUPS DISPONIBLES

| Archivo | Contenido | Fecha |
|---------|-----------|-------|
| PHospital_FULL_20251112.bak | Fase 1 y 2 | 12/11/2025 |
| PHospital_15-11-2025.bak | Fase 1, 2 + funciones | 15/11/2025 |
| PHospital_FULL_INDICES_CREADOS.bak | Proyecto 100% completo | 25/11/2025 |
| Backups automaticos SQL Agent | FULL, DIFF, LOG | Automaticos |

**Script de restauracion:**
```sql
USE master;
ALTER DATABASE PHospital SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

RESTORE DATABASE PHospital
FROM DISK = 'C:\Ruta\PHospital_FULL_INDICES_CREADOS.bak'
WITH REPLACE, STATS = 10;

ALTER DATABASE PHospital SET MULTI_USER;
```

---

## 12. ESTRUCTURA DE ARCHIVOS DEL PROYECTO

```
PHospital_Completo/
|
|-- Fase_1_Estructura/
|   |-- Script_1.1_BD_y_Esquemas.sql
|   |-- Script_1.2_Tablas.sql
|   |-- Script_1.3_Datos_Maestros.sql
|   |-- Script_1.4_Datos_Prueba.sql
|   |-- Script_1.5_Procedimientos_Originales.sql
|
|-- Fase_2_Funcionalidades/
|   |-- Script_2_Funcionalidades.sql
|
|-- Fase_3_Datos_Masivos/
|   |-- Script_BULK_INSERT_Datos_Masivos.sql
|   |-- Medicos_Nuevos.csv
|   |-- Pacientes_Nuevos.csv
|   |-- Consultas_Nuevas.csv
|   |-- TratamientosXConsulta.csv
|
|-- Fase_4_Facturacion/
|   |-- Script_Generar_Facturas.sql
|
|-- Fase_5_Seguridad/
|   |-- Script_5_Roles_Usuarios_Auditoria.sql
|   |-- Script_Verificacion_Seguridad.sql
|
|-- Fase_6_Indices/
|   |-- INDICES.sql
|   |-- Script_Analisis_Fragmentacion.sql
|   |-- Script_Mantenimiento_Indices.sql
|
|-- Fase_7_Funciones_Ventana/
|   |-- Script_7_Funciones_Ventana.sql
|
|-- Fase_8_Backup/
|   |-- Script_Backup_PHospital.sql
|   |-- Script_Restaurar_PHospital.sql
|   |-- PHospital_FULL_INDICES_CREADOS.bak
|
|-- PowerBI/
|   |-- Dashboard_PHospital.pbix
|
|-- Documentacion/
    |-- DOCUMENTACION_FINAL_PHOSPITAL.md
```

---

## 13. ESPECIFICACIONES TECNICAS

| Especificacion | Valor |
|----------------|-------|
| Motor | SQL Server 2022 Developer |
| Modelo de datos | Normalizado (3FN) |
| Esquemas | 4 |
| Tablas | 10 |
| Vistas | 10 |
| Funciones | 7 |
| Procedimientos almacenados | 8 |
| Triggers | 5 |
| Total de objetos | 67 |
| Total de indices | 20 (10 CLUSTERED + 10 NONCLUSTERED) |
| SQL Agent Jobs | 3 |
| Roles personalizados | 5 |
| Usuarios | 5 |
| Auditorias | 3 |
| Total de registros | ~25,000 |
| Facturacion total | $1,023,435 |

---

## 14. TECNOLOGIAS Y CONCEPTOS APLICADOS

**Diseno de Base de Datos:**
- Normalizacion (3FN - Tercera Forma Normal)
- Esquemas para organizacion logica
- Relaciones FK con integridad referencial
- Constraints (PK, FK, NOT NULL, UNIQUE)

**Programabilidad:**
- Triggers para validaciones automaticas
- Procedimientos almacenados para logica de negocio
- Funciones escalares y de tabla
- Vistas para consultas frecuentes

**Analisis Avanzado:**
- Window Functions (AVG, RANK, ROW_NUMBER, LAG)
- CTEs (Common Table Expressions)
- PARTITION BY para agrupacion logica

**Optimizacion:**
- Indices NONCLUSTERED estrategicos
- Analisis de fragmentacion
- Mantenimiento de indices (REBUILD/REORGANIZE)
- Pruebas de rendimiento (STATISTICS IO/TIME)
- Eliminacion de indices redundantes

**Seguridad:**
- Roles personalizados por funcion
- Usuarios con politicas de contrasena
- Auditorias de servidor y base de datos
- Trazabilidad completa de operaciones

**Continuidad de Negocio:**
- Backups automatizados con SQL Agent
- Estrategia FULL + DIFERENCIAL + LOG
- RTO y RPO definidos
- Documentacion de recuperacion

**Business Intelligence:**
- Dashboard Power BI funcional
- Vista optimizada para BI
- Analisis en tiempo real

---

**Ultima Actualizacion:** 25 de Noviembre 2025  
**Equipo:** PHospital  
**Version de Documentacion:** 7.0 Final
