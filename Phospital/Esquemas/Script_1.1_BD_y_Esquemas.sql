--- FASE 1.1: CREACION DE BASE DE DATOS Y ESQUEMAS
--- Proyecto: PHospital - Sistema de Gestion Hospitalaria
--- Fecha: 2025-11-12



--- Crear base de datos PHospital
CREATE DATABASE PHospital
GO

--- Usar la base de datos
USE PHospital
GO

--- Crear esquema Pacientes para tablas relacionadas con pacientes
CREATE SCHEMA Pacientes AUTHORIZATION dbo
GO

--- Crear esquema Personal para tablas relacionadas con medicos
CREATE SCHEMA Personal AUTHORIZATION dbo
GO

--- Crear esquema Tesoreria para tablas relacionadas con facturacion
CREATE SCHEMA Tesoreria AUTHORIZATION dbo
GO

--- Crear esquema Secretaria para tablas relacionadas con consultas
CREATE SCHEMA Secretaria AUTHORIZATION dbo
GO

--- Consultar todos los esquemas creados
SELECT name AS Esquema, USER_NAME(principal_id) AS Propietario 
FROM sys.schemas 
WHERE name IN ('Pacientes', 'Personal', 'Tesoreria', 'Secretaria')
GO
