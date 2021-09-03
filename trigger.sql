CREATE or REPLACE FUNCTION tg_contratoNuevo() RETURNS TRIGGER
AS
$tg_contratoNuevo$
  DECLARE
    Contrato_nuevo date;
    maximo int;
BEGIN
    select contrato_fecha into Contrato_nuevo from contrato where contrato_id=new.contrato_id;
    select detalle_cantidad_de_dano into maximo from detalle_de_mantenimiento where detalle_id=new.detalle_id;
    if (  maximo >5) then
        raise exception 'El contrato no permitido, el dron ha tenido más de cinco mantenimiento';
    END if;
    RETURN new;
END;
$tg_contratoNuevo$
LANGUAGE plpgsql;

--before after instead of
create trigger trigger_contratoNuevo before insert
on Registro fOR EACH ROW
execute procedure tg_contratoNuevo();


--mostrar el trigger
INSERT into Registro ( contrato_Id, Detalle_Id) values (1,10);
