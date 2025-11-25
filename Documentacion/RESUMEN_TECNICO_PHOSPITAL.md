# 📋 RESUMEN TÉCNICO - PHOSPITAL
**Estado Actual del Sistema**

---

## 🔐 ROLES (5 roles activos)

### **1. rol_analista**
**Función:** Análisis y reportes en Power BI  
**Permisos:** SELECT en Secretaria.Vista_PowerBI  
**Usuario asignado:** Analista

### **2. rol_administrador**
**Función:** Control total del sistema  
**Permisos:** CONTROL en 4 esquemas (Pacientes, Personal, Tesoreria, Secretaria)  
**Usuario asignado:** DBAdmin

### **3. rol_invitado**
**Función:** Solo lectura en vistas específicas  
**Permisos:** SELECT en 6 vistas  
**Usuario asignado:** Invitado

### **4. rol_profesor**
**Función:** Evaluación académica sin modificar datos  
**Permisos:** SELECT + VIEW DEFINITION en 4 esquemas  
**Usuario asignado:** Profesor

### **5. rol_alumno**
**Función:** Desarrollo del proyecto  
**Permisos:** CONTROL en 4 esquemas (acceso completo)  
**Usuario asignado:** Alumno

### **Consultas para ver roles:**
```sql
--- Ver todos los roles personalizados
SELECT name AS Rol, create_date AS FechaCreacion
FROM sys.database_principals
WHERE type = 'R' AND is_fixed_role = 0;

--- Ver permisos de cada rol
SELECT 
    USER_NAME(grantee_principal_id) AS Rol,
    permission_name AS Permiso,
    OBJECT_SCHEMA_NAME(major_id) AS Esquema
FROM sys.database_permissions
WHERE USER_NAME(grantee_principal_id) LIKE 'rol_%';

--- Ver miembros de cada rol
SELECT 
    ROLE.name AS Rol,
    USER.name AS Usuario
FROM sys.database_role_members RM
JOIN sys.database_principals ROLE ON RM.role_principal_id = ROLE.principal_id
JOIN sys.database_principals USER ON RM.member_principal_id = USER.principal_id
WHERE ROLE.name LIKE 'rol_%';
```

---

## 🔍 AUDITORÍAS (3 auditorías activas)

### **1. Auditoria_PHospital_Servidor**
**Tipo:** Auditoría de servidor  
**Ubicación:** C:\ADMIN BDA\Phospital\AUDITORIAS  
**Configuración:**
- Tamaño máximo: 100 MB por archivo
- Archivos máximos: 10 (rotación automática)
- Retardo de cola: 1000 ms
- Acción en fallo: CONTINUE

**Estado:** ACTIVA ✅

### **2. Spec_Auditoria_Servidor_PHospital**
**Tipo:** Especificación de auditoría de servidor  
**Auditoría asociada:** Auditoria_PHospital_Servidor  
**Eventos auditados:**
- FAILED_LOGIN_GROUP (intentos fallidos de login)
- SUCCESSFUL_LOGIN_GROUP (logins exitosos)
- SERVER_ROLE_MEMBER_CHANGE_GROUP (cambios en roles de servidor)
- DATABASE_PERMISSION_CHANGE_GROUP (cambios en permisos de BD)

**Estado:** ACTIVA ✅

### **3. Spec_Auditoria_BD_PHospital**
**Tipo:** Especificación de auditoría de base de datos  
**Auditoría asociada:** Auditoria_PHospital_Servidor  
**Objetos auditados:**
- Pacientes.Pacientes: SELECT, INSERT, UPDATE, DELETE
- Secretaria.Consultas: SELECT, INSERT, UPDATE, DELETE
- Tesoreria.Factura: SELECT, INSERT, UPDATE
- Tesoreria.CrearFactura: EXECUTE
- Secretaria.CrearConsulta: EXECUTE

**Usuario auditado:** public (todos los usuarios)  
**Estado:** ACTIVA ✅

### **Consultas para ver auditorías:**
```sql
--- Ver auditorías de servidor
SELECT 
    name AS Auditoria,
    type_desc AS Tipo,
    audit_file_path AS RutaArchivos,
    max_file_size AS TamañoMaxMB,
    max_files AS ArchivosMaximos
FROM sys.server_audits
WHERE name LIKE '%PHospital%';

--- Ver estado de auditorías
SELECT name AS Auditoria, is_state_enabled AS Activa
FROM sys.server_audits
WHERE name LIKE '%PHospital%';

--- Ver especificaciones de servidor
SELECT 
    SAS.name AS EspecificacionServidor,
    SA.name AS AuditoriaAsociada,
    SASD.audit_action_name AS AccionAuditada
FROM sys.server_audit_specifications SAS
JOIN sys.server_audits SA ON SAS.audit_guid = SA.audit_guid
JOIN sys.server_audit_specification_details SASD ON SAS.server_specification_id = SASD.server_specification_id
WHERE SAS.name LIKE '%PHospital%';

--- Ver especificaciones de base de datos
SELECT 
    DAS.name AS EspecificacionBD,
    SA.name AS AuditoriaAsociada,
    DASD.audit_action_name AS Accion,
    OBJECT_SCHEMA_NAME(DASD.major_id) + '.' + OBJECT_NAME(DASD.major_id) AS Objeto
FROM sys.database_audit_specifications DAS
JOIN sys.server_audits SA ON DAS.audit_guid = SA.audit_guid
JOIN sys.database_audit_specification_details DASD ON DAS.database_specification_id = DASD.database_specification_id
WHERE DAS.name LIKE '%PHospital%';

--- Ver logs de auditoría generados
SELECT 
    event_time AS Fecha,
    action_id AS Accion,
    succeeded AS Exitoso,
    session_server_principal_name AS Usuario,
    database_name AS BaseDatos,
    object_name AS Objeto,
    statement AS Instruccion
FROM sys.fn_get_audit_file('C:\ADMIN BDA\Phospital\AUDITORIAS\*.sqlaudit', DEFAULT, DEFAULT)
ORDER BY event_time DESC;
```

---

## 📊 ÍNDICES (13 índices NONCLUSTERED)

### **Esquema Pacientes (3 índices)**

#### **IDX_Pacientes_DUI**
- **Tabla:** Pacientes.Pacientes
- **Tipo:** UNIQUE NONCLUSTERED
- **Columna:** DUI
- **Propósito:** Búsqueda rápida por documento único

#### **IDX_Pacientes_Apellidos**
- **Tabla:** Pacientes.Pacientes
- **Tipo:** NONCLUSTERED
- **Columna:** Apellidos
- **Propósito:** Búsqueda por apellidos en recepción

#### **IDX_Pacientes_TipoSangre**
- **Tabla:** Pacientes.Pacientes
- **Tipo:** NONCLUSTERED
- **Columna:** idTipoDeSangre
- **Propósito:** Filtrado por tipo de sangre

---

### **Esquema Personal (1 índice)**

#### **IDX_Medicos_Especialidad**
- **Tabla:** Personal.Medicos
- **Tipo:** NONCLUSTERED
- **Columna:** idEspecialidad
- **Propósito:** Búsqueda de médicos por especialidad

---

### **Esquema Secretaria (6 índices)**

#### **IDX_Consultas_Fecha**
- **Tabla:** Secretaria.Consultas
- **Tipo:** NONCLUSTERED
- **Columna:** Fecha
- **Propósito:** Filtrado por rango de fechas

#### **IDX_Consultas_Estado**
- **Tabla:** Secretaria.Consultas
- **Tipo:** NONCLUSTERED
- **Columna:** Estado
- **Propósito:** Filtrado por estado de cita

#### **IDX_Consultas_Paciente**
- **Tabla:** Secretaria.Consultas
- **Tipo:** NONCLUSTERED
- **Columna:** idPaciente
- **Propósito:** Historial médico por paciente

#### **IDX_Consultas_Medico**
- **Tabla:** Secretaria.Consultas
- **Tipo:** NONCLUSTERED
- **Columna:** idMedico
- **Propósito:** Consultas por médico

#### **IDX_Consultas_Compuesto**
- **Tabla:** Secretaria.Consultas
- **Tipo:** NONCLUSTERED
- **Columnas:** idPaciente, Fecha
- **Propósito:** Búsquedas combinadas paciente-fecha

#### **IDX_TratamientoXConsulta_Consulta**
- **Tabla:** Secretaria.TratamientoXConsulta
- **Tipo:** NONCLUSTERED
- **Columna:** idConsulta
- **Propósito:** Tratamientos por consulta

---

### **Esquema Tesoreria (3 índices)**

#### **IDX_Factura_Fecha**
- **Tabla:** Tesoreria.Factura
- **Tipo:** NONCLUSTERED
- **Columna:** Fecha
- **Propósito:** Reportes por período

#### **IDX_Factura_Paciente**
- **Tabla:** Tesoreria.Factura
- **Tipo:** NONCLUSTERED
- **Columna:** idPaciente
- **Propósito:** Historial de facturación por paciente

#### **IDX_Factura_Estado**
- **Tabla:** Tesoreria.Factura
- **Tipo:** NONCLUSTERED
- **Columna:** Estado
- **Propósito:** Cuentas por cobrar

---

### **Consultas para ver índices:**
```sql
--- Ver todos los índices
SELECT 
    SCHEMA_NAME(t.schema_id) AS Esquema,
    OBJECT_NAME(i.object_id) AS Tabla,
    i.name AS Indice,
    i.type_desc AS Tipo,
    i.is_unique AS EsUnico
FROM sys.indexes i
JOIN sys.tables t ON i.object_id = t.object_id
WHERE i.name IS NOT NULL
AND t.schema_id IN (SCHEMA_ID('Pacientes'), SCHEMA_ID('Personal'), SCHEMA_ID('Tesoreria'), SCHEMA_ID('Secretaria'))
ORDER BY Esquema, Tabla, Indice;

--- Ver columnas de cada índice
SELECT 
    SCHEMA_NAME(t.schema_id) AS Esquema,
    OBJECT_NAME(ic.object_id) AS Tabla,
    i.name AS Indice,
    c.name AS Columna,
    ic.key_ordinal AS Posicion
FROM sys.index_columns ic
JOIN sys.indexes i ON ic.object_id = i.object_id AND ic.index_id = i.index_id
JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
JOIN sys.tables t ON ic.object_id = t.object_id
WHERE i.name IS NOT NULL
AND t.schema_id IN (SCHEMA_ID('Pacientes'), SCHEMA_ID('Personal'), SCHEMA_ID('Tesoreria'), SCHEMA_ID('Secretaria'))
ORDER BY Esquema, Tabla, Indice, Posicion;

--- Ver fragmentación de índices
SELECT 
    OBJECT_NAME(ips.object_id) AS Tabla,
    i.name AS Indice,
    ips.avg_fragmentation_in_percent AS Fragmentacion,
    ips.page_count AS Paginas
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') ips
JOIN sys.indexes i ON ips.object_id = i.object_id AND ips.index_id = i.index_id
WHERE ips.database_id = DB_ID()
AND i.name IS NOT NULL
ORDER BY Fragmentacion DESC;

--- Ver uso de índices
SELECT 
    OBJECT_NAME(ius.object_id) AS Tabla,
    i.name AS Indice,
    ius.user_seeks AS Busquedas,
    ius.user_scans AS Escaneos,
    ius.user_lookups AS Consultas,
    ius.user_updates AS Actualizaciones
FROM sys.dm_db_index_usage_stats ius
JOIN sys.indexes i ON ius.object_id = i.object_id AND ius.index_id = i.index_id
WHERE ius.database_id = DB_ID()
AND i.name IS NOT NULL
ORDER BY (ius.user_seeks + ius.user_scans + ius.user_lookups) DESC;
```

---

## 📌 RESUMEN GENERAL

### **Objetos de Seguridad:**
- **Logins:** 5 (Login_Analista, Login_Administrador, Login_Invitado, Login_Profesor, Login_Alumno)
- **Usuarios:** 5 (Analista, DBAdmin, Invitado, Profesor, Alumno)
- **Roles personalizados:** 5 (rol_analista, rol_administrador, rol_invitado, rol_profesor, rol_alumno)
- **Auditorías activas:** 3 (1 servidor + 2 especificaciones)

### **Índices:**
- **CLUSTERED:** 10 (automáticos por PRIMARY KEY)
- **NONCLUSTERED:** 13 (optimización manual)
- **Total:** 23 índices

### **Ubicaciones importantes:**
- **Scripts:** Carpeta del proyecto SQL Server
- **Backups:** Varios archivos .bak
- **Logs de auditoría:** C:\ADMIN BDA\Phospital\AUDITORIAS

### **Estado del proyecto:**
- **Progreso:** 90% completado
- **Fase actual:** Solo falta optimización adicional de índices (opcional)
- **Seguridad:** ✅ Completada al 100%
- **Auditorías:** ✅ Completadas al 100% y activas
- **Índices básicos:** ✅ Completados al 100%

---

**Última actualización:** 24 de Noviembre 2025  
**Versión:** 5.0 FINAL
