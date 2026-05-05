--
--1
--
--Automatic Zoom
--Para lanzar errores personalizados puedes utilizar: 
-- 
--RAISE_APPLICATION_ERROR(error_number, message); 
-- 
--Donde error_number es un entero negativo comprendido entre –20000..-20999 y 
--message es una cadena que devolvemos a la aplicación. 
-- 
--1. Crea un trigger de tabla que cuando cambie el número de teléfono de un empleado 
--guarde en una tabla que debes haber creado previamente el código de empleado, el 
--número de teléfono antiguo y el número de teléfono nuevo, además de la fecha del 
--cambio. 
create table historial_telefonos (
    id_empleado NUMBER(6),
    telefono_antiguo VARCHAR2(20),
    telefono_nuevo varchar2(20),
    fecha_cambio DATE
);

ALTER TABLE historial_telefonos
ADD ( CONSTRAINT hist_tlf_pk
       		 PRIMARY KEY (id_empleado,telefono_antiguo,telefono_nuevo)
    ) ;

ALTER TABLE historial_telefonos
ADD ( CONSTRAINT hist_tlf_fk
        	 FOREIGN KEY (id_empleado)
          	  REFERENCES employees(employee_id) 
    ) ;
-- 
--2. Crear un trigger que se ejecutará antes de eliminar un empleado e insertará en una 
--tabla de BackUp el id, nombre y apellidos, email, salario, departamento y trabajo, 
--además de la fecha de la eliminación. 
-- 
--3. Dentro de la tabla de trabajos hay un salario mínimo y un salario máximo. 
--Necesitamos un control por el que cada vez que se cambie uno de estos datos, 
--saber si hay empleados de ese trabajo que quedan fuera de ese rango, y si es así 
--impedirlo dando un mensaje por consola. 
-- 
--a. Por ejemplo, el salario mínimo de IT_PROG es 4.000. Si se quisiera cambiar 
--el salario mínimo a 5.000, debe dar error porque hay trabajadores con este 
--trabajo que no ganan 5.000. 
-- 
--4. Crea un trigger que me avise al cambiar el departamento de un empleado si el 
--departamento antiguo y el nuevo no están en la misma ciudad. 
-- 
--5. Crea un trigger que, al insertar o actualizar un empleado, verifique que su salario no es 
--inferior al MIN_SALARY ni superior al MAX_SALARY de su puesto en la tabla JOBS. Si es 
--menor al mínimo dará un error e impedirá el cambio, y si es mayor al máximo emite un 
--mensaje de alerta pero permite la modificación. 
-- 
--6. Crea un trigger que avise mediante un mensaje si, al asignar un departamento a un 
--empleado, su jefe directo (manager_id en employees) no coincide con el jefe 
--responsable de dicho departamento (manager_id en departments). (Si al actualizar el 
--departamento de un empleado obtienes un error originado por el trigger 
--HR.UPDATE_JOB_HISTORY, deshabilita dicho trigger). 
-- 
--7. Añade la columna COMMISSION_AMT a la tabla EMPLOYEES. Crea un trigger que, cada 
--vez que cambie el salario o el porcentaje de comisión, calcule automáticamente el importe 
--resultante y lo guarde en dicha columna. Si el porcentaje actual es null, el importe de la 
--comisión será 0 (cero, no null). 