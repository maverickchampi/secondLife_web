drop database if exists bd_servicio_venta;
create database bd_servicio_venta;
use bd_servicio_venta;
/*----------------categoria----------------*/
create table tb_categoria ( 
	id_categ int not null,
	nom_categ varchar(45) not null,
	descrip_categ varchar(256) not null,
	estado int not null	
);
/* estado
		1.- activo
		2.- desactivo
*/    
alter table tb_categoria 
	add constraint PKcateg primary key(id_categ),
    add constraint  UQcateg_nom unique (nom_categ ),
    add constraint CKcateg_est check (estado in (1, 2)),    
	modify id_categ int auto_increment,
    alter estado set default 1;

/*---------------tabla login----------------*/
create table tb_login (
	id_log char(5) not null,
	usuario varchar(15) not null, 
	pass varchar(15) not null,  
	email_log varchar(100) not null,
    estado int not null	
);
alter table tb_login 
	add constraint PKlogin primary key (id_log),
    add constraint CKusua check (length(usuario)>=7),
    add constraint CKpass check (length(pass)>=7),
    add constraint CKlogins_est check (estado in (1, 2)),
    add constraint CKlogin_email check (length(email_log)>=10),
    alter estado set default 1;
DELIMITER $$
CREATE TRIGGER tg_insertar_idlogin
BEFORE INSERT ON tb_login
FOR EACH ROW
BEGIN
    IF (SELECT COUNT(*) FROM tb_login)=0   THEN
        SET NEW.id_log= 'lg001';
    ELSE
        SET NEW.id_log= CONCAT('lg', LPAD((SELECT COUNT(*) FROM tb_login)+1, 3, '0'));
	END IF;
END$$
DELIMITER ;

/*----------------tabla departamento----------------*/
create table tb_departamento (
	id_dep int not null,
	nom_dep varchar(100) not null
);
alter table tb_departamento
	add constraint PKdepar primary key (id_dep),
    add constraint CKdepar_nom check (length(nom_dep)>=3),
    modify id_dep int auto_increment;

/*----------------tabla provincia ----------------*/
create table tb_provincia (
	id_prov int not null,
	id_dep int not null,
	nom_prov varchar(100) not null
);
alter table tb_provincia
	add constraint PKprov primary key(id_prov),
    add constraint FKprov_dep foreign key(id_dep) references tb_departamento(id_dep),
    add constraint CKprov_nom check (length(nom_prov)>=3),
    modify id_prov int auto_increment;
    
/*----------------tabla registro----------------*/
create table tb_distrito ( -- (ESTABLECIMIENTO - Cercado de Lima)
    id_dist int not null,    
	id_prov int not null,    
	nom_dist varchar(100)
);
alter table tb_distrito 
	add constraint PKdist primary key(id_dist),
    add constraint FKdist_prov foreign key(id_prov) references tb_provincia(id_prov),
    add constraint CKdist_nom check (length(nom_dist)>=3),
    modify id_dist int auto_increment;
       
/*----------------tabla cliente----------------*/
create table tb_cliente (
	id_clie char(5) not null,
	dni_clie char(8) not null, 
	nom_clie varchar(100) not null,
	ape_clie varchar(100) not null,
	fec_nac_clie timestamp not null default current_timestamp,
	id_dist int,
	dir_clie varchar(256),
    tel_clie char(9),
    id_log char(5) not null,
    estado int not null
);
alter table tb_cliente 
	add constraint PKclie primary key (id_clie),
    add constraint FKclie_dist foreign key(id_dist) references tb_distrito(id_dist),
    add constraint FKclie_log foreign key (id_log) references tb_login (id_log),
    add constraint CKclie_dni check (length(dni_clie)=8),
    add constraint CKclie_dato check (length(nom_clie)>=2 and (length(ape_clie)>=2)),
    add constraint CKclie_tel check (length(tel_clie)=9),
    add constraint CKclie_est check (estado in (1, 2)),
	alter estado set default 1;
DELIMITER $$
CREATE TRIGGER tg_insertar_idcliente
BEFORE INSERT ON tb_cliente
FOR EACH ROW
BEGIN
    IF (SELECT COUNT(*) FROM tb_cliente)=0   THEN
        SET NEW.id_clie= 'cl001';
    ELSE
        SET NEW.id_clie= CONCAT('cl', LPAD((SELECT COUNT(*) FROM tb_cliente)+1, 3, '0'));
	END IF;
END$$
DELIMITER ; 

/*---------------- tabla registro ----------------*/
create table tb_registro (
	id_regis char(5) not null,
	id_categ int not null,
	id_clie char(5) not null,
	nom_prod varchar(100) not null,
	observacion varchar(256),
	fecha_regis timestamp not null default current_timestamp,
	stock int not null,
	precio decimal(8,2) not null,
	calidad int not null,
	estado int not null
);
/* calidad
		1.- bueno
		2.- intermedio
		3.- malo
	estado
		1.- activo
		2.- desactivo
*/
alter table  tb_registro 
	add constraint PKregistro primary key(id_regis),
    add constraint FKregis_categ foreign key (id_categ) references tb_categoria(id_categ),
    add constraint FKregis_clie foreign key (id_clie) references tb_cliente(id_clie),
    add constraint CKregis_prod check (length(nom_prod)>=10),
    add constraint CKregis_prec check (precio>=5.0),
    add constraint CKregis_stock check (stock>=0 and stock <=100),
    add constraint CKregis_cal check (calidad in (1, 2, 3)),
    add constraint CKregis_esta check (estado in (1, 2)),
    alter estado set default 1;
DELIMITER $$
CREATE TRIGGER tg_insertar_idregistro
BEFORE INSERT ON tb_registro
FOR EACH ROW
BEGIN
    IF (SELECT COUNT(*) FROM tb_categoria)=0   THEN
        SET NEW.id_regis= 'rg001';
    ELSE
        SET NEW.id_regis= CONCAT('rg', LPAD((SELECT COUNT(*) FROM tb_registro)+1, 3, '0'));
	END IF;
END$$
DELIMITER ; 

/*----------------tabla producto----------------*/    
create table tb_producto (
	id_prod char(5) not null,
	id_regis char(5) not null,
	descrip_prod varchar(256) not null,
	fec_regis_prod timestamp not null default current_timestamp,
	stock int,
	precio decimal(8,2),
	image varchar(256),
	calidad int,
	estado int
);
/* calidad
		1.- bueno
		2.- intermedio
		3.- malo
	estado
		1.- activo
		2.- desactivo
*/
alter table  tb_producto
	add constraint PKprod primary key (id_prod),
    add constraint FKprod_reg foreign key (id_regis) references tb_registro(id_regis),
	add constraint CKprod_des check (length(descrip_prod)>=10),
    add constraint CKprod_prec check (precio>=5.0),
    add constraint CKprod_stock check (stock>=0 and stock <=100),
    add constraint CKprod_cal check (calidad in (1, 2, 3)),
    add constraint CKprod_esta check (estado in (1, 2)),
    alter estado set default 1;
DELIMITER $$
CREATE TRIGGER tg_insertar_idproducto
BEFORE INSERT ON tb_producto
FOR EACH ROW
BEGIN
    IF (SELECT COUNT(*) FROM tb_categoria)=0   THEN
        SET NEW.id_prod= 'pd001';
    ELSE
        SET NEW.id_prod= CONCAT('pd', LPAD((SELECT COUNT(*) FROM tb_producto)+1, 3, '0'));
	END IF;
END$$
DELIMITER ; 

/*----------------tabla rol----------------*/
create table tb_rol (
	id_rol int not null,
	nom_rol varchar(250) not null,
	sue_min decimal(8,2) not null,
	sue_max decimal(8,2) not null
);
alter table tb_rol
	add constraint PKrol primary key (id_rol),
    add constraint CKrol_nom check (length(nom_rol)>=3),
    add constraint CKrol_suemax check (sue_min>=930 and sue_min<=2000),
    add constraint CKrol_suemin check (sue_max>2000 and sue_max<=5000),
    modify id_rol int auto_increment;
 
/*----------------tabla empleado----------------*/
create table tb_empleado (
	id_emp char(5) not null,   
	dni_emp char(8) not null,
	id_rol int not null,
	nom_emp  varchar(100) not null,
	ape_emp varchar(100) not null,
	tel_emp char(9) not null,
	id_dist  int not null,
	dir_emp varchar(256) not null,   
	fec_nac_emp timestamp not null,
	obs_emp  varchar(256),
	sue_emp decimal(8,2) not null,
    id_log char(5) not null,
    estado int not null
);
alter table tb_empleado
	add constraint PKemp primary key (id_emp),
	add constraint FKemp_rol foreign key(id_rol) references tb_rol(id_rol),
    add constraint FKemp_dist foreign key(id_dist) references tb_distrito(id_dist),
    add constraint FKemp_log foreign key (id_log) references tb_login (id_log),
    add constraint CKemp_dni check (length(dni_emp)=8),
    add constraint CKemp_dato check (length(nom_emp)>=2 and (length(ape_emp)>=2)),
    add constraint CKemp_tel check (length(tel_emp)=9),
    add constraint CKemp_sue check (sue_emp>=0 and sue_emp<=5000),
	add constraint CKemp_est check (estado in (1, 2)),
	alter estado set default 1;
delimiter $$
create trigger tg_insertar_idempleado
BEFORE INSERT ON tb_empleado
FOR EACH ROW
BEGIN
    IF (SELECT COUNT(*) FROM tb_empleado)=0   THEN
        SET NEW.id_emp= 'ep001';
    ELSE
        SET NEW.id_emp= CONCAT('ep', LPAD((SELECT COUNT(*) FROM tb_empleado)+1, 3, '0'));
	END IF;
end$$
delimiter ;    
/*TB_METODO DE PAGO
	code_met_pag INT,
	des_med_pag VARCHAR(20)*/

/*----------------tabla boleta----------------*/
create table tb_boleta (
	num_bol char(6) not null,
	id_log char(5) not null,
	-- cod_med_pag int not null,
	fec_bol  timestamp not null default current_timestamp,
	impo_bol decimal(8,2) not null,
	envio decimal(8,2) not null,
	total_bol  decimal(8,2) not null
);
alter table tb_boleta
	add constraint PKbol primary key (num_bol),
    add constraint FKbol_log foreign key (id_log) references tb_login(id_log),
    add constraint CKbol_impo check (impo_bol>=1.0),
    add constraint CKbol_envio check (envio>=1.0),
    add constraint CKbol_total check (total_bol>=5.0);   
delimiter $$
create trigger tg_insertar_idboleta
before insert on tb_boleta 
for each  row
begin
    if (select COUNT(*) from tb_boleta)=0   THEN
        set new.num_bol= '000001';
    else
        set new.num_bol= CONCAT(LPAD((SELECT COUNT(*) FROM tb_boleta)+1, 6, '0'));
	end if;
end$$
delimiter ; 
/*----------------tabla detalle de boleta----------------*/
create table tb_detalle_boleta(
	num_det_bol CHAR(4) not null,
	num_bol  CHAR(6) not null,
	id_prod char(5) not null,
	cant_prod  int not null,
	sub_tot  decimal(8,2) not null
);
alter table tb_detalle_boleta
	add constraint PKdetalbol primary key (num_det_bol),
    add constraint FKdetalbol_bol foreign key (num_bol) references tb_boleta(num_bol),
    add constraint FKdetalbol_prod foreign key (id_prod) references tb_producto(id_prod),
    add constraint CKdetalbol_cant check (cant_prod>=1 and cant_prod<=5),
    add constraint CKdetalbol_sub check (sub_tot>=5.0 and sub_tot<=5000);    
delimiter $$
create trigger tg_insertar_iddetalleboleta
before insert on tb_detalle_boleta
for each row
begin
    if (select COUNT(*) FROM tb_detalle_boleta)=0   THEN
        set new.num_bol= '0001';
    else
        set new.num_bol= CONCAT(LPAD((SELECT COUNT(*) FROM tb_detalle_boleta)+1, 4, '0'));
	end if;
end$$
delimiter ; 
/*---------------------ingreso de datos-----------------------*/
insert into tb_categoria(nom_categ, descrip_categ) values ('laptops', 'info');
insert into tb_categoria(nom_categ, descrip_categ) values ('impresores', 'info');
insert into tb_categoria(nom_categ, descrip_categ) values ('celulares', 'info');
insert into tb_categoria(nom_categ, descrip_categ) values ('cámaras', "info");
insert into tb_categoria(nom_categ, descrip_categ) values ('wearables', 'info');
insert into tb_categoria(nom_categ, descrip_categ) values ('TV´s', 'info');
insert into tb_categoria(nom_categ, descrip_categ) values ('audio', 'info');

insert into tb_departamento values (null, 'Lima');

insert into tb_provincia values (null, 1, 'Lima');

insert into tb_distrito values (null, 1, 'Cercado de Lima');
insert into tb_distrito values (null, 1, 'San Luis');    
insert into tb_distrito values (null, 1, 'Breña');    
insert into tb_distrito values (null, 1, 'La Victoria');    
insert into tb_distrito values (null, 1, 'Rimac');
insert into tb_distrito values (null, 1, 'Lince');    
insert into tb_distrito values (null, 1, 'San Miguel');
insert into tb_distrito values (null, 1, 'Jesús María');
insert into tb_distrito values (null, 1, 'Magdalena');    
insert into tb_distrito values (null, 1, 'Pblo. Libre'); 

insert into tb_login(usuario, pass, email_log) values ('madel_12', '12345678', 'madeliyricra23@gmail.com');
insert into tb_cliente values (null, '70915220', 'Madeliy', 'Ricra Gutierrez', '2002-04-23', 1, null, null, 'lg001', 1);

insert into tb_rol values (null, 'técnico infomático', 930, 2600);
insert into tb_rol values (null, 'personal seguridad', 930, 2600);
insert into tb_rol values (null, 'personal motorizado', 930, 2600);

/*
select*from tb_boleta;
select*from tb_categoria;
select*from tb_cliente;
select*from tb_departamento;
select*from tb_detalle_boleta;
select*from distrito;
select*from tb_empleado;
select*from tb_login;
select*from tb_producto;
select*from tb_provincia;
select*from tb_registro;
select*from tb_rol;
*/



