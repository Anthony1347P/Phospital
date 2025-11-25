# 📋 RESUMEN: ROLES Y AUDITORÍAS - PHOSPITAL
## Fase 5: Seguridad y Auditoría

---

## 🎭 ROLES PERSONALIZADOS (7 ROLES)

### **1. ROL_ANALISTA** 📊
**Usuario:** Analista  
**Contraseña:** Analista2025!  
**Propósito:** Power BI y análisis de datos

**Permisos:**
- ✅ SELECT en todos los 4 esquemas (Pacientes, Personal, Tesoreria, Secretaria)
- ✅ EXECUTE en procedimientos de reportes:
  - Ver_Historial_de_Facturas
  - Ver_Ultima_Factura
  - SangreCompatible
  - SP_Reporte_Consultas_Por_Periodo
- ❌ NO puede INSERT, UPDATE, DELETE

**Casos de uso:**
- Conectar Power BI para reportes
- Análisis de datos sin modificar
- Generar dashboards
- Ejecutar reportes predefinidos

---

### **2. ROL_CONSULTOR** 📖
**Usuario:** Consultor  
**Contraseña:** Consultor2025!  
**Propósito:** Solo lectura completa

**Permisos:**
- ✅ SELECT en todos los 4 esquemas
- ❌ NO puede EXECUTE procedimientos
- ❌ NO puede INSERT, UPDATE, DELETE

**Casos de uso:**
- Revisar información sin modificar
- Consultas generales
- Auditorías internas
- Supervisión sin riesgo de cambios

**Diferencia con Analista:**
- Analista puede ejecutar SP de reportes
- Consultor solo ve datos directamente

---

### **3. ROL_OPERADOR** 👨‍💼
**Usuario:** Operador  
**Contraseña:** Operador2025!  
**Propósito:** Operaciones diarias en Secretaría

**Permisos:**
- ✅ SELECT, INSERT, UPDATE en esquema Secretaria
- ✅ SELECT en esquemas Pacientes, Personal, Tesoreria (solo lectura)
- ✅ EXECUTE en CrearConsulta
- ❌ NO puede DELETE
- ❌ NO puede modificar Pacientes, Personal, Tesoreria

**Casos de uso:**
- Registrar consultas nuevas
- Actualizar estado de consultas
- Ver información de pacientes y médicos
- Operaciones del día a día

---

### **4. ROL_ADMINISTRADOR** 👑
**Usuario:** DBAdmin  
**Contraseña:** Admin2025!  
**Propósito:** Administración completa

**Permisos:**
- ✅ CONTROL total en todos los 4 esquemas
- ✅ Puede hacer TODO (SELECT, INSERT, UPDATE, DELETE, EXECUTE)
- ✅ Puede modificar estructura (ALTER)
- ✅ Control total sobre objetos

**Casos de uso:**
- Mantenimiento de BD
- Modificaciones de estructura
- Resolución de problemas
- Gestión completa del sistema

---

### **5. ROL_INVITADO** 👤
**Usuario:** Invitado  
**Contraseña:** Invitado2025!  
**Propósito:** Acceso muy limitado

**Permisos:**
- ✅ SELECT solo en VISTAS (6 vistas):
  - Vista_Consultas_Detalladas
  - Vista_Pacientes_Completa
  - Vista_Medicos_Productividad
  - Vista_Facturacion_Mensual
  - Vista_Tratamientos_Mas_Usados
  - Costo_de_Consulta_por_Medico
- ❌ NO puede ver tablas directamente
- ❌ NO puede EXECUTE procedimientos

**Casos de uso:**
- Visitantes externos
- Demostraciones
- Acceso temporal sin riesgo
- Ver solo información resumida

**Diferencia con Consultor:**
- Invitado solo ve vistas (información procesada)
- Consultor ve tablas completas

---

### **6. ROL_PROFESOR** 🎓
**Usuario:** Profesor  
**Contraseña:** Profesor2025!  
**Propósito:** Evaluación y revisión académica

**Permisos:**
- ✅ SELECT en todos los 4 esquemas
- ✅ VIEW DEFINITION en todos los esquemas (ver código de SP, funciones, triggers)
- ❌ NO puede modificar datos

**Casos de uso:**
- Evaluar el proyecto
- Revisar código de procedimientos
- Ver estructura completa
- Validar implementación

**Diferencia con Consultor:**
- Profesor puede ver DEFINICIÓN de objetos (código)
- Consultor solo ve datos

---

### **7. ROL_ALUMNO** 🎒
**Usuario:** Alumno  
**Contraseña:** Alumno2025!  
**Propósito:** Estudiante con acceso limitado

**Permisos:**
- ✅ SELECT en 3 vistas principales:
  - Vista_Consultas_Detalladas
  - Vista_Pacientes_Completa
  - Vista_Medicos_Productividad
- ✅ SELECT en esquema Secretaria completo
- ❌ NO puede ver Pacientes, Personal, Tesoreria directamente

**Casos de uso:**
- Estudiantes practicando consultas
- Aprendizaje sin riesgo
- Acceso a información de consultas
- Práctica de SQL SELECT

---

## 🔐 COMPARATIVA DE ROLES

| Rol | SELECT Esquemas | SELECT Vistas | EXECUTE SP | INSERT/UPDATE/DELETE | VIEW DEFINITION |
|-----|----------------|---------------|------------|---------------------|----------------|
| **Analista** | ✅ Todos | ✅ Todas | ✅ Reportes | ❌ | ❌ |
| **Consultor** | ✅ Todos | ✅ Todas | ❌ | ❌ | ❌ |
| **Operador** | ✅ Todos | ✅ Todas | ✅ CrearConsulta | ✅ Solo Secretaria | ❌ |
| **Administrador** | ✅ Todos | ✅ Todas | ✅ Todos | ✅ Todos | ✅ |
| **Invitado** | ❌ | ✅ 6 vistas | ❌ | ❌ | ❌ |
| **Profesor** | ✅ Todos | ✅ Todas | ❌ | ❌ | ✅ Todos |
| **Alumno** | ✅ Solo Secretaria | ✅ 3 vistas | ❌ | ❌ | ❌ |

---

## 🔍 AUDITORÍAS (3 AUDITORÍAS)

### **1. AUDITORÍA DE SERVIDOR**
**Nombre:** Auditoria_PHospital_Servidor  
**Ubicación:** C:\ADMIN BDA\Audit\PHospital\  
**Archivo:** *.sqlaudit

**Qué audita:**
- ✅ Inicios de sesión fallidos (FAILED_LOGIN_GROUP)
- ✅ Inicios de sesión exitosos (SUCCESSFUL_LOGIN_GROUP)
- ✅ Cambios en roles de servidor (SERVER_ROLE_MEMBER_CHANGE_GROUP)
- ✅ Cambios en permisos de BD (DATABASE_PERMISSION_CHANGE_GROUP)

**Para qué sirve:**
- Detectar intentos de acceso no autorizado
- Rastrear quién inició sesión y cuándo
- Monitorear cambios de seguridad
- Cumplimiento y auditoría

**Configuración:**
- Tamaño máximo: 100 MB por archivo
- Máximo 10 archivos antes de reciclar
- Si falla: continuar operando

---

### **2. ESPECIFICACIÓN DE AUDITORÍA DE SERVIDOR**
**Nombre:** Spec_Auditoria_Servidor_PHospital

**Eventos capturados:**
```
1. FAILED_LOGIN_GROUP
   - Captura: Intentos fallidos de login
   - Ejemplo: Usuario equivocó contraseña
   
2. SUCCESSFUL_LOGIN_GROUP
   - Captura: Logins exitosos
   - Ejemplo: Analista inició sesión correctamente
   
3. SERVER_ROLE_MEMBER_CHANGE_GROUP
   - Captura: Alguien agregó/quitó usuario de rol servidor
   - Ejemplo: Agregaron usuario a sysadmin
   
4. DATABASE_PERMISSION_CHANGE_GROUP
   - Captura: Cambios en permisos de BD
   - Ejemplo: Alguien hizo GRANT o REVOKE
```

---

### **3. ESPECIFICACIÓN DE AUDITORÍA DE BASE DE DATOS**
**Nombre:** Spec_Auditoria_BD_PHospital  
**Base de datos:** PHospital

**Operaciones auditadas:**

#### **Tabla Pacientes.Pacientes:**
- SELECT, INSERT, UPDATE, DELETE por TODOS (public)
- Registra quién ve, agrega, modifica o elimina pacientes

#### **Tabla Tesoreria.Factura:**
- SELECT, INSERT, UPDATE por TODOS
- Registra acceso y cambios en facturas

#### **Tabla Secretaria.Consultas:**
- SELECT, INSERT, UPDATE, DELETE por TODOS
- Registra todas las operaciones en consultas

#### **Procedimiento CrearFactura:**
- EXECUTE por TODOS
- Registra quién genera facturas

#### **Procedimiento CrearConsulta:**
- EXECUTE por TODOS
- Registra quién crea consultas

---

## 📊 CÓMO VER LOS LOGS DE AUDITORÍA

### **Ver últimos 100 eventos:**
```sql
SELECT TOP 100
    event_time AS Fecha,
    succeeded AS Exitoso,
    session_server_principal_name AS Usuario,
    database_name AS BaseDatos,
    statement AS Consulta
FROM sys.fn_get_audit_file('C:\ADMIN BDA\Audit\PHospital\*.sqlaudit', DEFAULT, DEFAULT)
ORDER BY event_time DESC;
```

### **Ver solo logins fallidos:**
```sql
SELECT 
    event_time AS Fecha,
    session_server_principal_name AS Usuario,
    statement AS Detalle
FROM sys.fn_get_audit_file('C:\ADMIN BDA\Audit\PHospital\*.sqlaudit', DEFAULT, DEFAULT)
WHERE action_id = 'LGIF'
ORDER BY event_time DESC;
```

### **Ver operaciones en tabla específica:**
```sql
SELECT 
    event_time AS Fecha,
    session_server_principal_name AS Usuario,
    statement AS Operacion,
    succeeded AS Exitoso
FROM sys.fn_get_audit_file('C:\ADMIN BDA\Audit\PHospital\*.sqlaudit', DEFAULT, DEFAULT)
WHERE object_name = 'Pacientes'
ORDER BY event_time DESC;
```

---

## 🧪 CÓMO PROBAR LOS ROLES

### **Prueba 1: Probar rol_analista**
```sql
--- Cambiar a usuario Analista
EXECUTE AS USER = 'Analista';

--- Esto DEBE funcionar (SELECT)
SELECT TOP 5 * FROM Pacientes.Pacientes;

--- Esto DEBE funcionar (EXECUTE)
EXEC Tesoreria.Ver_Ultima_Factura @idPaciente = 1;

--- Esto NO debe funcionar (INSERT)
INSERT INTO Pacientes.Pacientes (Nobres, Apellidos) VALUES ('Test', 'Test');

--- Volver a usuario normal
REVERT;
```

### **Prueba 2: Probar rol_invitado**
```sql
EXECUTE AS USER = 'Invitado';

--- Esto DEBE funcionar (vista)
SELECT TOP 5 * FROM Pacientes.Vista_Pacientes_Completa;

--- Esto NO debe funcionar (tabla directa)
SELECT TOP 5 * FROM Pacientes.Pacientes;

REVERT;
```

### **Prueba 3: Probar rol_operador**
```sql
EXECUTE AS USER = 'Operador';

--- Esto DEBE funcionar (INSERT en Secretaria)
INSERT INTO Secretaria.Consultas (idPaciente, idMedico, Fecha, Motivo, Estado)
VALUES (1, 1, GETDATE(), 'Prueba', 'Pendiente');

--- Esto NO debe funcionar (INSERT en Pacientes)
INSERT INTO Pacientes.Pacientes (Nobres, Apellidos) VALUES ('Test', 'Test');

REVERT;
```

---

## 🔍 VERIFICAR QUE TODO ESTÁ FUNCIONANDO

### **Verificar roles creados:**
```sql
SELECT name AS Rol, create_date 
FROM sys.database_principals
WHERE type = 'R' AND name LIKE 'rol_%';
```

### **Verificar usuarios y sus roles:**
```sql
SELECT 
    dp.name AS Usuario,
    r.name AS Rol
FROM sys.database_principals dp
LEFT JOIN sys.database_role_members drm ON dp.principal_id = drm.member_principal_id
LEFT JOIN sys.database_principals r ON drm.role_principal_id = r.principal_id
WHERE dp.type = 'S' 
AND dp.name IN ('Analista', 'Consultor', 'Operador', 'DBAdmin', 'Invitado', 'Profesor', 'Alumno');
```

### **Verificar auditorías habilitadas:**
```sql
--- Auditorías servidor
SELECT name, is_state_enabled 
FROM sys.server_audits;

--- Especificaciones servidor
SELECT name, is_state_enabled 
FROM sys.server_audit_specifications;

--- Especificaciones BD
SELECT name, is_state_enabled 
FROM sys.database_audit_specifications;
```

---

## 💡 CASOS DE USO PRÁCTICOS

### **Caso 1: Power BI**
```
Usuario: Login_Analista
Contraseña: Analista2025!
Puede: Leer todas las tablas y ejecutar SP de reportes
No puede: Modificar datos
```

### **Caso 2: Recepcionista del hospital**
```
Usuario: Login_Operador
Contraseña: Operador2025!
Puede: Crear y actualizar consultas
No puede: Modificar pacientes o crear facturas
```

### **Caso 3: Auditor externo**
```
Usuario: Login_Consultor
Contraseña: Consultor2025!
Puede: Ver todos los datos sin modificar
No puede: Ejecutar procedimientos o cambiar datos
```

### **Caso 4: Demo para cliente**
```
Usuario: Login_Invitado
Contraseña: Invitado2025!
Puede: Ver solo vistas (información resumida)
No puede: Ver detalles sensibles en tablas
```

---

## 🚨 SEGURIDAD IMPLEMENTADA

### **Políticas de contraseña:**
```
✅ CHECK_POLICY = ON
   - Complejidad requerida
   - Longitud mínima
   
✅ CHECK_EXPIRATION = ON
   - Contraseñas expiran
   - Requieren cambio periódico
```

### **Principio de mínimo privilegio:**
```
✅ Cada rol tiene SOLO los permisos que necesita
✅ Invitado: solo vistas
✅ Operador: solo Secretaria
✅ Analista: solo lectura + reportes
```

### **Auditoría completa:**
```
✅ Todos los logins registrados
✅ Todas las operaciones en tablas críticas
✅ Cambios de permisos detectados
✅ Intentos fallidos alertados
```

---

## 📖 RESUMEN EJECUTIVO

**Creamos 7 roles con permisos específicos según necesidad:**
1. Analista → Power BI
2. Consultor → Solo lectura
3. Operador → Operaciones diarias
4. Administrador → Control total
5. Invitado → Acceso muy limitado
6. Profesor → Evaluación académica
7. Alumno → Práctica limitada

**Implementamos 3 niveles de auditoría:**
1. Servidor → Logins y seguridad
2. Especificación Servidor → Eventos específicos
3. Especificación BD → Operaciones en tablas críticas

**Todo funciona según las Guías 4, 5 y 6 de la universidad.**

---

**Última actualización:** 18 de Noviembre 2025  
**Estado:** Fase 5 completada ✅
