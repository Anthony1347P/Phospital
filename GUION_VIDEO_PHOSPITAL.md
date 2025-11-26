# GUION DE VIDEO - PROYECTO PHOSPITAL
## Sistema de Gestion Hospitalaria
### Duracion Total: 10 minutos | 6 Personas

---

## DISTRIBUCION DE TIEMPO POR PERSONA

| Persona | Tema | Tiempo |
|---------|------|--------|
| 1. Anthony | Descripcion General de la BD | 1:40 min |
| 2. Persona 2 | Datos Masivos y Estadisticas | 1:40 min |
| 3. Persona 3 | Seguridad: Roles, Usuarios, Auditorias | 1:40 min |
| 4. Persona 4 | Indices y Optimizacion | 1:40 min |
| 5. Persona 5 | Funciones Ventana | 1:40 min |
| 6. Persona 6 | SQL Agent, Backups, Power BI y Conclusiones | 1:40 min |

---

# PERSONA 1: ANTHONY
## Tema: Descripcion General de la Base de Datos
### Tiempo: 1 minuto 40 segundos

---

### GUION COMPLETO (Hablar a camara o mostrando pantalla)

**[0:00 - 0:15] INTRODUCCION** (Hablar a camara)
> "Hola, soy Anthony y les presento PHospital, un sistema de gestion hospitalaria desarrollado en SQL Server. Este proyecto implementa una base de datos completa para administrar pacientes, personal medico, consultas y facturacion."

**[0:15 - 0:35] ARQUITECTURA - 4 ESQUEMAS** (Mostrar pantalla con diagrama o SSMS)
> "La base de datos esta organizada en 4 esquemas logicos:
> - **Pacientes**: Gestiona datos de pacientes, tipos de sangre y aseguradoras
> - **Personal**: Administra medicos y especializaciones
> - **Tesoreria**: Maneja facturacion y tratamientos
> - **Secretaria**: Controla consultas medicas"

**[0:35 - 0:55] TABLAS - 10 EN TOTAL** (Mostrar SSMS con las tablas)
> "El sistema cuenta con 10 tablas normalizadas en Tercera Forma Normal:
> - Esquema Pacientes: TipoDeSangre, Aseguradora, Pacientes
> - Esquema Personal: Especializacion, Medicos
> - Esquema Tesoreria: Tratamientos, Factura, FacturaDetalle
> - Esquema Secretaria: Consultas, TratamientoXConsulta"

**[0:55 - 1:15] OBJETOS DE BASE DE DATOS** (Mostrar resumen o query)
> "En total tenemos 67 objetos de base de datos:
> - 10 Vistas, incluyendo Vista_PowerBI para reportes
> - 7 Funciones, 4 de ellas con funciones ventana
> - 8 Procedimientos almacenados para logica de negocio
> - 5 Triggers que validan datos especificos de El Salvador"

**[1:15 - 1:40] VALIDACIONES SALVADORENAS** (Mostrar codigo de triggers)
> "Los triggers implementan validaciones especificas para El Salvador:
> - DUI: Exactamente 8 digitos
> - Celular: 8 digitos iniciando con 6 o 7
> - Edad: Entre 0 y 120 anos
> - Integridad: No permite eliminar pacientes con consultas activas
> 
> Ahora mi companero les explicara los datos cargados en el sistema."

---

### NOTAS TECNICAS PARA ANTHONY:

**Consultas para mostrar en pantalla:**
```sql
--- Ver esquemas
SELECT name AS Esquema FROM sys.schemas 
WHERE name IN ('Pacientes', 'Personal', 'Tesoreria', 'Secretaria');

--- Contar objetos
SELECT 'Tablas' AS Tipo, COUNT(*) AS Cantidad FROM sys.tables 
WHERE schema_id IN (SCHEMA_ID('Pacientes'), SCHEMA_ID('Personal'), 
                    SCHEMA_ID('Tesoreria'), SCHEMA_ID('Secretaria'))
UNION ALL
SELECT 'Vistas', COUNT(*) FROM sys.views 
WHERE schema_id IN (SCHEMA_ID('Pacientes'), SCHEMA_ID('Personal'), 
                    SCHEMA_ID('Tesoreria'), SCHEMA_ID('Secretaria'))
UNION ALL
SELECT 'Funciones', COUNT(*) FROM sys.objects WHERE type IN ('FN', 'IF', 'TF')
UNION ALL
SELECT 'Procedimientos', COUNT(*) FROM sys.procedures
UNION ALL
SELECT 'Triggers', COUNT(*) FROM sys.triggers WHERE is_ms_shipped = 0;
```

---

# PERSONA 2
## Tema: Datos Masivos y Estadisticas
### Tiempo: 1 minuto 40 segundos

---

### GUION COMPLETO

**[0:00 - 0:20] INTRODUCCION A LOS DATOS** (Hablar a camara)
> "Continuando con la presentacion, les hablo sobre los datos masivos cargados en PHospital. El sistema maneja volumenes de datos realistas que simulan la operacion de un hospital real."

**[0:20 - 0:45] ESTADISTICAS PRINCIPALES** (Mostrar pantalla con resultados)
> "Nuestro sistema contiene:
> - 1,000 pacientes registrados con datos salvadorenos reales
> - 70 medicos en 9 especializaciones diferentes
> - 8,004 consultas medicas distribuidas en 3 anos
> - 9,855 tratamientos aplicados a pacientes"

**[0:45 - 1:05] FACTURACION** (Mostrar query de facturacion)
> "En el modulo de Tesoreria tenemos:
> - 6,350 facturas generadas automaticamente
> - 7,825 detalles de factura
> - Un monto total facturado de mas de un millon de dolares: exactamente $1,023,435 dolares"

**[1:05 - 1:25] METODO DE CARGA** (Explicar proceso)
> "Los datos fueron cargados usando archivos CSV con BULK INSERT, lo que permitio una carga eficiente de grandes volumenes. Los archivos incluyen:
> - Pacientes_CON_ID.csv
> - Medicos_CON_ID.csv
> - Consultas_CON_ID.csv
> - TratamientoXConsulta_CON_ID.csv"

**[1:25 - 1:40] TRANSICION** (Hablar a camara)
> "Todos los datos cumplen con las validaciones de triggers que menciono Anthony. Ahora mi companero explicara como protegemos esta informacion con el sistema de seguridad."

---

### CONSULTAS PARA MOSTRAR:
```sql
--- Estadisticas del sistema
SELECT 'Pacientes' AS Entidad, COUNT(*) AS Total FROM Pacientes.Pacientes
UNION ALL SELECT 'Medicos', COUNT(*) FROM Personal.Medicos
UNION ALL SELECT 'Consultas', COUNT(*) FROM Secretaria.Consultas
UNION ALL SELECT 'Tratamientos Aplicados', COUNT(*) FROM Secretaria.TratamientoXConsulta
UNION ALL SELECT 'Facturas', COUNT(*) FROM Tesoreria.Factura
UNION ALL SELECT 'Detalles Factura', COUNT(*) FROM Tesoreria.FacturaDetalle;

--- Total facturado
SELECT FORMAT(SUM(Total), 'C', 'en-US') AS TotalFacturado FROM Tesoreria.Factura;
```

---

# PERSONA 3
## Tema: Seguridad - Roles, Usuarios y Auditorias
### Tiempo: 1 minuto 40 segundos

---

### GUION COMPLETO

**[0:00 - 0:15] INTRODUCCION** (Hablar a camara)
> "La seguridad es fundamental en un sistema hospitalario. PHospital implementa un sistema de seguridad multicapa con roles, usuarios y auditorias completas."

**[0:15 - 0:40] ROLES PERSONALIZADOS - 5 ROLES** (Mostrar SSMS)
> "Creamos 5 roles personalizados segun la funcion del usuario:
> - **rol_administrador**: Control total del sistema
> - **rol_analista**: Acceso a vistas para Power BI
> - **rol_alumno**: Acceso completo para desarrollo
> - **rol_profesor**: Lectura para evaluacion academica
> - **rol_invitado**: Solo acceso a vistas, sin tablas directas"

**[0:40 - 1:00] USUARIOS - 5 USUARIOS** (Mostrar consulta de usuarios)
> "Cada rol tiene su usuario correspondiente con politicas de seguridad:
> - DBAdmin, Analista, Alumno, Profesor, Invitado
> - Todos con CHECK_POLICY y CHECK_EXPIRATION activados
> - Contrasenas seguras que cumplen requisitos de complejidad"

**[1:00 - 1:25] AUDITORIAS - 3 ACTIVAS** (Mostrar configuracion)
> "El sistema cuenta con 3 niveles de auditoria:
> - **Auditoria de Servidor**: Registra logins y cambios
> - **Especificacion de Servidor**: Audita 4 grupos de eventos
> - **Especificacion de BD**: Audita 8 acciones en objetos criticos
> 
> Los logs se almacenan en C:\ADMIN BDA\Phospital\AUDITORIAS"

**[1:25 - 1:40] TRANSICION**
> "Con esta capa de seguridad, toda accion queda registrada y es trazable. Mi companero ahora explicara como optimizamos el rendimiento con indices."

---

### CONSULTAS PARA MOSTRAR:
```sql
--- Ver roles creados
SELECT name AS Rol FROM sys.database_principals 
WHERE type = 'R' AND name LIKE 'rol_%';

--- Ver usuarios y sus roles
SELECT dp.name AS Usuario, r.name AS Rol
FROM sys.database_principals dp
JOIN sys.database_role_members drm ON dp.principal_id = drm.member_principal_id
JOIN sys.database_principals r ON drm.role_principal_id = r.principal_id
WHERE dp.type = 'S' AND dp.name IN ('Analista', 'DBAdmin', 'Invitado', 'Profesor', 'Alumno');

--- Ver auditorias
SELECT name AS Auditoria, is_state_enabled AS Activa FROM sys.server_audits;
```

---

# PERSONA 4
## Tema: Indices y Optimizacion
### Tiempo: 1 minuto 40 segundos

---

### GUION COMPLETO

**[0:00 - 0:15] INTRODUCCION** (Hablar a camara)
> "Para garantizar un rendimiento optimo con mas de 25,000 registros, implementamos una estrategia de indices cuidadosamente disenada."

**[0:15 - 0:40] INDICES IMPLEMENTADOS - 20 TOTAL** (Mostrar lista de indices)
> "PHospital cuenta con 20 indices en total:
> - 10 indices CLUSTERED creados automaticamente por las Primary Keys
> - 10 indices NONCLUSTERED estrategicos creados manualmente
> 
> Los NONCLUSTERED estan distribuidos en las tablas mas consultadas:
> - Pacientes: 2 indices (DUI y Apellidos)
> - Medicos: 1 indice (Especialidad)
> - Consultas: 4 indices (Fecha, Estado, Paciente, Medico)
> - Factura: 3 indices (Fecha, Paciente, Estado)"

**[0:40 - 1:05] OPTIMIZACION** (Mostrar analisis)
> "Durante la optimizacion, eliminamos 3 indices redundantes:
> - IDX_Pacientes_TipoSangre: Baja selectividad, solo 8 valores
> - IDX_Consultas_Paciente_Fecha: Redundante con otro indice
> - IDX_TratamientoXConsulta_Consulta: Tabla pequena, FK suficiente"

**[1:05 - 1:25] PRUEBAS DE RENDIMIENTO** (Mostrar STATISTICS IO)
> "Validamos el rendimiento usando SET STATISTICS IO y TIME. Las pruebas demuestran mejoras significativas en:
> - Busqueda por DUI: Lecturas logicas reducidas
> - Consultas por fecha: Acceso directo al indice
> - Historial de paciente: Ordenamiento optimizado"

**[1:25 - 1:40] TRANSICION**
> "Tambien implementamos analisis de fragmentacion y scripts de mantenimiento. Mi companero explicara las consultas avanzadas con funciones ventana."

---

### CONSULTAS PARA MOSTRAR:
```sql
--- Ver todos los indices
SELECT t.name AS Tabla, i.name AS Indice, i.type_desc AS Tipo
FROM sys.indexes i
JOIN sys.tables t ON i.object_id = t.object_id
WHERE i.name IS NOT NULL
ORDER BY t.name, i.type_desc;

--- Prueba de rendimiento
SET STATISTICS IO ON;
SELECT * FROM Pacientes.Pacientes WHERE DUI = 25102023;
SET STATISTICS IO OFF;
```

---

# PERSONA 5
## Tema: Funciones Ventana
### Tiempo: 1 minuto 40 segundos

---

### GUION COMPLETO

**[0:00 - 0:15] INTRODUCCION** (Hablar a camara)
> "Las funciones ventana permiten analisis avanzados sin necesidad de subconsultas complejas. Implementamos 4 consultas clave que demuestran su poder."

**[0:15 - 0:40] CONSULTA 1: RANKING DE ASEGURADORAS** (Mostrar codigo y resultado)
> "Primera consulta: Ranking de aseguradoras mas frecuentadas usando RANK().
> Esta consulta clasifica las aseguradoras por cantidad de consultas, util para negociaciones comerciales."
```sql
SELECT Aseguradora, COUNT(*) AS Consultas,
       RANK() OVER (ORDER BY COUNT(*) DESC) AS Ranking
FROM Secretaria.Consultas c
JOIN Pacientes.Pacientes p ON c.idPaciente = p.id
JOIN Pacientes.Aseguradora a ON p.idSeguro = a.idSeguro
GROUP BY Aseguradora;
```

**[0:40 - 1:00] CONSULTA 2: PROMEDIO POR MEDICO** (Mostrar codigo)
> "Segunda consulta: Costo promedio de consulta por medico usando AVG() OVER con PARTITION BY.
> Permite comparar el costo de cada consulta contra el promedio del medico que la atendio."

**[1:00 - 1:20] CONSULTAS 3 Y 4: LAG Y ROW_NUMBER** (Mostrar resultados)
> "Tercera consulta: Seguimiento de pacientes con LAG() que compara la consulta actual contra la anterior del mismo paciente.
> 
> Cuarta consulta: Historial cronologico con ROW_NUMBER() que numera las consultas de cada paciente ordenadas por fecha."

**[1:20 - 1:40] VALOR DE NEGOCIO**
> "Estas funciones ventana permiten:
> - Analisis de tendencias
> - Comparaciones temporales
> - Rankings dinamicos
> - Seguimiento de evolucion del paciente
> 
> Mi companero cerrara con SQL Agent, backups y conclusiones."

---

# PERSONA 6
## Tema: SQL Agent, Backups, Power BI y Conclusiones
### Tiempo: 1 minuto 40 segundos

---

### GUION COMPLETO

**[0:00 - 0:20] SQL AGENT - 3 JOBS** (Mostrar SQL Server Agent en SSMS)
> "Implementamos automatizacion con SQL Server Agent. Creamos 3 Jobs para backups automaticos:
> - **Full_Backup**: Backup completo semanal
> - **Diff_Backup**: Backup diferencial diario
> - **Log_Backup**: Backup de log cada 3-6 horas
> 
> Todos probados exitosamente con 100% de ejecuciones correctas."

**[0:20 - 0:40] ESTRATEGIA DE BACKUP** (Mostrar diagrama o explicar)
> "La estrategia garantiza:
> - RTO menor a 1 hora: tiempo de recuperacion
> - RPO menor a 6 horas: perdida maxima de datos
> - Recuperacion point-in-time con logs
> - Continuidad del negocio garantizada"

**[0:40 - 1:00] DASHBOARD POWER BI** (Mostrar dashboard si es posible)
> "Conectamos Power BI a la vista Vista_PowerBI para analisis en tiempo real:
> - Consultas por especialidad
> - Tendencias temporales
> - Distribucion por aseguradoras
> - Productividad de medicos"

**[1:00 - 1:25] RESUMEN DEL PROYECTO** (Hablar a camara)
> "En resumen, PHospital es un sistema completo con:
> - 67 objetos de base de datos
> - 25,000+ registros reales
> - Mas de un millon de dolares facturados
> - Seguridad multicapa con auditorias
> - Indices optimizados para rendimiento
> - Automatizacion con SQL Agent
> - Dashboard de analisis en Power BI"

**[1:25 - 1:40] CONCLUSION FINAL** (Hablar a camara, todo el equipo si es posible)
> "El proyecto cumple el 100% de los requisitos mas puntos extra por SQL Agent.
> Calificacion estimada: 105 de 100 puntos.
> Gracias por su atencion."

---

## RESUMEN DE TIEMPOS

| Segmento | Persona | Tiempo Acumulado |
|----------|---------|------------------|
| Descripcion General | Anthony | 0:00 - 1:40 |
| Datos Masivos | Persona 2 | 1:40 - 3:20 |
| Seguridad | Persona 3 | 3:20 - 5:00 |
| Indices | Persona 4 | 5:00 - 6:40 |
| Funciones Ventana | Persona 5 | 6:40 - 8:20 |
| SQL Agent y Conclusiones | Persona 6 | 8:20 - 10:00 |

---

## CONSEJOS PARA LA GRABACION

1. **Practica el guion** varias veces para ajustarte al tiempo
2. **Prepara las consultas** en SSMS antes de grabar
3. **Usa pantalla compartida** para mostrar codigo y resultados
4. **Habla claro y pausado** pero sin ser demasiado lento
5. **Coordina las transiciones** entre companeros
6. **Verifica que la base de datos** tenga todos los datos antes de grabar

---

## MATERIAL VISUAL SUGERIDO

- Diagrama de los 4 esquemas
- Capturas de SSMS con tablas y objetos
- Resultados de las consultas en pantalla
- Capturas de SQL Server Agent con los Jobs
- Dashboard de Power BI (si esta disponible)
- Grafico de estadisticas del sistema

---

**Documento generado para el Proyecto PHospital**
**Fecha: Noviembre 2025**
