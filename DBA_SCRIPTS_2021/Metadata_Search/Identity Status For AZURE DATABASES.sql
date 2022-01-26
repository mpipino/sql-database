/* Valor límite */
Declare @threshold decimal(3,2) = .85;
 --drop table #identityStatus
Create Table #identityStatus
(
     table_name        varchar(128)
    , column_name       varchar(128)
    , data_type         varchar(128)
    , last_value        bigint
    , max_value         bigint
);
 

    Insert Into #identityStatus
    Select Object_Name(id.object_id) As [table_name]
        , id.name As [column_name]
        , t.name As [data_type]
        , Cast(id.last_value As bigint) As [last_value]
        , Case 
            When t.name = 'tinyint'   Then 255 
            When t.name = 'smallint'  Then 32767 
            When t.name = 'int'       Then 2147483647 
            When t.name = 'bigint'    Then 9223372036854775807
          End As [max_value]
    From sys.identity_columns As id
    Join sys.types As t
        On id.system_type_id = t.system_type_id
    Where id.last_value Is Not Null;
 
/* Consulta de resultados */
Select  table_name Tabla
    , column_name ColumnaIdentity
    , data_type Tipo
    , last_value UltimoValor
    , Case 
        When last_value < 0 Then 100
        Else (1 - Cast(last_value As float(4)) / max_value) * 100 
      End As [%RestanteSegunTipo]
    , Case 
        When Cast(last_value As float(4)) / max_value >= @threshold
            Then 'Complicado'
        Else 'Bien por ahora'
        End As [Estado]
From #identityStatus
Order By [%RestanteSegunTipo];
 
/* Quitar temporal */
Drop Table #identityStatus;