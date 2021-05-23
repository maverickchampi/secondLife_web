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

/*---------------tabla numero de cuenta----------------*/
create table tb_tarjeta (
	id_tarj char(5) not null,
    tip_tarj varchar(25) not null,
    num_tarj char(16) not null,
    fec_venc date not null,
    cvv int not null,
    id_log char(5) not null
);
alter table tb_tarjeta
	add constraint PKtarjeta primary key (id_tarj),
    add constraint FKtarj_log foreign key(id_log) references tb_login(id_log),
    add constraint CKtarj_tip check (length(tip_tarj)>=4),
    add constraint CKtarj_num check (length(num_tarj)=16),
    add constraint CKtarj_cvv check (cvv>=100 and cvv<=999);
DELIMITER $$
CREATE TRIGGER tg_insertar_idtarjeta
BEFORE INSERT ON tb_tarjeta
FOR EACH ROW
BEGIN
    IF (SELECT COUNT(*) FROM tb_tarjeta)=0   THEN
        SET NEW.id_tarj= 'tj001';
    ELSE
        SET NEW.id_tarj= CONCAT('tj', LPAD((SELECT COUNT(*) FROM tb_tarjeta)+1, 3, '0'));
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
    
/*----------------tabla direccion----------------*/
create table tb_direccion(
	id_direc char(5) not null,
    latitud decimal not null,
    longitud decimal not null,
    desc_direc varchar(256) not null,
    etiqueta varchar(15) not null,
    id_dist  int not null,
	id_log char(5) not null
);
alter table tb_direccion
	add constraint PKdireccion primary key(id_direc),
     add constraint FKdirec_log foreign key(id_log) references tb_login(id_log),
	add constraint FKdirec_dist foreign key(id_dist) references tb_distrito(id_dist),
	add constraint CKdirec_desc check (length(desc_direc)>=4);
delimiter $$
create trigger tg_insertar_iddireccion
BEFORE INSERT ON tb_direccion
FOR EACH ROW
BEGIN
    IF (SELECT COUNT(*) FROM tb_direccion)=0   THEN
        SET NEW.id_direc= 'dc001';
    ELSE
        SET NEW.id_direc= CONCAT('dc', LPAD((SELECT COUNT(*) FROM tb_direccion)+1, 3, '0'));
	END IF;
end$$
delimiter ;      
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
    add constraint CKrol_suemax check (sue_min>=930 and sue_min<=1200),
    add constraint CKrol_suemin check (sue_max>=1200 and sue_max<=5000),
    modify id_rol int auto_increment;
 
/*----------------tabla empleado----------------*/
create table tb_empleado (
	id_emp char(5) not null,   
	dni_emp char(8) not null,
	id_rol int not null,
	nom_emp  varchar(100) not null,
	ape_emp varchar(100) not null,
	tel_emp char(9) not null,
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

/*----------------tabla cliente----------------*/
create table tb_cliente (
	id_clie char(5) not null,
	dni_clie char(8) not null, 
	nom_clie varchar(100) not null,
	ape_clie varchar(100) not null,
	fec_nac_clie timestamp not null default current_timestamp,
    tel_clie char(9),
    id_log char(5),
    estado int
);
alter table tb_cliente 
	add constraint PKclie primary key (id_clie),
    add constraint FKclie_log foreign key (id_log) references tb_login (id_log),
    add constraint CKclie_dni check (length(dni_clie)=8),
    add constraint CKclie_dato check (length(nom_clie)>=2 and (length(ape_clie)>=2)),
    add constraint CKclie_tel check (length(tel_clie)=9),
    add constraint CKclie_est check (estado in (1, 2) or null),
	alter estado set default 1;
DELIMITER $$
CREATE TRIGGER tg_insertar_idcliente
BEFORE INSERT ON tb_cliente 
FOR EACH ROW
BEGIN
    IF (SELECT COUNT(*) FROM tb_cliente)=0   THEN
        SET NEW.id_clie= 'cl001';
    ELSE
        SET NEW.id_clie= CONCAT('lg', LPAD((SELECT COUNT(*) FROM tb_cliente)+1, 3, '0'));
	END IF;
END$$
DELIMITER ;

/*---------------- tabla registro ----------------*/
create table tb_registro (
	id_regis char(5) not null,
	id_categ int not null,
	id_clie char(5) not null,
	descrip_prod varchar(100) not null,
	observacion varchar(256),
	fecha_regis timestamp not null default current_timestamp,
	stock int not null,
	precio decimal(8,2) not null,
    image varchar(256) not null,
	calidad decimal (4,2) not null,
	estado int not null
);
/* calidad
		0-3  >> mal estado: inservible, falta de algun componente fisico, daño grave en la pintura y/o cuerpo,
				software brickeado o bloqueado. (tiempo de uso < 2 años)
		3-5  >> estado regular: daño en la pintura, cuerpo dañado o software bloqueado. (tiempo de uso < 1 año)
		5-7  >> estado bueno: ligeros rayones en el cuerpo. (tiempo de uso < 6 meses)
        7-10 >> estado excelente: practicamente como nuevo sin señales de uso. (tiempo de uso < 3 meses)
	estado
		1.- activo (aceptado)
		2.- desactivo (no aceptado)
*/
alter table  tb_registro 
	add constraint PKregistro primary key(id_regis),
    add constraint FKregis_categ foreign key (id_categ) references tb_categoria(id_categ),
    add constraint FKregis_clie foreign key (id_clie) references tb_cliente(id_clie),
    add constraint CKregis_prod check (length(descrip_prod)>=10 and length(observacion)>=10),
    add constraint CKregis_prec check (precio>=5.0),
    add constraint CKregis_stock check (stock>=0 and stock <=100),
    add constraint CKregis_cal check (calidad>=1 and calidad<=10),
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
    cod_prod char(10) not null,
	id_categ int not null,
    mar_prod varchar(100) not null,
    mod_prod varchar(100) not null,
	descrip_prod varchar(256) not null,
    observacion varchar(256) not null,
	fec_comp_prod timestamp not null default current_timestamp,
    stock int not null,
    precio decimal(8,2) not null,
	image varchar(256) not null,
    calidad decimal (4,2) not null,
	estado int
);
/* calidad
		0-3  >> mal estado: inservible, falta de algun componente fisico, daño grave en la pintura y/o cuerpo,
				software brickeado o bloqueado. (tiempo de uso < 2 años)
		3-5  >> estado regular: daño en la pintura, cuerpo dañado o software bloqueado. (tiempo de uso < 1 año)
		5-7  >> estado bueno: ligeros rayones en el cuerpo. (tiempo de uso < 6 meses)
        7-10 >> estado excelente: practicamente como nuevo sin señales de uso. (tiempo de uso < 3 meses)
	estado
		1.- activo (listo para la venta)
		2.- desactivo (en reparacion)
*/
alter table  tb_producto
	add constraint PKprod primary key (id_prod),
    add constraint FKprod_categ foreign key (id_categ) references tb_categoria(id_categ),
	add constraint CKprod_desc check (length(descrip_prod)>=10 and length(observacion)>=10),
    add constraint CKprod_cal_comp check (calidad>=0 and calidad<=10),
     add constraint CKprod_prec check (precio>=5.0),
    add constraint CKprod_esta check (estado in (1, 2)),
    alter estado set default 2;
DELIMITER $$
CREATE TRIGGER tg_insertar_idproducto
BEFORE INSERT ON tb_producto
FOR EACH ROW
BEGIN
    IF (SELECT COUNT(*) FROM tb_producto)=0   THEN
        SET NEW.id_prod= 'pd001';
    ELSE
        SET NEW.id_prod= CONCAT('pd', LPAD((SELECT COUNT(*) FROM tb_producto)+1, 3, '0'));
	END IF;
END$$
DELIMITER ; 

/*----------------tabla boleta----------------*/
create table tb_boleta (
	num_bol char(8) not null,
	id_log char(5) not null,
	tipo_pago int not null,
    descrip_pago varchar(30) not null,
    id_direc char(5) not null,
	fec_bol  timestamp not null default current_timestamp,
	impo_bol decimal(8,2) not null,
	envio decimal(8,2) not null,
	total_bol  decimal(8,2) not null
);
alter table tb_boleta
	add constraint PKbol primary key (num_bol),
    add constraint FKbol_log foreign key (id_log) references tb_login(id_log),
    add constraint FKbol_direc foreign key (id_direc) references tb_direccion(id_direc),
    add constraint CKbol_impo check (impo_bol>=1.0),
    add constraint CKbol_envio check (envio>=1.0),
    add constraint CKbol_total check (total_bol>=5.0),
    add constraint CKtip_pago check (tipo_pago in (1, 2));   
    
/*
	1 - tarjeta
    2 - paypal
*/
delimiter $$
create trigger tg_insertar_idboleta
before insert on tb_boleta 
for each  row
begin
    if (select COUNT(*) from tb_boleta)=0   THEN
        set new.num_bol= '00000001';
    else
        set new.num_bol= CONCAT(LPAD((SELECT COUNT(*) FROM tb_boleta)+1, 8, '0'));
	end if;
end$$
delimiter ; 
/*----------------tabla detalle de boleta----------------*/
create table tb_detalle_boleta(
	num_det_bol CHAR(6) not null,
	num_bol  CHAR(8) not null,
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
        set new.num_bol= '000001';
    else
        set new.num_bol= CONCAT(LPAD((SELECT COUNT(*) FROM tb_detalle_boleta)+1, 6, '0'));
	end if;
end$$
delimiter ; 
/*---------------------ingreso de datos-----------------------*/
insert into tb_categoria(nom_categ, descrip_categ) values ('Laptops', 'Computadoras portátiles de peso y tamaño ligero, su tamaño es aproximado al de un portafolio.');
insert into tb_categoria(nom_categ, descrip_categ) values ('Impresoras', 'Periféricos encargados de transferir las imágenes y textos de tu PC a papel.');
insert into tb_categoria(nom_categ, descrip_categ) values ('Smartphones', 'Teléfonos celulares inteligentes.');
insert into tb_categoria(nom_categ, descrip_categ) values ('Cámaras', "Aparatos para registrar imágenes estáticas o en movimiento.");
insert into tb_categoria(nom_categ, descrip_categ) values ('Wearables', 'Dispositivos que se usan en el cuerpo humano y que interactúan con otros aparatos para transmitir o recoger algún tipo de datos.');
insert into tb_categoria(nom_categ, descrip_categ) values ('Smart TV´s', 'Televisores inteligentes.');
insert into tb_categoria(nom_categ, descrip_categ) values ('Audio', 'Dispositivos que reproducen, graban o procesan sonido.');

insert into tb_departamento values (1, 'Lima');

insert into tb_provincia values (null, 1, 'Lima');

insert into tb_distrito values (null, 1, 'Ancón');
insert into tb_distrito values (null, 1, 'Ate');
insert into tb_distrito values (null, 1, 'Barranco');   
insert into tb_distrito values (null, 1, 'Breña'); 
insert into tb_distrito values (null, 1, 'Carabayllo');
insert into tb_distrito values (null, 1, 'Chaclacayo');
insert into tb_distrito values (null, 1, 'Chorrillos');
insert into tb_distrito values (null, 1, 'Cieneguilla');
insert into tb_distrito values (null, 1, 'Comas');
insert into tb_distrito values (null, 1, 'El Agustino'); 
insert into tb_distrito values (null, 1, 'Independencia'); 
insert into tb_distrito values (null, 1, 'Jesús María');
insert into tb_distrito values (null, 1, 'La Molina');   
insert into tb_distrito values (null, 1, 'La Victoria');   
insert into tb_distrito values (null, 1, 'Lima Centro');  
insert into tb_distrito values (null, 1, 'Lince');   
insert into tb_distrito values (null, 1, 'Los Olivos');   
insert into tb_distrito values (null, 1, 'Lurín');  
insert into tb_distrito values (null, 1, 'Magdalena');  
insert into tb_distrito values (null, 1, 'Miraflores');   
insert into tb_distrito values (null, 1, 'Pachacamac'); 
insert into tb_distrito values (null, 1, 'Pucusana'); 
insert into tb_distrito values (null, 1, 'Pblo. Libre');  
insert into tb_distrito values (null, 1, 'Puente Piedra');   
insert into tb_distrito values (null, 1, 'Punta Hermosa'); 
insert into tb_distrito values (null, 1, 'Punta Negra'); 
insert into tb_distrito values (null, 1, 'Rímac'); 
insert into tb_distrito values (null, 1, 'San Bartolo');  
insert into tb_distrito values (null, 1, 'San Borja');  
insert into tb_distrito values (null, 1, 'San Isidro');  
insert into tb_distrito values (null, 1, 'San Juan de Lurigancho');  
insert into tb_distrito values (null, 1, 'San Juan de Miraflores');  
insert into tb_distrito values (null, 1, 'San Luis');   
insert into tb_distrito values (null, 1, 'San Martín de Porres');  
insert into tb_distrito values (null, 1, 'San Miguel');     
insert into tb_distrito values (null, 1, 'Santa Anita');     
insert into tb_distrito values (null, 1, 'Santa María del Mar'); 
insert into tb_distrito values (null, 1, 'Santa Rosa');       
insert into tb_distrito values (null, 1, 'Santiago de Surco');  
insert into tb_distrito values (null, 1, 'Surquillo');       
insert into tb_distrito values (null, 1, 'Villa El Salvador');     
insert into tb_distrito values (null, 1, 'Villa María del Triunfo');            

insert into tb_login(usuario, pass, email_log) values ('madel_12', '12345678', 'madeliyricra@gmail.com');
insert into tb_login(usuario, pass, email_log) values ('calax590', '321654987', 'luizito590@gmail.com');
insert into tb_login(usuario, pass, email_log) values ('mknecroc12', '741852963', 'willymas123@gmail.com');
insert into tb_login(usuario, pass, email_log) values ('maver78', '987523641', 'maverick78@gmail.com');

insert into tb_cliente values (null,'70915220', 'Madeliy', 'Ricra Gutierrez', '2002-04-23', '987654321', 'lg001', 1);
insert into tb_cliente values (null,'72450000', 'Luis Fernando', 'Pérez Burga', '2000-09-05', '987654321', 'lg002', 1);
insert into tb_cliente values (null,'72397705', 'Willy Alberto', 'Melendez Gamarra', '2000-10-21', '987654321', 'lg003', 1);
insert into tb_cliente values (null,'71234568', 'Maverick', 'Champi Romero', '1999-05-07', '987654321', 'lg004', 1);
insert into tb_cliente values (null,'76428945', 'Juan', 'Rodriguez Suarez', '2002-04-23',  '987654321', null, 1);
insert into tb_cliente values (null,'73248756', 'Roberto', 'Fernandez Ramirez', '2002-04-23', '987654321', null, 1);
insert into tb_cliente values (null,'73200896', 'Alex', 'Quispe Cavero', '2002-04-23', '987654321', null, 1);

insert into tb_rol values (null, 'técnico infomático', 1200, 2000);
insert into tb_rol values (null, 'personal seguridad', 1200, 1800);
insert into tb_rol values (null, 'personal delivery', 930, 1200);

/*----------------------LAPTOPS-------------------------*/
insert into tb_registro values (null, 1, 'cl001', 'Es una laptop HP...', 'El equipo muestra ligero rapones en la pintura de la parte frontal, software y componentes en buen estado.', '2021-05-01', 1, 800.0, 'no imagen', 6.0, 1);
insert into tb_producto values (null, '632541-001', 1, 'HP', '15-dw1085la', 'Procesador: i3-10110U; RAM: 4GB DDR4; ROM: 256GB SSD; Pantalla: 15,6" FHD',
								'Equipo en buen estado, pintura refaccionada', '2021-05-07', 1, 1500.0, 'no imagen', 8.5, 1);
                                
insert into tb_registro values (null, 1, 'cl001', 'Es una laptop ...', 'El equipo se muestra sin sistema operativo, y daño en uno de los puertos USB', '2021-05-10', 1, 500.0,'no imagen', 4.5, 1);                      
insert into tb_producto values (null, '632541-002', 1, 'HP', '15-dw1085la', 'Procesador: i3-10110U; RAM: 4GB DDR4; ROM: 256GB SSD; Pantalla: 15,6" FHD',
								'Equipo en buen estado, sistema instalado y puerto usb reparado', '2021-05-15', 1, 1000.0, 'no imagen', 7.5, 1);
  
insert into tb_registro values (null, 1, 'cl001', 'Es una laptop ...', 'El equipo muestra placa base destruida, pantalla inservible y teclado con falta de teclas', '2021-05-10', 1, 200.0, 'no imagen', 2.7, 1);      
insert into tb_producto values (null, '632541-003', 1, 'HP', '15-dw1085la', 'Procesador: i3-10110U; RAM: 4GB DDR4; ROM: 256GB SSD; Pantalla: 15,6" FHD',
								 'Equipo en buen estado, completamente restaurado','2021-05-25', 1, 800.0, 'no imagen', 7.0, 1);
                                
insert into tb_registro values (null, 1, 'cl001', 'Es una laptop ...', 'El equipo muestra ligero rapones en la pintura de la parte frontal, software y componentes en buen estado.', '2021-05-10', 1, 2800.0, 'no imagen', 6.0, 1);                              
insert into tb_producto values (null, '732685-001', 1, 'Apple', 'Macbook Air 13', 'Procesador: M1; RAM: 8GB; ROM: 256GB; Pantalla: 13" FHD',
								'Equipo en buen estado, pintura refaccionada','2020-07-07', 1, 4000.0, 'no imagen', 8.5, 1);

insert into tb_registro values (null, 1, 'cl001', 'Es una laptop ...', 'El equipo se muestra sin sistema operativo, y daño en uno de los puertos USB', '2021-05-10', 1, 2000.0, 'no imagen', 4.5, 1);                                      
insert into tb_producto values (null, '732685-002', 1, 'Apple', 'Macbook Air 13', 'Procesador: M1; RAM: 8GB; ROM: 256GB; Pantalla: 13" FHD',
								 'Equipo en buen estado, sistema instalado y puerto usb reparado', '2020-07-15', 1,  2700.0, 'no imagen', 7.5, 1);

insert into tb_registro values (null, 1, 'cl001', 'Es una laptop ...', 'El equipo muestra placa base destruida, pantalla inservible y teclado con falta de teclas', '2021-05-10', 1,  1200.0, 'no imagen', 2.7, 1);                                      
insert into tb_producto values (null, '732685-003', 1, 'Apple', 'Macbook Air 13', 'Procesador: M1; RAM: 8GB; ROM: 256GB; Pantalla: 13" FHD',
								'Equipo en buen estado, completamente restaurado','2020-07-25', 1, 2000.0, 'no imagen', 7.0, 1);
 
insert into tb_registro values (null, 1, 'cl001', 'Es una laptop ...', 'El equipo muestra placa base destruida, pantalla inservible y teclado con falta de teclas', '2021-05-10', 1,  4000.0, 'no imagen', 2.7, 1);      
insert into tb_producto values (null, '852147-001', 1, 'ASUS', 'ROG Zephyrus G14', 'Procesador: Ryzen 9 4900HS; RAM: 16GB; ROM: 1TB SSD; Pantalla: 14" QHD',
								'Equipo en buen estado, completamente restaurado', '2020-11-07', 1, 7000.0, 'no imagen', 7.0, 1);
                                
insert into tb_registro values (null, 1, 'cl001', 'Es una laptop ...', 'El equipo muestra ligero rapones en la pintura de la parte frontal, software y componentes en buen estado.', '2021-05-10', 1, 3500.0, 'no imagen', 6.0, 1);      
insert into tb_producto values (null, '852147-002', 1, 'ASUS', 'ROG Zephyrus G14', 'Procesador: Ryzen 9 4900HS; RAM: 16GB; ROM: 1TB SSD; Pantalla: 14" QHD',
								'Equipo en buen estado, pintura refaccionada', '2021-11-13', 1, 6000.0, 'no imagen', 8.5, 1);
                                
insert into tb_registro values (null, 1, 'cl001', 'Es una laptop ...', 'El equipo se muestra sin sistema operativo, y daño en uno de los puertos USB', '2021-05-10', 1, 3000.0, 'no imagen', 4.5, 1);                                      
insert into tb_producto values (null, '852147-003', 1, 'ASUS', 'ROG Zephyrus G14', 'Procesador:Ryzen 9 4900HS; RAM: 16GB; ROM: 1TB SSD; Pantalla: 14" QHD',
								'Equipo en buen estado, sistema instalado y puerto usb reparado', '2021-11-25', 1, 5500.0, 'no imagen', 7.5, 1);
                                
insert into tb_registro values (null, 1, 'cl001', 'Es una laptop ...', 'El equipo se muestra sin placa base, pantalla inservible y teclado con falta de teclas', '2021-05-10', 1, 2500.0, 'no imagen', 2.0, 1);      						
insert into tb_producto values (null, '852147-004', 1, 'ASUS', 'ROG Zephyrus G14', 'Procesador: Ryzen 9 4900HS; RAM: 16GB; ROM: 1TB SSD; Pantalla: 14" QHD',
								'Equipo en buen estado, completamente restaurado', '2021-11-30', 1, 5000.0, 'no imagen', 2.0, 1);


/*----------------------IMPRESORAS-------------------------*/
insert into tb_registro values (null, 1, 'cl001', 'Es una impresora ...', 'El equipo muestra ligeros raspones en el cuerpo y nivel de tinta al 50%', '2021-05-10', 1, 450.0, 'no imagen', 6.0, 1);      	
insert into tb_producto values (null, '524786-001', 2, 'HP', 'Multifuncional Ink Tank 415', 'Capacidad: 60 hojas; Wi-Fi: No; Bluetooth: No; NFC: No',
								'Equipo en buen estado, pintura refaccionada y tinta al 100%', '2020-07-07', 1, 700.0, 'no imagen', 8.5, 1);
                        
insert into tb_registro values (null, 1, 'cl001', 'Es una impresora ...', 'El equipo se muestra con daños en la bandeja y sin deposito de tinta', '2021-05-10', 1, 400.0, 'no imagen', 4.5, 1);      	                                
insert into tb_producto values (null, '524786-002', 2, 'HP', 'Multifuncional Ink Tank 415', 'Capacidad: 60 hojas; Wi-Fi: No; Bluetooth: No; NFC: No',
								'Equipo en buen estado, partes refaccionadas y tinta al 100%', '2020-07-15', 1, 650.0, 'no imagen', 7.5, 1);
                                
insert into tb_registro values (null, 1, 'cl001', 'Es una impresora ...', 'El equipo muestra sistema de impresion dañado, partes del cuerpo rotas y sin deposito de tinta', '2021-05-10', 1, 250.0, 'no imagen', 2.7, 1);                                    
insert into tb_producto values (null, '524786-003', 2, 'HP', 'Multifuncional Ink Tank 415', 'Capacidad: 60 hojas; Wi-Fi: No; Bluetooth: No; NFC: No',
								'Equipo en buen estado, completamente restaurado y tinta al 100%','2020-07-25', 1, 550.0, 'no imagen', 7.0, 1);
                                
insert into tb_registro values (null, 1, 'cl001', 'Es una impresora ...', 'El equipo muestra ligeros raspones en el cuerpo y nivel de tinta al 50%', '2021-05-10', 1, 300.0, 'no imagen', 6.0, 1);                                    
insert into tb_producto values (null, '374905-001', 2, 'CANON', 'Multifuncional Color G2110', 'Capacidad: 100 hojas; Wi-Fi: No; Bluetooth: No; NFC: No',
								'Equipo en buen estado, pintura refaccionada y tinta al 100%', '2020-07-07', 1, 500.0, 'no imagen', 8.5, 1);
                                
insert into tb_registro values (null, 1, 'cl001', 'Es una impresora ...', 'El equipo se muestra con daños en la bandeja y sin deposito de tinta', '2021-05-10', 1, 250.0, 'no imagen', 4.5, 1);                                    
insert into tb_producto values (null, '374905-002', 2, 'CANON', 'Multifuncional Color G2110', 'Capacidad: 100 hojas; Wi-Fi: No; Bluetooth: No; NFC: No',
								'Equipo en buen estado, partes refaccionadas y tinta al 100%', '2020-07-15', 1,  450.0, 'no imagen', 7.5, 1);
                                
insert into tb_registro values (null, 1, 'cl001', 'Es una impresora ...', 'El equipo muestra sistema de impresion dañado, partes del cuerpo rotas y sin deposito de tinta', '2021-05-10', 1, 150.0, 'no imagen', 2.7, 1);                                    
insert into tb_producto values (null, '374905-003', 2, 'CANON', 'Multifuncional Color G2110', 'Capacidad: 100 hojas; Wi-Fi: No; Bluetooth: No; NFC: No',
								'Equipo en buen estado, completamente restaurado y tinta al 100%', '2020-07-25', 1, 400.0, 'no imagen', 7.0, 1);
                                
insert into tb_registro values (null, 1, 'cl001', 'Es una impresora ...', 'El equipo muestra ligeros raspones en el cuerpo y nivel de tinta al 50%', '2021-05-10', 1, 700.0, 'no imagen', 6.0, 1);                                    
insert into tb_producto values (null, '842364-001', 2, 'Epson', 'Multifuncional Wifi EcoTank L4160', 'Capacidad: 100 hojas; Wi-Fi: Si; Bluetooth: No; NFC: No',
								'Equipo en buen estado, pintura refaccionada y tinta al 100%', '2020-07-07', 1, 1000.0, 'no imagen', 8.5, 1);
                                
insert into tb_registro values (null, 1, 'cl001', 'Es una impresora ...', 'El equipo se muestra con daños en la bandeja y sin deposito de tinta', '2021-05-10', 1, 650.0, 'no imagen', 4.5, 1);                                    
insert into tb_producto values (null, '842364-002', 2, 'Epson', 'Multifuncional Wifi EcoTank L4160', 'Capacidad: 100 hojas; Wi-Fi: Si; Bluetooth: No; NFC: No',
								'Equipo en buen estado, partes refaccionadas y tinta al 100%', '2020-07-15', 1, 850.0, 'no imagen', 7.5, 1);
                                
insert into tb_registro values (null, 1, 'cl001', 'Es una impresora ...', 'El equipo muestra sistema de impresion dañado, partes del cuerpo rotas y sin deposito de tinta', '2021-05-10', 1, 500.0, 'no imagen', 2.7, 1);                                    
insert into tb_producto values (null, '842364-003', 2, 'Epson', 'Multifuncional Wifi EcoTank L4160', 'Capacidad: 100 hojas; Wi-Fi: Si; Bluetooth: No; NFC: No',
								'Equipo en buen estado, completamente restaurado y tinta al 100%', '2020-07-25', 1, 700.0, 'no imagen', 7.0, 1);
                                
insert into tb_registro values (null, 1, 'cl001', 'Es una impresora ...', 'El equipo se muestra sin sistema de impresion, partes del cuerpo rotas y sin deposito de tinta', '2021-05-10', 1, 450.0, 'no imagen', 2.0, 1);    
insert into tb_producto values (null, '842364-004', 2, 'Epson', 'Multifuncional Wifi EcoTank L4160', 'Capacidad: 100 hojas; Wi-Fi: Si; Bluetooth: No; NFC: No',
								'Equipo en buen estado, completamente restaurado y tinta al 100%', '2020-07-25', 1, 650.0, 'no imagen', 7.0, 1);
              
              
/*----------------------SMARTPHONES-------------------------*/
insert into tb_registro values (null, 1, 'cl001', 'Es una celular ...', 'El equipo muestra ligeros raspones en el cuerpo', '2021-05-10', 1, 3500.0, 'no imagen', 6.0, 1);    
insert into tb_producto values (null, '125487-001', 3, 'Apple', 'iPhone 12 Blue', 'Pantalla: 6.1" FHD+; RAM: 4GB; ROM: 128GB; Procesador: A14 Bionic; Cámara posterior: 12MP; Cámara frontal: 12MP',
								'Equipo en buen estado, pintura refaccionada', '2020-07-07', 1, 4000.0, 'no imagen', 8.5, 1);
                                
insert into tb_registro values (null, 1, 'cl001', 'Es una celular ...', 'El equipo se muestra con parte posterior quebrada', '2021-05-10', 1, 3200.0, 'no imagen', 4.5, 1);                                    
insert into tb_producto values (null, '125487-002', 3, 'Apple', 'iPhone 12 Blue', 'Pantalla: 6.1" FHD+; RAM: 4GB; ROM: 128GB; Procesador: A14 Bionic; Cámara posterior: 12MP; Cámara frontal: 12MP',
								'Equipo en buen estado, vidrio reemplazado', '2020-07-15', 1, 3800.0, 'no imagen', 7.5, 1);
                                
insert into tb_registro values (null, 1, 'cl001', 'Es una celular ...', 'El equipo muestra pantalla quebrada, daño en el cuerpo y sistema bloqueado', '2021-05-10', 1, 3000.0, 'no imagen', 2.7, 1);                                    
insert into tb_producto values (null, '125487-003', 3, 'Apple', 'iPhone 12 Blue', 'Capacidad: 60 hojas; Wi-Fi: No; Bluetooth: No; NFC: No',
								'Equipo en buen estado, completamente restaurado', '2020-07-25', 1, 3500.0, 'no imagen', 7.0, 1);

insert into tb_registro values (null, 1, 'cl001', 'Es una celular ...', 'El equipo muestra ligeros raspones en el cuerpo', '2021-05-10', 1, 800.0, 'no imagen', 6.0, 1);                                    
insert into tb_producto values (null, '524861-001', 3, 'Xiaomi', 'Poco X3 NFC', 'Pantalla: 6.67" FHD+; RAM: 6GB; ROM: 128GB; Procesador: Qualcomm Snapdragon 732G; Cámara posterior: 64MP; Cámara frontal: 20MP',
								'Equipo en buen estado, pintura refaccionada', '2020-07-07', 1, 1000.0, 'no imagen', 8.5, 1);
                                
insert into tb_registro values (null, 1, 'cl001', 'Es una celular ...', 'El equipo se muestra con pantalla quebrada', '2021-05-10', 1, 600.0, 'no imagen', 4.5, 1);                                   
insert into tb_producto values (null, '524861-002', 3, 'Xiaomi', 'Poco X3 NFC', 'Pantalla: 6.67" FHD+; RAM: 6GB; ROM: 128GB; Procesador: Qualcomm Snapdragon 732G; Cámara posterior: 64MP; Cámara frontal: 20MP',
								'Equipo en buen estado, vidrio reemplazado', '2020-07-15', 1, 800.0, 'no imagen', 7.5, 1);
                                
insert into tb_registro values (null, 1, 'cl001', 'Es una celular ...', 'El equipo muestra pantalla quebrada, daño en el cuerpo y sistema bloqueado', '2021-05-10', 1, 450.0, 'no imagen', 2.7, 1);                                    
insert into tb_producto values (null, '524861-003', 3, 'Xiaomi', 'Poco X3 NFC', 'Pantalla: 6.67" FHD+; RAM: 6GB; ROM: 128GB; Procesador: Qualcomm Snapdragon 732G; Cámara posterior: 64MP; Cámara frontal: 20MP',
								'Equipo en buen estado, completamente restaurado', '2020-07-25', 1, 750.0, 'no imagen', 7.0, 1);
                                
 insert into tb_registro values (null, 1, 'cl001', 'Es una celular ...', 'El equipo muestra ligeros raspones en el cuerpo', '2021-05-10', 1, 1200.0, 'no imagen', 6.0, 1);                                   
insert into tb_producto values (null, '993254-001', 3, 'Samsung', 'Galaxy A71 Blanco', 'Pantalla: 6.7" FHD+; RAM: 6GB; ROM: 128GB; Procesador: Qualcomm Snapdragon 730; Cámara posterior: 40MP; Cámara frontal: 32MP',
								'Equipo en buen estado, pintura refaccionada', '2020-07-07', 1, 1400.0, 'no imagen', 8.5, 1);
                                
insert into tb_registro values (null, 1, 'cl001', 'Es una celular ...', 'El equipo se muestra con pantalla quebrada', '2021-05-10', 1, 1000.0, 'no imagen', 4.5, 1);                                    
insert into tb_producto values (null, '993254-002', 3, 'Samsung', 'Galaxy A71 Blanco', 'Pantalla: 6.7" FHD+; RAM: 6GB; ROM: 128GB; Procesador: Qualcomm Snapdragon 730; Cámara posterior: 40MP; Cámara frontal: 32MP',
								'Equipo en buen estado, vidrio reemplazado', '2020-07-15', 1, 1200.0, 'no imagen', 7.5, 1);
                                
insert into tb_registro values (null, 1, 'cl001', 'Es una celular ...', 'El equipo muestra pantalla quebrada, daño en el cuerpo y sistema bloqueado', '2021-05-10', 1, 600.0, 'no imagen', 2.7, 1);                                    
insert into tb_producto values (null, '993254-003', 3, 'Samsung', 'Galaxy A71 Blanco', 'Pantalla: 6.7" FHD+; RAM: 6GB; ROM: 128GB; Procesador: Qualcomm Snapdragon 730; Cámara posterior: 40MP; Cámara frontal: 32MP',
								'Equipo en buen estado, completamente restaurado', '2020-07-25', 1, 800.0, 'no imagen',  7.0, 1);
                                
insert into tb_registro values (null, 1, 'cl001', 'Es una celular ...', 'El equipo muestra pantalla inservivble, daño en la parte posterior y sistema bloqueado', '2021-05-10', 1, 550.0, 'no imagen', 2.0, 1);                                    
insert into tb_producto values (null, '993254-004', 3, 'Samsung', 'Galaxy A71 Blanco', 'Capacidad: 100 hojas; Wi-Fi: Si; Bluetooth: No; NFC: No',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  1, 750.0, 'no imagen', 7.0, 1);



/*----------------------CÁMARAS-------------------------*/


/*----------------------WEAREABLES-------------------------*/


/*----------------------SMART TV'S-------------------------*/


/*----------------------AUDIO-------------------------*/


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