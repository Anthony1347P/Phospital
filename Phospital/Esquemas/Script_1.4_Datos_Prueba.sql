--- FASE 1.4: INSERCION DE DATOS DE PRUEBA
--- Proyecto: PHospital - Sistema de Gestion Hospitalaria


USE PHospital
GO

--- Insertar 30 pacientes
INSERT INTO Pacientes.Pacientes (Nobres, Apellidos, Sexo, edad, idTipoDeSangre, Celular, Direccion, DUI, idSeguro) VALUES
('Andrea', 'Mendoza Pérez', 'F', 35, 1, 78901234, 'Av. Las Flores #123, San Salvador', 123456789, 1),
('Carlos', 'Gómez Alas', 'M', 52, 2, 67890123, 'Calle Principal #45, Santa Ana', 987654321, 2),
('Sofía', 'Ramírez Castro', 'F', 22, 3, 76543210, 'Res. El Roble, Casa 15, Sonsonate', 543210987, 3),
('Javier', 'Hernández Rivas', 'M', 45, 1, 60123456, 'Blvd. Constitución, Edif. 8, Apto 3B', 112233445, 1),
('Laura', 'Díaz Ventura', 'F', 18, 4, 79012345, 'Col. San Benito, Pasaje D #7, La Libertad', 887766554, 2),
('Miguel', 'Flores Quintanilla', 'M', 65, 2, 65432109, 'Urb. Los Naranjos, Bloque B, Apt 101', 334455667, 3),
('Elena', 'Acosta Morales', 'F', 29, 3, 70011223, 'Calle Arce #210, San Miguel', 998877665, 1),
('Ricardo', 'Vargas Beltrán', 'M', 38, 1, 62233445, 'Final Av. Peralta, Casa 1, Usulután', 445566778, 2),
('Patricia', 'Chávez Melgar', 'F', 58, 4, 73344556, 'Res. Cumbres de Cuscatlán, Etapa I, Lote 14', 102030405, 3),
('Fernando', 'Guerrero Landaverde', 'M', 12, 1, 64455667, 'Col. Escalón, 8va Calle Oriente #50', 504030201, 1),
('Gabriela', 'López Portillo', 'F', 41, 2, 75566778, 'Km 5 Carretera a Comalapa, Cantón El Jícaro', 293847561, 2),
('Diego', 'Reyes Valencia', 'M', 27, 3, 66677889, 'Calle a Huizúcar, Condominio Santa Lucía', 778899001, 3),
('Carolina', 'Méndez Cruz', 'F', 33, 1, 77788990, 'Av. Bernal, Edificio Torre Azul, Apto 12A', 135792468, 1),
('Alex', 'Salazar Rivera', 'M', 50, 4, 68899001, 'Col. Layco, Pasaje 3 #17, Soyapango', 246801357, 2),
('Valeria', 'Orellana Pineda', 'F', 25, 2, 79900112, 'Zona Rosa, Calle 3, Lote 9, Antiguo Cuscatlán', 975310864, 3),
('Roberto', 'Molina Escobar', 'M', 72, 3, 60011223, 'Res. Altavista, Bloque C, Casa 5, Ilopango', 864209753, 1),
('Adriana', 'Juárez Mata', 'F', 48, 1, 71122334, 'Calle El Progreso, Lote 6, Ciudad Delgado', 369258147, 2),
('Samuel', 'Paz Cornejo', 'M', 19, 4, 62233445, 'Barrio San Jacinto, Calle 1, #30, Cojutepeque', 741852963, 3),
('Esther', 'Morán Zepeda', 'F', 61, 2, 73344556, 'Av. Olímpica, Cond. Metrocenter, Apto 5D', 147258369, 1),
('Pablo', 'Villatoro Luna', 'M', 30, 3, 64455667, 'Pasaje 1, Colonia Satélite, #8, Ahuachapán', 963852741, 2),
('Luis', 'Martínez López', 'M', 36, 5, 70123456, 'Colonia Miramonte, Calle Los Pinos #23, San Salvador', 045897645, 1),
('María', 'González Torres', 'F', 29, 6, 71234567, 'Calle El Carmen, Residencial Santa Elena, casa #45, Santa Tecla', 204678812, 2),
('José', 'Ramírez Mejía', 'M', 43, 7, 72345678, 'Avenida Independencia, Barrio El Calvario, casa #12, San Vicente', 378904567, 3),
('Claudia', 'Hernández Cruz', 'F', 51, 8, 73456789, 'Residencial Las Palmas, Calle Las Margaritas, casa #88', 426789654, 1),
('Raúl', 'Pineda Salazar', 'M', 27, 1, 74567890, 'Colonia Escalón, 9na Calle Poniente #101, San Salvador', 785402123, 2),
('Verónica', 'Lemus Rivera', 'F', 34, 2, 75678901, 'Calle Los Naranjos, Urbanización El Paraíso, casa #17, La Unión', 058900321, 3),
('Ernesto', 'Cañas López', 'M', 60, 3, 76789012, 'Urbanización El Trébol, Calle Las Acacias, casa #56, Santa Ana', 230890765, 1),
('Silvia', 'Morales Pérez', 'F', 22, 4, 77890123, 'Zona Industrial de Soyapango, Calle Principal #200', 604333577, 2),
('Oscar', 'Navarrete Flores', 'M', 39, 5, 78901234, 'Avenida Las Rosas, Colonia El Bosque, casa #33, Chalatenango', 999000111, 3),
('Beatriz', 'Zelaya Molina', 'F', 45, 6, 79012345, 'Colonia San Francisco, Calle Las Violetas, casa #90, Usulután', 101112131, 1)
GO

--- Insertar 10 medicos 
INSERT INTO Personal.Medicos (Nombres, Apellidos, Sexo, edad, idEspecialidad, celular) VALUES
('Ana', 'Bárcenas López', 'F', 40, 1, 77700001), 
('Jorge', 'Cisneros Dávila', 'M', 55, 2, 66600002), 
('María', 'Escobar Fuentes', 'F', 32, 3, 78800003), 
('Luis', 'Granados Herrera', 'M', 48, 4, 69900004), 
('Teresa', 'Izaguirre Jerez', 'F', 60, 5, 70011115), 
('Mario', 'Klimenko Luna', 'M', 35, 1, 61122226),
('Fabiola', 'Navas Orantes', 'F', 44, 2, 72233337), 
('Daniel', 'Pacheco Quinteros', 'M', 51, 3, 63344448), 
('Cecilia', 'Ramos Solís', 'F', 38, 4, 74455559), 
('Héctor', 'Torres Umaña', 'M', 59, 5, 65566660)
GO

--- Verificar datos insertados
SELECT 'Pacientes' AS Tabla, COUNT(*) AS Registros FROM Pacientes.Pacientes
UNION ALL
SELECT 'Medicos', COUNT(*) FROM Personal.Medicos
GO
